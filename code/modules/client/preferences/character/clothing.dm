/proc/generate_values_for_underwear(list/accessory_list, list/icons, color)
	var/icon/lower_half = icon('icons/blanks/32x32.dmi', "nothing")

	for (var/icon in icons)
		lower_half.Blend(icon('icons/mob/human_parts_greyscale.dmi', icon), ICON_OVERLAY)

	var/list/values = list()

	for (var/accessory_name in accessory_list)
		var/icon/icon_with_socks = new(lower_half)

		if (accessory_name != "Nude")
			var/datum/sprite_accessory/accessory = accessory_list[accessory_name]

			var/icon/accessory_icon = icon('icons/mob/clothing/underwear.dmi', accessory.icon_state)
			if (color && !accessory.use_static)
				accessory_icon.Blend(color, ICON_MULTIPLY)
			icon_with_socks.Blend(accessory_icon, ICON_OVERLAY)

		icon_with_socks.Crop(10, 1, 22, 13)
		icon_with_socks.Scale(32, 32)

		values[accessory_name] = icon_with_socks

	return values

/// Jumpsuit preference
/datum/preference/choiced/jumpsuit
	explanation = "Uniform"
	savefile_key = "jumpsuit_style"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX
	category = PREFERENCE_CATEGORY_APPEARANCE_GENERAL
	should_generate_icons = TRUE

/datum/preference/choiced/jumpsuit/init_possible_values()
	var/list/values = list()

	values[PREF_SUIT] = /obj/item/clothing/under/color/grey
	values[PREF_SKIRT] = /obj/item/clothing/under/color/jumpskirt/grey

	return values

/datum/preference/choiced/jumpsuit/apply_to_human(mob/living/carbon/human/target, value)
	target.jumpsuit_style = value

/datum/preference/choiced/jumpsuit/create_default_value()
	return PREF_SUIT

/// Socks preference
/datum/preference/choiced/socks
	explanation = "Socks"
	savefile_key = "socks"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX
	category = PREFERENCE_CATEGORY_APPEARANCE_LEGS
	should_generate_icons = TRUE

/datum/preference/choiced/socks/init_possible_values()
	return GLOB.socks_list

/datum/preference/choiced/socks/apply_to_human(mob/living/carbon/human/target, value)
	target.socks = value

/datum/preference/choiced/socks/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

/datum/preference/choiced/socks/create_default_value()
	return "Nude"

/datum/preference/choiced/socks/init_possible_values()
	return generate_values_for_underwear(GLOB.socks_list, list("human_r_leg", "human_l_leg"))

/// Undershirt preference
/datum/preference/choiced/undershirt
	explanation = "Undershirt"
	savefile_key = "undershirt"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX
	category = PREFERENCE_CATEGORY_APPEARANCE_TORSO
	should_generate_icons = TRUE

/datum/preference/choiced/undershirt/init_possible_values()
	return GLOB.undershirt_list

/datum/preference/choiced/undershirt/apply_to_human(mob/living/carbon/human/target, value)
	target.undershirt = value

/datum/preference/choiced/undershirt/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

/datum/preference/choiced/undershirt/create_default_value()
	return "Nude"

/datum/preference/choiced/undershirt/init_possible_values()
	var/icon/body = icon('icons/mob/human_parts_greyscale.dmi', "human_r_leg")
	body.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_l_leg"), ICON_OVERLAY)
	body.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_r_arm"), ICON_OVERLAY)
	body.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_l_arm"), ICON_OVERLAY)
	body.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_r_hand"), ICON_OVERLAY)
	body.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_l_hand"), ICON_OVERLAY)
	body.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_chest_m"), ICON_OVERLAY)

	var/list/values = list()

	for (var/accessory_name in GLOB.undershirt_list)
		var/icon/icon_with_undershirt = icon(body)

		if (accessory_name != "Nude")
			var/datum/sprite_accessory/accessory = GLOB.undershirt_list[accessory_name]
			icon_with_undershirt.Blend(icon('icons/mob/clothing/underwear.dmi', accessory.icon_state), ICON_OVERLAY)

		icon_with_undershirt.Crop(9, 9, 23, 23)
		icon_with_undershirt.Scale(32, 32)
		values[accessory_name] = icon_with_undershirt

	return values

/// Underwear preference
/datum/preference/choiced/underwear
	explanation = "Underwear"
	savefile_key = "underwear"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	sub_preferences = list(/datum/preference/color/underwear_color)
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX
	category = PREFERENCE_CATEGORY_APPEARANCE_GROIN
	should_generate_icons = TRUE

/datum/preference/choiced/underwear/init_possible_values()
	return GLOB.underwear_list

/datum/preference/choiced/underwear/apply_to_human(mob/living/carbon/human/target, value)
	target.underwear = value

/datum/preference/choiced/underwear/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

/datum/preference/choiced/underwear/create_default_value()
	return "Nude"

/datum/preference/choiced/underwear/init_possible_values()
	return generate_values_for_underwear(GLOB.underwear_list, list("human_chest_m", "human_r_leg", "human_l_leg"), COLOR_ALMOST_BLACK)

/datum/preference/color/underwear_color
	explanation = "Underwear Color"
	savefile_key = "underwear_color"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	feature_identifier = PREFERENCE_FEATURE_TRI_COLOR
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES

/datum/preference/color/underwear_color/apply_to_human(mob/living/carbon/human/target, value)
	target.underwear_color = value

/datum/preference/color/underwear_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)
