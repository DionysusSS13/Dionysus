/obj/item/organ/hair
	name = "hair"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HAIR
	layers = list(BODY_ADJ_LAYER)

	feature_key = "hair"

	color_source = ORGAN_COLOR_OVERRIDE

/obj/item/organ/hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/hair/get_global_feature_list()
	return GLOB.hairstyles_list

/obj/item/organ/hair/override_color(rgb_value)
	// If the owner's human, grab their human hair color, otherwise try dna, and failing that, just use the provided color.
	if (istype(owner, /mob/living/carbon/human))
		return human_hair_color(owner)

	var/dna_color = owner.dna.features["[feature_key]_color"]
	if (islist(dna_color))
		dna_color = dna_color[1]

	return dna_color || rgb_value

/obj/item/organ/hair/proc/human_hair_color(mob/living/carbon/human/own)
	return own.hair_color

/obj/item/organ/hair/facial
	name = "facial hair"

	slot = ORGAN_SLOT_EXTERNAL_FACIAL_HAIR

	feature_key = "facial_hair"

/obj/item/organ/hair/facial/get_global_feature_list()
	return GLOB.facial_hairstyles_list

/obj/item/organ/hair/facial/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDEFACIALHAIR))
		return TRUE
	return FALSE

/obj/item/organ/hair/facial/human_hair_color(mob/living/carbon/human/own)
	return own.facial_hair_color
