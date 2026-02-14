/datum/preference/blob/antagonists
	savefile_key = "antagonists"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/blob/antagonists/create_default_value()
	. = list()
	for(var/antagonist in GLOB.special_roles)
		.[antagonist] = TRUE

/datum/preference/blob/antagonists/deserialize(input, datum/preferences/preferences)
	var/list/reference = create_default_value()
	input |= reference
	input &= reference
	for(var/antagonist in input)
		input[antagonist] = !!input[antagonist]
	return input

/datum/preference/blob/antagonists/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/list/client_antags = prefs.read_preference(type)
	if(params["select_all"])
		for(var/antag in client_antags)
			client_antags[antag] = TRUE
		return prefs.update_preference(src, client_antags)

	if(params["deselect_all"])
		for(var/antag in client_antags)
			client_antags[antag] = FALSE
		return prefs.update_preference(src, client_antags)

	var/antag = params["toggle_antag"]
	if(!(antag in client_antags))
		return

	client_antags[antag] = !client_antags[antag]
	return prefs.update_preference(src, client_antags)
