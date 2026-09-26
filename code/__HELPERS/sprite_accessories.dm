/proc/build_sprite_accessory_icon_state(key, datum/sprite_accessory/sprite_datum, physique, image_layer_text, color_layer, is_inner)
	var/gender = (physique == FEMALE) ? "f" : "m"

	var/list/icon_state_builder = list()
	icon_state_builder += sprite_datum.gender_specific ? gender : "m" //Male is default because sprite accessories are so ancient they predate the concept of not hardcoding gender
	if (!is_inner)
		icon_state_builder += key
	else
		icon_state_builder += "[key]inner"
	icon_state_builder += sprite_datum.icon_state
	icon_state_builder += image_layer_text
	if (color_layer)
		icon_state_builder += color_layer
	return icon_state_builder.Join("_")
