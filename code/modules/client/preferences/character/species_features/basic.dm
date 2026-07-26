/datum/preference/choiced/mutant/hairstyle
	explanation = "Hairstyle"
	savefile_key = "hairstyle_name"
	relevant_mutant_bodypart = "hair"
	exclude_species_traits = list(NONHUMANHAIR)
	color_feature = /datum/preference/color/mutant/hair_color
	crop_area = PREF_CROP_AREA_HEAD
	greyscale_color = COLOR_DARK_BROWN
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX
	organ_type_to_use = /obj/item/organ/hair
	category = PREFERENCE_CATEGORY_APPEARANCE_HEAD

PREFERENCES_SET_MUTANT_CHOICE_LIST(hairstyle, GLOB.hairstyles_list)

/datum/preference/choiced/mutant/hairstyle/create_default_value()
	return "Bald"

/datum/preference/choiced/mutant/hairstyle/is_applicable_value(datum/sprite_accessory/accessory)
	return ..() && accessory.name != "Bald"

/datum/preference/color/mutant/hair_color
	savefile_key = "hair_color"
	exclude_species_traits = list(NONHUMANHAIR)
	choiced_preference_datum = /datum/preference/choiced/mutant/hairstyle
	relevant_mutant_bodypart = "hair"

/datum/preference/color/mutant/hair_color/create_default_value()
	return random_color_list(3)

/datum/preference/choiced/mutant/facial_hairstyle
	explanation = "Facial Hair"
	savefile_key = "facial_style_name"
	relevant_mutant_bodypart = "facial_hair"
	exclude_species_traits = list(NONHUMANHAIR)
	color_feature = /datum/preference/color/mutant/facial_hair_color
	crop_area = PREF_CROP_AREA_HEAD
	greyscale_color = COLOR_DARK_BROWN
	feature_identifier = PREFERENCE_FEATURE_ICON_BOX
	organ_type_to_use = /obj/item/organ/hair/facial
	category = PREFERENCE_CATEGORY_APPEARANCE_HEAD

PREFERENCES_SET_MUTANT_CHOICE_LIST(facial_hairstyle, GLOB.facial_hairstyles_list)

/datum/preference/choiced/mutant/facial_hairstyle/create_default_value()
	return "Shaved"

/datum/preference/choiced/mutant/facial_hairstyle/is_applicable_value(datum/sprite_accessory/accessory)
	return ..() && accessory.name != "Shaved"

/datum/preference/color/mutant/facial_hair_color
	savefile_key = "facial_hair_color"
	exclude_species_traits = list(NONHUMANHAIR)
	choiced_preference_datum = /datum/preference/choiced/mutant/facial_hairstyle
	relevant_mutant_bodypart = "facial_hair"

/datum/preference/color/mutant/facial_hair_color/create_default_value()
	return random_color_list(3)
