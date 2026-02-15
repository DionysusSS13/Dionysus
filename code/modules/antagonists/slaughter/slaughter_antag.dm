/datum/antagonist/slaughter
	name = "\improper Slaughter Demon"
	show_name_in_check_antagonists = TRUE
	ui_name = "AntagInfoDemon"
	job_rank = ROLE_XENOMORPH
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	var/fluff = "You're a Demon of Wrath, often dragged into reality by wizards to terrorize their enemies."
	var/objective_verb = "Kill"
	var/datum/mind/summoner

/datum/antagonist/slaughter/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/slaughter/greet()
	. = ..()
	to_chat(owner, span_warning("You have a powerful alt-attack that slams people backwards that you can activate by right-clicking your target!"))

/datum/antagonist/slaughter/proc/forge_objectives()


/datum/antagonist/slaughter/ui_static_data(mob/user)
	var/list/data = list()
	data["fluff"] = fluff
	data["explain_attack"] = TRUE
	return data

/datum/antagonist/slaughter/laughter
	name = "Laughter demon"
	objective_verb = "Hug and Tickle"
	fluff = "You're a Demon of Envy, sometimes dragged into reality by wizards as a way to cause wanton chaos."
