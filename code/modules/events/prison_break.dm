/datum/round_event_control/grey_tide
	name = "Grey Tide"
	typepath = /datum/round_event/grey_tide
	max_occurrences = 1
	min_players = 5

/datum/round_event/grey_tide
	announceWhen = 50
	endWhen = 20
	var/list/area/areasToOpen = list()
	var/list/potential_areas = list(/area/station/command,
									/area/station/engineering,
									/area/station/medical,
									/area/station/security,
									/area/station/cargo,
									/area/station/science)
	var/severity = 1


/datum/round_event/grey_tide/setup()
	announceWhen = rand(50, 60)
	endWhen = rand(20, 30)
	severity = rand(1,3)
	for(var/i in 1 to severity)
		var/picked_area = pick_n_take(potential_areas)
		for(var/area/A in GLOB.areas)
			if(istype(A, picked_area))
				areasToOpen += A


/datum/round_event/grey_tide/announce(fake)
	if(areasToOpen && areasToOpen.len > 0)
		priority_announce("Gr3y.T1d3 virus detected in [station_name()] door subroutines. Severity level of [severity]. Recommend station AI involvement.")
	else
		log_world("ERROR: Could not initiate grey-tide. No areas in the list!")
		kill()


/datum/round_event/grey_tide/start()
	for(var/area/A in areasToOpen)
		for(var/obj/machinery/light/L in A)
			L.flicker(10)

/datum/round_event/grey_tide/end()
	for(var/area/A in areasToOpen)
		for(var/obj/O in A)
			if(istype(O, /obj/structure/closet/secure_closet))
				var/obj/structure/closet/secure_closet/temp = O
				temp.locked = FALSE
				temp.update_appearance()
