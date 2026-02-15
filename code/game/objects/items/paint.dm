//NEVER USE THIS IT SUX -PETETHEGOAT
//IT SUCKS A BIT LESS -GIACOM
//IT SUCKED SO MUCH WE CHANGED IT ENTIRELY

TYPEINFO_DEF(/obj/item/paint_sprayer)
	default_materials = list(/datum/material/steel=50, /datum/material/glass=50)

/obj/item/paint_sprayer
	name = "paint sprayer"
	desc = "A slender and none-too-sophisticated device capable of applying paint onto walls and various other things. Applied paint can be removed by the Janitor."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "paint_sprayer"
	inhand_icon_state = "paint_sprayer"
	worn_icon_state = "painter"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	/// With what color will we paint with
	var/wall_color = COLOR_WHITE
	var/stripe_color = COLOR_WHITE

	var/preset_wall_colors= list(
		"Daedalus Industries" = list("wall" = PAINT_WALL_DAEDALUS, "trim" = PAINT_STRIPE_DAEDALUS),
		"Priapus Recreational Solutions" = list("wall" = PAINT_WALL_PRIAPUS, "trim" = PAINT_STRIPE_PRIAPUS),
		"Mars People's Coalition" = list("wall" = PAINT_WALL_MARS, "trim" = PAINT_STRIPE_MARS),
		"Command" = list("wall" = PAINT_WALL_COMMAND, "trim" = PAINT_STRIPE_COMMAND),
		"Medical" = list("wall" = PAINT_WALL_MEDICAL, "trim" = PAINT_STRIPE_MEDICAL),
	)

/obj/item/paint_sprayer/examine(mob/user)
	. = ..()

	. += span_notice("It is configured to paint walls using <span style='color:[wall_color]'>[wall_color]</span> paint and trims using <span style='color:[stripe_color]'>[stripe_color]</span> paint.")
	. += span_notice("Paint wall stripes by right clicking a wall.")

/obj/item/paint_sprayer/update_overlays()
	. = ..()
	var/mutable_appearance/color_overlay = mutable_appearance(icon, "paint_sprayer_color")
	color_overlay.color = wall_color
	. += color_overlay

/obj/item/paint_sprayer/attack_self(mob/living/user)
	var/static/list/options_list = list("Select wall color", "Select stripe color", "Color presets")
	var/option = input(user, null, "Configure Device", null) as null|anything in options_list
	switch(option)
		if("Select wall color")
			var/new_wall_color = input(user, "Choose new wall paint color", "Paint Color", wall_color) as color|null
			if(new_wall_color)
				wall_color = new_wall_color
		if("Select stripe color")
			var/new_stripe_color = input(user, "Choose new wall stripe color", "Paint Color", stripe_color) as color|null
			if(new_stripe_color)
				stripe_color = new_stripe_color
		if("Color presets")
			var/chosen = input(user, null, "Select a preset", null) as null|anything in preset_wall_colors
			if(!chosen)
				return
			chosen = preset_wall_colors[chosen]
			wall_color = chosen["wall"]
			stripe_color = chosen["trim"]
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	update_appearance()
	return TRUE

/obj/item/paint_sprayer/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(.)
		return
	if(!proximity)
		return
	if(!isturf(target) || isspaceturf(target))
		return TRUE
	target.add_atom_colour(wall_color, WASHABLE_COLOUR_PRIORITY)

/obj/item/paint_remover
	gender = PLURAL
	name = "paint remover"
	desc = "Used to remove color from anything."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "paint_neutral"
	inhand_icon_state = "paintcan"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	max_integrity = 100

/obj/item/paint_remover/examine(mob/user)
	. = ..()
	. += span_notice("Remove wall stripe paint by right-clicking a wall.")

/obj/item/paint_remover/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(.)
		return
	if(!proximity)
		return
	if(!isturf(target) && !isobj(target))
		return
	if(target.color != initial(target.color))
		target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
