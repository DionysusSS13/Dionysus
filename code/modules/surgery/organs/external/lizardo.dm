

///The horns of a lizard!
/obj/item/organ/horns
	name = "horns"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HORNS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "horns"
	preference = "feature_lizard_horns"

	dna_block = DNA_HORNS_BLOCK

/obj/item/organ/horns/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/horns/get_global_feature_list()
	return GLOB.horns_list

///The frills of a lizard (like weird fin ears)
/obj/item/organ/frills
	name = "frills"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_FRILLS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "frills"
	preference = "feature_lizard_frills"

	dna_block = DNA_FRILLS_BLOCK

/obj/item/organ/frills/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDEEARS))
		return TRUE
	return FALSE


/obj/item/organ/frills/get_global_feature_list()
	return GLOB.frills_list
