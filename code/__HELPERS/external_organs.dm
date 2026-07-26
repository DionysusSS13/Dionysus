/proc/build_external_organ_icon(key, datum/sprite_accessory/sprite_datum, physique, draw_color, organ_color_source, list/layers = global.layer_values, list/appearance_mods)
	RETURN_TYPE(/icon)

	var/icon/return_icon = icon()

	// I'm not a fan of this, but I'm here for results, not speed at all costs.
	var/list/color_layers
	if(sprite_datum.color_src == TRI_COLOR_LAYERS)
		color_layers = global.layer_text_color
	else
		var/static/list/null_list = list(null)
		color_layers = null_list // lazy but keeps it simple, stupid

	for(var/image_layer in layers)
		var/layer_text = global.layer2text["[image_layer]"]
		var/icon/layer_icon

		for(var/color_layer_index = 1, color_layer_index <= length(color_layers), color_layer_index++)
			var/color_layer = color_layers[color_layer_index]
			var/finished_icon_state = build_sprite_accessory_icon_state(key, sprite_datum, physique, layer_text, color_layer)
			if (!icon_exists(sprite_datum.icon, finished_icon_state))
				// Not too big an issue cause prefs spritesheet should cause all of this to be pre-cached.
				// If it does become an issue, then we'll want an external tool to parse icons and build a DB of valid icon states.
				// I don't feel like doing that.
				continue

			var/icon/color_layer_icon = icon(sprite_datum.icon, finished_icon_state)
			if(sprite_datum.color_src && draw_color)
				if(sprite_datum.color_src == TRI_COLOR_LAYERS && islist(draw_color))
					color_layer_icon.Blend(sanitize_hexcolor(draw_color[color_layer_index]), ICON_MULTIPLY)
				else if (islist(draw_color))
					color_layer_icon.Blend(sanitize_hexcolor(draw_color[1]), ICON_MULTIPLY)
				else if (draw_color)
					color_layer_icon.Blend(sanitize_hexcolor(draw_color), ICON_MULTIPLY)

			if(!layer_icon)
				layer_icon = color_layer_icon
			else
				layer_icon.Blend(color_layer_icon, ICON_OVERLAY)

			if(sprite_datum.has_inner)
				layer_icon.Blend(icon(sprite_datum.icon, build_sprite_accessory_icon_state(key, sprite_datum, physique, layer_text, color_layer, is_inner = TRUE)), ICON_OVERLAY)

		if(appearance_mods)
			for(var/datum/appearance_modifier/mod as anything in appearance_mods)
				if(image_layer in mod.eorgan_layers_affected)
					mod.BlendOnto(layer_icon)

		if (layer_icon)
			return_icon.Insert(layer_icon, layer_text)

	return return_icon
