GLOBAL_LIST_INIT(preferences_preview_backgrounds, list(
	"black",
	"grey",
	"floor",
	"plating",
	"darkfull",
	"smooth",
))

/// A preview of a character for use in the preferences menu
/atom/movable/screen/map_view/char_preview

	/// The body that is displayed
	var/mob/living/carbon/human/dummy/body
	/// The preferences this refers to
	var/datum/preferences/preferences

	var/image/canvas
	var/last_background

/atom/movable/screen/map_view/char_preview/Initialize(mapload, datum/preferences/preferences)
	. = ..()
	src.preferences = preferences

/atom/movable/screen/map_view/char_preview/Destroy()
	canvas?.cut_overlays()
	canvas = null
	QDEL_NULL(body)
	preferences?.preferences_menu?.character_preview_view = null
	preferences = null
	return ..()

/// Updates the currently displayed body
/atom/movable/screen/map_view/char_preview/proc/update_body()
	if (isnull(body))
		create_body()
	else
		body.wipe_state()

	preferences.preferences_menu.render_new_preview_appearance(body)

/atom/movable/screen/map_view/char_preview/proc/update_canvas()
	if (canvas)
		canvas.cut_overlays()

	if (canvas || preferences.preferences_menu.background != last_background)
		var/icon/dummy = icon('icons/turf/floors.dmi', GLOB.preferences_preview_backgrounds[preferences.preferences_menu.background])

		canvas = image(dummy)
		canvas.plane = GAME_PLANE
		last_background = preferences.preferences_menu.background

	canvas.add_overlay(body.appearance)

	appearance = canvas.appearance

/atom/movable/screen/map_view/char_preview/proc/create_body()
	QDEL_NULL(body)

	body = new

/atom/movable/screen/map_view/char_preview/proc/jiggle()
	fill_rect(0, 0, 0, 0)

	spawn(1) // Fugly byond workaround cause we need to jiggle the view. Entirely map_view impl agnostic, so feel free to reuse where needed.
		fill_rect(1, 1, 1, 1)

/datum/quad_char_preview // fuuuuuuck
	var/atom/movable/screen/map_view/char_preview/preview1
	var/atom/movable/screen/map_view/char_preview/preview2
	var/atom/movable/screen/map_view/char_preview/preview3
	var/atom/movable/screen/map_view/char_preview/preview4

/datum/quad_char_preview/New(datum/preferences/preferences)
	. = ..()
	preview1 = new(null, preferences)
	preview2 = new(null, preferences)
	preview3 = new(null, preferences)
	preview4 = new(null, preferences)

	preview2.dir = NORTH
	preview3.dir = EAST
	preview4.dir = WEST

/datum/quad_char_preview/Destroy(force, ...)
	. = ..()
	QDEL_NULL(preview1)
	QDEL_NULL(preview2)
	QDEL_NULL(preview3)
	QDEL_NULL(preview4)

/datum/quad_char_preview/proc/update_body()
	preview1.update_body()
	preview2.body = preview1.body
	preview3.body = preview1.body
	preview4.body = preview1.body
	update_canvas()

/datum/quad_char_preview/proc/update_canvas()
	preview1.update_canvas()
	preview2.update_canvas()
	preview3.update_canvas()
	preview4.update_canvas()

/datum/quad_char_preview/proc/create_body()
	preview1.create_body()
	preview2.body = preview1.body
	preview3.body = preview1.body
	preview4.body = preview1.body
	update_canvas()

/datum/quad_char_preview/proc/display_to_client(client/show_to)
	preview1.display_to_client(show_to)
	preview2.display_to_client(show_to)
	preview3.display_to_client(show_to)
	preview4.display_to_client(show_to)

/datum/quad_char_preview/proc/display_to(mob/show_to, datum/tgui_window/window)
	preview1.display_to(show_to, window)
	preview2.display_to(show_to, window)
	preview3.display_to(show_to, window)
	preview4.display_to(show_to, window)

/datum/quad_char_preview/proc/assigned_maps()
	return list(preview1.assigned_map, preview2.assigned_map, preview3.assigned_map, preview4.assigned_map)

/datum/quad_char_preview/proc/generate_view()
	preview1.generate_view("character_preview_[REF(preview1)]")
	preview2.generate_view("character_preview_[REF(preview2)]")
	preview3.generate_view("character_preview_[REF(preview3)]")
	preview4.generate_view("character_preview_[REF(preview4)]")

/datum/quad_char_preview/proc/jiggle()
	preview1.jiggle()
	preview2.jiggle()
	preview3.jiggle()
	preview4.jiggle()
