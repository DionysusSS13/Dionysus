/datum/preference/choiced/jobless_role
	savefile_key = "joblessrole"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	explanation = "Jobless Role"
	category = PREFERENCE_CATEGORY_GAME_GAMEPLAY

/datum/preference/choiced/jobless_role/create_default_value()
	return BEOVERFLOW

/datum/preference/choiced/jobless_role/init_possible_values()
	return list(BEOVERFLOW, BERANDOMJOB, RETURNTOLOBBY)
