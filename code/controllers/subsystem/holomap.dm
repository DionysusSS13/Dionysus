SUBSYSTEM_DEF(holomap)
	name = "Holomap"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_HOLOMAP

	/// Stores /icon objects for the holomaps
	var/list/holomaps_by_z

	/// Stores images for the holomaps scaled down for use by station map machines as overlays
	var/list/minimaps
	var/list/minimap_icons

	/// Generic invalid holomap icon
	var/icon/invalid_holomap_icon

/datum/controller/subsystem/holomap/Initialize(start_timeofday)
	holomaps_by_z = new /list(world.maxz)
	minimaps = new /list(world.maxz)
	minimap_icons = new /list(world.maxz)

	invalid_holomap_icon = icon('icons/blanks/480x480.dmi', "nothing")
	var/icon/backdrop = icon('icons/hud/holomap/holomap_480x480.dmi', "stationmap")
	var/icon/text = icon('icons/hud/holomap/holomap_64x64.dmi', "notfound")

	invalid_holomap_icon.Blend(backdrop, ICON_UNDERLAY)
	invalid_holomap_icon.Blend(text, ICON_OVERLAY, 480/2,  480/2)

	generate_holomaps()

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HOLOMAPS_READY)
	return ..()

/datum/controller/subsystem/holomap/proc/generate_holomaps()

/// Generate minimaps from a full map.
/datum/controller/subsystem/holomap/proc/generate_minimaps(icon/canvas, z)
	PRIVATE_PROC(TRUE)
	var/icon/mini = icon('icons/blanks/480x480.dmi', "nothing")
	mini.Blend(canvas, ICON_OVERLAY)
	mini.Scale(32, 32)

	minimaps[z] = list(
		"[NORTH]" = image(mini),
	)

	minimap_icons[z] = list(
		"[NORTH]" = mini,
	)


	var/icon/east = icon(mini)
	east.Turn(90)
	minimap_icons[z]["[EAST]"] = east
	minimaps[z]["[EAST]"] = image(east)

	var/icon/south = icon(mini)
	south.Turn(180)
	minimap_icons[z]["[SOUTH]"] = south
	minimaps[z]["[SOUTH]"] = image(south)

	var/icon/west = icon(mini)
	west.Turn(270)
	minimap_icons[z]["[WEST]"] = west
	minimaps[z]["[WEST]"] = image(west)

/// Get a holomap icon for a given z level
/datum/controller/subsystem/holomap/proc/get_holomap(z)
	if(z < 1 || z > length(holomaps_by_z))
		return null

	return holomaps_by_z[z]
