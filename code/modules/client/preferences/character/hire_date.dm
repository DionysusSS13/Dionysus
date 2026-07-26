/datum/preference/hire_date
	explanation = "Hire Date"
	savefile_key = "hire_date"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_SHORT_TEXT
	category = PREFERENCE_CATEGORY_EMPLOYEE_PII
	locked = TRUE

/datum/preference/hire_date/create_default_value()
	return "[time2text(world.realtime, "DD MMM")] [text2num(time2text(world.realtime, "YYYY")) + STATION_YEAR_OFFSET]"

/datum/preference/hire_date/is_valid(value)
	return length(value) == 11

/datum/preference/hire_date/deserialize(input, datum/preferences/preferences)
	return input // This can never be edited
