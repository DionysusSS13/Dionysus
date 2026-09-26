/datum/preference/toggle/hotkeys
	explanation = "Classic Hotkeys"
	category = PREFERENCE_CATEGORY_GAME_GAMEPLAY
	description = "When enabled, will revert to the legacy hotkeys, using the input bar rather than popups."
	savefile_key = "hotkeys"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/toggle/hotkeys/apply_to_client(client/client, value)
	client.hotkeys = value
	if(SSinput.initialized)
		client.set_macros() //They've changed their preferences, We need to rewrite the macro set again.

/datum/preference/toggle/hotkeys_silence
	explanation = "Classic Hotkey Warnings"
	category = PREFERENCE_CATEGORY_GAME_GAMEPLAY
	description = "When enabled, will suppress the warning about bad/unbindable hotkeys. You should probably read them at least once."
	savefile_key = "hotkeys_silence"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
