/// Species preference
/datum/preference/choiced/species
	explanation = "Species"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "species"
	priority = PREFERENCE_PRIORITY_SPECIES
	feature_identifier = PREFERENCE_FEATURE_NONE
	category = PREFERENCE_CATEGORY_MISC

/datum/preference/choiced/species/deserialize(input, datum/preferences/preferences)
	// The input should never be null here.
	return GLOB.species_list[sanitize_inlist(input, get_choices_serialized(), SPECIES_HUMAN)]

/datum/preference/choiced/species/serialize(input)
	if (!input) // Haven't picked a species yet.
		return null
	var/datum/species/species = input
	return initial(species.id)

/datum/preference/choiced/species/create_default_value()
	return null

/datum/preference/choiced/species/is_valid(value)
	. = ..()
	return . || value == null

/datum/preference/choiced/species/create_random_value(datum/preferences/preferences)
	return pick(get_choices())

/datum/preference/choiced/species/init_possible_values()
	var/list/values = list()

	for (var/species_id in get_selectable_species())
		values += GLOB.species_list[species_id]

	return values

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/target, value)
	target.set_species(value, icon_update = FALSE, pref_load = TRUE)

/datum/preference/choiced/species/value_changed(datum/preferences/prefs, new_value, old_value)
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/appearance_mods]
	prefs.update_preference(P, P.create_default_value())

/datum/preference/choiced/species/compile_constant_data()
	var/list/data = list()

	// This may serialize multiple levels of supspecies, but the frontend may not render it nicely
	// Get someone who actually enjoys whatever the hell is going on there to do it properly - Rimi
	var/list/species_by_id = list()
	var/list/subspecies = list()
	for (var/species_id in get_selectable_species())
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = new species_type
		species_by_id[species.id] = species
		if (length(species.subspecies))
			subspecies += species.subspecies

	for (var/species_id in species_by_id)
		var/datum/species/species = species_by_id[species_id]
		// Parent species handle serialization of these.
		if (species.type in subspecies)
			continue

		data[species.id] = serialize_species(species)

	return data

/datum/preference/choiced/species/proc/serialize_species(datum/species/species)

	var/list/subspecies_list

	if (length(species.subspecies))
		subspecies_list = list()
		for (var/datum/species/subspecies as anything in species.subspecies)
			subspecies_list[initial(subspecies.id)] = serialize_species(new subspecies)

	return list(
		"name" = species.name,
		"desc" = species.get_species_description(),
		"lore" = species.get_species_lore(),
		"icon" = sanitize_css_class_name(species.name),
		"use_skintones" = species.use_skintones,
		"sexes" = species.sexes,
		"enabled_features" = species.get_features(),
		"traits" = species.get_notable_traits(),
		"diet" = species.get_species_diet(),
		"subspecies" = subspecies_list,
	)
