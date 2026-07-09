/datum/unit_test/mapping_standards/enforce_count/doors
	abstract_type = /datum/unit_test/mapping_standards/enforce_count/doors

/datum/unit_test/mapping_standards/enforce_count/doors/get_collection()
	return INSTANCES_OF(/obj/machinery/door)

/datum/unit_test/mapping_standards/enforce_count/doors/blastdoor
	name = "MAPSTANDARDS: Tiles Must Have At Most 1 Blast Door"
	checked_type = /obj/machinery/door/poddoor
	failed_name = "Blast Doors"
