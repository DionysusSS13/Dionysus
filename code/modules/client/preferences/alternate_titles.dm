/datum/preference/blob/alternate_titles
	savefile_key = "alternate_titles"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/blob/alternate_titles/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/datum/job/job = SSjob.GetJob(params["job_id"])
	if (!job || !isnum(params["title_index"]) || params["title_index"] > length(job?.titles) || params["title_index"] < 1)
		return

	var/datum/job_title/new_title = job.type_to_title[text2path(params["title_index"])]
	if (!new_title)
		return

	var/list/alt_titles = prefs.read_preference(type)
	alt_titles[job.id] = new_title.type
	prefs.update_preference(src, alt_titles)
