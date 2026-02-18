/turf/closed/constructed_wall
	name = "steel wall"
	icon = 'icons/construction/wall/iron/wall/wall_0.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	smoothing_groups_with = SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_GRILLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
	uses_integrity = TRUE
	max_integrity = /datum/material/steel::wall_integrity
	baseturfs = /turf/open/floor/plating
	var/last_damage = 0
	var/heat_resistance = /datum/material/steel::heat_resistance
	var/datum/material/material_plating //! the material that the exterior of the wall is made of.
	var/datum/material/material_reinforcement //! (if applicable) the material that the reinforcement rods are made of.
	var/datum/material/material_trim_bottom //! (if applicable) the material that the bottom trim is made of.
	var/datum/material/material_trim_top //! (if applicable) the material that the top trim is made of.
	var/deconstruction_stage = WALL_DECON_NONE //! the current stage of wall deconstruction
	var/deconstruction_r_step = WALL_DECON_REINF_NONE //! the current stage of reinforcement deconstruction

/turf/closed/constructed_wall/New(loc, material_plating, material_reinforcement, material_trim_bottom, material_trim_top)
	return ..()

/turf/closed/constructed_wall/Initialize(mapload, material_plating, material_reinforcement, material_trim_bottom, material_trim_top)
	. = ..()
	if(uses_integrity && atom_integrity == null)
		atom_integrity = max_integrity
	src.material_plating = material_plating || src.material_plating || /datum/material/steel
	src.material_reinforcement = material_reinforcement || src.material_reinforcement
	src.material_trim_bottom = material_trim_bottom || src.material_trim_bottom
	src.material_trim_top = material_trim_top || src.material_trim_top
	update_material_resistances()
	update_appearance()
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/turf/closed/constructed_wall/proc/update_material_resistances()
	var/new_heat_resistance = material_plating.heat_resistance
	var/new_max_integrity = material_plating.wall_integrity
	if(!isnull(material_reinforcement))
		new_heat_resistance += material_reinforcement.heat_resistance * 0.25
		new_max_integrity += material_reinforcement.wall_integrity * 0.5
	heat_resistance = new_heat_resistance
	var/integrity_pct = atom_integrity / max_integrity
	max_integrity = new_max_integrity
	update_integrity(max_integrity * integrity_pct)

/turf/closed/constructed_wall/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(exposed_temperature <= heat_resistance)
		return
	var/ratio_over = exposed_temperature / heat_resistance
	var/damage_ratio = (ratio_over - 1) ** 2
	take_damage(2 ** damage_ratio, BURN)
	if(prob(ratio_over * 25))
		playsound(src, SFX_ROCK_TAP, 25)
	if(prob(ratio_over * 10))
		visible_message(span_warning("\The [src] seems to warp slightly!"))

/turf/closed/constructed_wall/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	last_damage = damage_amount
	return ..()

/turf/closed/constructed_wall/update_integrity(new_value)
	. = ..()
	update_appearance()

/turf/closed/constructed_wall/welder_act(mob/living/user, obj/item/tool)
	if(!Adjacent(user))
		return ..()
	while(atom_integrity < max_integrity)
		var/repair_amount = max(10, max_integrity * 0.1) // always repair at least 10 damage, otherwise 10% of the wall's max health
		repair_amount = min(repair_amount, max_integrity - atom_integrity)
		if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
			return TRUE
		repair_damage(repair_amount)
	return TRUE

/turf/closed/constructed_wall/atom_destruction(damage_flag)
	. = ..()
	if(last_damage < /obj/structure/girder::max_integrity)
		deconstruct_to_girder()
	else ScrapeAway()

/turf/closed/constructed_wall/proc/destroy_wall(and_girder = TRUE)
	if(and_girder)
		ScrapeAway()
		return
	deconstruct_to_girder()

/turf/closed/constructed_wall/can_smooth(atom/other)
	if(!istype(other, /obj/structure/girder))
		return ..()
	var/obj/structure/girder/girder = other
	return !isnull(girder.material_plating)

/turf/closed/constructed_wall/examine(mob/user)
	. = ..()
	if(atom_integrity < max_integrity)
		. += span_notice("The wall can be repaired with a <i>welder</i>.")
		switch((atom_integrity / max_integrity) * 100)
			if(00 to 02)
				. += span_warning("You're not even sure if this qualifies as a wall right now.")
			if(02 to 25)
				. += span_warning("The wall is almost destroyed.")
			if(25 to 50)
				. += span_warning("The wall looks like it's about to fall apart.")
			if(50 to 75)
				. += span_warning("The wall has seen better days.")
			if(75 to 90)
				. += span_warning("Looks fine to me.")
			if(90 to 100)
				. += span_warning("One could argue that the damage is soul.")
	if(!isnull(material_trim_bottom) || !isnull(material_trim_top))
		if(!isnull(material_trim_bottom))
			. += span_notice("You could remove the bottom trim with a <i>crowbar</i>.")
		if(!isnull(material_trim_top))
			. += span_notice("You could remove the top trim with a <i>crowbar</i>.")
		return .
	switch(deconstruction_stage)
		if(WALL_DECON_NONE)
			. += span_notice("You could loosen the [isnull(material_reinforcement) ? "plating" : "bulkhead"] with a <i>welder</i>.")
		if(WALL_DECON_WALL_WEAKENED)
			if(!isnull(material_reinforcement))
				switch(deconstruction_r_step)
					if(WALL_DECON_REINF_NONE)
						. += span_notice("You could remove the bulkhead with a <i>crowbar</i>.")
					if(WALL_DECON_REINF_BULKHEAD_REMOVED)
						. += span_notice("You could remove the grille with a <i>wirecutters</i>.")
					if(WALL_DECON_REINF_GRILLE_REMOVED)
						. += span_notice("You could remove the bracing with a <i>welder</i>.")
					if(WALL_DECON_REINF_BRACING_REMOVED)
						. += span_notice("You could remove the bolts with a <i>wrench</i>.")
					if(WALL_DECON_REINF_BOLTS_UNDONE)
						. += span_notice("You could remove the plating with a <i>crowbar</i>.")
			else
				. += span_notice("You could remove the plating with a <i>crowbar</i>.")

/turf/closed/constructed_wall/update_icon(updates)
	. = ..()
	if(!SSmaterials.initialized)
		return
	var/integrity_pct = atom_integrity / max_integrity
	var/datum/material/plating_material_instance = GET_MATERIAL_REF(material_plating)
	if(!plating_material_instance)
		stack_trace("null material_plating: [material_plating]")
		return
	var/list/icon/plating_icons = plating_material_instance.wall_icons
	var/total_states = length(plating_icons)
	if(!total_states)
		stack_trace("unimplemented material_plating: [material_plating]")
		return
	var/wanted_state = MAP(integrity_pct, 0, 1, 1, total_states)
	icon = plating_icons[wanted_state]

/turf/closed/constructed_wall/update_desc(updates)
	if(material_reinforcement)
		desc = "A reinforced bulkhead of [material_plating::wall_name]."
	else
		desc = "A wall of [material_plating::wall_name]."
	return ..()

/turf/closed/constructed_wall/update_overlays()
	. = ..()
	if(!SSmaterials.initialized)
		return
	if(deconstruction_stage)
		. += deconstruction_overlay()
	if(material_trim_top)
		. += trim_overlay_top()
	if(material_trim_bottom)
		. += trim_overlay_bottom()
	var/turf/closed/constructed_wall/south_connection = get_step(src, SOUTH)
	if(!istype(south_connection))
		return
	if(south_connection.material_plating != src.material_plating)
		. += mutable_appearance(south_connection.icon, "extension")

/turf/closed/constructed_wall/update_name(updates)
	. = ..()
	var/wall_name = material_plating::wall_name || material_plating::name
	name = "[wall_name] [material_reinforcement ? "bulkhead" : "wall"]"

/turf/closed/constructed_wall/proc/trim_overlay_bottom()
	var/integrity_pct = atom_integrity / max_integrity
	var/datum/material/material_instance = GET_MATERIAL_REF(material_trim_bottom)
	var/list/icon/trim_icons = material_instance.wall_icons_trim_bottom
	var/total_states = length(trim_icons)
	if(!total_states)
		stack_trace("unimplemented material_trim_bottom: [material_trim_bottom]")
		return
	var/wanted_state = MAP(integrity_pct, 0, 1, 1, total_states)
	return mutable_appearance(trim_icons[wanted_state], replacetext(icon_state, "wall", "trim"))

/turf/closed/constructed_wall/proc/trim_overlay_top()
	var/integrity_pct = atom_integrity / max_integrity
	var/datum/material/material_instance = GET_MATERIAL_REF(material_trim_top)
	var/list/icon/trim_icons = material_instance.wall_icons_trim_top
	var/total_states = length(trim_icons)
	if(!total_states)
		stack_trace("unimplemented material_trim_bottom: [material_trim_bottom]")
		return
	var/wanted_state = MAP(integrity_pct, 0, 1, 1, total_states)
	return mutable_appearance(trim_icons[wanted_state], replacetext(icon_state, "wall", "trim"))

/turf/closed/constructed_wall/proc/deconstruction_overlay()
	if(deconstruction_stage == 0)
		return
	var/list/overlays = list(mutable_appearance('icons/construction/wall/decon.dmi', "d[deconstruction_stage]", alpha = 125))
	if(deconstruction_r_step > 0)
		overlays += list(mutable_appearance('icons/construction/wall/decon.dmi', "r[deconstruction_r_step]", alpha = 125))
	return overlays
