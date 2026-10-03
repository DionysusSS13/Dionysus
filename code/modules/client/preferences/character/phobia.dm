/datum/preference/choiced/phobia
	explanation = "Phobia"
	savefile_key = "phobia"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	category = PREFERENCE_CATEGORY_EMPLOYEE_META
	feature_identifier = PREFERENCE_FEATURE_DROPDOWN_SWITCHER

/datum/preference/choiced/phobia/init_possible_values()
	return GLOB.phobia_types

/datum/preference/choiced/phobia/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return "Phobia" in preferences.read_preference(/datum/preference/blob/quirks)

/datum/preference/choiced/phobia/apply_to_human(mob/living/carbon/human/target, value)
	return
