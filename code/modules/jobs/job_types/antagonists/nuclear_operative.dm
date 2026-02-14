/datum/job/nuclear_operative
	id = ROLE_NUCLEAR_OPERATIVE
	titles = list(
		/datum/job_title/nuclear_operative,
	)
	spawn_logic = JOBSPAWN_FORCE_FIXED

/datum/job_title/nuclear_operative
	name = ROLE_NUCLEAR_OPERATIVE

/datum/job/nuclear_operative/get_roundstart_spawn_point_fixed()
	return get_latejoin_spawn_point()


/datum/job/nuclear_operative/get_latejoin_spawn_point()
	return pick(GLOB.nukeop_start)
