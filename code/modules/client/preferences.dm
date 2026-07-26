GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	/// Whether or not we allow saving/loading. Used for guests, if they're enabled
	var/load_and_save = TRUE
	/// Ensures that we always load the last used save, QOL
	var/default_slot = 1
	/// The maximum number of slots we're allowed to contain
	var/max_save_slots = 10

	/// Bitflags for communications that are muted
	var/muted = NONE
	/// Last IP that this client has connected from
	var/last_ip
	/// Last CID that this client has connected from
	var/last_id

	/// Cached changelog size, to detect new changelogs since last join
	var/lastchangelog = ""

	/// Custom keybindings. Map of keybind names to keyboard inputs.
	/// For example, by default would have "swap_hands" -> list("X")
	var/list/key_bindings = list()

	/// Cached list of keybindings, mapping keys to actions.
	/// For example, by default would have "X" -> list("swap_hands")
	var/list/key_bindings_by_key = list()

	var/toggles = TOGGLES_DEFAULT
	var/db_flags = NONE
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"

	var/unlock_content = 0

	var/list/ignoring = list()

	var/list/exp = list()

	var/action_buttons_screen_locs = list()

	///Someone thought we were nice! We get a little heart in OOC until we join the server past the below time (we can keep it until the end of the round otherwise)
	var/hearted
	///If we have a hearted commendations, we honor it every time the player loads preferences until this time has been passed
	var/hearted_until
	///What outfit typepaths we've favorited in the SelectEquipment menu
	var/list/favorite_outfits = list()

	/// A list of instantiated middleware
	var/list/datum/preference_middleware/middleware = list()

	/// The json savefile for this datum
	var/datum/json_savefile/savefile

	/// A list of keys that have been updated since the last save.
	var/list/recently_updated_keys = list()

	/// A cache of preference entries to values.
	/// Used to avoid expensive READ_FILE every time a preference is retrieved.
	var/value_cache = list()

	/// If set to TRUE, will update character_profiles on the next ui_data tick.
	var/tainted_character_profiles = FALSE

	/// Preference of how the preview should show the character.
	var/tmp/preview_pref = PREVIEW_PREF_JOB

	/// Used by the loadout UI
	var/tmp/loadout_show_equipped = FALSE
	var/tmp/loadout_category = LOADOUT_CATEGORY_BACKPACK
	var/tmp/loadout_subcategory = LOADOUT_SUBCATEGORY_MISC

	var/datum/preferences_menu/preferences_menu

/datum/preferences/Destroy(force, ...)
	QDEL_LIST(middleware)
	value_cache = null
	return ..()

/datum/preferences/New(client/C)
	if(!C)
		CRASH("Attempted to create preferences without a client or mock.")
	parent = C
	preferences_menu = new(src)

	for (var/middleware_type in subtypesof(/datum/preference_middleware))
		middleware += new middleware_type(src)

	if(istype(C) || istype(C, /datum/client_interface))
#ifdef UNIT_TESTS
		load_and_save = !is_guest_key(parent.key) //Treat them as fully real.
#else
		load_and_save = !is_guest_key(parent.key) && !istype(C, /datum/client_interface) // Never save mock clients to disk on prod.
#endif
		load_path(parent.ckey)
		if(load_and_save && !fexists(path))
			try_savefile_type_migration()
		unlock_content = !!C.IsByondMember() //TG made this a preference level var, I can do that if you want.
		if(unlock_content)
			max_save_slots = 15

	load_savefile()

	// give them default keybinds and update their movement keys
	key_bindings = deep_copy_list(GLOB.default_hotkeys)
	key_bindings_by_key = get_key_bindings_by_key(key_bindings)

	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return
	//we couldn't load character data so just randomize the character appearance + name
	randomise_appearance_prefs() //let's create a random character then - rather than a fat, bald and naked man.
	if(C)
		apply_all_client_preferences()
		C.set_macros()

	if(!loaded_preferences_successfully)
		save_preferences()
	save_character() //let's save this new random character so it doesn't keep generating new ones.

/datum/preferences/Topic(href, list/href_list)
	. = ..()
	if (.)
		return

	if (href_list["open_keybindings"])
		preferences_menu.ui_interact(usr, tab = PREFERENCE_TAB_KEYBINDINGS)
		return TRUE

/datum/preferences/proc/compile_character_preferences(mob/user)
	var/list/preferences = list()

	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (!preference.is_accessible(src))
			continue

		LAZYINITLIST(preferences[preference.category])

		var/value = read_preference(preference.type)
		var/data = preference.compile_ui_data(user, value, src)

		preferences[preference.category][preference.savefile_key] = data

	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		var/list/append_character_preferences = preference_middleware.get_character_preferences(user)
		if (isnull(append_character_preferences))
			continue

		for (var/category in append_character_preferences)
			if (category in preferences)
				preferences[category] += append_character_preferences[category]
			else
				preferences[category] = append_character_preferences[category]

	return preferences

/// Applies all PREFERENCE_SAVEFILE_PLAYER preferences
/datum/preferences/proc/apply_all_client_preferences()
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (preference.savefile_identifier != PREFERENCE_SAVEFILE_PLAYER)
			continue

		value_cache -= preference.type
		preference.apply_to_client(parent, read_preference(preference.type))

/datum/preferences/proc/create_character_profiles()
	var/list/profiles = list()

	for (var/index in 1 to max_save_slots)
		var/tree_key = "character[index]"
		var/save_data = savefile.get_entry(tree_key)

		var/is_default = index == default_slot

		var/name = is_default ? read_preference(/datum/preference/name/real_name) : save_data?["real_name"]
		var/icon = is_default ? read_preference(/datum/preference/stored_appearance) : save_data?["stored_appearance"]
		if (!icon && is_default)
			icon = icon2base64(get_flat_existing_human_icon(preferences_menu.character_preview_view.preview1.body, list(SOUTH)))
			write_preference(
				GLOB.preference_entries[/datum/preference/stored_appearance],
				icon
			)

		var/data = list(
			list(
				"name" = name,
				"image" = icon
			)
		)
		profiles += data


	return profiles

/// Applies the given preferences to a human mob.
/datum/preferences/proc/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE)
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (preference.savefile_identifier != PREFERENCE_SAVEFILE_CHARACTER)
			continue
		if(preference.requires_accessible && !preference.is_accessible(src))
			continue
		preference.apply_to_human(character, read_preference(preference.type), src)

	character.dna.real_name = character.real_name

	if(icon_updates)
		character.icon_render_keys = list()
		character.update_body(is_creating = TRUE)

/// Inverts the key_bindings list such that it can be used for key_bindings_by_key
/datum/preferences/proc/get_key_bindings_by_key(list/key_bindings)
	var/list/output = list()

	for (var/action in key_bindings)
		for (var/key in key_bindings[action])
			LAZYADD(output[key], action)

	return output

/datum/preferences/proc/get_chosen_job_title(job_id)
	RETURN_TYPE(/datum/job_title)
	var/datum/job/job = SSjob.GetJob(job_id)

	if (!job)
		CRASH("Given job id doesn't exist! ([job_id])")

	var/list/titles = read_preference(/datum/preference/blob/alternate_titles)
	var/datum/job_title/title = titles[job_id]

	if (!title)
		return job.get_title()

	return title

/datum/preferences/proc/get_chosen_job_title_name(job_id)
	var/datum/job_title/title = get_chosen_job_title(job_id)

	if (!title)
		var/datum/job/job = SSjob.GetJob(job_id)

		if (!job)
			CRASH("Given job id doesn't exist! ([job_id])")

		return job.get_title_name()

	return title.name
