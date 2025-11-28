/datum/antagonist_selector/cultist
	restricted_jobs = list(
		JOB_AI,
		JOB_PORT_AUTHORITY,
		JOB_CHAPLAIN,
		JOB_CYBORG,
		JOB_COMPLIANCE_AUDITOR,
		JOB_DIRECTOR_OF_PORT_SERVICES,
		JOB_PORT_MARSHAL,
		JOB_PRISONER,
		JOB_SECURITY_LIASON,
		JOB_BRIG_LIEUTENANT,
	)

	antag_datum = /datum/antagonist/cult
	antag_flag = ROLE_CULTIST

/datum/antagonist_selector/cultist/give_antag_datums(datum/game_mode/gamemode)
	var/datum/game_mode/one_antag/bloodcult/cult_gamemode = gamemode
	cult_gamemode.main_cult = new

	for(var/datum/mind/M in selected_antagonists)
		var/datum/antagonist/cult/new_cultist = new antag_datum()
		new_cultist.cult_team = cult_gamemode.main_cult
		new_cultist.give_equipment = TRUE
		M.add_antag_datum(new_cultist)
		GLOB.pre_setup_antags -= M

	cult_gamemode.main_cult.setup_objectives()
