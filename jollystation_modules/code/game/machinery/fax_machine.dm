
GLOBAL_LIST_EMPTY(fax_machines)

#define PAPERWORK_FILE "paperwork.json"

/datum/design/board/fax_machine
	name = "Machine Design (Fax Machine Board)"
	desc = "The circuit board for a Fax Machine."
	id = "fax_machine"
	build_path = /obj/item/circuitboard/machine/fax_machine
	category = list("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_SECURITY

/obj/item/circuitboard/machine/fax_machine
	name = "Fax Machine (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/fax_machine
	req_components = list(
		/obj/item/stack/sheet/mineral/silver = 1,
		/obj/item/stack/sheet/glass = 1,
		)

/// Sends messages, recieves messages, sends paperwork, recieves paperwork.
/obj/machinery/fax_machine
	name = "fax machine"
	desc = "Send faxes and process paperwork, you boring person."
	icon = 'icons/obj/machines/limbgrower.dmi'
	icon_state = "limbgrower_idleoff"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/circuitboard/machine/fax_machine
	var/obj/item/paper/stored_paper
	var/list/obj/item/paper/processed/recieved_papers

/obj/machinery/fax_machine/Initialize()
	. = ..()
	GLOB.fax_machines += src

/obj/machinery/fax_machine/Destroy()
	eject_all_recieved_papers()
	eject_stored_paper()

	GLOB.fax_machines -= src
	return ..()

/obj/machinery/fax_machine/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_FaxMachine")
		ui.open()

/obj/machinery/fax_machine/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/fax_machine/ui_data(mob/user)
	var/list/data = list()

	var/list/all_recieved_papers = list()
	for(var/obj/item/paper/processed/paper as anything in recieved_papers)
		var/list/found_paper_data = list()
		found_paper_data["title"] = paper.name
		found_paper_data["contents"] = paper.info
		found_paper_data["ref"] = REF(paper)
		all_recieved_papers += list(found_paper_data)
	if(all_recieved_papers.len)
		data["recieved_paper"] = list(all_recieved_papers)

	if(stored_paper)
		var/list/stored_paper_data = list()
		stored_paper_data["title"] = stored_paper.name
		stored_paper_data["contents"] = stored_paper.info
		stored_paper_data["ref"] = REF(stored_paper_data)
		data["stored_paper"] = list(stored_paper_data)

	return data

/obj/machinery/fax_machine/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("print_recieved_paper")
			var/obj/item/paper/processed/paper = locate(params["ref"]) in recieved_papers
			eject_recieved_paper(usr, paper)


/obj/machinery/fax_machine/attackby(obj/item/weapon, mob/user, params)
	if(!isliving(user))
		return ..()

	if(istype(weapon, /obj/item/paper/processed))
		check_paper(weapon)
		return
	else if(istype(weapon, /obj/item/paper))
		insert_paper(weapon, user)
		return

	return ..()

/obj/machinery/fax_machine/proc/check_paper(obj/item/paper/processed/inserted_paper)

/obj/machinery/fax_machine/proc/insert_paper(obj/item/paper/inserted_paper, mob/living/user)
	inserted_paper.forceMove(src)
	if(stored_paper)
		to_chat(user, span_notice("You take out [stored_paper] from [src] and insert [inserted_paper]."))
		eject_stored_paper(user)
	else
		to_chat(user, span_notice("You insert [inserted_paper] into [src]."))

	stored_paper = inserted_paper

/obj/machinery/fax_machine/proc/eject_all_recieved_papers(mob/living/user)
	for(var/obj/item/paper/processed/paper as anything in recieved_papers)
		eject_recieved_paper(user, paper)
	recieved_papers = null

/obj/machinery/fax_machine/proc/eject_recieved_paper(mob/living/user, obj/item/paper/processed/paper)
	if(user)
		user.put_in_hands(paper)
	else
		paper.forceMove(drop_location())
	recieved_papers -= paper

/obj/machinery/fax_machine/proc/eject_stored_paper(mob/living/user)
	if(user)
		user.put_in_hands(stored_paper)
	else
		stored_paper.forceMove(drop_location())
	stored_paper = null

/obj/machinery/fax_machine/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return


/datum/controller/subsystem/economy/fire(resumed = 0)
	. = ..()
	send_fax_paperwork()

/datum/controller/subsystem/economy/proc/send_fax_paperwork()
	var/list/area/processed_areas = list()
	for(var/obj/machinery/fax_machine/found_machine as anything in GLOB.fax_machines)
		var/area/area_loc = get_area(found_machine)
		if(area_loc in processed_areas)
			continue
		processed_areas += area_loc

		for(var/i in 1 to rand(0, 4))
			if(!islist(found_machine.recieved_papers))
				found_machine.recieved_papers = list()
			found_machine.recieved_papers += generate_paperwork(found_machine)
		found_machine.audible_message(span_notice("[src] beeps as it prints new paperwork available to process."))

/datum/controller/subsystem/economy/proc/generate_paperwork(obj/machinery/fax_machine/destination_machine)
	var/list/possible_subjects = strings(PAPERWORK_FILE, "subject") + "[station_name()]"
	var/paper_base_subject = pick(possible_subjects)
	var/paper_time_period = pick_list(PAPERWORK_FILE, "time_period")
	var/paper_occasion = pick_list(PAPERWORK_FILE, "occasion")
	var/paper_contents
	var/paper_victim
	var/paper_subject

	switch(paper_occasion)
		if("court case", "trial")
			paper_subject = paper_base_subject
			paper_victim = (prob(70) ? random_unique_name() : pick_list(PAPERWORK_FILE, "subject"))
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

	if(paper_subject)
		paper_contents = replacetext(paper_contents, "subject", paper_subject)
	if(paper_victim)
		paper_contents = replacetext(paper_contents, "victim", paper_victim)

	var/list/processed_paper_data = list()
	processed_paper_data["subject"] = paper_subject
	processed_paper_data["time_period"] = paper_time_period
	processed_paper_data["occasion"] = paper_occasion
	processed_paper_data["victim"] = paper_victim

	var/obj/item/paper/processed/spawned_paper = new(destination_machine, processed_paper_data)
	spawned_paper.name = "paper - '[paper_base_subject] Paperwork for \a [paper_time_period] [paper_occasion]'"
	spawned_paper.info = paper_contents
	spawned_paper.update_appearance()

	return spawned_paper

/obj/item/paper/processed
	var/list/paper_data
	var/required_line
	var/to_fulfill

/obj/item/paper/processed/Initialize(list/data)
	. = ..()
	paper_data = data
	generate_requirements()

/obj/item/paper/processed/examine(mob/user)
	. = ..()
	. += span_notice("To fulfill the paperwork, you must answer: [required_line]")

/obj/item/paper/processed/proc/generate_requirements()
	var/list/shuffled_data = shuffle(paper_data)
	for(var/data in shuffled_data)
		if(!shuffled_data[data])
			continue

		to_fulfill = shuffled_data[data]
		switch(data)
			if("subject")
				required_line = "Who was the subject of the document?"
			if("time_period")
				required_line = "When did the event in the document occur?"
			if("occasion")
				required_line = "What was the event in the document?"
			if("victim")
				required_line = "Who was the victim of the document?"
		return
