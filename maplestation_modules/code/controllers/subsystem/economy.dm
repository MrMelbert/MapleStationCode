/// -- Economy ss additions --
/datum/controller/subsystem/economy/fire(resumed = 0)
	. = ..()
	send_fax_paperwork()

/*
 * Send paperwork to process to fax machines in the world.
 *
 * if there's multiple fax machines in the same area, only send a fax to the first one we find.
 * if the chosen machine is at the limit length of paperwork, don't send anything.
 * if the chosen machine has recieving paperwork disabled, don't send anything.
 *
 * Otherwise, send a random number of paper to the selected machine.
 */
/datum/controller/subsystem/economy/proc/send_fax_paperwork()
	var/list/area/processed_areas = list()
	for(var/obj/machinery/fax_machine/found_machine as anything in GLOB.fax_machines)
		/// We only send to one fax machine in an area
		var/area/area_loc = get_area(found_machine)
		if(area_loc in processed_areas)
			continue
		processed_areas += area_loc

		if(LAZYLEN(found_machine.received_paperwork) >= found_machine.max_paperwork)
			continue
		if(!found_machine.can_receive_paperwork)
			continue

		var/num_papers_added = 0
		for(var/i in 1 to rand(0, 4))
			if(LAZYLEN(found_machine.received_paperwork) >= found_machine.max_paperwork)
				continue
			num_papers_added++
			LAZYADD(found_machine.received_paperwork, generate_paperwork(found_machine))
		if(num_papers_added)
			found_machine.audible_message(span_notice("[found_machine] beeps as new paperwork becomes available to process."))
			playsound(found_machine,  'sound/machines/twobeep.ogg', 50)

/*
 * Randomly generates a processed paperwotk to place in [destination_machine].
 * Spawns an [/obj/item/paper/processed] in [destination_machine]'s contents.
 *
 * return an instance of [/obj/item/paper/processed].
 */
/proc/generate_paperwork(obj/machinery/fax_machine/destination_machine)
	// Percent chance this paper will contain an error, somewhere.
	var/error_prob = prob(8)
	// Percent change that something will be redacted from the paper.
	var/redacted_prob = prob(15)
	// The 'base' subject of the paper.
	var/paper_base_subject = pick_list(COMPANY_FILE, "companies")
	// The month to this paper's date.
	var/rand_month = rand(1, 12)
	// A var tracking the date range we can use for randomizing dates.
	var/rand_days = 31
	switch(rand_month)
		if(4, 6, 9, 11)
			rand_days = 30
		if(2)
			rand_days = (GLOB.year_integer % 4 == 0) ? 29 : 28
	// The date the event of paper occured, randomly generated.
	var/paper_time_period = "[rand(GLOB.year_integer + 440, GLOB.year_integer + 540)]/[rand_month]/[rand(1, rand_days)]"
	// The event that happened in the paper.
	var/paper_occasion = pick_list_weighted(PAPERWORK_FILE, "occasion")
	// The contents of the paper. Will eventually not be null.
	var/paper_contents
	// The victim of the paper. This will usually be a randomly name.
	var/paper_victim
	// The species of the victim of the paper.
	var/paper_victim_species
	// The first subject of the paper, mentioned first.
	var/paper_primary_subject
	// The second subject of the paper, mentioned second or after victims.
	var/paper_secondary_subject
	// The station mentioned in the paper.
	var/paper_station
	// All the info about the paper we're tracking.
	var/list/all_tracked_data = list("time", "occasion")

	switch(paper_occasion)
		if("trial", "criminal trial", "civil trial", "court case", "criminal case", "civil case")
			paper_contents = pick_list(PAPERWORK_FILE, "contents_court_cases")

		if("execution", "re-education")
			paper_contents = pick_list_replacements(PAPERWORK_FILE, "contents_executions")

		if("patent", "intellectual property", "copyright")
			paper_contents = pick_list(PAPERWORK_FILE, "contents_patents")

		else
			paper_contents = pick_list(PAPERWORK_FILE, "contents_random")

	if(findtext(paper_contents, "subject_one"))
		paper_primary_subject = paper_base_subject
		all_tracked_data += "subject_one"
	if(findtext(paper_contents, "subject_two"))
		paper_secondary_subject = pick_list(COMPANY_FILE, "companies")
		if(paper_secondary_subject == paper_base_subject) // okay but what are the odds of picking the same name, threee times?
			paper_secondary_subject = pick_list(COMPANY_FILE, "companies")
		all_tracked_data += "subject_two"
	if(findtext(paper_contents, "victim"))
		var/list/possible_names = list(
			"human" = random_unique_name(),
			"lizard" = random_unique_lizard_name(),
			"plasmaman" = random_unique_plasmaman_name(),
			"ethereal" = random_unique_ethereal_name(),
			"moth" = random_unique_moth_name(),)
		paper_victim_species = pick(possible_names)
		paper_victim = possible_names[paper_victim_species]
		all_tracked_data += "victim"
	if(findtext(paper_contents, "station_name"))
		paper_station = prob(80) ? "[new_station_name()] Research Station" : "[syndicate_name()] Research Station"
		all_tracked_data += "station"

	if(redacted_prob)
		var/data_to_redact = pick(all_tracked_data)
		switch(data_to_redact)
			if("subject_one")
				paper_primary_subject = "\[REDACTED\]"
			if("subject_two")
				paper_secondary_subject = "\[REDACTED\]"
			if("station")
				paper_station = "\[REDACTED\]"
			if("victim")
				paper_victim = "\[REDACTED\]"
				paper_victim_species = "\[REDACTED\]"
			if("time")
				paper_time_period = "\[REDACTED\]"
			if("occasion")
				paper_occasion = "\[REDACTED\]"
		all_tracked_data -= data_to_redact

	if(error_prob)
		switch(pick(all_tracked_data))
			if("subject_one")
				paper_primary_subject = scramble_text(paper_primary_subject, rand(4, 8))
			if("subject_two")
				paper_secondary_subject = scramble_text(paper_secondary_subject, rand(4, 8))
			if("station")
				paper_station = scramble_text(paper_station, rand(3, 5))
			if("victim")
				paper_victim = scramble_text(paper_victim, rand(5, 8))
			if("time")
				paper_time_period = "[rand(GLOB.year_integer + 440, GLOB.year_integer + 540)]/[rand_month + 6]/[rand(rand_days, 1.5 * rand_days)]"
			if("occasion")
				paper_occasion = scramble_text(paper_occasion, rand(4, 8))

	if(paper_primary_subject)
		paper_contents = replacetext(paper_contents, "subject_one", paper_primary_subject)
	if(paper_secondary_subject)
		paper_contents = replacetext(paper_contents, "subject_two", paper_secondary_subject)
	if(paper_station)
		paper_contents = replacetext(paper_contents, "station_name", paper_station)
	if(paper_victim)
		paper_contents = replacetext(paper_contents, "victim", paper_victim)

	var/list/processed_paper_data = list()
	if(paper_primary_subject)
		processed_paper_data["subject_one"] = paper_primary_subject
	if(paper_secondary_subject)
		processed_paper_data["subject_two"] = paper_secondary_subject
	if(paper_victim)
		processed_paper_data["victim"] = paper_victim
		processed_paper_data["victim_species"] = paper_victim_species
	if(paper_station)
		processed_paper_data["station"] = paper_station
	processed_paper_data["time_period"] = paper_time_period
	processed_paper_data["occasion"] = paper_occasion
	processed_paper_data["redacts_present"] = redacted_prob
	processed_paper_data["errors_present"] = error_prob

	var/obj/item/paper/processed/spawned_paper = new(destination_machine)
	spawned_paper.paper_data = processed_paper_data
	spawned_paper.info = "[paper_time_period] - [paper_occasion]: [paper_contents]"
	spawned_paper.generate_requirements()
	spawned_paper.update_appearance()

	return spawned_paper
