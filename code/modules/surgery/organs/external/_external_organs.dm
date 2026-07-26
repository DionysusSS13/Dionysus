/**
* System for drawing organs with overlays. These overlays are drawn directly on the bodypart, attached to a person or not
* Works in tandem with the /datum/sprite_accessory datum to generate sprites
* Unlike normal organs, we're actually inside a persons limbs at all times
*/

/**mob_sprite is optional if you havent set sprite_datums for the object, and is used mostly to generate sprite_datums from a persons DNA
* For _mob_sprite we make a distinction between "Round Snout" and "round". Round Snout is the name of the sprite datum, while "round" would be part of the sprite
* I'm sorry
*/


/obj/item/organ/proc/set_sprite(sprite_name)
	stored_feature_id = sprite_name
	sprite_datum = get_global_feature_list()[sprite_name]
	if(!sprite_datum && stored_feature_id)
		stack_trace("External organ has no valid sprite datum for name [sprite_name]")

///Return a dumb glob list for this specific feature (called from parse_sprite)
/obj/item/organ/proc/get_global_feature_list()
	CRASH("External organ has no feature list, it will render invisible")

///Check whether we can draw the overlays. You generally don't want lizard snouts to draw over an EVA suit
/obj/item/organ/proc/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

///Update our features after something changed our appearance
/obj/item/organ/proc/mutate_feature(features, mob/living/carbon/human/human)
	if(!dna_block)
		return

	if(!get_global_feature_list())
		CRASH("External organ has no dna block/feature_list implimented!")

	var/list/feature_list = get_global_feature_list()

	set_sprite(feature_list[deconstruct_block(get_uni_feature_block(features, dna_block), feature_list.len)])

///Give the organ it's color. Force will override the existing one.
/obj/item/organ/proc/inherit_color(force)
	if(draw_color && !force)
		return
	switch(color_source)
		if(ORGAN_COLOR_OVERRIDE)
			draw_color = override_color(ownerlimb.draw_color)

		if(ORGAN_COLOR_INHERIT)
			draw_color = ownerlimb.draw_color

		if(ORGAN_COLOR_HAIR)
			if(!ishuman(ownerlimb.owner))
				return

			var/mob/living/carbon/human/human_owner = ownerlimb.owner
			draw_color = human_owner.hair_color

		// if(ORGAN_COLOR_STATIC)
		//   Do nothing

		if(ORGAN_COLOR_DNA)
			color = owner.dna.features["[feature_key]_color"]

	color = draw_color
	return TRUE

///Colorizes the limb it's inserted to, if required.
/obj/item/organ/proc/override_color(rgb_value)
	CRASH("External organ color set to override with no override proc.")
