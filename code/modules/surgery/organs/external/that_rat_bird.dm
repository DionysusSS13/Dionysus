// Teshari head feathers
/obj/item/organ/teshari_feathers
	name = "head feathers"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_FEATHERS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "teshari_feathers"
	preference = "teshari_feathers"

	dna_block = DNA_TESHARI_FEATHERS_BLOCK
	color_source = ORGAN_COLOR_HAIR

/obj/item/organ/teshari_feathers/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.obscured_slots & HIDEHAIR)
		return FALSE
	return TRUE

/obj/item/organ/teshari_feathers/get_global_feature_list()
	return GLOB.teshari_feathers_list

// Teshari ears
/obj/item/organ/teshari_ears
	name = "ear feathers"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_EARS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "teshari_ears"
	preference = "teshari_ears"

	dna_block = DNA_TESHARI_EARS_BLOCK

/obj/item/organ/teshari_ears/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.obscured_slots & HIDEHAIR)
		return FALSE
	return TRUE

/obj/item/organ/teshari_ears/get_global_feature_list()
	return GLOB.teshari_ears_list

/obj/item/organ/teshari_ears/build_overlays(physique, image_dir)
	. = ..()

	var/mutable_appearance/inner_ears = mutable_appearance(sprite_datum.icon, "m_teshari_earsinner_[sprite_datum.icon_state]_ADJ", layer = -BODY_ADJ_LAYER)
	var/mob/living/carbon/human/human_owner = owner
	if(owner)
		inner_ears.color = human_owner.facial_hair_color
		. += inner_ears

/obj/item/organ/teshari_ears/build_cache_key()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		. += H.facial_hair_color

// Teshari body feathers
/obj/item/organ/teshari_body_feathers
	name = "body feathers"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_BODY_FEATHERS
	layers = list(BODY_ADJ_LAYER)

	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	feature_key = "teshari_body_feathers"
	preference = "teshari_body_feathers"

	dna_block = DNA_TESHARI_BODY_FEATHERS_BLOCK
	color_source = ORGAN_COLOR_DNA
	mutcolor_used = MUTCOLORS_KEY_TESHARI_BODY_FEATHERS

/obj/item/organ/teshari_body_feathers/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!human)
		return TRUE
	if(human.obscured_slots & HIDEJUMPSUIT)
		return FALSE
	return TRUE

/obj/item/organ/teshari_body_feathers/get_global_feature_list()
	return GLOB.teshari_body_feathers_list

/obj/item/organ/teshari_body_feathers/build_overlays(physique, image_dir)
	. = ..()
	var/static/list/bodypart_color_indexes = list(
		BODY_ZONE_CHEST = MUTCOLORS_TESHARI_BODY_FEATHERS_1,
		BODY_ZONE_HEAD = MUTCOLORS_TESHARI_BODY_FEATHERS_2,
		BODY_ZONE_R_ARM = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
		BODY_ZONE_L_ARM = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
		BODY_ZONE_R_LEG = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
		BODY_ZONE_L_LEG = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
	)
	if(!owner)
		return

	for(var/image_layer in layers)
		var/state2use = build_sprite_accessory_icon_state(render_key || feature_key, sprite_datum, physique, global.layer2text[image_layer])

		for(var/obj/item/bodypart/BP as anything in owner.bodyparts - owner.get_bodypart(BODY_ZONE_CHEST))
			if(!IS_ORGANIC_LIMB(BP))
				continue
			var/mutable_appearance/new_overlay = mutable_appearance(sprite_datum.icon, "[state2use]_[BP.body_zone]", layer = -image_layer)
			var/list/colors = owner?.dna?.features["[feature_key]_color"]
			if (istype(colors) && length(colors))
				new_overlay.color = colors[bodypart_color_indexes[BP.body_zone]]
			. += new_overlay

/obj/item/organ/teshari_body_feathers/build_cache_key()
	. = ..()
	if(ishuman(owner))
		var/obj/item/bodypart/BP = owner.get_bodypart(BODY_ZONE_CHEST)
		. += BP ? "[IS_ORGANIC_LIMB(BP)]" : "NOAPPLY"
		BP = owner.get_bodypart(BODY_ZONE_HEAD)
		. += BP ? "[IS_ORGANIC_LIMB(BP)]" : "NOAPPLY"
		BP = owner.get_bodypart(BODY_ZONE_R_ARM)
		. += BP ? "[IS_ORGANIC_LIMB(BP)]" : "NOAPPLY"
		BP = owner.get_bodypart(BODY_ZONE_L_ARM)
		. += BP ? "[IS_ORGANIC_LIMB(BP)]" : "NOAPPLY"
		BP = owner.get_bodypart(BODY_ZONE_R_LEG)
		. += BP ? "[IS_ORGANIC_LIMB(BP)]" : "NOAPPLY"
		BP = owner.get_bodypart(BODY_ZONE_L_LEG)
		. += BP ? "[IS_ORGANIC_LIMB(BP)]" : "NOAPPLY"
	else
		. += "CHEST_ONLY"
