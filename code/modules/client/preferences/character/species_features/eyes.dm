/datum/preference/color/eye_color
	explanation = "Eye Color"
	savefile_key = "eye_color"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	relevant_species_trait = EYECOLOR
	feature_identifier = PREFERENCE_FEATURE_COLOR
	category = PREFERENCE_CATEGORY_APPEARANCE_HEAD

/datum/preference/color/eye_color/apply_to_human(mob/living/carbon/human/target, value)
	var/hetero = target.eye_color_heterochromatic
	target.eye_color_left = value
	if(!hetero)
		target.eye_color_right = value

	var/obj/item/organ/eyes/eyes_organ = target.getorgan(/obj/item/organ/eyes)
	if (!eyes_organ || !istype(eyes_organ))
		return

	if (!initial(eyes_organ.eye_color_left))
		eyes_organ.eye_color_left = value
	eyes_organ.old_eye_color_left = value

	if(hetero) // Don't override the angel demon hybrids please
		return

	if (!initial(eyes_organ.eye_color_right))
		eyes_organ.eye_color_right = value
	eyes_organ.old_eye_color_right = value
	eyes_organ.refresh()

/datum/preference/color/eye_color/create_default_value()
	return "#000000"


/datum/preference/color/sclera
	explanation = "Sclera Color"
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "sclera_color"
	relevant_species_trait = SCLERA
	feature_identifier = PREFERENCE_FEATURE_COLOR
	category = PREFERENCE_CATEGORY_APPEARANCE_HEAD

/datum/preference/color/sclera/create_default_value()
	return "#f8ef9e"

/datum/preference/color/sclera/apply_to_human(mob/living/carbon/human/target, value)
	target.sclera_color = value
	target.update_eyes()
