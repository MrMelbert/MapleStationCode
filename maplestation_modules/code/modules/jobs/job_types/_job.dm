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
		var/prio_to_use = jobtype.crewmonitor_priority
		while(jobs[jobtype.title])
			stack_trace("Crew monitor job priorty conflict with [jobtype] at [prio_to_use]")
			prio_to_use++
		jobs[jobtype.title] = prio_to_use
