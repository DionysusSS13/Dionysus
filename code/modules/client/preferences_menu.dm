/datum/preferences_menu
	var/datum/preferences/preferences
	var/datum/quad_char_preview/character_preview_view

	var/background = 1

	/// The current window, PREFERENCE_TAB_* in [`code/__DEFINES/preferences.dm`]
	var/current_window = PREFERENCE_TAB_CHARACTER

/datum/preferences_menu/New(datum/preferences/preferences)
	. = ..()
	src.preferences = preferences

/datum/preferences_menu/Destroy(force, ...)
	QDEL_NULL(character_preview_view)
	. = ..()

/datum/preferences_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch (action)
		if ("change_slot")
			// Save existing character
			preferences.save_character()

			// SAFETY: `load_character` performs sanitization the slot number
			if (!preferences.load_character(params["slot"]))
				preferences.tainted_character_profiles = TRUE
				preferences.randomise_appearance_prefs()
				preferences.save_character()

			for (var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
				preference_middleware.on_new_character(usr)

			character_preview_view.update_body()

			return TRUE

		if ("cycle_background")
			var/forwards = params["forwards"]
			background += forwards ? 1 : -1
			if (background > length(GLOB.preferences_preview_backgrounds))
				background = 1
			else if (background < 1)
				background = length(GLOB.preferences_preview_backgrounds)

			character_preview_view.update_canvas()

			return TRUE

		if ("set_preference")
			var/requested_preference_key = params["preference"]
			var/value = params["value"]

			for (var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
				if (preference_middleware.pre_set_preference(usr, requested_preference_key, value))
					return TRUE

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference) || requested_preference.locked)
				return FALSE

			// SAFETY: `write_preference` performs validation checks
			if (!preferences.write_preference(requested_preference, value))
				return FALSE

			if (istype(requested_preference, /datum/preference/name))
				preferences.tainted_character_profiles = TRUE

			if (requested_preference.savefile_identifier == PREFERENCE_SAVEFILE_CHARACTER)
				preferences.write_preference(GLOB.preference_entries[/datum/preference/stored_appearance], null)

			return TRUE

		if ("set_color_preference")
			var/requested_preference_key = params["preference"]

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference))
				return FALSE

			if (!istype(requested_preference, /datum/preference/color))
				return FALSE

			var/default_value = preferences.read_preference(requested_preference.type)

			// Yielding
			var/new_color = tgui_color_picker(
				usr,
				"Select new color",
				null,
				default_value || COLOR_WHITE,
			)

			if (!new_color)
				return FALSE

			if (!preferences.update_preference(requested_preference, new_color))
				return FALSE

			if (requested_preference.savefile_identifier == PREFERENCE_SAVEFILE_CHARACTER)
				preferences.write_preference(GLOB.preference_entries[/datum/preference/stored_appearance], null)

			return TRUE

		if ("set_tricolor_preference")
			var/requested_preference_key = params["preference"]
			var/index_key = params["value"]
			if(!isnum(index_key))
				return FALSE

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference))
				return FALSE

			if (!istype(requested_preference, /datum/preference/color/mutant))
				return FALSE

			var/old_value_list = preferences.read_preference(requested_preference.type)
			if (!islist(old_value_list))
				return FALSE
			var/old_value = old_value_list[index_key]

			// Yielding
			var/new_color = tgui_color_picker(
				usr,
				"Select new color",
				null,
				old_value || COLOR_WHITE,
			)

			if (!new_color)
				return FALSE

			// Handles turning #000000 to current skin color
			if(new_color == COLOR_BLACK)
				new_color = preferences.read_preference(/datum/preference/color/skin_color)

			old_value_list[index_key] = copytext(new_color, 2)

			if (!preferences.update_preference(requested_preference, jointext(old_value_list, ";")))
				return FALSE

			if (requested_preference.savefile_identifier == PREFERENCE_SAVEFILE_CHARACTER)
				preferences.write_preference(GLOB.preference_entries[/datum/preference/stored_appearance], null)

			return TRUE

		// Automated callback that fixes maps not being sized properly. Thanks BYOND.
		if ("do_da_jiggle")
			character_preview_view.jiggle()

	for (var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
		var/delegation = preference_middleware.action_delegations[action]
		if (!isnull(delegation))
			return call(preference_middleware, delegation)(params, usr)

	return FALSE

/datum/preferences_menu/ui_data(mob/user)
	var/list/data = list()

	if (preferences.tainted_character_profiles)
		data["character_profiles"] = preferences.create_character_profiles()
		preferences.tainted_character_profiles = FALSE

	data["preview_options"] = list(PREVIEW_PREF_JOB,PREVIEW_PREF_LOADOUT, PREVIEW_PREF_UNDERWEAR)
	data["preview_selection"] = preferences.preview_pref

	data["character_preferences"] = preferences.compile_character_preferences(user)

	// character_preview_view.update_body()

	// var/icon/char_icon = get_flat_existing_human_icon(character_preview_view.body)
	// var/icon/preview_icon = icon('icons/blanks/32x128.dmi', "nothing")
	// var/offset = 0
	// for (var/dir in GLOB.cardinals)
	// 	preview_icon.Blend(icon('icons/turf/floors.dmi', "floor"), ICON_OVERLAY, 0, offset)
	// 	preview_icon.Blend(icon(char_icon, dir=dir), ICON_OVERLAY, 0, offset)
	// 	offset += 32

	// data["character_preview_icon"] = icon2base64(preview_icon)

	data["active_slot"] = preferences.default_slot

	data["character_profiles"] = preferences.create_character_profiles()

	for (var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
		data += preference_middleware.get_ui_data(user)

	return data

/datum/preferences_menu/ui_static_data(mob/user)
	var/list/data = list()

	// Fuck maps and especially this dogshit """engine""", I have better shit to do.
	// If someone wants to make this a map, then good fucking luck, I wasted five hours on this fucking garbage.
	data["character_preview_view"] = character_preview_view.assigned_maps()

	data["overflow_role"] = SSjob.GetJobType(SSjob.overflow_role).id
	data["window"] = current_window

	data["content_unlocked"] = preferences.unlock_content

	for (var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
		data += preference_middleware.get_ui_static_data(user)

	return data

/datum/preferences_menu/ui_state(mob/user)
	return GLOB.always_state

// Without this, a hacker would be able to edit other people's preferences if
// they had the ref to Topic to.
/datum/preferences_menu/ui_status(mob/user, datum/ui_state/state)
	return user.client == preferences.parent ? UI_INTERACTIVE : UI_CLOSE

/datum/preferences_menu/ui_close(mob/user)
	preferences.save_character()
	preferences.save_preferences()
	QDEL_NULL(character_preview_view)

/datum/preferences_menu/ui_assets(mob/user)
	var/list/assets = list(
		get_asset_datum(/datum/asset/spritesheet/preferences),
		get_asset_datum(/datum/asset/json/preferences),
	)

	for (var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
		assets += preference_middleware.get_ui_assets()

	return assets

/datum/preferences_menu/ui_interact(mob/user, datum/tgui/ui, tab)
	// If you leave and come back, re-register the character preview
	if (!isnull(character_preview_view) && !(character_preview_view.preview1 in user.client?.screen))
		user.client?.register_map_obj(character_preview_view)

	if (tab)
		current_window = tab
		update_static_data(usr)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		character_preview_view = create_character_preview_view(user)
		ui = new(user, src, current_window == PREFERENCE_TAB_CHARACTER ? "DioPrefs" : "PreferencesMenu")
		ui.set_autoupdate(FALSE)
		ui.open()
		character_preview_view.display_to(user, ui.window)

/datum/preferences_menu/proc/create_character_preview_view(mob/user)
	character_preview_view = new(preferences)
	character_preview_view.generate_view()
	character_preview_view.update_body()

	return character_preview_view

/datum/preferences_menu/proc/render_new_preview_appearance(mob/living/carbon/human/dummy/mannequin)
	return preferences.render_new_preview_appearance(mannequin)
