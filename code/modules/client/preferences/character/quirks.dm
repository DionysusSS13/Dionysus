/datum/preference/blob/quirks
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "quirked_up"
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/blob/quirks/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return create_default_value()

	input = SSquirks.filter_invalid_quirks(input)

	return input

/datum/preference/blob/quirks/create_default_value()
	return list()
