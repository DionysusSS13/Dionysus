/// Contains title names and any custom equipment or features they might have.
/datum/job_title
	var/name = "NOPE"
	/// Assoc list of species to outfit datums. Turned into an outfit instance during runtime.
	/// If a species doesn't have an outfit, it will fall back to using the human outfit.
	/// The human outfit is **required** if it's for a stationside job.
	var/list/datum/outfit/outfits

/datum/job_title/New()
	. = ..()
	var/outfit
	for (var/species in outfits)
		outfit = outfits[species]
		outfits[species] = new outfit()
