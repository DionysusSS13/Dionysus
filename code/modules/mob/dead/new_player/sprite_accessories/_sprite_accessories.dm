/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/
/proc/init_sprite_accessory_subtypes(prototype, list/L, list/male, list/female,roundstart = FALSE, add_blank)//Roundstart argument builds a specific list for roundstart parts where some parts may be locked
	if(!istype(L))
		L = list()
	if(!istype(male))
		male = list()
	if(!istype(female))
		female = list()

	for(var/path in subtypesof(prototype))
		if(roundstart)
			var/datum/sprite_accessory/P = path
			if(initial(P.locked))
				continue
		var/datum/sprite_accessory/D = new path()

		if(D.icon_state)
			L[D.name] = D
		else
			L += D.name

		switch(D.gender)
			if(MALE)
				male += D.name
			if(FEMALE)
				female += D.name
			else
				male += D.name
				female += D.name

	if(add_blank)
		L[SPRITE_ACCESSORY_NONE] = new /datum/sprite_accessory/blank

	sortTim(L, GLOBAL_PROC_REF(cmp_text_none_first_asc))
	if(male)
		sortTim(male, GLOBAL_PROC_REF(cmp_text_none_first_asc))
	if(female)
		sortTim(female, GLOBAL_PROC_REF(cmp_text_none_first_asc))

	return L

/datum/sprite_accessory
	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// The preview name of the accessory.
	var/name
	/// Determines if the accessory will be skipped or included in random hair generations.
	var/gender = NEUTER
	/// Something that can be worn by either gender, but looks different on each.
	var/gender_specific
	/// Determines if the accessory will be skipped by color preferences.
	var/use_static
	/// This is used by preferences to build previews of the sprite accessory.
	/// Currently only TRI_COLOR_LAYERS does anything unique, and any other non-false value just shades with one color.
	var/color_src = MUTCOLORS
	/// Decides if this sprite has an "inner" part, such as the fleshy parts on ears.
	var/has_inner
	/// Is this part locked from roundstart selection? Used for parts that apply effects.
	var/locked = FALSE
	/// Should we center the sprite?
	var/center = FALSE
	/// The width of the sprite in pixels. Used to center it if necessary.
	var/dimension_x = 32
	/// The height of the sprite in pixels. Used to center it if necessary.
	var/dimension_y = 32
	/// Should this sprite block emissives?
	var/em_block = FALSE

/// Please use static vars to cache your icons.
/// THIS SHOULD ONLY HAVE ONE FRAME AND STATE
/// You should have all four directions, however.
/datum/sprite_accessory/proc/get_base_preview_icon()
	var/static/icon/human_icon
	if (!human_icon)
		var/icon/holding
		human_icon = icon('icons/mob/human_parts_greyscale.dmi', "human_chest_m")
		human_icon.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_head_m"), ICON_OVERLAY)
		human_icon.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_r_arm"), ICON_OVERLAY)
		human_icon.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_l_arm"), ICON_OVERLAY)
		human_icon.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_r_hand"), ICON_OVERLAY)
		human_icon.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_l_hand"), ICON_OVERLAY)
		human_icon.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_r_leg"), ICON_OVERLAY)
		human_icon.Blend(icon('icons/mob/human_parts_greyscale.dmi', "human_l_leg"), ICON_OVERLAY)
		human_icon.Blend(skintone2hex("caucasian1"), ICON_MULTIPLY)
		holding = icon('icons/mob/human_face.dmi', "eyes_l")
		holding.Blend("#242424", ICON_MULTIPLY)
		human_icon.Blend(holding, ICON_OVERLAY)
		holding = icon('icons/mob/human_face.dmi', "eyes_r")
		holding.Blend("#242424", ICON_MULTIPLY)
		human_icon.Blend(holding, ICON_OVERLAY)
	return human_icon

/datum/sprite_accessory/blank
	name = "None"
	icon_state = "None"
