// -- QM changes --
/datum/job/quartermaster
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list(JOB_CAPTAIN)
	head_announce = list(RADIO_CHANNEL_SUPPLY)
	req_admin_notify = TRUE
	supervisors = "the captain"
	liver_traits = list(TRAIT_ROYAL_METABOLISM)
	departments_list = list(
		/datum/job_department/cargo,
		/datum/job_department/command,
		)
	voice_of_god_power = 1.4

/datum/job/quartermaster/get_captaincy_announcement(mob/living/captain)
	return "Due to staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"

/datum/outfit/job/quartermaster
	name = "Quartermaster"
	jobtype = /datum/job/quartermaster

	id = /obj/item/card/id/advanced/silver
	backpack_contents = list(
		/obj/item/modular_computer/tablet/preset/advanced/command/cargo=  1,
		/obj/item/melee/baton/telescopic = 1,
	)
	belt = /obj/item/pda/quartermaster
	ears = /obj/item/radio/headset/heads/headset_qm
