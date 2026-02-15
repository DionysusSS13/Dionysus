/**
 * ## Imps
 *
 * Imps used to be summoned by a devil ascending to their final form, but now they're just
 * kinda sitting in limbo... Well, whatever! They're kinda cool anyways!
 */
/datum/antagonist/imp
	name = "\improper Imp"
	show_in_antagpanel = FALSE
	show_in_roundend = FALSE
	ui_name = "AntagInfoDemon"

/datum/antagonist/imp/on_gain()
	. = ..()
	give_objectives()

/datum/antagonist/imp/proc/give_objectives()


/datum/antagonist/imp/ui_static_data(mob/user)
	var/list/data = list()
	data["fluff"] = "You're an Imp, a lesser being of congealed sin summoned to serve the hierarchy of hell."

	return data
