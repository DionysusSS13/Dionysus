/datum/job/paramedic
	title = JOB_PARAMEDIC
	description = "Run around the station looking for patients, respond to \
		emergencies, give patients a roller bed ride to medbay."
	department_head = list(JOB_DIRECTOR_OF_MEDICAE_SERVICES)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the medical director"
	selection_color = "#013d3b"
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/aether,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/paramedic,
		),
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	departments_list = list(
		/datum/job_department/medical,
		)

	family_heirlooms = list(/obj/item/storage/medkit/ancient/heirloom)

	mail_goodies = list(
		/obj/item/reagent_containers/hypospray/medipen = 20,
		/obj/item/reagent_containers/hypospray/medipen/dermaline = 10,
		/obj/item/reagent_containers/hypospray/medipen/meralyne = 10,
		/obj/item/reagent_containers/hypospray/medipen/dexalin = 10,
		/obj/item/reagent_containers/hypospray/medipen/dylovene = 10,
		/obj/item/reagent_containers/hypospray/medipen/survival/luxury = 5
	)
	rpg_title = "Corpse Runner"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/paramedic
	name = "Paramedic"
	jobtype = /datum/job/paramedic

	id = /obj/item/card/id/advanced
	id_template = /datum/access_template/job/paramedic
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/toggle/labcoat/paramedic
	backpack_contents = list(
		/obj/item/roller = 1,
		/obj/item/bodybag/stasis = 1,
		/obj/item/pager/aether = 1,
		/obj/item/diagnosis_book = 1,
	)
	belt = /obj/item/storage/belt/medical/paramedic
	ears = /obj/item/radio/headset/headset_med
	head = /obj/item/clothing/head/soft/paramedic
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	shoes = /obj/item/clothing/shoes/really_blue_sneakers

	back = /obj/item/storage/backpack/medic

	box = /obj/item/storage/box/survival/medical
	chameleon_extras = /obj/item/gun/syringe
	pda_slot = ITEM_SLOT_LPOCKET
