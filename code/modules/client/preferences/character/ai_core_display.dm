/// What to show on the AI screen
/datum/preference/choiced/ai_core_display
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "preferred_ai_core_display"
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX

/datum/preference/choiced/ai_core_display/init_possible_values()
	return GLOB.ai_core_display_screens - "Portrait"

/datum/preference/choiced/ai_core_display/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return istype(preferences.get_highest_priority_job(), /datum/job/ai)

/datum/preference/choiced/ai_core_display/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/ai_core_display/create_default_value()
	return "Goon"
