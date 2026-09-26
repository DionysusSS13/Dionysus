/datum/preference/toggle/disable_pain_flash
	explanation = "Disable pain flashes"
	category = PREFERENCE_CATEGORY_GAME_ACCESSIBILITY
	description = "Disables pain flash effects"
	savefile_key = "disable_pain_flash"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	default_value = FALSE

/datum/preference/toggle/motion_sickness
	explanation = "Moition sickness aid"
	description = "Disables effects that may induce motion sickness."
	category = PREFERENCE_CATEGORY_GAME_ACCESSIBILITY
	savefile_key = "motion_sickness"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	default_value = FALSE

/datum/preference/toggle/motion_sickness/apply_to_client(client/client, value)
	if(client.mob)
		SEND_SIGNAL(client.mob, COMSIG_MOB_MOTION_SICKNESS_UPDATE, value)
