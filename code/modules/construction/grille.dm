/obj/structure/grillen
	base_icon_state = "grille"
	name = "grille"
	desc = "A metal grille."
	icon = 'icons/construction/wall/grille/wall/wall_0.dmi'
	icon_state = "wall-0"
	density = TRUE
	anchored = FALSE
	smoothing_groups = SMOOTH_GROUP_GRILLE
	smoothing_groups_with = SMOOTH_GROUP_GRILLE + SMOOTH_GROUP_WALLS
	pass_flags_self = PASSGRILLE
	can_atmos_pass = CANPASS_ALWAYS
	flags_1 = CONDUCT_1
	max_integrity = 50
	integrity_failure = 0.4

/obj/structure/grillen/Initialize(mapload)
	. = ..()
	become_atmos_sensitive()

/obj/structure/grillen/Destroy()
	update_cable_icons_on_turf(get_turf(src))
	lose_atmos_sensitivity()
	return ..()

/obj/structure/grillen/update_icon(updates)
	. = ..()
	var/static/list/icon/grille_icons = list(
		'icons/construction/wall/grille/wall/wall_0.dmi',
		'icons/construction/wall/grille/wall/wall_1.dmi',
		'icons/construction/wall/grille/wall/wall_2.dmi',
		'icons/construction/wall/grille/wall/wall_3.dmi',
		'icons/construction/wall/grille/wall/wall_4.dmi',
		'icons/construction/wall/grille/wall/wall_5.dmi',
	)
	var/integrity_pct = atom_integrity / max_integrity
	var/wanted_state = MAP(integrity_pct, 0, 1, 0, 5)
	icon = grille_icons[wanted_state]
	return ..()

/obj/structure/grillen/proc/smoothing_start()
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/grillen/proc/smoothing_end()
	smoothing_flags = /obj/structure/grillen::smoothing_flags
	icon_state = /obj/structure/grillen::icon_state
	QUEUE_SMOOTH_NEIGHBORS(src)
	update_appearance()

/obj/structure/grillen/update_integrity(new_value)
	. = ..()
	update_appearance()

/obj/structure/grillen/screwdriver_act(mob/living/user, obj/item/tool)
	if(!Adjacent(user))
		return ..()
	var/obj/structure/window/window = locate() in get_turf(src)
	if(!isnull(window))
		balloon_alert(user, "cannot reach!")
		return TRUE
	if(shock(user, 75))
		return TRUE
	balloon_alert_to_viewers("adjusting anchors...")
	if(!tool.use_tool(src, user, 1 SECONDS, volume=50))
		return TRUE
	anchored = !anchored
	if(anchored)
		smoothing_start()
	else
		smoothing_end()
	return TRUE

/obj/structure/grillen/wirecutter_act(mob/living/user, obj/item/tool)
	if(!Adjacent(user))
		return ..()
	if(anchored)
		balloon_alert(user, "unanchor first!")
		return TRUE
	if(shock(user, 100))
		return TRUE
	balloon_alert_to_viewers("cutting...")
	if(!tool.use_tool(src, user, 1 SECONDS, volume=50))
		return TRUE
	var/obj/item/stack/rods/rods = new(loc, 2) // keep in sync with the crafting recipe
	user.put_in_hands(rods)
	var/turf/old_loc = loc
	qdel(src)
	QUEUE_SMOOTH_NEIGHBORS(old_loc)
	return TRUE

/obj/structure/grillen/proc/repair()
	repair_damage(max_integrity)

/obj/structure/grillen/BumpedBy(atom/movable/AM)
	if(!ismob(AM))
		return
	var/mob/M = AM
	shock(M, 70, M.get_empty_held_index() ? SHOCK_HANDS : SHOCK_USE_AVG_SIEMENS)

/obj/structure/grillen/attack_animal(mob/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(!shock(user, 70) && !QDELETED(src)) //Last hit still shocks but shouldn't deal damage to the grille
		take_damage(rand(5,10), BRUTE, BLUNT, 1)

/obj/structure/grillen/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/grillen/hulk_damage()
	return 60

/obj/structure/grillen/attack_hulk(mob/living/carbon/human/user)
	if(shock(user, 70))
		return
	. = ..()

/obj/structure/grillen/attackby(obj/item/attacking_item, mob/user, params)
	if(!istype(attacking_item, /obj/item/stack/sheet))
		return ..()
	if(atom_integrity < (max_integrity * 0.7))
		balloon_alert(user, "grille is too damaged to attach a window!")
		return TRUE
	var/obj/item/stack/sheet/sheet = attacking_item
	var/datum/material/material_instance = GET_MATERIAL_REF(sheet.material_type)
	if(!material_instance)
		stack_trace("null material_type: [sheet.material_type]")
		return
	var/obj/structure/window/window_type = material_instance.window_type
	if(!window_type)
		balloon_alert(user, "This cannot make a window!")
		return TRUE
	if(!isfloorturf(loc))
		balloon_alert(user, "what floor?")
		return TRUE
	for(var/atom/movable/other in loc)
		if(other == src)
			continue
		if(other.density)
			balloon_alert(user, "no room!")
			return TRUE
	var/obj/structure/window/window = new window_type(loc)
	window.anchored = TRUE
	window.state = WINDOW_OUT_OF_FRAME
	window.setDir(dir)
	return TRUE

/obj/structure/grillen/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(span_warning("[user] hits [src]."), null, null, COMBAT_MESSAGE_RANGE)
	log_combat(user, src, "hit")
	if(!shock(user, 70))
		take_damage(rand(5,10), BRUTE, BLUNT, 1)

/obj/structure/grillen/attack_alien(mob/living/user, list/modifiers)
	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_warning("[user] mangles [src]."), null, null, COMBAT_MESSAGE_RANGE)
	if(!shock(user, 70))
		take_damage(20, BRUTE, BLUNT, 1)

/obj/structure/grillen/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!. && istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/grillen/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!density)
		return TRUE
	if(pass_info.pass_flags & PASSGRILLE)
		return TRUE
	return FALSE

/obj/structure/grillen/proc/shock(mob/user, prb, shock_flags = SHOCK_HANDS)
	if(!anchored || broken) // anchored/broken grilles are never connected
		return FALSE
	if(!prob(prb))
		return FALSE
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src, 1, TRUE, shock_flags = shock_flags))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return TRUE
		else
			return FALSE
	return FALSE

/obj/structure/grillen/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(exposed_temperature > T0C + 1500 && !broken)
		take_damage(1, BURN, 0, 0)

/obj/structure/grillen/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isobj(AM))
		if(prob(50) && anchored && !broken)
			var/obj/O = AM
			if(O.throwforce != 0)//don't want to let people spam tesla bolts, this way it will break after time
				var/turf/T = get_turf(src)
				var/obj/structure/cable/C = T.get_cable_node()
				if(C)
					playsound(src, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
					tesla_zap(src, 3, C.newavail() * 0.01, ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN | ZAP_LOW_POWER_GEN | ZAP_ALLOW_DUPLICATES) //Zap for 1/100 of the amount of power. At a million watts in the grid, it will be as powerful as a tesla revolver shot.
					C.add_delayedload(C.newavail() * 0.0375) // you can gain up to 3.5 via the 4x upgrades power is halved by the pole so thats 2x then 1X then .5X for 3.5x the 3 bounces shock.
	return ..()

/obj/structure/grillen/zap_act(power, zap_flags)
	if(!anchored)
		return ..()

	var/turf/turfloc = loc
	var/obj/structure/cable/C = turfloc.get_cable_node()
	if(!C)
		return ..()

	zap_flags &= ~ZAP_OBJ_DAMAGE
	C.add_avail(power / 7500)
	power = power / 7500
	return ..()

/obj/structure/grillen/get_dumping_location()
	return null
