/// Used as a parent type for types that want to allow construction, but do not want to be floors
/// I wish I could use components for turfs at scale
/// Please do not bloat this. Love you <3
/turf/open/misc
	name = "coder/mapper fucked up"
	desc = "report on github please"
	icon_state = "BROKEN"

	flags_1 = NO_SCREENTIPS_1
	turf_flags = CAN_BE_DIRTY_1 | IS_SOLID | NO_RUST

	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	underfloor_accessibility = UNDERFLOOR_INTERACTABLE
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN
	smoothing_groups_with = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR

	tiled_dirt = TRUE

/turf/open/misc/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(.)
		return TRUE

	if(istype(W, /obj/item/stack/rods))
		build_with_rods(W, user)
		return TRUE
	else if(istype(W, /obj/item/stack/tile/iron))
		build_with_floor_tiles(W, user)
		return TRUE

/turf/open/misc/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/turf/open/misc/ex_act(severity, target)
	. = ..()

	if(target == src)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return TRUE
	if(severity < EXPLODE_DEVASTATE && is_shielded())
		return FALSE

	if(target)
		severity = EXPLODE_LIGHT

	switch(severity)
		if(EXPLODE_DEVASTATE)
			ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
		if(EXPLODE_HEAVY)
			switch(rand(1, 3))
				if(1 to 2)
					ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
				if(3)
					if(prob(80))
						ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
					else
						break_tile()
					hotspot_expose(1000,CELL_VOLUME)
		if(EXPLODE_LIGHT)
			if (prob(50))
				break_tile()
				hotspot_expose(1000,CELL_VOLUME)


/turf/open/misc/is_shielded()
	for(var/obj/structure/A in contents)
		return TRUE

/turf/open/misc/blob_act(obj/structure/blob/B)
	return
