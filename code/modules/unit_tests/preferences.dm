/// Requires all preferences to implement required methods.
/datum/unit_test/preferences_implement_everything

/datum/unit_test/preferences_implement_everything/Run()
	var/datum/preferences/preferences = new(new /datum/client_interface)
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		if (preference.savefile_identifier == PREFERENCE_SAVEFILE_CHARACTER)
			preference.apply_to_human(human, preference.create_informed_default_value(preferences), preferences)

		if (istype(preference, /datum/preference/choiced))
			var/datum/preference/choiced/choiced_preference = preference
			choiced_preference.init_possible_values()

		if (istype(preference, /datum/preference/choiced/mutant))
			var/datum/preference/choiced/mutant/mutant = preference
			if (!mutant.relevant_mutant_bodypart)
				Fail("[preference_type] doesn't specify relevant_mutant_bodypart", "code/modules/unit_tests/preferences.dm", 20)
			if (!islist(mutant.sprite_accessory))
				Fail("[preference_type] doesn't specify sprite_accessory", "code/modules/unit_tests/preferences.dm", 22)
			if (!mutant.organ_type_to_use)
				Fail("[preference_type] doesn't specify organ_type_to_use", "code/modules/unit_tests/preferences.dm", 24)

		if (istype(preference, /datum/preference/color/mutant))
			var/datum/preference/color/mutant/mutant = preference
			if (!mutant.choiced_preference_datum)
				Fail("[mutant.type] doesn't specify choiced_preference_datum", "code/modules/unit_tests/preferences.dm", 29)

		if (!preference.category)
			Fail("[preference_type] has no category!")

		if (!preference.explanation)
			Fail("[preference_type] has no explanation!")

		if (preference.feature_identifier == "None" && preference.category != "misc")
			Fail("[preference_type] has a category that's auto handled, yet doesn't have a feature identifier!")

		// Smoke-test is_valid
		preference.is_valid("string")
		preference.is_valid(100)
		preference.is_valid(list(1, 2, 3))
		preference.is_valid(null)
		preference.is_valid(/datum/unit_test)
		preference.is_valid(new /datum/unit_test)

/// Requires all preferences to have a valid, unique savefile_identifier.
/datum/unit_test/preferences_valid_savefile_key

/datum/unit_test/preferences_valid_savefile_key/Run()
	var/list/known_savefile_keys = list()

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		if (!istext(preference.savefile_key))
			TEST_FAIL("[preference_type] has an invalid savefile_key.")

		if (preference.savefile_key in known_savefile_keys)
			TEST_FAIL("[preference_type] has a non-unique savefile_key `[preference.savefile_key]`!")

		known_savefile_keys += preference.savefile_key

/datum/unit_test/preferences_can_serialize

/datum/unit_test/preferences_can_serialize/Run()
	var/datum/preferences/preferences = new(new /datum/client_interface)
	preferences.ui_data()
	preferences.ui_static_data()
