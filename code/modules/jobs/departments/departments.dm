/// Singleton representing a category of jobs forming a department.
/datum/job_department
	/// Department as displayed on different menus.
	var/department_name = "No department assigned"
	/// Bitflags associated to the specific department.
	var/department_bitflags = NONE
	/// Typepath of the job datum leading this department.
	var/datum/job/department_head = null
	/// Experience granted by playing in a job of this department.
	var/department_experience_type = null
	/// The order in which this department appears on menus, in relation to other departments.
	var/display_order = 0
	/// The header color to be displayed in the ban panel, classes defined in banpanel.css
	var/label_class = "undefineddepartment"
	/// The color used in the latejoin menu.
	var/latejoin_color = "#6681a5"
	/// Job singleton datums associated to this department. Populated on job initialization.
	var/list/department_jobs = list()
	/// For separatists, what independent name prefix does their nation get named?
	var/list/nation_prefixes = list()
	/// What manifest to start in besides the generic ones. Can be null.
	var/manifest_key = null
	/// Account ID for the budget
	var/budget_id = null

	var/exclude_from_latejoin = FALSE
	var/is_not_real_department = FALSE

/// Handles adding jobs to the department and setting up the job bitflags.
/datum/job_department/proc/add_job(datum/job/job)
	department_jobs += job
	job.departments_bitflags |= department_bitflags

/// Returns a nation name for this department.
/datum/job_department/proc/generate_nation_name()
	var/static/list/nation_suffixes = list("stan", "topia", "land", "nia", "ca", "tova", "dor", "ador", "tia", "sia", "ano", "tica", "tide", "cis", "marea", "co", "taoide", "slavia", "stotzka")
	return pick(nation_prefixes) + pick(nation_suffixes)

/datum/job_department/assistant/generate_nation_name()
	var/nomadic_name = pick("roving clans", "barbaric tribes", "tides", "bandit kingdom", "tribal society", "marauder clans", "horde")
	return "The [nomadic_name] of [..()]"

/// A special captain only department, for use by the preferences menu
/datum/job_department/captain
	department_name = DEPARTMENT_CAPTAIN
	department_bitflags = DEPARTMENT_BITFLAG_CAPTAIN
	department_head = /datum/job/captain
	is_not_real_department = TRUE

/datum/job_department/command
	department_name = DEPARTMENT_PORT_AUTHORITY
	department_bitflags = DEPARTMENT_BITFLAG_MANAGEMENT
	department_head = /datum/job/captain
	department_experience_type = EXP_TYPE_COMMAND
	display_order = 1
	label_class = "command"
	latejoin_color = "#ccccff"

/datum/job_department/security
	department_name = DEPARTMENT_SECURITY
	department_bitflags = DEPARTMENT_BITFLAG_SECURITY
	department_head = /datum/job/head_of_security
	department_experience_type = EXP_TYPE_SECURITY
	display_order = 2
	label_class = "security"
	latejoin_color = "#ffdddd"
	manifest_key = DATACORE_RECORDS_MARS
	nation_prefixes = list("Securi", "Beepski", "Shitcuri", "Red", "Stunba", "Flashbango", "Flasha", "Stanfordi")
	budget_id = ACCOUNT_SEC

/datum/job_department/engineering
	department_name = DEPARTMENT_ENGINEERING
	department_bitflags = DEPARTMENT_BITFLAG_ENGINEERING
	department_head = /datum/job/chief_engineer
	department_experience_type = EXP_TYPE_ENGINEERING
	display_order = 3
	label_class = "engineering"
	latejoin_color = "#ffeeaa"
	nation_prefixes = list("Atomo", "Engino", "Power", "Teleco")
	manifest_key = DATACORE_RECORDS_DAEDALUS
	budget_id = ACCOUNT_ENG

/datum/job_department/medical
	department_name = DEPARTMENT_MEDICAE
	department_bitflags = DEPARTMENT_BITFLAG_MEDICAL
	department_head = /datum/job/augur
	department_experience_type = EXP_TYPE_MEDICAL
	display_order = 4
	label_class = "medical"
	latejoin_color = "#ffddf0"
	nation_prefixes = list("Mede", "Healtha", "Recova", "Chemi", "Viro", "Psych")
	manifest_key = DATACORE_RECORDS_AETHER
	budget_id = ACCOUNT_MED

/datum/job_department/cargo
	department_name = DEPARTMENT_REQUISITIONS
	department_bitflags = DEPARTMENT_BITFLAG_CARGO
	department_head = /datum/job/quartermaster
	department_experience_type = EXP_TYPE_SUPPLY
	display_order = 6
	label_class = "supply"
	latejoin_color = "#ddddff"
	nation_prefixes = list("Cargo", "Guna", "Suppli", "Mule", "Crate", "Ore", "Mini", "Shaf")
	manifest_key = DATACORE_RECORDS_HERMES
	budget_id = ACCOUNT_CAR

/datum/job_department/silicon
	department_name = DEPARTMENT_SILICON
	department_bitflags = DEPARTMENT_BITFLAG_SILICON
	department_head = /datum/job/ai
	department_experience_type = EXP_TYPE_SILICON
	display_order = 7
	label_class = "silicon"
	latejoin_color = "#ccffcc"

/datum/job_department/silicon/generate_nation_name()
	return "United Nations" //For nations ruleset specifically, because all other sources of nation creation cannot choose silicons

/datum/job_department/service
	department_name = DEPARTMENT_SERVICE
	department_bitflags = DEPARTMENT_BITFLAG_SERVICE
	department_head = /datum/job/head_of_personnel
	department_experience_type = EXP_TYPE_SERVICE
	display_order = 8
	label_class = "service"
	latejoin_color = "#bbe291"
	nation_prefixes = list("Honka", "Boozo", "Fatu", "Danka", "Mimi", "Libra", "Jani", "Religi")

/// A special assistant only department, primarily for use by the preferences menu
/datum/job_department/assistant
	department_name = DEPARTMENT_ASSISTANT
	department_bitflags = DEPARTMENT_BITFLAG_ASSISTANT
	display_order = 9
	nation_prefixes = list("Assa", "Mainte", "Tunnel", "Gris", "Grey", "Liath", "Grigio", "Ass", "Assi")
	// Don't add department_head! Assistants names should not be in bold.
	is_not_real_department = TRUE

/// Catch-all department for undefined jobs.
/datum/job_department/undefined
	display_order = 10
	exclude_from_latejoin = TRUE

/datum/job_department/company_leader
	department_name = DEPARTMENT_COMPANY_LEADER
	department_bitflags = DEPARTMENT_BITFLAG_COMPANY_LEADER
	exclude_from_latejoin = TRUE
	is_not_real_department = TRUE
