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

		if(LAZYLEN(found_machine.recieved_paperwork) >= found_machine.max_paperwork)
			continue
		if(!found_machine.can_recieve)
			continue

		var/num_papers_added = 0
		for(var/i in 1 to rand(0, 4))
			if(LAZYLEN(found_machine.recieved_paperwork) >= found_machine.max_paperwork)
				continue
			num_papers_added++
			LAZYADD(found_machine.recieved_paperwork, generate_paperwork(found_machine))
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
	var/error_paper = prob(8)
	var/paper_base_subject = pick_list(PAPERWORK_FILE, "subject")
	var/rand_month = rand(1, 12)
	var/rand_days = 31
	switch(rand_month)
		if(4, 6, 9, 11)
			rand_days = 30
		if(2)
			rand_days = (GLOB.year_integer % 4 == 0) ? 29 : 28

	var/paper_time_period = "[rand(GLOB.year_integer + 400, GLOB.year_integer + 550)]/[rand_month]/[rand(1, rand_days)]"
	var/paper_occasion = pick_list(PAPERWORK_FILE, "occasion")
	var/paper_contents
	var/paper_victim
	var/paper_subject

	switch(paper_occasion)
		if("court case", "trial")
			paper_subject = paper_base_subject
			paper_victim = pick_list(PAPERWORK_FILE, "subject")
			if(prob(30) || paper_victim == paper_subject)
				paper_victim = random_unique_name()
			paper_contents = pick_list(PAPERWORK_FILE, "contents_court_cases")

		if("execution", "re-education")
			paper_subject = paper_base_subject
			paper_victim = random_unique_name()
			paper_contents = pick_list(PAPERWORK_FILE, "contents_executions")

		if("patent")
			paper_subject = paper_base_subject
			paper_contents = pick_list(PAPERWORK_FILE, "contents_patents")

		else
			paper_contents = pick_list(PAPERWORK_FILE, "contents_random")

	if(error_paper)
		var/list/error_options = list("occasion", "time", "subject", "victim")
		if(!paper_subject)
			error_options -= "subject"
		if(!paper_victim)
			error_options -= "victim"
		switch(pick(error_options))
			if("subject")
				paper_subject = scramble_text(paper_subject)
			if("victim")
				paper_victim = scramble_text(paper_victim)
			if("time")
				paper_time_period = "[rand(GLOB.year_integer + 400, GLOB.year_integer + 550)]/[rand_month + 6]/[rand(rand_days, 1.5 * rand_days)]"
			if("occasion")
				paper_occasion = scramble_text(paper_occasion)

	if(paper_subject)
		paper_contents = replacetext(paper_contents, "subject", paper_subject)
	if(paper_victim)
		paper_contents = replacetext(paper_contents, "victim", paper_victim)

	var/list/processed_paper_data = list()
	if(paper_subject)
		processed_paper_data["subject"] = paper_subject
	if(paper_victim)
		processed_paper_data["victim"] = paper_victim
	processed_paper_data["time_period"] = paper_time_period
	processed_paper_data["occasion"] = paper_occasion

	var/obj/item/paper/processed/spawned_paper = new(destination_machine)
	spawned_paper.paper_data = processed_paper_data
	spawned_paper.errors_present = error_paper
	spawned_paper.info = "[paper_time_period] - [paper_occasion]: [paper_contents]"
	spawned_paper.generate_requirements()
	spawned_paper.update_appearance()

	return spawned_paper
