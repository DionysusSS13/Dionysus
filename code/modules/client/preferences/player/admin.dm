/datum/preference/color/asay_color
	explanation = "Admin chat color"
	category = PREFERENCE_CATEGORY_GAME_ADMIN
	description = "The color of your messages in Adminsay."
	savefile_key = "asaycolor"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/color/asay_color/create_default_value()
	return DEFAULT_ASAY_COLOR

/datum/preference/color/asay_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return is_admin(preferences.parent) && CONFIG_GET(flag/allow_admin_asaycolor)

/// What outfit to equip when spawning as a briefing officer for an ERT
/datum/preference/choiced/brief_outfit
	explanation = "Brief outfit"
	category = PREFERENCE_CATEGORY_GAME_ADMIN
	description = "The outfit to gain when spawning as the briefing officer."
	savefile_key = "brief_outfit"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

/datum/preference/choiced/brief_outfit/deserialize(input, datum/preferences/preferences)
	var/path = text2path(input)
	if (!ispath(path, /datum/outfit))
		return create_default_value()

	return path

/datum/preference/choiced/brief_outfit/serialize(input)
	return "[input]"

/datum/preference/choiced/brief_outfit/create_default_value()
	return /datum/outfit/centcom/commander

/datum/preference/choiced/brief_outfit/init_possible_values()
	return subtypesof(/datum/outfit)

/datum/preference/choiced/brief_outfit/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return is_admin(preferences.parent)

/datum/preference/toggle/bypass_deadmin_in_centcom
	explanation = "Bypass deadmin options when in CentCom"
	category = PREFERENCE_CATEGORY_GAME_ADMIN
	description = "Whether or not to always remain an admin when spawned in CentCom."
	savefile_key = "bypass_deadmin_in_centcom"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	default_value = FALSE

/datum/preference/toggle/bypass_deadmin_in_centcom/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return is_admin(preferences.parent)
