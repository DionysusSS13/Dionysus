/datum/preference_middleware/jobs

/datum/preference_middleware/jobs/get_constant_data(mob/user)
	var/list/jobs = list()
	var/list/departments = list()
	var/list/data = list(
		"departments" = departments,
		"jobs" = jobs,
	)

	for (var/datum/job/job as anything in SSjob.joinable_occupations)
		var/datum/job_department/sub_department = length(job.departments_list) > 1 ? job.departments_list[2] : null
		jobs[job.id] = list(
			"is_head" = !!job.head_announce,
			"alt_titles" = job.titles,
			"display_title" = job.get_title(),
			"department" = job.department_for_prefs ? job.department_for_prefs : job.departments_list[1],
			"sub_department" = sub_department?.type,
			"description" = job.get_description(),
			"flavor" = job.get_flavor(),
			"tips" = job.get_tips(),
			"css_class" = sanitize_css_class_name(job.id),
		)

	for (var/datum/job_department/department)
		departments["[department.type]"] = list(
			"name" = department.department_name,
			"color" = department.latejoin_color,
			"css_class" = sanitize_css_class_name("[department.type]"),
			"head" = initial(department.department_head.id),
		)

	return data

/datum/preference_middleware/jobs/get_ui_data(mob/user)
	var/list/data = list()

	for (var/datum/job/job as anything in SSjob.joinable_occupations)
		data[job.id] = list(
			"banned" = is_banned_from(user.ckey, job),
			"account_days_left" = job.available_in_days(user.client),
			"playtime_required" = list("department" = job.exp_required_type_department, "time_left" = job.required_playtime_remaining(user.client)),
		)

	return list("jobs" = data)
