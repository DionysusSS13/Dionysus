/atom/movable/screen/map_view/inventory
	var/atom/movable/screen/background/background

/atom/movable/screen/map_view/inventory/Initialize(mapload)
	. = ..()
	generate_view("inventory_map")
	background = new
	background.del_on_map_removal = FALSE
	background.assigned_map = "inventory_map"

/atom/movable/screen/map_view/inventory/Destroy()
	QDEL_NULL(background)
	return ..()

/atom/movable/screen/map_view/inventory/display_to_client(client/show_to)
	. = ..()
	show_to.register_map_obj(background)

/client/verb/inventory_map_resize(new_size as text)
	set name = ".inventory_map_resize"
	set hidden = TRUE
	var/size = splittext(new_size, " ")
	var/size_x = text2num(size[1])
	var/size_y = text2num(size[2])
	if(!size_x || !size_y)
		return
	var/rsize_x = round(size_x / 32)
	var/rsize_y = round(size_y / 32)
	if(!size_x || !size_y)
		return
	inventory_panel.background.fill_rect(1, 1, rsize_x, rsize_y)

/client/verb/inventory_map_show()
	set name = ".inventory_map_show"
	set hidden = TRUE
	var/panel_size = winget(src, "inventory_map", "size")
	var/size = splittext(panel_size, "x")
	var/size_x = text2num(size[1])
	var/size_y = text2num(size[2])
	if(!size_x || !size_y)
		return
	var/rsize_x = round(size_x / 32)
	var/rsize_y = round(size_y / 32)
	inventory_panel.background.fill_rect(1, 1, rsize_x, rsize_y)
