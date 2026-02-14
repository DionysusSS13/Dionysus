/datum/job/lawyer
	id = JOB_CIVIL_REPRESENTATIVE
	titles = list(
		/datum/job_title/lawyer,
		/datum/job_title/lawyer/defence,
		/datum/job_title/lawyer/prosecutor,
	)
	description = "Advocate for prisoners, create law-binding contracts, \
		ensure Security is following protocol and Space Law."
	department_head = list(JOB_DIRECTOR_OF_PORT_SERVICES)
	faction = FACTION_STATION
	pinpad_key = "memejob"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/none
	)

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	departments_list = list(
		/datum/job_department/service,
		)
	rpg_title = "Magistrate"
	family_heirlooms = list(/obj/item/gavelhammer, /obj/item/book/manual/wiki/security_space_law)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/lawyer
	name = "Civil Representative"
	jobtype = /datum/job/lawyer

	id_template = /datum/access_template/job/lawyer
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/black
	belt = /obj/item/modular_computer/tablet/pda/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge
	l_hand = /obj/item/storage/briefcase/lawyer

	chameleon_extras = /obj/item/stamp/law

/datum/outfit/job/lawyer/defence
	name = "Defence Attorney"
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/blue

/datum/outfit/job/lawyer/prosecutor
	name = "Prosecutor"
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/red

/datum/job_title/lawyer
	name = JOB_CIVIL_REPRESENTATIVE
	outfits = list(
		SPECIES_HUMAN = /datum/outfit/job/lawyer,
	)

/datum/job_title/lawyer/defence
	name = "Defence Attorney"
	outfits = list(
		SPECIES_HUMAN = /datum/outfit/job/lawyer/defence,
	)

/datum/job_title/lawyer/prosecutor
	name = "Prosecutor"
	outfits = list(
		SPECIES_HUMAN = /datum/outfit/job/lawyer/prosecutor,
	)
