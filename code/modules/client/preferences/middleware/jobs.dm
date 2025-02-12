/datum/preference_middleware/jobs
	action_delegations = list(
		"set_job_preference" = PROC_REF(set_job_preference),
		"set_title_preference" = PROC_REF(set_title_preference),
	)

/datum/preference_middleware/jobs/proc/set_job_preference(list/params, mob/user)
	var/job_title = params["job"]
	var/level = params["level"]

	if (level != null && level != JP_LOW && level != JP_MEDIUM && level != JP_HIGH)
		return FALSE

	var/datum/job/job = SSjob.GetJob(job_title)

	if (isnull(job))
		return FALSE

	if (job.faction != FACTION_STATION)
		return FALSE

	if (!preferences.set_job_preference_level(job, level))
		return FALSE

	preferences.character_preview_view?.update_body()

	if(isnewplayer(user))
		var/mob/dead/new_player/cycle = user
		cycle.update_ready_report()

	return TRUE

/datum/preference_middleware/jobs/proc/set_title_preference(list/params, mob/user)
	var/base_title = params["base_title"]
	var/new_title = params["new_title"]
	if(new_title == base_title)
		new_title = null // clearing, essentially

	var/datum/job/job = SSjob.GetJob(base_title)
	if(isnull(job))
		return FALSE
	if(new_title && !(new_title in job.get_titles(TRUE)))
		return FALSE

	set_title(base_title, new_title)
	preferences.character_preview_view?.update_body()
	return TRUE

/datum/preference_middleware/jobs/get_constant_data()
	var/list/data = list()

	var/list/departments = list()
	var/list/jobs = list()

	for (var/datum/job/job as anything in SSjob.joinable_occupations)
		if (job.job_flags & JOB_LATEJOIN_ONLY)
			continue
		var/datum/job_department/department_type = job.department_for_prefs || job.departments_list?[1]
		if (isnull(department_type))
			stack_trace("[job] does not have a department set, yet is a joinable occupation!")
			continue

		if (isnull(job.description))
			stack_trace("[job] does not have a description set, yet is a joinable occupation!")
			continue

		var/department_name = initial(department_type.department_name)
		if (isnull(departments[department_name]))
			var/datum/job/department_head_type = initial(department_type.department_head)

			departments[department_name] = list(
				"head" = department_head_type && initial(department_head_type.title),
			)

		jobs[job.title] = list(
			"description" = job.description,
			"department" = department_name,
			"title_options" = job.get_titles(TRUE),
		)

	data["departments"] = departments
	data["jobs"] = jobs

	return data

/datum/preference_middleware/jobs/get_ui_data(mob/user)
	var/list/data = list()

	data["job_preferences"] = preferences.job_preferences
	data["job_titles"] = preferences.read_preference(/datum/preference/job_titles) || list()

	return data

/datum/preference_middleware/jobs/get_ui_static_data(mob/user)
	var/list/data = list()

	var/list/required_job_playtime = get_required_job_playtime(user)
	if (!isnull(required_job_playtime))
		data += required_job_playtime

	var/list/job_bans = get_job_bans(user)
	if (job_bans.len)
		data["job_bans"] = job_bans

	return data.len > 0 ? data : null

/datum/preference_middleware/jobs/proc/get_required_job_playtime(mob/user)
	var/list/data = list()

	var/list/job_days_left = list()
	var/list/job_required_experience = list()

	for (var/datum/job/job as anything in SSjob.all_occupations)
		if (job.job_flags & JOB_LATEJOIN_ONLY)
			continue
		var/required_playtime_remaining = job.required_playtime_remaining(user.client)
		if (required_playtime_remaining)
			job_required_experience[job.title] = list(
				"experience_type" = job.get_exp_req_type(),
				"required_playtime" = required_playtime_remaining,
			)

			continue

		if (!job.player_old_enough(user.client))
			job_days_left[job.title] = job.available_in_days(user.client)

	if (job_days_left.len)
		data["job_days_left"] = job_days_left

	if (job_required_experience)
		data["job_required_experience"] = job_required_experience

	return data

/datum/preference_middleware/jobs/proc/get_job_bans(mob/user)
	var/list/data = list()

	for (var/datum/job/job as anything in SSjob.all_occupations)
		if (is_banned_from(user.client?.ckey, job.title))
			data += job.title

	return data

/datum/preference_middleware/jobs/proc/set_title(base_title, new_title)
	var/list/set_prefs = preferences.read_preference(/datum/preference/job_titles) || list()
	set_prefs[base_title] = new_title
	preferences.update_preference(GLOB.preference_entries[/datum/preference/job_titles], set_prefs)

/// Tracks what title you have set for jobs
/// Assoc lazylist [job_title] = [title they set]
/datum/preference/job_titles
	savefile_key = "job_titles"
	can_randomize = FALSE
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/job_titles/create_default_value()
	return null

/datum/preference/job_titles/is_valid(value)
	return islist(value) || isnull(value)

/datum/preference/job_titles/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/job_titles/deserialize(input, datum/preferences/preferences)
	var/list/input_sanitized = list()
	for(var/job_title in input)
		var/datum/job/job = SSjob.GetJob(job_title)
		if(isnull(job))
			continue
		if(!(input[job_title] in job.get_titles(TRUE)))
			continue
		input_sanitized[job_title] = input[job_title]

	return input_sanitized

/datum/preference/job_titles/serialize(input)
	return length(input) ? input : null
