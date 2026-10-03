/datum/preference/numeric/age
	explanation = "Age"
	savefile_key = "age"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_NUMBER
	category = PREFERENCE_CATEGORY_EMPLOYEE_PII

	minimum = AGE_MIN
	maximum = AGE_MAX

/datum/preference/numeric/age/apply_to_human(mob/living/carbon/human/target, value)
	target.age = value
