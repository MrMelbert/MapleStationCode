// makes it so stuff dropped is deleted unless it has the INDESTRUCTIBLE trait
// literally just a modified cryopod process

/obj/machinery/cryopod/process()
	if(!occupant)
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant.stat == DEAD)
		open_machine()

	if(!mob_occupant.client && COOLDOWN_FINISHED(src, despawn_world_time))
		if(!control_computer_weakref)
			find_control_computer(urgent = TRUE)

		new_despawn_occupant()

/obj/machinery/cryopod/proc/new_despawn_occupant()
	var/mob/living/mob_occupant = occupant
	var/list/crew_member = list()

	crew_member["name"] = mob_occupant.real_name

	if(mob_occupant.mind)
		// Handle job slot/tater cleanup.
		var/job = mob_occupant.mind.assigned_role.title
		crew_member["job"] = job
		SSjob.FreeRole(job)
		if(LAZYLEN(mob_occupant.mind.objectives))
			mob_occupant.mind.objectives.Cut()
			mob_occupant.mind.special_role = null
	else
		crew_member["job"] = "N/A"

	// Delete them from datacore.
	var/announce_rank = null
	for(var/datum/data/record/medical_record as anything in GLOB.data_core.medical)
		if(medical_record.fields["name"] == mob_occupant.real_name)
			qdel(medical_record)
	for(var/datum/data/record/security_record as anything in GLOB.data_core.security)
		if(security_record.fields["name"] == mob_occupant.real_name)
			qdel(security_record)
	for(var/datum/data/record/general_record as anything in GLOB.data_core.general)
		if(general_record.fields["name"] == mob_occupant.real_name)
			announce_rank = general_record.fields["rank"]
			qdel(general_record)

	var/obj/machinery/computer/cryopod/control_computer = control_computer_weakref?.resolve()
	if(!control_computer)
		control_computer_weakref = null
	else
		control_computer.frozen_crew += list(crew_member)

	// Make an announcement and log the person entering storage.
	if(GLOB.announcement_systems.len)
		var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
		announcer.announce("CRYOSTORAGE", mob_occupant.real_name, announce_rank, list())

	visible_message(span_notice("[src] hums and hisses as it moves [mob_occupant.real_name] into storage."))

	for(var/obj/item/item_content as anything in mob_occupant)
		if(istype(item_content) || !(item_content.resistance_flags & INDESTRUCTIBLE))
			qdel(item_content)
		if(istype(item_content) || (item_content.resistance_flags & INDESTRUCTIBLE))
			continue
		if (issilicon(mob_occupant) && istype(item_content, /obj/item/mmi))
			continue
		mob_occupant.transferItemToLoc(item_content, drop_location(), force = TRUE, silent = TRUE)

	handle_objectives()
	QDEL_NULL(occupant)
	open_machine()
	name = initial(name)
