/datum/job/station_engineer
	id = JOB_STATION_ENGINEER
	titles = list(
		/datum/job_title/station_engineer,
		/datum/job_title/station_engineer/electrician,
		/datum/job_title/station_engineer/enginetech,
		/datum/job_title/station_engineer/mainttech,
	)
	description = "Start the Supermatter, wire the solars, repair station hull \
		and wiring damage."
	department_head = list(JOB_CHIEF_ENGINEER)
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "the chief engineer"
	selection_color = "#5b4d20"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/daedalus,
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_ENG

	liver_traits = list(TRAIT_ENGINEER_METABOLISM)

	departments_list = list(
		/datum/job_department/engineering,
		)

	family_heirlooms = list(/obj/item/clothing/head/hardhat, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters)

	mail_goodies = list(
		/obj/item/storage/box/lights/mixed = 20,
		/obj/item/lightreplacer = 10,
		/obj/item/holosign_creator/engineering = 8,
		/obj/item/clothing/head/hardhat/red/upgraded = 1
	)
	rpg_title = "Crystallomancer"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/engineer
	name = "Station Engineer"
	jobtype = /datum/job/station_engineer

	id_template = /datum/access_template/job/station_engineer
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	belt = /obj/item/storage/belt/utility/full/engi
	ears = /obj/item/radio/headset/headset_eng
	head = /obj/item/clothing/head/hardhat
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/color/yellow
	l_pocket = /obj/item/modular_computer/tablet/pda/engineering
	r_pocket = /obj/item/t_scanner

	back = /obj/item/storage/backpack/industrial

	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET
	skillchips = list(/obj/item/skillchip/job/engineer)

/datum/outfit/job/engineer/mod
	name = "Station Engineer (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/engineering
	head = null
	mask = /obj/item/clothing/mask/breath
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null

/datum/outfit/job/engineer/enginetech
	name = "Engine Technician"
	uniform = /obj/item/clothing/under/rank/engineering/engineer/enginetech

/datum/outfit/job/engineer/electrician
	name = "Electrician"
	uniform = /obj/item/clothing/under/rank/engineering/engineer/electrician

/datum/outfit/job/engineer/mainttech
	name = "Maintenance Technician"
	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard

/datum/job_title/station_engineer
	name = JOB_STATION_ENGINEER
	outfits = list(
		SPECIES_HUMAN = /datum/outfit/job/engineer,
	)

/datum/job_title/station_engineer/enginetech
	name = "Engine Technician"
	outfits = list(
		SPECIES_HUMAN = /datum/outfit/job/engineer/enginetech,
	)

/datum/job_title/station_engineer/electrician
	name = "Electrician"
	outfits = list(
		SPECIES_HUMAN = /datum/outfit/job/engineer/electrician,
	)

/datum/job_title/station_engineer/mainttech
	name = "Maintenance Technician"
	outfits = list(
		SPECIES_HUMAN = /datum/outfit/job/engineer/mainttech,
	)
