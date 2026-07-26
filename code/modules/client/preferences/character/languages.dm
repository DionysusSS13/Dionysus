/datum/preference/blob/languages
	priority = PREFERENCE_PRIORITY_APPEARANCE_MODS //run after everything mostly
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "languages"
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/blob/languages/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return create_default_value()

	input &= GLOB.preference_language_types

	if(!check_legality(input))
		return create_default_value()

	return input

/datum/preference/blob/languages/create_default_value()
	return list()

/datum/preference/blob/languages/apply_to_human(mob/living/carbon/human/target, value)
	for(var/datum/language/path as anything in value)
		var/language_flags = value[path]
		target.grant_language(path, language_flags & LANGUAGE_UNDERSTAND, language_flags & LANGUAGE_SPEAK, LANGUAGE_MIND)

/datum/preference/blob/languages/proc/tally_points(list/languages)
	var/point_tally = 0
	for(var/datum/language/path as anything in languages)
		var/value = languages[path]
		if(value & LANGUAGE_SPEAK)
			point_tally++
		if(value & LANGUAGE_UNDERSTAND)
			point_tally++

	return point_tally

/datum/preference/blob/languages/proc/check_legality(list/languages)
	return tally_points(languages) <= 3
