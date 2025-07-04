#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_ACCOUNTAGE 4
#define JOB_UNAVAILABLE_SLOTFULL 5
/// Job unavailable due to incompatibility with an antag role.
#define JOB_UNAVAILABLE_ANTAG_INCOMPAT 6

#define DEFAULT_RELIGION "Christianity"
#define DEFAULT_DEITY "Space Jesus"
#define DEFAULT_BIBLE "Default Bible Name"
#define DEFAULT_BIBLE_REPLACE(religion) "The Holy Book of [religion]"

#define JOB_DISPLAY_ORDER_DEFAULT 100


/**
 * =======================
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * =======================
 * These names are used as keys in many locations in the database
 * you cannot change them trivially without breaking job bans and
 * role time tracking, if you do this and get it wrong you will die
 * and it will hurt the entire time
 */

//No department
#define JOB_CIVILLIAN "Civilian"
#define JOB_PRISONER "Prisoner" //Pending Removal
//Command
#define JOB_PORT_AUTHORITY "Port Authority"
#define JOB_DIRECTOR_OF_PORT_SERVICES "Director of Port Services"
#define JOB_SECURITY_CONSULTANT "Security Consultant"
//Silicon
#define JOB_AI "AI" //Pending rework
#define JOB_CYBORG "Cyborg" //Pending rework
#define JOB_PERSONAL_AI "Personal AI" //Removed?
//Security
#define JOB_PORT_MARSHAL "Port Marshal"
#define JOB_BRIG_LIEUTENANT "Brig Lieutenant"
#define JOB_COMPLIANCE_AUDITOR "Compliance Auditor"
#define JOB_SECURITY_LIASON "Security Liason"
#define JOB_SECURITY_LIASON_MEDICAE "Security Liason (Medicae)"
#define JOB_SECURITY_LIASON_ENGINEERING "Security Liason (Engineering)"
#define JOB_SECURITY_OFFICER_SCIENCE "Security Officer (Science)" //Removed
#define JOB_SECURITY_LIASON_REQUISITIONS "Security Liason (Requisitions)"
//Engineering
#define JOB_CHIEF_ENGINEER "Chief Engineer"
#define JOB_STATION_ENGINEER "Station Engineer"
#define JOB_ATMOSPHERIC_TECHNICIAN "Atmospheric Technician" //Removed
//Medical
#define JOB_DIRECTOR_OF_MEDICAE_SERVICES "Director of Medicae Services"
#define JOB_MEDICAE_TECHNICIAN "Medicae Technician"
#define JOB_PARAMEDIC "Paramedic" //Removed
#define JOB_PHARMACOLOGIST "Pharmacologist"
#define JOB_VIROLOGIST "Virologist" //Removed
//Supply
#define JOB_QUARTERMASTER "Quartermaster"
#define JOB_DECKHAND "Deckhand"
#define JOB_PROSPECTOR "Prospector" //Removed
//Service
#define JOB_LOUNGE_STEWARD "Lounge Steward"
#define JOB_BOTANIST "Botanist"
#define JOB_CULINARY_VENDOR "Culinary Vendor"
#define JOB_JANITOR "Janitor"
#define JOB_CLOWN "Clown" //Removed
#define JOB_ARCHIVIST "Archivist"
#define JOB_CIVIL_REPRESENTATIVE "Civil Representative"
#define JOB_CHAPLAIN "Chaplain" //Considering removal.
#define JOB_PSYCHOLOGIST "Psychologist" //Removed
//ERTs
#define JOB_ERT_DEATHSQUAD "Death Commando"
#define JOB_ERT_COMMANDER "Emergency Response Team Commander"
#define JOB_ERT_OFFICER "Security Response Officer"
#define JOB_ERT_ENGINEER "Engineering Response Officer"
#define JOB_ERT_MEDICAL_DOCTOR "Medical Response Officer"
#define JOB_ERT_CHAPLAIN "Religious Response Officer"
#define JOB_ERT_JANITOR "Janitorial Response Officer"
#define JOB_ERT_CLOWN "Entertainment Response Officer"
//CentCom
#define JOB_CENTCOM "Central Command"
#define JOB_CENTCOM_OFFICIAL "CentCom Official"
#define JOB_CENTCOM_ADMIRAL "Admiral"
#define JOB_CENTCOM_COMMANDER "CentCom Commander"
#define JOB_CENTCOM_VIP "VIP Guest"
#define JOB_CENTCOM_BARTENDER "CentCom Bartender"
#define JOB_CENTCOM_CUSTODIAN "Custodian"
#define JOB_CENTCOM_THUNDERDOME_OVERSEER "Thunderdome Overseer"
#define JOB_CENTCOM_MEDICAL_DOCTOR "Medical Officer"
#define JOB_CENTCOM_RESEARCH_OFFICER "Research Officer"
#define JOB_CENTCOM_SPECIAL_OFFICER "Special Ops Officer"
#define JOB_CENTCOM_PRIVATE_SECURITY "Private Security Force"

#define DEPARTMENT_UNASSIGNED "No department assigned"

#define DEPARTMENT_BITFLAG_SECURITY (1<<0) //Company names pending if TODO_DEPT
#define DEPARTMENT_SECURITY "TODO_SECURITY"
#define DEPARTMENT_BITFLAG_MANAGEMENT (1<<1)
#define DEPARTMENT_PORT_AUTHORITY "Port Authority"
#define DEPARTMENT_BITFLAG_SERVICE (1<<2)
#define DEPARTMENT_SERVICE "Independant"
#define DEPARTMENT_BITFLAG_CARGO (1<<3)
#define DEPARTMENT_REQUISITIONS "TODO_REQUISITIONS"
#define DEPARTMENT_BITFLAG_ENGINEERING (1<<4)
#define DEPARTMENT_ENGINEERING "TODO_ENGI"
#define DEPARTMENT_BITFLAG_SCIENCE (1<<5) //Removed
#define DEPARTMENT_SCIENCE "Science"
#define DEPARTMENT_BITFLAG_MEDICAL (1<<6)
#define DEPARTMENT_MEDICAE "Medicae Services"
#define DEPARTMENT_BITFLAG_SILICON (1<<7)
#define DEPARTMENT_SILICON "Silicon"
#define DEPARTMENT_BITFLAG_ASSISTANT (1<<8)
#define DEPARTMENT_ASSISTANT "Civilian"
#define DEPARTMENT_BITFLAG_CAPTAIN (1<<9)
#define DEPARTMENT_CAPTAIN "Captain" //Is this even still in use?
#define DEPARTMENT_BITFLAG_COMPANY_LEADER (1<<10)
#define DEPARTMENT_COMPANY_LEADER "Company Leader"

/* Job datum job_flags */
/// Whether the mob is announced on arrival.
#define JOB_ANNOUNCE_ARRIVAL (1<<0)
/// Whether the mob is added to the crew manifest.
#define JOB_CREW_MANIFEST (1<<1)
/// Whether the mob is equipped through SSjob.EquipRank() on spawn.
#define JOB_EQUIP_RANK (1<<2)
/// Whether the job is considered a regular crew member of the station. Equipment such as AI and cyborgs not included.
#define JOB_CREW_MEMBER (1<<3)
/// Whether this job can be joined through the new_player menu.
#define JOB_NEW_PLAYER_JOINABLE (1<<4)
/// Reopens this position if we lose the player at roundstart.
#define JOB_REOPEN_ON_ROUNDSTART_LOSS (1<<5)
/// If the player with this job can have quirks assigned to him or not. Relevant for new player joinable jobs and roundstart antags.
#define JOB_ASSIGN_QUIRKS (1<<6)
/// Whether this job can be an intern.
#define JOB_CAN_BE_INTERN (1<<7)

#define FACTION_NONE "None"
#define FACTION_STATION "Station"

/// Spawn point is always fixed.
#define JOBSPAWN_FORCE_FIXED 0
/// Spawn point prefers a fixed spawnpoint, but can be a latejoin one.
#define JOBSPAWN_ALLOW_RANDOM 1
/// Spawn point is always a random spawnpoint.
#define JOBSPAWN_FORCE_RANDOM 2
