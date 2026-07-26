/datum/preference/stored_appearance
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "stored_appearance"
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/stored_appearance/deserialize(input, datum/preferences/preferences)
	return input

/datum/preference/stored_appearance/create_default_value()
	return null

/datum/preference/stored_appearance/is_valid(value)
	return value == null || istext(value)

/datum/preference/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return
