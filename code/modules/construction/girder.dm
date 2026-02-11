#define GIRDER_NOTHING "nothing"
#define GIRDER_STRUCTURAL "structural"

#define STRUCTURE_COST 2
#define PLATING_COST 2
#define REINFORCEMENT_COST 2

/obj/structure/girder
	name = "girder frame"
	desc = "A frame for a wall girder."
	icon = 'icons/construction/wall/girder/wall/wall_0.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	density = FALSE
	can_atmos_pass = CANPASS_ALWAYS
	smoothing_groups = SMOOTH_GROUP_WALLS
	smoothing_groups_with = SMOOTH_GROUP_GRILLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
	uses_integrity = TRUE
	max_integrity = /datum/material/steel::wall_integrity * 0.5
	/// The material that the girder walls are made of.
	var/datum/material/material_plating = null
	/// The material that the reinforcement rods are made of.
	var/datum/material/material_reinforcement = null
	/// Are the reinforcement rods secured?
	var/reinforcement_secure = FALSE
	/// The heat resistance of the girder.
	var/heat_resistance = /datum/material/steel::heat_resistance

/obj/structure/girder/Initialize(mapload)
	. = ..()
	become_atmos_sensitive()
	update_appearance()

/obj/structure/girder/update_overlays()
	. = ..()
	if(material_plating)
		return .
	if(anchored)
		. += "anchoring"

/obj/structure/girder/update_icon(updates)
	. = ..()
	var/static/list/icon/girder_icons = list(
		'icons/construction/wall/girder/wall/wall_0.dmi',
		'icons/construction/wall/girder/wall/wall_1.dmi',
		'icons/construction/wall/girder/wall/wall_2.dmi',
	)
	var/static/list/icon/reinforced_icons = list(
		'icons/construction/wall/girder_reinforced/wall/wall_0.dmi',
		'icons/construction/wall/girder_reinforced/wall/wall_1.dmi',
		'icons/construction/wall/girder_reinforced/wall/wall_2.dmi',
	)
	var/integrity_pct = atom_integrity / max_integrity
	var/wanted_state = MAP(integrity_pct, 0, 1, 0, 2)
	if(material_reinforcement)
		icon = reinforced_icons[wanted_state]
		// icon_state should be set by smoothing
	else if (material_plating)
		icon = girder_icons[wanted_state]
		// icon_state should be set by smoothing
	else
		icon = 'icons/construction/wall/girder/base.dmi'
		icon_state = "base"

/obj/structure/girder/examine(mob/user)
	. = ..()
	if(isnull(material_plating))
		. += "The floor anchor bolts can be <b>wrenched</b> [anchored ? "loose" : "secure"]."
		. += "The structure can be cut apart using a <b>welder</b>."
		. += "Plating can be <b>welded</b> onto the structure."
		return .
	if(isnull(material_reinforcement))
		. += "The plating can be cut apart using a <b>welder</b>."
		. += "Reinforcement can be <b>welded</b> onto the structure."
		return .
	. += "The reinforcement rods can be [reinforcement_secure ? "" : "un"]secured using a <b>screwdriver</b>."
	if(!reinforcement_secure)
		. += "The reinforcement rods can be cut apart using a <b>welder</b>."
		return .
	. += "The girder can be finished using a <b>screwdriver</b>."

/obj/structure/girder/proc/start_smoothing()
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)
	update_appearance()

/obj/structure/girder/proc/stop_smoothing()
	smoothing_flags = initial(smoothing_flags)
	icon_state = initial(icon_state)
	update_appearance()

/obj/structure/girder/attackby(obj/item/object, mob/user, params)
	if(!Adjacent(object))
		return ..()
	if(istype(object, /obj/item/stack/sheet))
		if(isnull(material_plating))
			add_plating(user, object)
			return TRUE
		if(isnull(material_reinforcement))
			add_reinforcement(user, object)
			return TRUE
	return ..()

/obj/structure/girder/proc/update_material_resistances()
	var/new_heat_resistance = /obj/structure/girder::heat_resistance
	var/new_max_integrity = /obj/structure/girder::max_integrity
	if(!isnull(material_plating)) // take the highest heat resistance and max integrity when compared the the actual girder frame
		heat_resistance = max(heat_resistance, material_plating.heat_resistance)
		max_integrity = max(max_integrity, material_plating.wall_integrity)
	if(!isnull(material_reinforcement))
		new_heat_resistance += material_reinforcement.heat_resistance * 0.25
		new_max_integrity += material_reinforcement.wall_integrity * 0.5
	heat_resistance = new_heat_resistance
	var/integrity_pct = atom_integrity / max_integrity
	max_integrity = new_max_integrity
	update_integrity(max_integrity * integrity_pct)

/obj/structure/girder/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(exposed_temperature <= heat_resistance)
		return
	var/ratio_over = exposed_temperature / heat_resistance
	var/damage_ratio = (ratio_over - 1) ** 2
	take_damage(2 ** damage_ratio, BURN)
	if(prob(ratio_over * 25))
		playsound(src, SFX_ROCK_TAP, 25)
	if(prob(ratio_over * 10))
		visible_message(span_warning("\The [src] seems to warp slightly!"))

/obj/structure/girder/proc/add_plating(mob/user, obj/item/stack/sheet/material_sheet)
	if(!anchored)
		balloon_alert(user, "not anchored!")
		return
	if(material_sheet.amount < PLATING_COST)
		balloon_alert(user, "not enough!")
		return
	var/obj/item/weldingtool/welder = locate() in user.held_items
	if(!istype(welder))
		balloon_alert(user, "need welder!")
		return
	user.balloon_alert_to_viewers("welding...")
	if(!welder.use_tool(src, user, 2 SECONDS, volume = 50))
		balloon_alert(user, "interrupted!")
		return
	if(!material_sheet.use(PLATING_COST))
		balloon_alert(user, "not enough!")
		return
	material_plating = material_sheet.material_type
	density = TRUE
	start_smoothing()
	update_material_resistances()

/obj/structure/girder/proc/add_reinforcement(mob/user, obj/item/stack/sheet/reinforcement_material)
	if(reinforcement_material.amount < PLATING_COST)
		balloon_alert(user, "not enough!")
		return
	var/obj/item/weldingtool/welder = locate() in user.held_items
	if(!istype(welder))
		balloon_alert(user, "need welder!")
		return
	user.balloon_alert_to_viewers("welding...")
	if(!welder.use_tool(src, user, 2 SECONDS, volume = 50))
		balloon_alert(user, "interrupted!")
		return
	if(!reinforcement_material.use(PLATING_COST))
		balloon_alert(user, "not enough!")
		return
	material_reinforcement = reinforcement_material.material_type
	start_smoothing()
	update_material_resistances()

/obj/structure/girder/wrench_act(mob/user, obj/item/tool)
	if(!Adjacent(user))
		return ..()
	if(!isnull(material_plating))
		balloon_alert(user, "already plated!")
		return TRUE
	balloon_alert_to_viewers("[anchored ? "unsecuring" : "securing"]...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
		return TRUE
	anchored = !anchored
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/structure/girder/screwdriver_act(mob/user, obj/item/tool)
	if(!Adjacent(user))
		return ..()
	if(isnull(material_reinforcement))
		return ..()
	balloon_alert_to_viewers("[reinforcement_secure ? "unsecuring" : "securing"] reinforcements...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
		return TRUE
	reinforcement_secure = !reinforcement_secure
	// todo: change base_icon_state and re-smooth, plz bimmer
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/structure/girder/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	if(!Adjacent(user))
		return ..()
	if(isnull(material_plating))
		return ..()
	if(!anchored)
		balloon_alert(user, "not anchored!")
		return TRUE
	if(!isnull(material_reinforcement) && !reinforcement_secure)
		balloon_alert(user, "secure the reinforcements first!")
		return TRUE
	var/turf/my_loc = get_turf(src)
	if(!istype(my_loc, /turf/open/floor))
		balloon_alert(user, "how?")
		return TRUE
	for(var/atom/movable/other in my_loc)
		if(other == src)
			continue
		if(other.density)
			balloon_alert(user, "no room!")
			return TRUE
	balloon_alert_to_viewers("finishing...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
		return TRUE
	my_loc.ChangeTurf(/turf/closed/constructed_wall, args_turf_new = list(material_plating = material_plating, material_reinforcement = material_reinforcement))
	qdel(src)
	return TRUE

/obj/structure/girder/welder_act_secondary(mob/living/user, obj/item/tool)
	if(!Adjacent(user))
		return ..()
	if(!isnull(material_reinforcement))
		if(reinforcement_secure)
			balloon_alert(user, "secured!")
			return TRUE
		balloon_alert_to_viewers("cutting...")
		if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
			return TRUE
		user.put_in_hands(new material_reinforcement.sheet_type(loc, REINFORCEMENT_COST))
		material_reinforcement = null
		reinforcement_secure = FALSE
		// todo: change base_icon_state and re-smooth
		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	if(!isnull(material_plating))
		balloon_alert_to_viewers("cutting...")
		if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
			return TRUE
		user.put_in_hands(new material_plating.sheet_type(loc, PLATING_COST))
		material_plating = null
		smoothing_flags = initial(smoothing_flags)
		icon_state = initial(icon_state)
		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	balloon_alert_to_viewers("dismantling...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
		return TRUE
	user.put_in_hands(new /obj/item/stack/sheet/steel(loc, 2)) // keep in sync with code/game/objects/items/stacks/sheets/sheet_types.dm:75
	qdel(src)
	return TRUE
