/datum/preference/choiced/mutant/lizard_frills
	savefile_key = "feature_lizard_frills"
	relevant_mutant_bodypart = "lizard_frills"
	greyscale_color = COLOR_DARK_BROWN
	explanation = "Frills"
	color_feature = /datum/preference/color/mutant/lizard_frills
	crop_area = PREF_CROP_AREA_HEAD // We want just the head area.
	category = PREFERENCE_CATEGORY_APPEARANCE_HEAD
	organ_type_to_use = /obj/item/organ/frills

PREFERENCES_SET_MUTANT_CHOICE_LIST(lizard_frills, GLOB.frills_list)

/datum/preference/color/mutant/lizard_frills
	explanation = "Frills Color"
	savefile_key = "lizard_frills_color"
	relevant_mutant_bodypart = "lizard_frills"
	choiced_preference_datum = /datum/preference/choiced/mutant/lizard_frills

/datum/preference/choiced/mutant/lizard_snout
	savefile_key = "feature_lizard_snout"
	relevant_mutant_bodypart = "lizard_snout"
	greyscale_color = COLOR_DARK_BROWN
	explanation = "Snout"
	color_feature = /datum/preference/color/mutant/lizard_snout
	crop_area = PREF_CROP_AREA_HEAD // We want just the head area.
	category = PREFERENCE_CATEGORY_APPEARANCE_HEAD
	organ_type_to_use = /obj/item/organ/snout

PREFERENCES_SET_MUTANT_CHOICE_LIST(lizard_snout, GLOB.snouts_list)

/datum/preference/choiced/mutant/lizard_snout/create_default_value()
	return "Round"

/datum/preference/color/mutant/lizard_snout
	explanation = "Snout Color"
	savefile_key = "lizard_snout_color"
	relevant_mutant_bodypart = "lizard_snout"
	choiced_preference_datum = /datum/preference/choiced/mutant/lizard_snout

/datum/preference/choiced/mutant/lizard_spines
	savefile_key = "feature_lizard_spines"
	relevant_mutant_bodypart = "lizard_spines"
	greyscale_color = COLOR_DARK_BROWN
	explanation = "Spines"
	color_feature = /datum/preference/color/mutant/lizard_spines
	crop_area = PREF_CROP_AREA_HEAD // We want just the head area.
	category = PREFERENCE_CATEGORY_APPEARANCE_TORSO
	organ_type_to_use = /obj/item/organ/spines

PREFERENCES_SET_MUTANT_CHOICE_LIST(lizard_spines, GLOB.spines_list)

/datum/preference/choiced/mutant/lizard_spines/create_default_value()
	return "Short"

/datum/preference/color/mutant/lizard_spines
	explanation = "Spines Color"
	savefile_key = "lizard_spines_color"
	relevant_mutant_bodypart = "lizard_spines"
	choiced_preference_datum = /datum/preference/choiced/mutant/lizard_spines

/datum/preference/choiced/mutant/lizard_tail
	savefile_key = "feature_lizard_tail"
	relevant_mutant_bodypart = "lizard_tail"
	greyscale_color = COLOR_DARK_BROWN
	explanation = "Tail"
	color_feature = /datum/preference/color/mutant/lizard_tail
	crop_area = PREF_CROP_AREA_HEAD // We want just the head area.
	category = PREFERENCE_CATEGORY_APPEARANCE_GROIN
	organ_type_to_use = /obj/item/organ/tail

PREFERENCES_SET_MUTANT_CHOICE_LIST(lizard_tail, GLOB.tails_list_lizard)

/datum/preference/choiced/mutant/lizard_tail/create_default_value()
	return "Smooth"

/datum/preference/color/mutant/lizard_tail
	explanation = "Tail Color"
	savefile_key = "lizard_tail_color"
	relevant_mutant_bodypart = "lizard_tail"
	choiced_preference_datum = /datum/preference/choiced/mutant/lizard_tail

/datum/preference/choiced/lizard_legs
	explanation = "Leg Type"
	savefile_key = "feature_lizard_legs"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	relevant_mutant_bodypart = "legs"
	category = PREFERENCE_CATEGORY_APPEARANCE_GENERAL

/datum/preference/choiced/lizard_legs/init_possible_values()
	return assoc_to_keys(GLOB.legs_list)

/datum/preference/choiced/lizard_legs/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["legs"] = value
