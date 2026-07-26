// RIMI TODO: Move to spritemod
// /datum/preference/choiced/facial_hair_gradient
// 	explanation = "Facial Hair Gradient"
// 	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
// 	savefile_key = "facial_hair_gradient"
// 	relevant_species_trait = FACEHAIR
// 	sub_preferences = list(/datum/preference/color/facial_hair_gradient)
// 	feature_identifier = PREFERENCE_FEATURE_ICON_BOX

// /datum/preference/choiced/facial_hair_gradient/init_possible_values()
// 	return assoc_to_keys(GLOB.facial_hair_gradients_list)

// /datum/preference/choiced/facial_hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
// 	LAZYSETLEN(target.grad_style, GRADIENTS_LEN)
// 	target.grad_style[GRADIENT_FACIAL_HAIR_KEY] = value
// 	target.update_body_parts()

// /datum/preference/choiced/facial_hair_gradient/create_default_value()
// 	return "None"

// /datum/preference/color/facial_hair_gradient
// 	explanation = "Facial Hair Gradient Color"
// 	is_sub_preference = TRUE
// 	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
// 	savefile_key = "facial_hair_gradient_color"
// 	relevant_species_trait = FACEHAIR
// 	feature_identifier = PREFERENCE_FEATURE_COLOR

// /datum/preference/color/facial_hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
// 	LAZYSETLEN(target.grad_color, GRADIENTS_LEN)
// 	target.grad_color[GRADIENT_FACIAL_HAIR_KEY] = value
// 	target.update_body_parts()

// /datum/preference/color/facial_hair_gradient/is_accessible(datum/preferences/preferences)
// 	if (!..(preferences))
// 		return FALSE
// 	return preferences.read_preference(/datum/preference/choiced/facial_hair_gradient) != "None"

// /datum/preference/choiced/hair_gradient
// 	explanation = "Hairstyle Gradient"
// 	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
// 	savefile_key = "hair_gradient"
// 	relevant_species_trait = HAIR
// 	sub_preferences = list(/datum/preference/color/hair_gradient)
// 	feature_identifier = PREFERENCE_FEATURE_ICON_BOX

// /datum/preference/choiced/hair_gradient/init_possible_values()
// 	return assoc_to_keys(GLOB.hair_gradients_list)

// /datum/preference/choiced/hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
// 	LAZYSETLEN(target.grad_style, GRADIENTS_LEN)
// 	target.grad_style[GRADIENT_HAIR_KEY] = value
// 	target.update_body_parts()

// /datum/preference/choiced/hair_gradient/create_default_value()
// 	return "None"

// /datum/preference/choiced/hair_gradient/is_accessible(datum/preferences/preferences)
// 	if (!..(preferences))
// 		return FALSE
// 	if(preferences.read_preference(/datum/preference/choiced/species) == /datum/species/moth)
// 		return FALSE

// 	return TRUE

// /datum/preference/color/hair_gradient
// 	explanation = "Hairstyle Gradient Color"
// 	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
// 	savefile_key = "hair_gradient_color"
// 	relevant_species_trait = HAIR
// 	is_sub_preference = TRUE
// 	feature_identifier = PREFERENCE_FEATURE_COLOR

// /datum/preference/color/hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
// 	LAZYSETLEN(target.grad_color, GRADIENTS_LEN)
// 	target.grad_color[GRADIENT_HAIR_KEY] = value
// 	target.update_body_parts()

// /datum/preference/color/hair_gradient/is_accessible(datum/preferences/preferences)
// 	if (!..(preferences))
// 		return FALSE
// 	return preferences.read_preference(/datum/preference/choiced/hair_gradient) != "None"
