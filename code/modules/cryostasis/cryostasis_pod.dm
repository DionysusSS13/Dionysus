#define AHELP_FIRST_MESSAGE "Please adminhelp before leaving the round, even if there are no administrators online!"

/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */
GLOBAL_LIST_EMPTY(cryopod_computers)

// Mind weakref to rank
GLOBAL_LIST_EMPTY(ghost_records)

/// A list of all cryopods that aren't quiet, to be used by the "Send to Cryogenic Storage" VV action.
GLOBAL_LIST_EMPTY(valid_cryopods)

// Cryopods themselves.
/obj/machinery/cryostasis_pod
	name = "cryogenic freezer"
	desc = "Suited for Cyborgs and Humanoids, the pod is a safe place for personnel affected by the Space Sleep Disorder to get some rest."
	icon = 'icons/obj/cryostasis.dmi'
	icon_state = "cryopod-open"
	base_icon_state = "cryopod"
	use_power = FALSE // Very gamey, but I foresee it being frustrating not being able to cleanly leave the round
	density = TRUE
	anchored = TRUE
	state_open = TRUE

	var/open_icon_state = "cryopod-open"
	/// Whether the cryopod respects the minimum time someone has to be disconnected before they can be put into cryo by another player
	var/allow_timer_override = FALSE

	/// Time until despawn when a mob enters a cryopod. You cannot other people in pods unless they're catatonic.
	var/time_till_despawn = 30 SECONDS
	/// Cooldown for when it's now safe to try an despawn the player.
	COOLDOWN_DECLARE(despawn_world_time)

	///Weakref to our controller
	var/datum/weakref/control_computer_weakref
	COOLDOWN_DECLARE(last_no_computer_message)
	/// if false, plays announcement on cryo
	var/quiet = FALSE
	/// If not quiet, what faction's announcement system should we try to find?
	var/announcement_faction = FACTION_STATION

	/// Has the occupant been tucked in?
	var/tucked = FALSE

	/// What was the ckey of the client that entered the cryopod?
	var/stored_ckey = null
	/// The name of the mob that entered the cryopod.
	var/stored_name = null
	/// The rank (job title) of the mob that entered the cryopod, if it was a human. "N/A" by default.
	var/stored_rank = "N/A"

/obj/machinery/cryostasis_pod/quiet
	quiet = TRUE

/obj/machinery/cryostasis_pod/Initialize(mapload)
	..()
	if(!quiet)
		GLOB.valid_cryopods += src
	return INITIALIZE_HINT_LATELOAD //Gotta populate the cryopod computer GLOB first

/obj/machinery/cryostasis_pod/LateInitialize()
	. = ..()
	update_icon()
	find_control_computer()

// This is not a good situation
/obj/machinery/cryostasis_pod/Destroy()
	GLOB.valid_cryopods -= src
	control_computer_weakref = null
	return ..()

/obj/machinery/cryostasis_pod/proc/find_control_computer(urgent = FALSE)
	for(var/cryo_console in GLOB.cryopod_computers)
		var/obj/machinery/computer/cryostasis/console = cryo_console
		if(get_area(console) == get_area(src))
			control_computer_weakref = WEAKREF(console)
			break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer_weakref && urgent && COOLDOWN_FINISHED(src, last_no_computer_message))
		COOLDOWN_START(src, last_no_computer_message, 5 MINUTES)
		log_admin("Cryopod in [get_area(src)] could not find control computer!")
		message_admins("Cryopod in [get_area(src)] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer_weakref != null

/obj/machinery/cryostasis_pod/close_machine(atom/movable/target, density_to_set = TRUE)
	if(!control_computer_weakref)
		find_control_computer(TRUE)
	if((isnull(target) || isliving(target)) && state_open && !panel_open)
		state_open = FALSE
		set_density(density_to_set)

		if(!target)
			for(var/atom in loc)
				if (!(can_be_occupant(atom)))
					continue
				var/atom/movable/current_atom = atom
				if(current_atom.has_buckled_mobs())
					continue
				if(isliving(current_atom))
					var/mob/living/current_mob = atom
					if(current_mob.buckled || current_mob.mob_size >= MOB_SIZE_LARGE)
						continue
				target = atom

	var/mob/living/mobtarget = target
	if(target && !target.has_buckled_mobs() && (!isliving(target) || !mobtarget.buckled))
		set_occupant(target)
		target.forceMove(src)
	update_appearance()

	var/mob/living/mob_occupant = occupant
	if(mob_occupant && mob_occupant.stat != DEAD)
		to_chat(occupant, span_notice("<b>You feel cool air surround you. You go numb as your senses turn inward.</b>"))
		stored_ckey = mob_occupant.ckey
		stored_name = mob_occupant.name

		if(mob_occupant.mind)
			stored_rank = mob_occupant.mind.assigned_role.get_title_name(mob_occupant.client)
			if(isnull(stored_ckey))
				stored_ckey = mob_occupant.mind.key // if mob does not have a ckey and was placed in cryo by someone else, we can get the key this way

	COOLDOWN_START(src, despawn_world_time, time_till_despawn)

/obj/machinery/cryostasis_pod/open_machine(drop = TRUE, density_to_set = FALSE)
	..()
	set_density(TRUE)
	name = initial(name)
	tucked = FALSE
	stored_ckey = null
	stored_name = null
	stored_rank = "N/A"

/obj/machinery/cryostasis_pod/container_resist_act(mob/living/user)
	visible_message(span_notice("[occupant] emerges from [src]!"),
		span_notice("You climb out of [src]!"))
	open_machine()

/obj/machinery/cryostasis_pod/relaymove(mob/user)
	container_resist_act(user)

/obj/machinery/cryostasis_pod/process()
	if(!occupant)
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant.stat == DEAD)
		open_machine()

	if(!mob_occupant.client && COOLDOWN_FINISHED(src, despawn_world_time))
		if(!control_computer_weakref)
			find_control_computer(urgent = TRUE)

		despawn_occupant()

/obj/machinery/cryostasis_pod/proc/handle_objectives()

/**
 * Attempt to store a given item in either the control computer or on the ground.
 * * holder - mob holding the item being stored
 * * target_item - the item to store
 * * control_computer - the cryo console connected to this pod, can be null
 */
/obj/machinery/cryostasis_pod/proc/try_store_item(mob/living/holder, obj/item/target_item, obj/machinery/computer/cryostasis/control_computer)
	if(!istype(target_item) || HAS_TRAIT(target_item, TRAIT_NODROP))
		return FALSE
	if (issilicon(holder) && istype(target_item, /obj/item/mmi))
		return FALSE
	if(istype(target_item, /obj/item/implant/storage)) // store the contents of the storage implant
		for(var/obj/item/nested_item as anything in target_item)
			try_store_item(holder, nested_item, control_computer)
		return FALSE
	if(istype(target_item, /obj/item/modular_computer))
		qdel(target_item) // PDAs are too messy to handle in their current form.
		return FALSE
	if(target_item.item_flags & (ABSTRACT|DROPDEL))
		return FALSE

	if(control_computer)
		holder.transferItemToLoc(target_item, control_computer, force = TRUE, silent = TRUE)
		target_item.unequipped(holder)
		control_computer.frozen_item += target_item
	else
		holder.transferItemToLoc(target_item, drop_location(), force = TRUE, silent = TRUE)
	return TRUE

/// This function can not be undone; do not call this unless you are sure.
/// Handles despawning the player.
/obj/machinery/cryostasis_pod/proc/despawn_occupant()
	var/mob/living/mob_occupant = occupant

	SSjob.FreeRole(stored_rank)

	// Delete them from datacore and ghost records.
	var/announce_rank = GLOB.ghost_records[WEAKREF(mob_occupant)]
	if(announce_rank)
		GLOB.ghost_records.Remove(WEAKREF(mob_occupant))
	else
		for (var/library_name in SSdatacore.library)
			var/datum/data_library/library = SSdatacore.library[library_name]
			var/datum/data/record/record = library.records_by_name[mob_occupant.real_name]
			if(record && library_name == DATACORE_RECORDS_STATION)
				announce_rank = record.fields[DATACORE_TEMPLATE_RANK]
				qdel(record)

	var/obj/machinery/computer/cryostasis/control_computer = control_computer_weakref?.resolve()
	if(!control_computer)
		control_computer_weakref = null
	else
		control_computer.frozen_crew += list(list("name" = stored_name, "job" = stored_rank))

	// Make an announcement and log the person entering storage. If set to quiet, does not make an announcement.
	if(!quiet)
		control_computer.announce("CRYO_LEAVE", mob_occupant, announce_rank, list())

	visible_message(span_notice("[src] hums and hisses as it moves [mob_occupant.real_name] into storage."))

	var/list/nuke_disks = mob_occupant.get_all_contents_type(/obj/item/disk/nuclear) // No
	for(var/obj/item/disk/nuclear/the_disk as anything in nuke_disks)
		var/turf/launch_target = get_edge_target_turf(src, pick(GLOB.alldirs))
		mob_occupant.transferItemToLoc(the_disk, drop_location(), force = TRUE, silent = TRUE)
		the_disk.throw_at(launch_target, 8, 14)
		visible_message(span_warning("[src] violently ejects [the_disk]!"))

	// get_equipped_items() prevents moving bodyparts, since those are in mob contents now
	for(var/obj/item/item_content in mob_occupant.get_equipped_items(TRUE))
		try_store_item(mob_occupant, item_content, control_computer)

	GLOB.joined_player_list -= stored_ckey

	handle_objectives()
	mob_occupant.ghostize(FALSE)
	QDEL_NULL(occupant)
	open_machine()
	name = initial(name)

/obj/machinery/cryostasis_pod/MouseDroppedOn(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target) || !can_interact(user) || !target.Adjacent(user) || !istype(user.loc, /turf) || target.buckled)
		return

	if(occupant)
		to_chat(user, span_notice("[src] is already occupied!"))
		return

	if(target.stat == DEAD)
		to_chat(user, span_notice("Dead people can not be put into cryo."))
		return

	// Allows admins to enable players to override SSD Time check.
	if(allow_timer_override)
		if(tgui_alert(user, "Would you like to place [target] into [src]?", "Place into Cryopod?", list("Yes", "No")) != "No")
			to_chat(user, span_danger("You put [target] into [src]."))
			log_admin("[key_name(user)] has put [key_name(target)] into a overridden stasis pod.")
			message_admins("[key_name(user)] has put [key_name(target)] into a overridden stasis pod. [ADMIN_JMP(src)]")

			add_fingerprint(target)

			close_machine(target)
			name = "[name] ([target.name])"

	// Allows players to cryo others. Checks if they have been AFK for 30 minutes.
	if(target.key && user != target)
		if(!target.mind || !target.client) // Is the character empty / AI Controlled
			var/ssd_time = CONFIG_GET(number/cryostasis_min_ssd_time) MINUTES
			if(target.last_client_time + ssd_time >= world.time)
				to_chat(user, span_notice("You can't put [target] into [src] for another [round(((ssd_time - (world.time - target.last_client_time)) / (1 MINUTES)), 1)] minutes."))
				log_admin("[key_name(user)] has attempted to put [key_name(target)] into a stasis pod, but they were only disconnected for [round(((world.time - target.last_client_time) / (1 MINUTES)), 1)] minutes.")
				message_admins("[key_name(user)] has attempted to put [key_name(target)] into a stasis pod. [ADMIN_JMP(src)]")
				return
			else if(tgui_alert(user, "Would you like to place [target] into [src]?", "Place into Cryopod?", list("Yes", "No")) == "Yes")
				if(target.mind.assigned_role.req_admin_notify)
					tgui_alert(user, "They are an important role! [AHELP_FIRST_MESSAGE]")
				to_chat(user, span_danger("You put [target] into [src]."))
				log_admin("[key_name(user)] has put [key_name(target)] into a stasis pod.")
				message_admins("[key_name(user)] has put [key_name(target)] into a stasis pod. [ADMIN_JMP(src)]")

				add_fingerprint(target)

				close_machine(target)
				name = "[name] ([target.name])"

		else if(iscyborg(target))
			to_chat(user, span_danger("You can't put [target] into [src], [target.p_theyre()] online."))
		else
			to_chat(user, span_danger("You can't put [target] into [src], [target.p_theyre()] conscious."))
		return

	if(target == user && (tgui_alert(target, "Would you like to enter cryostasis?", "Enter Cryopod?", list("Yes", "No")) != "Yes"))
		return

	if(target == user)
		if(target.mind.assigned_role.req_admin_notify)
			tgui_alert(target, "You're an important role! [AHELP_FIRST_MESSAGE]")
		var/datum/antagonist/antag = target.mind.has_antag_datum(/datum/antagonist)
		if(antag)
			tgui_alert(target, "You're \a [antag.name]! [AHELP_FIRST_MESSAGE]")

	if(LAZYLEN(target.buckled_mobs) > 0)
		if(target == user)
			to_chat(user, span_danger("You can't fit into \the [src] while someone is buckled to you."))
		else
			to_chat(user, span_danger("You can't fit [target] into \the [src] while someone is buckled to them."))
		return

	if(!istype(target) || !can_interact(user) || !target.Adjacent(user) || !istype(user.loc, /turf) || target.buckled)
		return
		// rerun the checks in case of shenanigans

	if(occupant)
		to_chat(user, span_notice("[src] is already occupied!"))
		return

	if(target == user)
		visible_message(span_infoplain("[user] starts climbing into \the [src]."))
	else
		visible_message(span_infoplain("[user] starts putting [target] into \the [src]."))

	to_chat(target, span_warning("<b>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</b>"))

	log_admin("[key_name(target)] entered a stasis pod.")
	message_admins("[key_name_admin(target)] entered a stasis pod. [ADMIN_JMP(src)]")
	add_fingerprint(target)

	close_machine(target)
	name = "[name] ([target.name])"

// Attacks/effects.
/obj/machinery/cryostasis_pod/blob_act()
	return // Sorta gamey, but we don't really want these to be destroyed.

/obj/machinery/cryostasis_pod/attackby(obj/item/weapon, mob/living/carbon/human/user, params)
	. = ..()
	if(istype(weapon, /obj/item/bedsheet))
		if(!occupant || !istype(occupant, /mob/living))
			return
		if(tucked)
			to_chat(user, span_warning("[occupant.name] already looks pretty comfortable!"))
			return
		to_chat(user, span_notice("You tuck [occupant.name] into their pod!"))
		qdel(weapon)
		tucked = TRUE

/obj/machinery/cryostasis_pod/update_icon_state()
	icon_state = state_open ? open_icon_state : base_icon_state
	return ..()

#undef AHELP_FIRST_MESSAGE
