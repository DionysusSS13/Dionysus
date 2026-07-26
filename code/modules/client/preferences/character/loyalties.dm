/datum/preference/choiced/datum_backed/loyalty
	explanation = "Primary Loyalty"
	savefile_key = "loyalty"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_DROPDOWN // RIMI TODO: Description dropdown
	category = PREFERENCE_CATEGORY_EMPLOYEE_LOYALTIES

	choices_datum = /datum/faction_loyalty

/datum/preference/choiced/datum_backed/secondary_loyalty
	explanation = "Secondary Loyalty"
	savefile_key = "secondary_loyalty"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_DROPDOWN
	category = PREFERENCE_CATEGORY_EMPLOYEE_LOYALTIES

	choices_datum = /datum/faction_loyalty
