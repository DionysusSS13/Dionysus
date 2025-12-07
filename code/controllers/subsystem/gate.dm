SUBSYSTEM_DEF(gate)
	name = "Gate"
	flags = SS_NO_INIT
	wait = 0.5 SECONDS
	priority = FIRE_PRIORITY_PARALLAX

	var/gate_icon_state = "0,0"
	var/light_pattern = list("#ff1e1e", "#ffe600")
	var/light_color = "#ff1e1e"
	var/light_current_color = 1

/datum/controller/subsystem/gate/fire(resumed)
	// Lazy and simple, just the way I like it
	light_current_color += 1
	if (light_current_color > length(light_pattern))
		light_current_color = 1

	var/new_color = light_pattern[light_current_color]

	if (new_color == light_color)
		return

	light_color = light_pattern[light_current_color]
	update_parallax(gate_icon_state, light_color)

/datum/controller/subsystem/gate/proc/set_state(icon_state, list/light_pattern)
	if (!islist(light_pattern))
		CRASH("Light pattern isn't a list??")
	light_current_color = 1
	light_pattern = light_pattern
	gate_icon_state = icon_state

/datum/controller/subsystem/gate/proc/update_parallax(icon_state, color)
	gate_icon_state = icon_state
	light_color = color
	SEND_SIGNAL(src, COMSIG_GATE_UPDATED, icon_state, color)
