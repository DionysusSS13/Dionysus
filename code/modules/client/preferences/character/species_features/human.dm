/datum/preference/choiced/mutant/tail_human
	savefile_key = "feature_human_tail"
	relevant_mutant_bodypart = "tail"
	greyscale_color = COLOR_DARK_BROWN
	explanation = "Tail"
	color_feature = /datum/preference/color/mutant/tail_human
	sprite_direction = NORTH
	accessories_to_ignore = list(/datum/sprite_accessory/tails/lizard)
	category = PREFERENCE_CATEGORY_APPEARANCE_GROIN
	organ_type_to_use = /obj/item/organ/tail

PREFERENCES_SET_MUTANT_CHOICE_LIST(tail_human, GLOB.tails_list_human)

/datum/preference/color/mutant/tail_human
	savefile_key = "tail_human_color"
	relevant_mutant_bodypart = "tail"
	choiced_preference_datum = /datum/preference/choiced/mutant/tail_human

/datum/preference/choiced/mutant/ears
	savefile_key = "feature_human_ears"
	relevant_mutant_bodypart = "ears"
	greyscale_color = COLOR_DARK_BROWN
	explanation = "Ears"
	color_feature = /datum/preference/color/mutant/ears
	crop_area = PREF_CROP_AREA_HEAD // We want just the head area.
	category = PREFERENCE_CATEGORY_APPEARANCE_HEAD
	organ_type_to_use = /obj/item/organ/ears/cat // RIMI TODO: Maybe make these not a direct nerf, but at the same time... cuteness comes at a cost

PREFERENCES_SET_MUTANT_CHOICE_LIST(ears, GLOB.ears_list)

/datum/preference/color/mutant/ears
	savefile_key = "ears_color"
	relevant_mutant_bodypart = "ears"
	choiced_preference_datum = /datum/preference/choiced/mutant/ears

// /datum/preference/choiced/mutant/horns
// 	savefile_key = "feature_horns"
// 	relevant_mutant_bodypart = "horns"
// 	explanation = "Horns"
// 	color_feature = "horns_color"
// 	crop_area = list(11, 22, 21, 32) // We want just the head area.

// MUTANT_CHOICED_NEW(horns, GLOB.horns_list)

// /datum/preference/choiced/mutant/horns/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)

// 	if(icon_exists(sprite_accessory.icon, "m_horns_[original_icon_state]_FRONT[suffix]"))
// 		return "m_horns_[original_icon_state]_FRONT[suffix]"

// 	return "m_horns_[original_icon_state]_ADJ[suffix]"

// /datum/preference/color/mutant/horns/is_accessible(datum/preferences/preferences)
// 	. = ..()
// 	if(. || !preferences)
// 		return

// 	return preferences.read_preference(/datum/preference/choiced/species) == /datum/species/lizard

// /datum/preference/color/mutant/horns
// 	savefile_key = "horns_color"
// 	relevant_mutant_bodypart = "horns"
// 	choiced_preference_datum = /datum/preference/choiced/mutant/horns
