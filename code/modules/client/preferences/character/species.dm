/// Species preference
/datum/preference/choiced/species
	explanation = "Species"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "species"
	priority = PREFERENCE_PRIORITY_SPECIES
	feature_identifier = PREFERENCE_FEATURE_NONE

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

	for (var/species_id in get_selectable_species())
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = new species_type()

		data[species_id] = list()
		data[species_id]["name"] = species.name
		data[species_id]["desc"] = species.get_species_description()
		data[species_id]["lore"] = species.get_species_lore()
		data[species_id]["icon"] = sanitize_css_class_name(species.name)
		data[species_id]["use_skintones"] = species.use_skintones
		data[species_id]["sexes"] = species.sexes
		data[species_id]["enabled_features"] = species.get_features()
		data[species_id]["traits"] = species.get_notable_traits()
		data[species_id]["diet"] =  species.get_species_diet()

		qdel(species)

	return data
