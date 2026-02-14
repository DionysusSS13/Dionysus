/**
 * This type is used to indicate a lack of a job.
 * The mind variable assigned_role will point here by default.
 * As any other job datum, this is a singleton.
 **/

/datum/job/unassigned
	id = "Unassigned Crewmember"
	titles = list(
		/datum/job_title/unassigned,
	)
	rpg_title = "Peasant"
	paycheck = PAYCHECK_ZERO

/datum/job_title/unassigned
	name = "Unassigned Crewmember"
