/// An associative list of job_name:employer_path
/datum/preference/choiced/employer
	explanation = "Employer"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "employer"
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/choiced/employer/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/employer/create_default_value()
	return /datum/employer/none

/datum/preference/choiced/employer/init_possible_values()
	return subtypesof(/datum/employer)

/datum/preference/choiced/employer/value_changed(datum/preferences/prefs, new_value, old_value)
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/blob/job_priority]
	prefs.update_preference(P, P.create_default_value())

/datum/preference/choiced/employer/serialize(input)
	var/datum/employer/path = input
	return initial(path.name)

/datum/preference/choiced/employer/deserialize(input, datum/preferences/preferences)
	if(input in get_choices_serialized())
		return GLOB.employers_by_name[input]

	return create_default_value()

/datum/preference/choiced/employer/create_default_value()
	return /datum/employer/none

/// Associative list of job:integer, where integer is a priority between 1 and 4
/datum/preference/blob/job_priority
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "job_priority"
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/blob/job_priority/create_default_value()
	return list()

/datum/preference/blob/job_priority/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/blob/job_priority/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return create_default_value()

	for(var/thing in input)
		if(!istext(thing) || !SSjob.GetJob(thing))
			input -= thing
			continue

		if(!isnum(input[thing]) || !(input[thing] in list(JP_LOW, JP_MEDIUM, JP_HIGH)))
			input -= thing

	return input
