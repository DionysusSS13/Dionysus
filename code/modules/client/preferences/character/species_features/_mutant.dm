// Made in Artea with spite.

// This isn't technically mutant stuff only anymore, it's just the historic term for parts that aren't seen on baseline humans.
// Except I've fucked the system into submission and now I can use it for anything I want.
/datum/preference/choiced/mutant
	priority = PREFERENCE_PRIORITY_NAME_MODIFICATIONS // Otherwise organs will get qdel'd on body replacement.
	abstract_type = /datum/preference/choiced/mutant
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX
	should_generate_icons = TRUE
	can_randomize = FALSE // Let's not force folk with mutant horrors beyond their comprehension, and force them to clean up a crappy randomly generated partslist.
	/// The color feature to use for supplemental features. If null, it won't do anything.
	var/color_feature
	/// The global list containing the sprite accessories to use. Override New to set.
	var/list/sprite_accessory
	/// A list of types to exclude, including their subtypes.
	var/list/accessories_to_ignore
	/// Organ to use for this sprite accessory. The organ's sprites are overriden by the accessory sprites.
	var/obj/item/organ/organ_type_to_use

/datum/preference/choiced/mutant/create_default_value()
	return "None"

/datum/preference/choiced/mutant/init_possible_values()
	return generate_mutant_valid_values(sprite_accessory, accessories_to_ignore)

/datum/preference/choiced/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features[relevant_mutant_bodypart] = value

	var/datum/sprite_accessory/accessory = sprite_accessory[value]
	if(!is_applicable_value(accessory) || !is_accessible(preferences))
		return
	if(!accessory)
		CRASH("Accessory is null for [value]!")
	var/obj/item/organ/new_organ_to_add = new organ_type_to_use(FALSE, accessory.name)
	if (color_feature)
		new_organ_to_add.color_source = ORGAN_COLOR_DNA
		new_organ_to_add.draw_color = target.dna.features["[relevant_mutant_bodypart]_color"]
	new_organ_to_add.Insert(target, TRUE, FALSE)

/// This proc is equivalent to saying "should I apply this?". If false, the entire mutant pref will be skipped.
/datum/preference/choiced/mutant/proc/is_applicable_value(datum/sprite_accessory/accessory)
	return accessory?.icon_state && accessory.icon_state != "none" && accessory.name != "None"

/datum/preference/choiced/mutant/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	species = new species
	if(relevant_mutant_bodypart in species.mutant_bodyparts)
		return TRUE

/datum/preference/choiced/mutant/compile_constant_data()
	. = ..()
	if(color_feature)
		var/datum/preference/sub_preference_instance = GLOB.preference_entries[color_feature]
		LAZYADD(.[PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES], list(list("key" = sub_preference_instance.savefile_key, "feature" = sub_preference_instance.feature_identifier)))

/// Mutant color. Used to automagically apply a color to a mutant part. Very nice.
/datum/preference/color/mutant
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	abstract_type = /datum/preference/color/mutant
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_TRI_COLOR

	/// The path of the mutant choice datum to read from. Important.
	var/choiced_preference_datum

/datum/preference/color/mutant/deserialize(input, datum/preferences/preferences)
	return sanitize_hexcolor_list(splittext(input, ";"))

/datum/preference/color/mutant/serialize(input)
	return "[input[1]];[input[2]];[input[3]]"

/// Helper proc that ensures the list is in the correct format. Potentially destructive.
/datum/preference/color/mutant/proc/sanitize_hexcolor_list(list/input)
	if(!islist(input) || length(input) != 3 || "{" == copytext(json_encode(input), 1, 2))
		return create_default_value()

	for(var/index = 1, index < 4, index++)
		input[index] = sanitize_hexcolor(input[index], include_crunch = FALSE, default = random_color())

	return input

/datum/preference/color/mutant/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/preference/choiced/mutant/pref = GLOB.preference_entries[choiced_preference_datum]
	if (!pref.is_accessible(preferences))
		return FALSE // Don't try to serialize this if it can't even be seen.

/datum/preference/color/mutant/create_default_value()
	return random_color_list(3)

// Fuck you, this is sanitized already, so this is pointless.
/datum/preference/color/mutant/is_valid(value)
	return TRUE

/datum/preference/color/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["[relevant_mutant_bodypart]_color"] = value

/datum/preference/color/mutant/compile_ui_data(mob/user, value, datum/preferences/preferences)
	var/datum/preference/choiced/mutant/pref = GLOB.preference_entries[choiced_preference_datum]
	var/datum/sprite_accessory/accessory = pref.sprite_accessory[preferences.read_preference(choiced_preference_datum)]

	if (!pref.is_applicable_value(accessory))
		return "" // No colors for you

	var/return_value = list()
	var/static/list/color_layers = list("primary", "secondary", "tertiary")


	for(var/index in 1 to 3)
		for(var/layer in global.layer2text)
			var/icon_state = build_sprite_accessory_icon_state(initial(pref.organ_type_to_use.render_key) || initial(pref.organ_type_to_use.feature_key), accessory, MALE, global.layer2text[layer], color_layers[index])
			if (index == 1 || icon_exists(accessory.icon, icon_state))
				return_value += value[index]
				break // This color layer is being used, we don't need to look any further

	return jointext(return_value, ";")
