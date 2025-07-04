//////////////////////////////////////////////
//                                          //
//            LATEJOIN RULESETS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/trim_candidates()
	for(var/mob/P in candidates)
		if(!P.client || !P.mind || is_unassigned_job(P.mind.assigned_role)) // Are they connected?
			candidates.Remove(P)
		else if (P.client.get_remaining_days(minimum_required_age) > 0)
			candidates.Remove(P)
		else if(P.mind.assigned_role.title in restricted_roles) // Does their job allow for it?
			candidates.Remove(P)
		else if((exclusive_roles.len > 0) && !(P.mind.assigned_role.title in exclusive_roles)) // Is the rule exclusive to their job?
			candidates.Remove(P)
		else
			var/list/client_antags = P.client.prefs.read_preference(/datum/preference/blob/antagonists)
			if(!client_antags[antag_preference || antag_flag] || is_banned_from(P.ckey, list(antag_flag_override || antag_flag, ROLE_SYNDICATE)))
				candidates.Remove(P)

/datum/dynamic_ruleset/latejoin/ready(forced = 0)
	if (!forced)
		var/job_check = 0
		if (enemy_roles.len > 0)
			for (var/mob/M in GLOB.alive_player_list)
				if (M.stat == DEAD)
					continue // Dead players cannot count as opponents
				if (M.mind && (M.mind.assigned_role.title in enemy_roles) && (!(M in candidates) || (M.mind.assigned_role.title in restricted_roles)))
					job_check++ // Checking for "enemies" (such as sec officers). To be counters, they must either not be candidates to that rule, or have a job that restricts them from it

		var/threat = round(mode.threat_level/10)
		if (job_check < required_enemies[threat])
			return FALSE
	return ..()

/datum/dynamic_ruleset/latejoin/execute()
	var/mob/M = pick(candidates)
	assigned += M.mind
	M.mind.special_role = antag_flag
	M.mind.add_antag_datum(antag_datum)
	return TRUE

//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/infiltrator
	name = "Syndicate Infiltrator"
	antag_datum = /datum/antagonist/traitor
	antag_flag = ROLE_SYNDICATE_INFILTRATOR
	antag_flag_override = ROLE_TRAITOR
	protected_roles = list(
		JOB_PORT_AUTHORITY,
		JOB_DIRECTOR_OF_PORT_SERVICES,
		JOB_PORT_MARSHAL,
		JOB_SECURITY_LIASON,
		JOB_BRIG_LIEUTENANT,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
	)
	required_candidates = 1
	weight = 7
	cost = 5
	requirements = list(5,5,5,5,5,5,5,5,5,5)
	repeatable = TRUE

//////////////////////////////////////////////
//                                          //
//       REVOLUTIONARY PROVOCATEUR          //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/provocateur
	name = "Provocateur"
	persistent = TRUE
	antag_datum = /datum/antagonist/rev/head
	antag_flag = ROLE_PROVOCATEUR
	antag_flag_override = ROLE_REV_HEAD
	restricted_roles = list(
		JOB_AI,
		JOB_PORT_AUTHORITY,
		JOB_CHIEF_ENGINEER,
		JOB_DIRECTOR_OF_MEDICAE_SERVICES,
		JOB_CYBORG,
		JOB_COMPLIANCE_AUDITOR,
		JOB_DIRECTOR_OF_PORT_SERVICES,
		JOB_PORT_MARSHAL,
		JOB_PRISONER,
		JOB_SECURITY_LIASON,
		JOB_BRIG_LIEUTENANT,
	)
	enemy_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_PORT_AUTHORITY,
		JOB_COMPLIANCE_AUDITOR,
		JOB_PORT_MARSHAL,
		JOB_SECURITY_LIASON,
		JOB_BRIG_LIEUTENANT,
	)
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 2
	delay = 1 MINUTES // Prevents rule start while head is offstation.
	cost = 20
	requirements = list(101,101,70,40,30,20,20,20,20,20)
	flags = HIGH_IMPACT_RULESET
	blocking_rules = list(/datum/dynamic_ruleset/roundstart/revs)
	var/required_heads_of_staff = 3
	var/finished = FALSE
	/// How much threat should be injected when the revolution wins?
	var/revs_win_threat_injection = 20
	var/datum/team/revolution/revolution

/datum/dynamic_ruleset/latejoin/provocateur/ready(forced=FALSE)
	if (forced)
		required_heads_of_staff = 1
	if(!..())
		return FALSE
	var/head_check = 0
	for(var/mob/player in GLOB.alive_player_list)
		if (player.mind.assigned_role.departments_bitflags & (DEPARTMENT_BITFLAG_COMPANY_LEADER))
			head_check++

	return (head_check >= required_heads_of_staff)

/datum/dynamic_ruleset/latejoin/provocateur/execute()
	var/mob/M = pick(candidates) // This should contain a single player, but in case.
	if(check_eligible(M.mind)) // Didnt die/run off z-level/get implanted since leaving shuttle.
		assigned += M.mind
		M.mind.special_role = antag_flag
		revolution = new()
		var/datum/antagonist/rev/head/new_head = new()
		new_head.give_flash = TRUE
		new_head.remove_clumsy = TRUE
		new_head = M.mind.add_antag_datum(new_head, revolution)
		revolution.update_objectives()
		revolution.update_heads()
		SSshuttle.registerHostileEnvironment(revolution)
		return TRUE
	else
		log_game("DYNAMIC: [ruletype] [name] discarded [M.name] from head revolutionary due to ineligibility.")
		log_game("DYNAMIC: [ruletype] [name] failed to get any eligible headrevs. Refunding [cost] threat.")
		return FALSE

/datum/dynamic_ruleset/latejoin/provocateur/rule_process()
	var/winner = revolution.check_completion()
	if (isnull(winner))
		return

	finished = winner
	return RULESET_STOP_PROCESSING

/datum/dynamic_ruleset/latejoin/provocateur/check_finished()
	return !!finished

/// Checks for revhead loss conditions and other antag datums.
/datum/dynamic_ruleset/latejoin/provocateur/proc/check_eligible(datum/mind/M)
	var/turf/T = get_turf(M.current)
	if(!considered_afk(M) && considered_alive(M) && is_station_level(T.z) && !M.antag_datums?.len && !HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return TRUE
	return FALSE

/datum/dynamic_ruleset/latejoin/provocateur/round_result()
	revolution.round_result(finished)

//////////////////////////////////////////////
//                                          //
//           HERETIC SMUGGLER               //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/heretic_smuggler
	name = "Heretic Smuggler"
	antag_datum = /datum/antagonist/heretic
	antag_flag = ROLE_HERETIC_SMUGGLER
	antag_flag_override = ROLE_HERETIC
	protected_roles = list(
		JOB_PORT_AUTHORITY,
		JOB_DIRECTOR_OF_PORT_SERVICES,
		JOB_PORT_MARSHAL,
		JOB_PRISONER,
		JOB_SECURITY_LIASON,
		JOB_BRIG_LIEUTENANT,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
	)
	required_candidates = 1
	weight = 4
	cost = 10
	requirements = list(101,101,101,10,10,10,10,10,10,10)
	repeatable = TRUE

/datum/dynamic_ruleset/latejoin/heretic_smuggler/execute()
	var/mob/picked_mob = pick(candidates)
	assigned += picked_mob.mind
	picked_mob.mind.special_role = antag_flag
	var/datum/antagonist/heretic/new_heretic = picked_mob.mind.add_antag_datum(antag_datum)

	// Heretics passively gain influence over time.
	// As a consequence, latejoin heretics start out at a massive
	// disadvantage if the round's been going on for a while.
	// Let's give them some influence points when they arrive.
	new_heretic.knowledge_points += round((world.time - SSticker.round_start_time) / new_heretic.passive_gain_timer)
	// BUT let's not give smugglers a million points on arrival.
	// Limit it to four missed passive gain cycles (4 points).
	new_heretic.knowledge_points = min(new_heretic.knowledge_points, 5)

	return TRUE
