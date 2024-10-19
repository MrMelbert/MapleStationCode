// -- Job datum definitions --
/datum/job
	/// Bitflags of factions this job itself can be associated with.
	/// Alternative to checking for faction on the mind, since faction isn't very consistent
	var/faction_alignment
	/// Priority for the job on the crew monitor.
	var/crewmonitor_priority = -1

// Update crew monitor with new jobs
/datum/crewmonitor/New()
	. = ..()
	for(var/datum/job/jobtype as anything in subtypesof(/datum/job))
		if(!(initial(jobtype.job_flags) & JOB_NEW_PLAYER_JOINABLE))
			continue
		if(jobtype.crewmonitor_priority < 0)
			continue
		jobs[jobtype.title] = jobtype.crewmonitor_priority
