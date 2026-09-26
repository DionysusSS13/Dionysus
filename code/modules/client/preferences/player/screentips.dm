/datum/preference/choiced/enable_screentips
	explanation = "Enable screentips"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "Enables screen tips, the text you see when hovering over something. When set to \"Only with tips\", will only show when there is more information than just the name, such as what right-clicking it does."
	savefile_key = "screentip_pref"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/choiced/enable_screentips/init_possible_values()
	return list(SCREENTIP_PREFERENCE_ENABLED, SCREENTIP_PREFERENCE_CONTEXT_ONLY, SCREENTIP_PREFERENCE_DISABLED)

/datum/preference/choiced/enable_screentips/create_default_value()
	return SCREENTIP_PREFERENCE_DISABLED

/datum/preference/choiced/enable_screentips/apply_to_client(client/client, value)
	client.mob?.hud_used?.screentips_enabled = value

/datum/preference/choiced/enable_screentips/deserialize(input, datum/preferences/preferences)
	// Migrate old always disabled screentips to context only.
	// Screentips were always meant to have context, though were initially merged without it.
	// This accepts that those users found screentips distracting, but gives a second chance now that
	// they provide a more obvious helping hand.
	// If they are still too distracting, there's nothing stopping them from disabling it again for good.
	if (input == FALSE)
		return ..(SCREENTIP_PREFERENCE_CONTEXT_ONLY, preferences)

	if (input == TRUE)
		return ..(SCREENTIP_PREFERENCE_ENABLED, preferences)

	return ..(input, preferences)

/datum/preference/color/screentip_color
	explanation = "Screentips color"
	category = PREFERENCE_CATEGORY_GAME_UI
	description = "The color of screen tips, the text you see when hovering over something."
	savefile_key = "screentip_color"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/color/screentip_color/apply_to_client(client/client, value)
	client.mob?.hud_used?.screentip_color = value

/datum/preference/color/screentip_color/create_default_value()
	return "#ffd391"
