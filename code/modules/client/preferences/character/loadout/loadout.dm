/datum/preference/blob/loadout
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "nu_loadout"
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/blob/loadout/apply_to_human(mob/living/carbon/human/target, value)
	return //We handle this in job code.

/datum/preference/blob/loadout/create_default_value()
	return list()

/datum/preference/blob/loadout/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return create_default_value()

	var/list/loadout_entries = list()
	for(var/list/entry as anything in input)
		var/path = text2path(entry["path"])
		if(!path || !(locate(path) in GLOB.loadout_items))
			continue

		var/name = entry["name"]
		var/desc = entry["desc"]
		var/color = entry["color"]
		var/gags_colors = entry["gags_colors"]
		var/color_rotation = entry["color_rotation"]

		var/datum/loadout_entry/entry_datum = new(path, name, desc, color, gags_colors, color_rotation)

		loadout_entries += entry_datum

	var/points_in_slot = preferences.calculate_loadout_points(loadout_entries)
	if(points_in_slot < 0)
		return create_default_value()

	return loadout_entries

/datum/preference/blob/loadout/serialize(input)
	if(!islist(input))
		return json_encode(create_default_value())

	var/list/out = list()
	for(var/datum/loadout_entry/entry in input)
		out[++out.len] = entry.to_list()

	return out
