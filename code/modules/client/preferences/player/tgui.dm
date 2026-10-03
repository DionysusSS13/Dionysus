/datum/preference/toggle/tgui_fancy
	explanation = "Enable fancy TGUI"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "Makes TGUI windows look better, at the cost of compatibility."
	savefile_key = "tgui_fancy"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/toggle/tgui_fancy/apply_to_client(client/client, value)
	for (var/datum/tgui/tgui as anything in client.mob?.tgui_open_uis)
		// Force it to reload either way
		tgui.update_static_data(client.mob)

// Determines if input boxes are in tgui or old fashioned
/datum/preference/toggle/tgui_input
	explanation = "Input: Enable TGUI"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "Renders input boxes in TGUI."
	savefile_key = "tgui_input"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/// Large button preference. Error text is in tooltip.
/datum/preference/toggle/tgui_input_large
	explanation = "Input: Larger buttons"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "Makes TGUI buttons less traditional, more functional."
	savefile_key = "tgui_input_large"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	default_value = FALSE

/datum/preference/toggle/tgui_input_large/apply_to_client(client/client, value)
	for (var/datum/tgui/tgui as anything in client.mob?.tgui_open_uis)
		// Force it to reload either way
		tgui.send_full_update(client.mob)

/// Swapped button state - sets buttons to SS13 traditional SUBMIT/CANCEL
/datum/preference/toggle/tgui_input_swapped
	explanation = "Input: Swap Submit/Cancel buttons"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "Makes TGUI buttons less traditional, more functional."
	savefile_key = "tgui_input_swapped"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/toggle/tgui_input_swapped/apply_to_client(client/client, value)
	for (var/datum/tgui/tgui as anything in client.mob?.tgui_open_uis)
		// Force it to reload either way
		tgui.send_full_update(client.mob)

/datum/preference/toggle/tgui_lock
	explanation = "Lock TGUI to main monitor"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "Locks TGUI windows to your main monitor."
	savefile_key = "tgui_lock"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	default_value = FALSE

/datum/preference/toggle/tgui_lock/apply_to_client(client/client, value)
	for (var/datum/tgui/tgui as anything in client.mob?.tgui_open_uis)
		// Force it to reload either way
		tgui.update_static_data(client.mob)


/datum/preference/toggle/ui_scale
	explanation = "Toggle UI scaling"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "If UIs should scale up to match your monitor scaling."
	savefile_key = "ui_scale"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	default_value = TRUE

/datum/preference/toggle/ui_scale/apply_to_client(client/client, value)
	if(!istype(client))
		return

	spawn(-1)
		client.refresh_tgui()
