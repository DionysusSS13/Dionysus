/datum/preference/blob/alternate_titles
	explanation = "Alternate Titles"
	savefile_key = "alternate_titles"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_NONE
	category = PREFERENCE_CATEGORY_MISC

/datum/preference/blob/alternate_titles/deserialize(input, datum/preferences/preferences)
	if (!islist(input))
		return

	for (var/key in input)
		if (isnum(key))
			input -= key
			continue

		var/datum/job/job = SSjob.GetJob(key)
		if (!job)
			input -= key
			continue

		var/name = input[key]
		var/found_title
		for (var/datum/job_title/title as anything in job.titles)
			if (title.name == name)
				found_title = TRUE
				break

		if (!found_title)
			input -= key

	return input
