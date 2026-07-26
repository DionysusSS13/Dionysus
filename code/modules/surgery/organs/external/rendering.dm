GLOBAL_REAL_VAR(layer2text) = list(
	"[BODY_BEHIND_LAYER]" = "BEHIND",
	"[BODY_ADJ_LAYER]" = "ADJ",
	"[FRONT_MUTATIONS_LAYER]" = "FRONT_UNDER",
	"[BODY_FRONT_LAYER]" = "FRONT",
)
GLOBAL_REAL_VAR(layer_text) = list(
	"BEHIND",
	"ADJ",
	"FRONT_UNDER",
	"FRONT",
)
GLOBAL_REAL_VAR(layer_values) = list(
	BODY_BEHIND_LAYER,
	BODY_ADJ_LAYER,
	FRONT_MUTATIONS_LAYER,
	BODY_FRONT_LAYER,
)

GLOBAL_REAL_VAR(layer_text_color) = list(
	"primary",
	"secondary",
	"tertiary",
)

GLOBAL_LIST_EMPTY(organ_overlays_cache)

/obj/item/organ
	///Sometimes we need multiple layers, for like the back, middle and front of the person
	var/list/layers

	///Defines what kind of 'organ' we're looking at. Sprites have names like 'm_mothwings_firemoth'. 'mothwings' would then be feature_key
	var/feature_key = ""
	///Similar to feature key, but overrides it in the case you need more fine control over the iconstate, like with Tails.
	var/render_key = ""
	///Stores the dna.features[feature_key], used for external organs that can be surgically removed or inserted.
	var/stored_feature_id = ""
	/// The savefile_key of the preference this relates to. Used for the preferences UI.
	var/preference

	///Sprite datum we use to draw on the bodypart
	var/datum/sprite_accessory/sprite_datum

	///With what DNA block do we mutate in mutate_feature() ? For genetics
	var/dna_block

	///Reference to the limb we're inside of
	var/obj/item/bodypart/ownerlimb

	///The color this organ draws with. Updated by bodypart/inherit_color()
	var/draw_color

	///Where does this organ inherit it's color from?
	var/color_source = ORGAN_COLOR_INHERIT

	///See above
	var/mutcolor_used
	///Which index of the mutcolor key list to use. Defaults to 1, so MUTCOLORS_GENERIC_1 if mutcolor_used is MUTCOLORS_KEY_GENERIC
	var/mutcolor_index = 1

	///Does this organ have any bodytypes to pass to it's ownerlimb?
	var/external_bodytypes = NONE

	//A lazylist of this organ's appearance_modifier datums
	var/list/appearance_mods

///Add the overlays we need to draw on a person. Called from _bodyparts.dm
/obj/item/organ/proc/get_overlays(physique, image_dir)
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)

	. = list()
	if(!stored_feature_id)
		return

	set_sprite(stored_feature_id)
	if(!sprite_datum)
		CRASH("No sprite datum found for [type]")

	if(sprite_datum.name == "None")
		return

	. = build_overlays(physique, image_dir)

	var/cache_key = json_encode(build_cache_key())
	if(GLOB.organ_overlays_cache[cache_key])
		return GLOB.organ_overlays_cache[cache_key]

	GLOB.organ_overlays_cache[cache_key] = .
	return .

/// Build overlays
/obj/item/organ/proc/build_overlays(physique, image_dir)
	RETURN_TYPE(/list)
	. = list()
	var/icon/finished_icon = build_external_organ_icon(render_key || feature_key, sprite_datum, physique, draw_color, color_source, layers, appearance_mods)
	for(var/image_layer in layers)

		var/image/overlay = image(finished_icon, global.layer2text["[image_layer]"], layer = -image_layer, dir = image_dir)

		if(sprite_datum.em_block)
			overlay.overlays += emissive_blocker(overlay.icon, overlay.icon_state, overlay.alpha)

		if(sprite_datum.center)
			center_image(overlay, sprite_datum.dimension_x, sprite_datum.dimension_y)

		. += overlay

	return .

///Generate a unique key based on our sprites. So that if we've aleady drawn these sprites, they can be found in the cache and wont have to be drawn again (blessing and curse)
/obj/item/organ/proc/build_cache_key()
	. = list()
	if(owner && !can_draw_on_bodypart(owner))
		. += "HIDDEN"
		return .

	. += "[sprite_datum?.icon_state]"
	. += "[render_key ? render_key : feature_key]"
	if(islist(draw_color))
		for(var/index in 1 to length(draw_color))
			. += "color[index]:[draw_color[index]]"
	else
		. += "[draw_color]"
	for(var/datum/appearance_modifier/mod as anything in appearance_mods)
		. += mod.key
	return .
