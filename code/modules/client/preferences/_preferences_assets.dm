/// Assets generated from `/datum/preference` icons
/datum/asset/spritesheet/preferences
	name = "preferences"
	early = TRUE
	cross_round_cachable = TRUE
	load_immediately = TRUE

/datum/asset/spritesheet/preferences/create_spritesheets()
	var/list/to_insert = list()

	for (var/preference_key in GLOB.preference_entries_by_key)
		var/datum/preference/choiced/preference = GLOB.preference_entries_by_key[preference_key]
		if (!istype(preference))
			continue

		if (!preference.should_generate_icons)
			continue

		var/list/choices = preference.get_choices_serialized()
		for (var/preference_value in choices)
			var/create_icon_of = choices[preference_value]

			var/icon/icon
			var/icon_state

			if (ispath(create_icon_of, /atom))
				var/atom/atom_icon_source = create_icon_of
				icon = initial(atom_icon_source.icon)
				icon_state = initial(atom_icon_source.icon_state)
			else if (isicon(create_icon_of))
				icon = create_icon_of
			else
				CRASH("[create_icon_of] is an invalid preference value (from [preference_key]:[preference_value]).")

			to_insert[preference.get_spritesheet_key(preference_value)] = list(icon, icon_state)

	for (var/datum/species/species as anything in get_selectable_species_by_type())
		// We're not particularly performance sensitive here. While I don't trust species to change owners nicely, I do expect the same species to be able to modify itself without breaking.
		var/mob/living/carbon/human/dummy/consistent/dummy = new
		species = new species()
		for (var/gender in list(MALE, FEMALE))
			for (var/i = 1, i < 5, i++)
				species.prepare_human_for_preview(dummy, gender, i)
				var/icon/icon = get_flat_existing_human_icon(dummy)
				for (var/dir in GLOB.cardinals)
					Insert("species___[species.id]_[gender == MALE ? "male" : "female"]_[i]_[dir2text(dir)]", icon, "", dir)

	for (var/datum/job/job as anything in SSjob.joinable_occupations)
		var/mob/living/carbon/human/dummy/consistent/dummy = new
		job.prepare_human_for_preview(dummy)
		var/icon = get_flat_existing_human_icon(dummy, list(SOUTH))
		Insert("job___[sanitize_css_class_name(job.id)]", icon)

	for (var/spritesheet_key in to_insert)
		var/list/inserting = to_insert[spritesheet_key]
		Insert(spritesheet_key, inserting[1], inserting[2])

/// Returns the key that will be used in the spritesheet for a given value.
/datum/preference/proc/get_spritesheet_key(value)
	return "[savefile_key]___[sanitize_css_class_name(value)]"

/// Sends information needed for shared details on individual preferences
/datum/asset/json/preferences
	name = "preferences"

/datum/asset/json/preferences/generate()
	var/list/preference_data = list()

	for (var/middleware_type in subtypesof(/datum/preference_middleware))
		var/datum/preference_middleware/middleware = new middleware_type
		var/data = middleware.get_constant_data()
		if (!isnull(data))
			preference_data[middleware.key] = data

		qdel(middleware)

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference_entry = GLOB.preference_entries[preference_type]
		var/data = preference_entry.compile_constant_data()
		if (!isnull(data))
			preference_data[preference_entry.savefile_key] = data

	return preference_data
