/datum/preference/blob/antagonists
	savefile_key = "antagonists"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/blob/antagonists/create_default_value()
	. = list()
	for(var/antagonist in GLOB.special_roles)
		.[antagonist] = TRUE

/datum/preference/blob/antagonists/deserialize(input, datum/preferences/preferences)
	var/list/reference = create_default_value()
	input |= reference
	input &= reference
	for(var/antagonist in input)
		input[antagonist] = !!input[antagonist]
	return input
