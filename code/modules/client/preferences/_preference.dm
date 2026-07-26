// Priorities must be in order!
/// The default priority level
#define PREFERENCE_PRIORITY_DEFAULT 1
/// The priority level for quirk-based prefs
#define PREFERENCE_PRIORITY_QUIRKS 2
/// The priority at which species runs, needed for external organs to apply properly.
#define PREFERENCE_PRIORITY_SPECIES 3
/// The priority at which gender is determined, needed for proper randomization.
#define PREFERENCE_PRIORITY_GENDER 4
/// The priority at which body type is decided, applied after gender so we can
/// support the "use gender" option.
#define PREFERENCE_PRIORITY_BODY_TYPE 5
/// Augments come after species and bodytype.
#define PREFERENCE_PRIORITY_AUGMENTS 6
/// Applies branding to prosthetics
#define PREFERENCE_PRIORITY_BRANDED_PROSTHETICS 7
/// The priority hair is applied. We apply human hair first, and moth hair after, only if they are a moth. Sorry.
#define PREFERENCE_PRIORITY_HUMAN_HAIR 8
/// The priority non-human hair is applied (used to apply moth hair after normal hair)
#define PREFERENCE_PRIORITY_NONHUMAN_HAIR 9
/// The priority at which names are decided, needed for proper randomization.
#define PREFERENCE_PRIORITY_NAMES 10
/// Preferences that aren't names, but change the name changes set by PREFERENCE_PRIORITY_NAMES.
#define PREFERENCE_PRIORITY_NAME_MODIFICATIONS 11
/// Preferences that modify appearance in any non-trivial way
#define PREFERENCE_PRIORITY_APPEARANCE_MODS 12

/// The maximum preference priority, keep this updated, but don't use it for `priority`.
#define MAX_PREFERENCE_PRIORITY PREFERENCE_PRIORITY_APPEARANCE_MODS

/// For choiced preferences, this key will be used to set display names in constant data.
#define CHOICED_PREFERENCE_DISPLAY_NAMES "display_names"

/// The required list size for crop parameters in generate_icon.
#define REQUIRED_CROP_LIST_SIZE 4
#define REQUIRED_COLOR_LIST_SIZE 3

/// An assoc list list of types to instantiated `/datum/preference` instances
GLOBAL_LIST_INIT(preference_entries, init_preference_entries())

/// An assoc list of preference entries by their `savefile_key`
GLOBAL_LIST_INIT(preference_entries_by_key, init_preference_entries_by_key())

/// Takes an assoc list of names to /datum/sprite_accessory and returns a value
/// fit for `/datum/preference/init_possible_values()`
/proc/possible_values_for_sprite_accessory_list(list/datum/sprite_accessory/sprite_accessories)
	var/list/possible_values = list()
	for (var/name in sprite_accessories)
		var/datum/sprite_accessory/sprite_accessory = sprite_accessories[name]
		if (istype(sprite_accessory))
			possible_values[name] = icon(sprite_accessory.icon, sprite_accessory.icon_state)
		else
			// This means it didn't have an icon state
			possible_values[name] = icon('icons/effects/landmarks_static.dmi', "x")
	return possible_values

/proc/init_preference_entries()
	var/list/output = list()
	for (var/datum/preference/preference_type as anything in subtypesof(/datum/preference))
		if (isabstract(preference_type))
			continue
		output[preference_type] = new preference_type
	return output

/proc/init_preference_entries_by_key()
	var/list/output = list()
	for (var/datum/preference/preference_type as anything in subtypesof(/datum/preference))
		if (isabstract(preference_type))
			continue
		output[initial(preference_type.savefile_key)] = GLOB.preference_entries[preference_type]
	return output

/// Returns a flat list of preferences in order of their priority
/proc/get_preferences_in_priority_order()
	var/list/preferences[MAX_PREFERENCE_PRIORITY]

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		LAZYADD(preferences[preference.priority], preference)

	var/list/flattened = list()
	for (var/index in 1 to MAX_PREFERENCE_PRIORITY)
		if (preferences[index])
			flattened += preferences[index]
	return flattened

/// Represents an individual preference.
/datum/preference
	abstract_type = /datum/preference
	/// The display default name when inserted into the chargen
	var/explanation

	/// The key inside the savefile to use.
	/// This is also sent to the UI.
	/// Once you pick this, don't change it.
	var/savefile_key

	/// The category of preference, for use by the PreferencesMenu.
	/// This isn't used for anything other than as a key for UI data.
	/// It is up to the PreferencesMenu UI itself to interpret it.
	var/category = "misc"

	/// What savefile should this preference be read from?
	/// Valid values are PREFERENCE_SAVEFILE_CHARACTER and PREFERENCE_SAVEFILE_PLAYER.
	/// See the documentation in [code/__DEFINES/preferences.dm].
	var/savefile_identifier

	var/feature_identifier

	/// The priority of when to apply this preference.
	/// Used for when you need to rely on another preference.
	var/priority = PREFERENCE_PRIORITY_DEFAULT

	/// If set, will be available to randomize, but only if the preference
	/// is for PREFERENCE_SAVEFILE_CHARACTER.
	var/can_randomize = TRUE

	/// If the selected species has this in its /datum/species/mutant_bodyparts,
	/// will show the feature as selectable.
	var/relevant_mutant_bodypart = null

	/// If the selected species has this in its /datum/species/species_traits,
	/// will show the feature as selectable.
	var/relevant_species_trait = null

	/// If the selected species has this in its /datum/species/var/cosmetic_organs,
	/// will show the feature as selectable.
	var/obj/item/organ/relevant_external_organ = null

	/// Any species that has any of the listed species traits will not have the option to pick this pref
	var/exclude_species_traits = list()

	/// If this preference is not accessible, do not attempt to apply it to mobs.
	var/requires_accessible = FALSE

	/// A typepath for a sub preference. Ex: Hair Style's sub_preferences is /datum/preference/color/hair_color
	var/sub_preferences

	/// Is this type a sub preference?
	var/is_sub_preference = FALSE

	/// Can this preference be edited by the user ever?
	var/locked = FALSE

/datum/preference/New()
	. = ..()
	if (abstract_type != type && savefile_identifier == PREFERENCE_SAVEFILE_CHARACTER && !feature_identifier)
		CRASH("[type] has no feature identifier!")

/// Called on the saved input when retrieving.
/// Also called by the value sent from the user through UI. Do not trust it.
/// Input is the value inside the savefile, output is to tell other code
/// what the value is.
/// This is useful either for more optimal data saving or for migrating
/// older data.
/// Must be overridden by subtypes.
/// Can return null if no value was found.
/datum/preference/proc/deserialize(input, datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`deserialize()` was not implemented on [type]!")

/// Called on the input while saving.
/// Input is the current value, output is what to save in the savefile.
/datum/preference/proc/serialize(input)
	SHOULD_NOT_SLEEP(TRUE)
	return input

/// Produce a default, potentially random value for when no value for this
/// preference is found in the savefile.
/// Either this or create_informed_default_value must be overriden by subtypes.
/datum/preference/proc/create_default_value()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`create_default_value()` was not implemented on [type]!")

/// Produce a default, potentially random value for when no value for this
/// preference is found in the savefile.
/// Unlike create_default_value(), will provide the preferences object if you
/// need to use it.
/// If not overriden, will call create_default_value() instead.
/datum/preference/proc/create_informed_default_value(datum/preferences/preferences)
	return create_default_value()

/// Produce a random value for the purposes of character randomization.
/// Will just create a default value by default.
/datum/preference/proc/create_random_value(datum/preferences/preferences)
	return create_informed_default_value(preferences)

/// Returns whether or not a preference can be randomized.
/datum/preference/proc/is_randomizable()
	SHOULD_NOT_OVERRIDE(TRUE)
	return savefile_identifier == PREFERENCE_SAVEFILE_CHARACTER && can_randomize

/// Given a savefile, return either the saved data or an acceptable default.
/// This will write to the savefile if a value was not found with the new value.
/datum/preference/proc/read(list/save_data, datum/preferences/preferences)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/value

	if (!isnull(save_data))
		value = save_data[savefile_key]

	if (isnull(value))
		return null
	else
		return deserialize(value, preferences)

/// Given a savefile, writes the inputted value.
/// Returns TRUE for a successful application.
/// Return FALSE if it is invalid.
/datum/preference/proc/write(list/save_data, value)
	SHOULD_NOT_OVERRIDE(TRUE)

	if (!is_valid(value))
		return FALSE

	if (!isnull(save_data))
		save_data[savefile_key] = serialize(value)

	return TRUE

/// Apply this preference onto the given client.
/// Called when the savefile_identifier == PREFERENCE_SAVEFILE_PLAYER.
/datum/preference/proc/apply_to_client(client/client, value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return

/// Fired when the preference is updated.
/// Calls apply_to_client by default, but can be overridden.
/datum/preference/proc/apply_to_client_updated(client/client, value)
	SHOULD_NOT_SLEEP(TRUE)
	apply_to_client(client, value)

/// Apply this preference onto the given human.
/// Must be overriden by subtypes.
/// Called when the savefile_identifier == PREFERENCE_SAVEFILE_CHARACTER.
/datum/preference/proc/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`apply_to_human()` was not implemented for [type]!")

/datum/preferences/proc/get_save_data_for_savefile_identifier(savefile_identifier)
	RETURN_TYPE(/list)

	if (!parent)
		return null
	if(!savefile)
		CRASH("Attempted to get the savedata for [savefile_identifier] of [parent] without a savefile. This should have been handled by load_preferences()")

	// Both of these will cache savefiles, but only for a tick.
	// This is because storing a savefile will lock it, causing later issues down the line.
	// Do not change them to addtimer, since the timer SS might not be running at this time.
	switch (savefile_identifier)
		if (PREFERENCE_SAVEFILE_CHARACTER)
			return savefile.get_entry("character[default_slot]")
		if (PREFERENCE_SAVEFILE_PLAYER)
			return savefile.get_entry()
		else
			CRASH("Unknown savefile identifier [savefile_identifier]")

/// Read a /datum/preference type and return its value.
/// This will write to the savefile if a value was not found with the new value.
/datum/preferences/proc/read_preference(preference_type)
	var/datum/preference/preference_entry = GLOB.preference_entries[preference_type]
	if (isnull(preference_entry))
		var/extra_info = ""

		// Current initializing subsystem is important to know because it might be a problem with
		// things running pre-assets-initialization.
		if (!isnull(Master.current_initializing_subsystem))
			extra_info = "Info was attempted to be retrieved while [Master.current_initializing_subsystem] was initializing."
		else if (!MC_RUNNING())
			extra_info = "Info was attempted to be retrieved before the MC started, but not while it was actively initializing a subsystem"

		CRASH("Preference type `[preference_type]` is invalid! [extra_info]")

	if (preference_type in value_cache)
		. = value_cache[preference_type]
		if(islist(.))
			return (.):Copy()
		return .

	var/value = preference_entry.read(get_save_data_for_savefile_identifier(preference_entry.savefile_identifier), src)
	if (isnull(value))
		value = preference_entry.create_informed_default_value(src)
		if (write_preference(preference_entry, value))
			return value
		else
			CRASH("Couldn't write the default value for [preference_type] (received [value])")
	value_cache[preference_type] = value
	if(islist(value))
		return value:Copy()
	return value

/// Set a /datum/preference entry.
/// Returns TRUE for a successful preference application.
/// Returns FALSE if it is invalid.
/datum/preferences/proc/write_preference(datum/preference/preference, preference_value)
	if(ispath(preference))
		preference = GLOB.preference_entries[preference]
	var/save_data = get_save_data_for_savefile_identifier(preference.savefile_identifier)
	var/new_value = preference.deserialize(preference_value, src)
	var/success = preference.write(save_data, new_value)
	if (success)
		value_cache[preference.type] = new_value
	return success

/// Will perform an update on the preference, but not write to the savefile.
/// This will, for instance, update the character preference view.
/// Performs sanity checks.
/datum/preferences/proc/update_preference(datum/preference/preference, preference_value)
	if (!preference.is_accessible(src))
		return FALSE

	var/old_value = read_preference(preference.type)
	var/new_value = preference.deserialize(preference_value, src)
	var/success = preference.write(null, new_value)

	if (!success)
		return FALSE

	if(old_value != new_value)
		preference.value_changed(src, new_value, old_value)

	recently_updated_keys |= preference.type
	value_cache[preference.type] = new_value

	if (preference.savefile_identifier == PREFERENCE_SAVEFILE_PLAYER)
		preference.apply_to_client_updated(parent, read_preference(preference.type))
	else
		spawn(-1)
			preferences_menu.character_preview_view?.update_body()
			var/datum/tgui/ui = SStgui.get_open_ui(parent, src)
			ui?.send_update()

	return TRUE

/// Called when a user updates the value of this preference.
/datum/preference/proc/value_changed(datum/preferences/prefs, new_value, old_value)
	return

/// Checks that a given value is valid.
/// Must be overriden by subtypes.
/// Any type can be passed through.
/datum/preference/proc/is_valid(value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`is_valid()` was not implemented for [type]!")

/// Returns data to be sent to users in the menu
/datum/preference/proc/compile_ui_data(mob/user, value, /datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)

	return serialize(value)

/// Returns data compiled into the preferences JSON asset
/datum/preference/proc/compile_constant_data()
	SHOULD_NOT_SLEEP(TRUE)

	var/list/data = list("name" = explanation, "feature" = feature_identifier, "locked" = locked)
	if (length(sub_preferences))
		for (var/sub_preference in sub_preferences)
			var/datum/preference/sub_preference_instance = GLOB.preference_entries[sub_preference]
			LAZYADD(data[PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES], list(list("key" = sub_preference_instance.savefile_key, "feature" = sub_preference_instance.feature_identifier, "locked" = sub_preference_instance.locked)))
	return data

/// Can this preference currently be edited by the user?
/datum/preference/proc/is_editable(datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)

	return !locked

/// Returns whether or not this preference is accessible.
/// If FALSE, will not show in the UI and will not be editable (by update_preference).
/datum/preference/proc/is_accessible(datum/preferences/preferences)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if (!isnull(relevant_mutant_bodypart) || !isnull(relevant_species_trait) || !isnull(relevant_external_organ))
		var/species_type = preferences.read_preference(/datum/preference/choiced/species)

		var/datum/species/species = new species_type
		if (!(savefile_key in species.get_features()))
			return FALSE

	return TRUE

/// A preference that is a choice of one option among a fixed set.
/// Used for preferences such as clothing.
/datum/preference/choiced
	/// If this is TRUE, icons will be generated.
	/// This is necessary for if your `init_possible_values()` override
	/// returns an assoc list of names to atoms/icons.
	var/should_generate_icons = FALSE

	var/list/cached_values

	var/list/cached_serialized_values

	abstract_type = /datum/preference/choiced

	feature_identifier = PREFERENCE_FEATURE_DROPDOWN_SWITCHER

	/// A list of the four co-ordinates to crop to, if `generate_icons` is enabled. Useful for icons whose main contents are smaller than 32x32. Please keep it square. (x1, y1, x2, y2)
	var/list/crop_area
	/// The direction to use when creating icons.
	var/sprite_direction = SOUTH
	/// A color to apply to the icon if it's greyscale, and `generate_icons` is enabled.
	var/greyscale_color

/datum/preference/choiced/New()
	. = ..()
	if(crop_area && (!istype(crop_area) || length(crop_area) != REQUIRED_CROP_LIST_SIZE))
		CRASH("Invalid crop paramater! The provided crop area list is not four entries long, or is not a list!")
	if(greyscale_color && islist(greyscale_color) && length(greyscale_color) != REQUIRED_COLOR_LIST_SIZE)
		CRASH("Invalid greyscale color paramater! The provided greyscale color list is not three entries long!")

/// Automatically handles generating icon states and values for mutant parts.
/datum/preference/choiced/proc/generate_mutant_valid_values(list/accessories, accessories_to_ignore = null)
	var/list/data = list()

	for(var/accessory_name in accessories)
		var/datum/sprite_accessory/accessory = accessories[accessory_name]

		if(islist(accessories_to_ignore))
			for(var/path in accessories_to_ignore)
				if(istype(accessory, path))
					continue

		data[initial(accessory.name) || accessory_name] = generate_icon(accessory, sprite_direction)

	return data

/// Generates and allows for post-processing on icons, such as greyscaling and cropping.
/datum/preference/choiced/proc/generate_icon(datum/sprite_accessory/sprite_accessory, dir = SOUTH)
	if(!sprite_accessory?.icon_state || lowertext(sprite_accessory.icon_state) == "none")
		return icon('icons/effects/landmarks_static.dmi', "x")

	var/color
	if(greyscale_color)
		if (sprite_accessory.color_src == TRI_COLOR_LAYERS)
			if(islist(greyscale_color))
				color = greyscale_color
			else
				var/color_tmp = greyscale_color
				color = list(greyscale_color)
				for(var/i in 1 to 2)
					color_tmp = "#[darken_color(darken_color(copytext(color_tmp, 2)))]"
					color += color_tmp
		else if (islist(greyscale_color))
			color = greyscale_color[1]
		else
			color = greyscale_color

	var/icon/human_icon = sprite_accessory.get_base_preview_icon()

	var/icon/iconsheet = build_external_organ_icon(relevant_mutant_bodypart, sprite_accessory, MALE, color, sprite_accessory.color_src)
	var/list/generated_icon_states = icon_states(iconsheet)

	var/icon/icon_to_return

	if(human_icon)
		icon_to_return = icon(human_icon, dir=dir, frame=1, moving=0)
	else
		icon_to_return = icon(iconsheet, generated_icon_states[1], dir, 1, FALSE)
		generated_icon_states.Remove(1)

	for (var/icon_state in generated_icon_states)
		icon_to_return.Blend(icon(iconsheet, icon_state, dir, 1, FALSE), ICON_OVERLAY)

	if(islist(crop_area))
		icon_to_return.Crop(crop_area[1], crop_area[2], crop_area[3], crop_area[4])

	// Okay so apparently byond doesn't actually populate icon metadata with it's supposed size when adding the first icon state
	// So I have to poke it here to say "hey dipshit, it's this size"
	icon_to_return.Scale(32, 32)

	return icon_to_return

/// Returns a list of every possible value.
/// The first time this is called, will run `init_values()`.
/// Return value can be in the form of:
/// - A flat list of raw values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of raw values to atoms/icons.
/datum/preference/choiced/proc/get_choices()
	// Override `init_values()` instead.
	SHOULD_NOT_OVERRIDE(TRUE)

	if (isnull(cached_values))
		cached_values = init_possible_values()
		ASSERT(cached_values.len)

	return cached_values

/// Returns a list of every possible value, serialized.
/// Return value can be in the form of:
/// - A flat list of serialized values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of serialized values to atoms/icons.
/datum/preference/choiced/proc/get_choices_serialized()
	// Override `init_values()` instead.
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(cached_serialized_values))
		cached_serialized_values = list()
		var/choices = get_choices()

		if (should_generate_icons)
			for (var/choice in choices)
				cached_serialized_values[serialize(choice)] = choices[choice]
		else
			for (var/choice in choices)
				cached_serialized_values += serialize(choice)

	return cached_serialized_values

/// Returns a list of every possible value.
/// This must be overriden by `/datum/preference/choiced` subtypes.
/// Return value can be in the form of:
/// - A flat list of raw values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of raw values to atoms/icons, in which case
/// icons will be generated.
/datum/preference/choiced/proc/init_possible_values()
	CRASH("`init_possible_values()` was not implemented for [type]!")

/datum/preference/choiced/is_valid(value)
	return value in get_choices()

/datum/preference/choiced/deserialize(input, datum/preferences/preferences)
	return sanitize_inlist(input, get_choices(), create_default_value())

/datum/preference/choiced/create_default_value()
	return pick(get_choices())

/datum/preference/choiced/compile_constant_data()
	var/list/data = ..()

	var/list/choices = list()

	for (var/choice in get_choices())
		choices += choice

	data["choices"] = choices

	if (should_generate_icons)
		var/list/icons = list()

		for (var/choice in choices)
			icons[choice] = get_spritesheet_key(choice)

		data["icons"] = icons

	if (crop_area) // Used to adjust the preview dummy, so we're not cutting icons every time a preference changes.
		data["crop_area"] = crop_area

	return data

/// A preference that represents an RGB color of something.
/// Will give the value as 6 hex digits, without a hash.
/datum/preference/color
	abstract_type = /datum/preference/color
	feature_identifier = PREFERENCE_FEATURE_COLOR

/datum/preference/color/deserialize(input, datum/preferences/preferences)
	return sanitize_hexcolor(input)

/datum/preference/color/create_default_value()
	return random_color()

/datum/preference/color/serialize(input)
	return sanitize_hexcolor(input)

/datum/preference/color/is_valid(value)
	return findtext(value, GLOB.is_color)

/// A numeric preference with a minimum and maximum value
/datum/preference/numeric
	/// The minimum value
	var/minimum

	/// The maximum value
	var/maximum

	/// The step of the number, such as 1 for integers or 0.5 for half-steps.
	var/step = 1

	abstract_type = /datum/preference/numeric
	feature_identifier = PREFERENCE_FEATURE_NUMBER

/datum/preference/numeric/deserialize(input, datum/preferences/preferences)
	if(istext(input)) // Sometimes TGUI will return a string instead of a number, so we take that into account.
		input = text2num(input) // Worst case, it's null, it'll just use create_default_value()
	return sanitize_float(input, minimum, maximum, step, create_default_value())

/datum/preference/numeric/serialize(input)
	return sanitize_float(input, minimum, maximum, step, create_default_value())

/datum/preference/numeric/create_default_value()
	return rand(minimum, maximum)

/datum/preference/numeric/is_valid(value)
	return isnum(value) && value >= round(minimum, step) && value <= round(maximum, step)

/datum/preference/numeric/compile_constant_data()
	. = ..()

	. += list(
		"minimum" = minimum,
		"maximum" = maximum,
		"step" = step,
	)

/// A prefernece whose value is always TRUE or FALSE
/datum/preference/toggle
	abstract_type = /datum/preference/toggle

	/// The default value of the toggle, if create_default_value is not specified
	var/default_value = TRUE
	feature_identifier = PREFERENCE_FEATURE_CHECKBOX

/datum/preference/toggle/create_default_value()
	return default_value

/datum/preference/toggle/deserialize(input, datum/preferences/preferences)
	return !!input

/datum/preference/toggle/is_valid(value)
	return value == TRUE || value == FALSE

/datum/preference/text
	abstract_type = /datum/preference/text
	feature_identifier = PREFERENCE_FEATURE_SHORT_TEXT
	var/max_length = 50
	var/placeholder

/datum/preference/text/deserialize(input, datum/preferences/preferences)
	return STRIP_HTML_SIMPLE(input, max_length)

/datum/preference/text/create_default_value()
	return ""

/datum/preference/text/is_valid(value)
	return istext(value)

/datum/preference/text/compile_constant_data()
	. = ..()
	.["max_length"] = max_length
	.["placeholder"] = placeholder

///Holds any kind of abstract list data you'd like it to. MUST impliment `is_valid`!
/datum/preference/blob
	abstract_type = /datum/preference/blob
	can_randomize = FALSE

/datum/preference/blob/create_default_value()
	return list()

/datum/preference/blob/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return list()
	return input

/datum/preference/blob/is_valid(value)
	return islist(value)

/datum/preference/blob/apply_to_human(mob/living/carbon/human/target, value)
	return

/// Generates choices from a base type datum.
/datum/preference/choiced/datum_backed
	abstract_type = /datum/preference/choiced/datum_backed

	/// The base datum that will be subtyped and used to populate choices.
	var/choices_datum

	/// Set this to a reference of the proc inside your datum that will provide the value to use. If not set, this will try to use "name".
	var/data_proc

	/// If this datum has a description. If data_proc is set, you should return an assoc list of "name" and "description".
	var/has_description

	var/list/cached_instances = list()

/datum/preference/choiced/datum_backed/New()
	. = ..()

	if (!ispath(choices_datum, /datum))
		CRASH("[type] has no choices datum!")

	var/list/subtypes = subtypesof(choices_datum)
	if (length(subtypes) < 1)
		CRASH("[type] choices datum ([choices_datum]) has no choices!")

	for (var/datum/type as anything in subtypes)
		if (initial(type.abstract_type) == type)
			continue

		cached_instances[type] = new type

/datum/preference/choiced/datum_backed/init_possible_values()

	var/list/data = list()

	for (var/datum/type as anything in cached_instances)
		var/datum/instance = cached_instances[type]

		if (data_proc)
			var/list/result = call(instance, data_proc)()
			data += result
		else
			data += instance:name

	return data

/datum/preference/choiced/datum_backed/compile_constant_data()
	. = ..()

	var/list/descriptions = list()
	.["descriptions"] = descriptions

	for (var/datum/type as anything in cached_instances)
		var/datum/instance = cached_instances[type]

		if (data_proc)
			var/list/result = call(instance, data_proc)()
			descriptions[result["name"]] = result["description"]
		else
			descriptions[instance:name] = instance:description

#undef REQUIRED_CROP_LIST_SIZE
