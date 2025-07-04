/datum/access_group_manager
	var/job_title = ""

	var/list/access_groups = list()
	var/list/pdas = list()
	var/list/templates = list()

/datum/access_group_manager/captain
	job_title = JOB_PORT_AUTHORITY
	access_groups = list(/datum/access_group/station/management)

/datum/access_group_manager/hop
	job_title = JOB_DIRECTOR_OF_PORT_SERVICES
	access_groups = list(/datum/access_group/station/independent_areas)

/datum/access_group_manager/security
	job_title = JOB_PORT_MARSHAL
	access_groups = list(/datum/access_group/station/security)

/datum/access_group_manager/medical
	job_title = JOB_DIRECTOR_OF_MEDICAE_SERVICES
	access_groups = list(/datum/access_group/station/medical)

/datum/access_group_manager/engineering
	job_title = JOB_CHIEF_ENGINEER
	access_groups = list(/datum/access_group/station/engineering)

/datum/access_group_manager/cargo
	job_title = JOB_QUARTERMASTER
	access_groups = list(/datum/access_group/station/cargo)

