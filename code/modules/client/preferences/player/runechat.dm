/datum/preference/toggle/enable_runechat
	explanation = "Enable Runechat"
	category = PREFERENCE_CATEGORY_GAME_RUNECHAT
	savefile_key = "chat_on_map"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/toggle/enable_runechat_non_mobs
	explanation = "Enable Runechat on objects"
	category = PREFERENCE_CATEGORY_GAME_RUNECHAT
	savefile_key = "see_chat_non_mob"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/toggle/see_rc_emotes
	explanation = "Enable Runechat emotes"
	category = PREFERENCE_CATEGORY_GAME_RUNECHAT
	savefile_key = "see_rc_emotes"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/numeric/max_chat_length
	explanation = "Max chat length"
	category = PREFERENCE_CATEGORY_GAME_RUNECHAT
	savefile_key = "max_chat_length"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

	minimum = 1
	maximum = CHAT_MESSAGE_MAX_LENGTH

/datum/preference/numeric/max_chat_length/create_default_value()
	return CHAT_MESSAGE_MAX_LENGTH
