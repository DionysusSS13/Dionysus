/datum/antagonist/ninja
	name = "\improper Space Ninja"
	antagpanel_category = "Space Ninja"
	job_rank = ROLE_SPACE_NINJA
	antag_hud_name = "space_ninja"
	hijack_speed = 1
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	suicide_cry = "FOR THE SPIDER CLAN!!"
	preview_outfit = /datum/outfit/ninja
	///Whether or not this ninja will obtain objectives
	var/give_objectives = TRUE
	///Whether or not this ninja receives the standard equipment
	var/give_equipment = TRUE

/**
 * Proc that equips the space ninja outfit on a given individual.  By default this is the owner of the antagonist datum.
 *
 * Proc that equips the space ninja outfit on a given individual.  By default this is the owner of the antagonist datum.
 * Arguments:
 * * ninja - The human to receive the gear
 * * Returns a proc call on the given human which will equip them with all the gear.
 */
/datum/antagonist/ninja/proc/equip_space_ninja(mob/living/carbon/human/ninja = owner.current)
	return ninja.equipOutfit(/datum/outfit/ninja)

/**
 * Proc that adds the proper memories to the antag datum
 *
 * Proc that adds the ninja starting memories to the owner of the antagonist datum.
 */
/datum/antagonist/ninja/proc/addMemories()
	antag_memory += "I am an elite mercenary of the mighty Spider Clan. A <font color='red'><B>SPACE NINJA</B></font>!<br>"
	antag_memory += "Surprise is my weapon. Shadows are my armor. Without them, I am nothing. (//initialize your suit by clicking the initialize UI button, to use abilities like stealth)!<br>"

/datum/antagonist/ninja/greet()
	. = ..()
	SEND_SOUND(owner.current, sound('sound/effects/ninja_greeting.ogg'))
	to_chat(owner.current, "I am an elite mercenary of the mighty Spider Clan!")
	to_chat(owner.current, "Surprise is my weapon. Shadows are my armor. Without them, I am nothing. (//initialize your suit by right clicking on it, to use abilities like stealth)!")

/datum/antagonist/ninja/on_gain()
	addMemories()
	if(give_equipment)
		equip_space_ninja(owner.current)

	owner.current.mind.set_assigned_role(SSjob.GetJobType(/datum/job/space_ninja))
	owner.current.mind.special_role = ROLE_SPACE_NINJA
	return ..()

/datum/antagonist/ninja/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.set_assigned_role(SSjob.GetJobType(/datum/job/space_ninja))
	new_owner.special_role = ROLE_SPACE_NINJA
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has ninja'ed [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has ninja'ed [key_name(new_owner)].")
