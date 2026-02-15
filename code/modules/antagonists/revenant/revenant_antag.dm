/datum/antagonist/revenant
	name = "\improper Revenant"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE

/datum/antagonist/revenant/greet()

/datum/antagonist/revenant/proc/forge_objectives()

/datum/antagonist/revenant/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/revenant/get_preview_icon()
	return finish_preview_icon(icon('icons/mob/mob.dmi', "revenant_idle"))
