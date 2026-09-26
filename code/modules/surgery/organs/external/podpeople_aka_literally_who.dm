//podperson hair
/obj/item/organ/pod_hair
	name = "leaves"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_POD_HAIR
	layers = list(BODY_FRONT_LAYER, BODY_ADJ_LAYER)

	feature_key = "pod_hair"
	preference = "feature_pod_hair"

	dna_block = DNA_POD_HAIR_BLOCK

	color_source = ORGAN_COLOR_OVERRIDE

/obj/item/organ/pod_hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.obscured_slots & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/pod_hair/get_global_feature_list()
	return GLOB.pod_hair_list

/obj/item/organ/pod_hair/override_color(rgb_value)
	var/list/rgb_list = rgb2num(rgb_value)
	return rgb(255 - rgb_list[1], 255 - rgb_list[2], 255 - rgb_list[3])
