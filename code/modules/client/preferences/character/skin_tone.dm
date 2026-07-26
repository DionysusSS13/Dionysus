/datum/preference/color/skin_color
	explanation = "Skin Color"
	category = PREFERENCE_CATEGORY_APPEARANCE_GENERAL
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "skin_color"

/datum/preference/color/skin_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.skin_tone = value
	target.dna.update_dna_identity()

/datum/preference/color/skin_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/color/skin_color/create_default_value()
	return skintone2hex(random_skin_tone())
