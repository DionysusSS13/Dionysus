/datum/preference/toggle/auto_fit_viewport
	explanation = "Auto fit viewport"
	category = PREFERENCE_CATEGORY_GAME_UI
	savefile_key = "auto_fit_viewport"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/toggle/auto_fit_viewport/apply_to_client_updated(client/client, value)
	INVOKE_ASYNC(client, /client/verb/fit_viewport)
