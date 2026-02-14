/datum/antagonist/obsessed
	name = "Obsessed"
	show_in_antagpanel = TRUE
	antagpanel_category = "Other"
	job_rank = ROLE_OBSESSED
	antag_hud_name = "obsessed"
	show_name_in_check_antagonists = TRUE
	roundend_category = "obsessed"
	silent = TRUE //not actually silent, because greet will be called by the trauma anyway.
	suicide_cry = "FOR MY LOVE!!"
	preview_outfit = /datum/outfit/obsessed
	var/datum/brain_trauma/special/obsessed/trauma

/datum/antagonist/obsessed/admin_add(datum/mind/new_owner,mob/admin)
	var/mob/living/carbon/C = new_owner.current
	if(!istype(C))
		to_chat(admin, "[roundend_category] come from a brain trauma, so they need to at least be a carbon!")
		return
	if(!C.getorgan(/obj/item/organ/brain)) // If only I had a brain
		to_chat(admin, "[roundend_category] come from a brain trauma, so they need to HAVE A BRAIN.")
		return
	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] into [name].")
	log_admin("[key_name(admin)] made [key_name(new_owner)] into [name].")
	//PRESTO FUCKIN MAJESTO
	C.gain_trauma(/datum/brain_trauma/special/obsessed)//ZAP

/datum/antagonist/obsessed/greet()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/creepalert.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	var/policy = get_policy(ROLE_OBSESSED)
	if(policy)
		to_chat(owner, policy)

/datum/antagonist/obsessed/Destroy()
	if(trauma)
		qdel(trauma)
	. = ..()

/datum/antagonist/obsessed/get_preview_icon()
	var/mob/living/carbon/human/dummy/consistent/victim_dummy = new
	victim_dummy.hair_color = "#bb9966" // Brown
	victim_dummy.hairstyle = "Messy"
	victim_dummy.update_body_parts()

	var/icon/obsessed_icon = render_preview_outfit(preview_outfit, victim_dummy)
	var/icon/blood_overlay = icon('icons/effects/blood.dmi', "uniformblood")
	blood_overlay.Blend(COLOR_HUMAN_BLOOD, ICON_MULTIPLY)
	obsessed_icon.Blend(blood_overlay, ICON_OVERLAY)

	var/icon/final_icon = finish_preview_icon(obsessed_icon)

	final_icon.Blend(
		icon('icons/ui_icons/antags/obsessed.dmi', "obsession"),
		ICON_OVERLAY,
		ANTAGONIST_PREVIEW_ICON_SIZE - 30,
		20,
	)

	return final_icon

/datum/outfit/obsessed
	name = "Obsessed (Preview only)"

	uniform = /obj/item/clothing/under/rank/medical/doctor
	gloves = /obj/item/clothing/gloves/color/latex
	mask = /obj/item/clothing/mask/surgical
	l_hand = /obj/item/camera
	suit = /obj/item/clothing/suit/apron/surgical

/datum/antagonist/obsessed/roundend_report_header()
	return "<span class='header'>Someone became obsessed!</span><br>"

/datum/antagonist/obsessed/roundend_report()
	var/list/report = list()

	if(!owner)
		CRASH("antagonist datum without owner")

	report += "<b>[printplayer(owner)]</b>"

	var/objectives_complete = TRUE
	if(trauma)
		if(trauma.total_time_creeping > 0)
			report += span_greentext("The [name] spent a total of [DisplayTimeText(trauma.total_time_creeping)] being near [trauma.obsession]!")
		else
			report += span_redtext("The [name] did not go near their obsession the entire round! That's extremely impressive!")
	else
		report += span_redtext("The [name] had no trauma attached to their antagonist ways! Either it bugged out or an admin incorrectly gave this good samaritan antag and it broke! You might as well show yourself!!")

	if(objectives.len == 0 || objectives_complete)
		report += "<span class='greentext big'>The [name] was successful!</span>"
	else
		report += "<span class='redtext big'>The [name] has failed!</span>"

	return report.Join("<br>")
