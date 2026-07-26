// RIMI TODO: Remove this and instead make these apply from mutant prefs.
/datum/preference/appearance_mods
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "appearance_mods"
	priority = PREFERENCE_PRIORITY_APPEARANCE_MODS
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/appearance_mods/deserialize(input, datum/preferences/preferences)
	var/list/input_list = input:Copy()
	var/list/return_list = list()
	for(var/_type in input_list)
		var/list/mod_data = global.ModManager.DeserializeSavedMod(input_list[_type])
		if(!mod_data)
			continue
		return_list[_type] = mod_data

	return return_list

/datum/preference/appearance_mods/serialize(input)
	var/list/input_list = input:Copy()
	var/list/serialized_mods = list()
	for(var/_type in input_list)
		var/list/mod_data = input[_type]
		if(!mod_data)
			continue
		var/list/serial_mod_data = global.ModManager.SerializeModData(mod_data)
		if(!serial_mod_data)
			continue
		serialized_mods[serial_mod_data["path"]] = serial_mod_data
	return serialized_mods

/datum/preference/appearance_mods/apply_to_human(mob/living/carbon/human/target, value)
	var/list/deserialized_mods = value
	if(!value)
		return

	QDEL_LIST_ASSOC_VAL(target.appearance_mods)
	for(var/_type in deserialized_mods)
		var/list/mod_data = deserialized_mods[_type]
		var/new_color = mod_data["color"]
		var/new_priority = mod_data["priority"]
		var/new_blend_func = mod_data["color_blend"]

		var/datum/appearance_modifier/mod = LAZYACCESS(target.appearance_mods, _type)
		if(mod)
			if(!(mod.color == new_color) || !(mod.priority == new_priority) || !(mod.color_blend_func == new_blend_func))
				mod.SetValues(new_color, new_priority, new_blend_func)
				continue

		mod = global.ModManager.NewInstance(_type)
		mod.SetValues(new_color, new_priority, new_blend_func)
		mod.ApplyToMob(target)
		LAZYADDASSOC(target.appearance_mods, _type, mod)

	target.update_body_parts()

/datum/preference/appearance_mods/create_default_value()
	return list()

/datum/preference/appearance_mods/is_valid(value)
	if(!islist(value))
		return FALSE
	return TRUE


// RIMI TODO: Reference code
// /datum/preference/appearance_mods/button_act(mob/user, datum/preferences/prefs, list/params)
// 	var/datum/preference/requested_preference = GLOB.preference_entries_by_key["appearance_mods"]
// 	if (isnull(requested_preference))
// 		return FALSE

// 	var/list/pref_mods = prefs.read_preference(/datum/preference/appearance_mods):Copy()
// 	var/species_type = prefs.read_preference(/datum/preference/choiced/species)
// 	var/list/existing_mods = list()
// 	//All of pref code is written with the assumption that pref values about to be saved are serialized
// 	pref_mods = requested_preference.serialize(pref_mods)

// 	for(var/_type in pref_mods)
// 		var/datum/appearance_modifier/path = pref_mods[_type]["path"]
// 		path = text2path(path)
// 		existing_mods[initial(path.name)] = _type


// 	if(params["add"])
// 		var/list/add_new = global.ModManager.modnames_by_species[species_type] ^ existing_mods
// 		var/choice = tgui_input_list(usr, "Add Appearance Mod", "Appearance Mods", add_new)
// 		if(!choice)
// 			return FALSE

// 		var/datum/appearance_modifier/mod = global.ModManager.mods_by_name[choice]
// 		var/list/new_mod_data = list(
// 			"path" = "[mod.type]",
// 			"color" = "#FFFFFF",
// 			"priority" = 0,
// 			"color_blend" = "[mod.color_blend_func]",
// 		)

// 		if(mod.colorable)
// 			var/color = input(usr, "Appearance Mod Color", "Appearance Mods", COLOR_WHITE) as null|color
// 			if(!color)
// 				return FALSE
// 			new_mod_data["color"] = color

// 		var/priority = input(usr, "Appearance Mod Priority", "Appearance Mods", 0) as null|num
// 		if(isnull(priority))
// 			return

// 		new_mod_data["priority"] = "[priority]"

// 		if(!global.ModManager.ValidateSerializedList(new_mod_data))
// 			return FALSE

// 		pref_mods[mod.type] = new_mod_data

// 		if(!prefs.update_preference(requested_preference, pref_mods))
// 			return FALSE

// 		return TRUE

// 	else if(params["remove"])
// 		var/index_to_remove = params["mod_name"]
// 		if(!index_to_remove)
// 			return FALSE
// 		var/safety = alert(user, "Are you sure you want to remove [index_to_remove]?", "Remove Appearance Mod", "Yes", "No")
// 		if(safety != "Yes")
// 			return FALSE

// 		pref_mods -= existing_mods[index_to_remove]
// 		if(!prefs.update_preference(requested_preference, pref_mods))
// 			return FALSE
// 		return TRUE

// 	else if(params["modify"])
// 		var/index_to_modify = params["mod_name"]
// 		if(!index_to_modify)
// 			return FALSE

// 		var/static/list/modifiable_values = list("priority")
// 		var/datum/appearance_modifier/type2check = text2path(existing_mods[index_to_modify])
// 		if(initial(type2check.colorable))
// 			modifiable_values += "color"

// 		var/value2modify = tgui_input_list(usr, "Select Var to Modify", "Appearance Mods", modifiable_values)
// 		if(!value2modify)
// 			return FALSE

// 		switch(value2modify)
// 			if("color")
// 				var/color = input(usr, "Appearance Mod Color", "Appearance Mods", COLOR_WHITE) as null|color
// 				if(!color)
// 					return FALSE

// 				pref_mods[existing_mods[index_to_modify]]["color"] = color

// 			if("priority")
// 				var/priority = input(usr, "Appearance Mod Priority", "Appearance Mods", 0) as null|num
// 				if(isnull(priority))
// 					return
// 				pref_mods[existing_mods[index_to_modify]]["priority"] = "[priority]"

// 		if(!prefs.update_preference(requested_preference, pref_mods))
// 			return FALSE
// 		return TRUE
