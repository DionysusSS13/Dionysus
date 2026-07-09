//Every time you got lost looking for keycards, incriment: 1
//**************
//*****Keys*******************
//************** **  **
/obj/item/keycard
	name = "security keycard"
	desc = "This feels like it belongs to a door."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "keycard"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 7
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/puzzle_id = null

//Two test keys for use alongside the two test doors.
/obj/item/keycard/yellow
	name = "yellow keycard"
	desc = "A yellow keycard. How fantastic. Looks like it belongs to a high security door."
	color = "#f0da12"
	puzzle_id = "yellow"

/obj/item/keycard/blue
	name = "blue keycard"
	desc = "A blue keycard. How terrific. Looks like it belongs to a high security door."
	color = "#3bbbdb"
	puzzle_id = "blue"

//*************************
//***Box Pushing Puzzles***
//*************************
//We're working off a subtype of pressureplates, which should work just a BIT better now.
/obj/structure/holobox
	name = "holobox"
	desc = "A hard-light box, containing a secure decryption key."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "laserbox"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF

//Uses the pressure_plate settings for a pretty basic custom pattern that waits for a specific item to trigger. Easy enough to retool for mapping purposes or subtypes.
/obj/item/pressure_plate/hologrid
	name = "hologrid"
	desc = "A high power, electronic input port for a holobox, which can unlock the hologrid's storage compartment. Safe to stand on."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "lasergrid"
	anchored = TRUE
	trigger_mob = FALSE
	trigger_item = TRUE
	specific_item = /obj/structure/holobox
	removable_signaller = FALSE //Being a pressure plate subtype, this can also use signals.
	roundstart_signaller_freq = FREQ_HOLOGRID_SOLUTION //Frequency is kept on it's own default channel however.
	active = TRUE
	trigger_delay = 10
	protected = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	undertile_pressureplate = FALSE
	var/reward = /obj/item/food/cookie
	var/claimed = FALSE

/obj/item/pressure_plate/hologrid/Initialize(mapload)
	. = ..()
	if(undertile_pressureplate)
		AddElement(/datum/element/undertile, tile_overlay = tile_overlay, use_anchor = FALSE) //we remove use_anchor here, so it ALWAYS stays anchored

/obj/item/pressure_plate/hologrid/examine(mob/user)
	. = ..()
	if(claimed)
		. += span_notice("This one appears to be spent already.")

/obj/item/pressure_plate/hologrid/trigger()
	if(!claimed)
		new reward(loc)
	flick("lasergrid_a",src)
	icon_state = "lasergrid_full"
	claimed = TRUE

/obj/item/pressure_plate/hologrid/on_entered(datum/source, atom/movable/AM)
	. = ..()
	if(trigger_item && istype(AM, specific_item) && !claimed)
		AM.set_anchored(TRUE)
		flick("laserbox_burn", AM)
		trigger()
		QDEL_IN(AM, 15)

//Light puzzle
TYPEINFO_DEF(/obj/structure/light_puzzle)
	default_armor = list(BLUNT = 100, PUNCTURE = 100, SLASH = 0, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, FIRE = 100, ACID = 100)

/obj/structure/light_puzzle
	name = "light mechanism"
	desc = "It's a mechanism that seems to power something when all the lights are lit up. It looks virtually indestructable."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "light_puzzle"
	anchored = TRUE
	explosion_block = 3
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	light_outer_range = MINIMUM_USEFUL_LIGHT_RANGE
	light_power = 3
	light_color = LIGHT_COLOR_ORANGE
	var/powered = FALSE
	var/puzzle_id = null
	var/list/light_list = list(
		0, 0, 0,
		0, 0, 0,
		0, 0, 0
	)
	/// Banned combinations of the list in decimal
	var/static/list/banned_combinations = list(-1, 47, 95, 203, 311, 325, 422, 473, 488, 500, 511)

/obj/structure/light_puzzle/Initialize()
	. = ..()
	var/generated_board = -1
	while(generated_board in banned_combinations)
		generated_board = rand(0, 510)
	for(var/i in 0 to 8)
		var/position = !!(generated_board & (1<<i))
		light_list[i+1] = position
	update_icon(UPDATE_OVERLAYS)

/obj/structure/light_puzzle/update_overlays()
	. = ..()
	for(var/i in 1 to 9)
		if(!light_list[i])
			continue
		var/mutable_appearance/lit_image = mutable_appearance('icons/obj/puzzle_small.dmi', "light_lit")
		var/mutable_appearance/emissive_image = emissive_appearance('icons/obj/puzzle_small.dmi', "light_lit")
		lit_image.pixel_x = 8 * ((i % 3 || 3 ) - 1)
		lit_image.pixel_y = -8 * (ROUND_UP(i / 3) - 1)
		emissive_image.pixel_x = lit_image.pixel_x
		emissive_image.pixel_y = lit_image.pixel_y
		. += lit_image
		. += emissive_image

/obj/structure/light_puzzle/attack_hand(mob/living/user, list/modifiers)
	if(!modifiers || powered)
		return ..()
	var/light_clicked
	var/x_clicked = text2num(modifiers[ICON_X])
	var/y_clicked = text2num(modifiers[ICON_Y])
	if(x_clicked <= 4 || x_clicked >= 29 || y_clicked <= 4 || y_clicked >= 29)
		return ..()
	x_clicked = ROUND_UP((x_clicked - 4) / 8)
	y_clicked = (-(ROUND_UP((y_clicked - 4) / 8) - 4) - 1) * 3
	light_clicked = x_clicked + y_clicked
	switch_light(light_clicked)
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)

/obj/structure/light_puzzle/proc/switch_light(light)
	var/list/updating_lights = list()
	updating_lights += light
	if(light % 3 != 0)
		updating_lights += light + 1
	if(light % 3 != 1)
		updating_lights += light - 1
	if(light + 3 <= 9)
		updating_lights += light + 3
	if(light - 3 > 0)
		updating_lights += light - 3
	for(var/updating_light in updating_lights)
		light_list[updating_light] = !light_list[updating_light]
	update_icon(UPDATE_OVERLAYS)
	for(var/checking_light in light_list)
		if(!checking_light)
			return
	visible_message(span_boldnotice("[src] becomes fully charged!"))
	powered = TRUE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIGHT_MECHANISM_COMPLETED, puzzle_id)
	playsound(src, 'sound/machines/synth_yes.ogg', 100, TRUE)
