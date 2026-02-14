/mob/living/silicon/ai/verb/ai_cryo()
	set name = "Cryogenic Stasis"
	set desc = "Puts the current AI personality into cryogenic stasis, freeing the space for another."
	set category = "AI Commands"

	if(incapacitated())
		return
	if(alert("Would you like to enter cryo? This will ghost you. Remember to AHELP before cryoing out of important roles, even with no admins online.", "Are you sure?","Yes","No") != "Yes")
		return

	src.ghostize(FALSE)
	var/announce_rank = "Artificial Intelligence,"

	var/obj/machinery/announcement_system/announcer = pick_safe(GLOB.announcement_systems)
	if(announcer)
		// Sends an announcement the AI has cryoed.
		announcer.announce("CRYO_LEAVE", src.real_name, announce_rank, list())

	new /obj/structure/ai_core/latejoin_inactive(loc)
	if(src.mind)
		//Handle job slot/tater cleanup.
		if(src.mind.assigned_role.id == JOB_AI)
			SSjob.FreeRole(JOB_AI)
	LAZYNULL(src.mind.special_role)
	qdel(src)
