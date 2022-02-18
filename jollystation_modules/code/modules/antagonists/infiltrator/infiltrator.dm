/// -- Infiltrator antag. Advanced traitors but they get some nukops gear in their uplink. --
/datum/antagonist/traitor/advanced/intiltrator
	name = "Infiltrator"
	ui_name = null
	hijack_speed = 1
	advanced_antag_path = /datum/advanced_antag_datum/traitor/infiltrator
	antag_hud_name = "synd"

/datum/antagonist/traitor/advanced/intiltrator/on_gain()
	equip_infiltrator_outfit()
	return ..()

/datum/antagonist/traitor/advanced/intiltrator/set_name_on_add()
	name = "Infiltrator"

/datum/antagonist/traitor/advanced/intiltrator/apply_innate_effects(mob/living/mob_override)
	var/mob/living/living_antag = mob_override || owner.current
	add_team_hud(living_antag)
	living_antag.faction |= ROLE_SYNDICATE
	owner.set_assigned_role(SSjob.GetJobType(/datum/job/infiltrator))
	owner.special_role = ROLE_INFILTRATOR

/datum/antagonist/traitor/advanced/intiltrator/remove_innate_effects(mob/living/mob_override)
	var/mob/living/living_antag = mob_override || owner.current
	living_antag.faction -= ROLE_SYNDICATE
	owner.set_assigned_role(SSjob.GetJobType(/datum/job/unassigned))
	owner.special_role = null

/datum/antagonist/traitor/advanced/intiltrator/on_removal()
	var/obj/item/implant/uplink/infiltrator/infiltrator_implant = locate() in owner.current
	var/obj/item/implant/weapons_auth/weapons_implant = locate() in owner.current
	if(infiltrator_implant)
		to_chat(owner.current, span_danger("You hear a whirring in your ear as your [infiltrator_implant.name] deactivates and becomes non-functional!"))
		qdel(infiltrator_implant)
	if(weapons_implant)
		to_chat(owner.current, span_danger("You hear a click in your [prob(50) ? "right" : "left"] arm as your [weapons_implant.name] deactivates and becomes non-functional!"))
		qdel(weapons_implant)

	var/obj/item/organ/brain/their_brain = owner.current.getorganslot(ORGAN_SLOT_BRAIN)
	if(their_brain)
		var/obj/item/skillchip/disk_verifier/disky_chip = locate() in their_brain
		if(disky_chip)
			their_brain.remove_skillchip(disky_chip)
			qdel(disky_chip)

	return ..()

/datum/antagonist/traitor/advanced/intiltrator/roundend_report()
	var/list/result = list()

	result += printplayer(owner)
	result += "<b>[owner]</b> was a/an <b>[linked_advanced_datum.name]</b>, sent to infiltrate [station_name()][employer? ", employed by <b>[employer]</b>":""]."
	if(linked_advanced_datum.backstory)
		result += "<b>[owner]'s</b> backstory was the following: <br>[linked_advanced_datum.backstory]"

	var/TC_uses = 0
	var/uplink_true = FALSE
	var/purchases = ""

	if(linked_advanced_datum.finalized)
		LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
		var/datum/uplink_purchase_log/log = GLOB.uplink_purchase_logs_by_key[owner.key]
		if(log)
			uplink_true = TRUE
			TC_uses = log.total_spent
			purchases += log.generate_render(FALSE)

	if(LAZYLEN(linked_advanced_datum.our_goals))
		result += "<b>[owner]'s</b> objectives:"
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			result += goal.get_roundend_text(count++)
		if(linked_advanced_datum.finalized)
			result += "<br>They were afforded <b>[linked_advanced_datum.starting_points]</b> tc to accomplish these tasks."

	if(uplink_true && linked_advanced_datum.finalized)
		var/uplink_text = span_bold("(used [TC_uses] TC)")
		uplink_text += "[purchases]"
		result += uplink_text
	else
		result += span_bold("<br>The [name] never obtained their uplink!")

	return result.Join("<br>")

/datum/antagonist/traitor/advanced/intiltrator/roundend_report_footer()
	return "<br>And thus ends another attempted Syndicate infiltration on board [station_name()]."

/datum/antagonist/traitor/advanced/intiltrator/finalize_antag()
	var/mob/living/carbon/human/traitor_mob = owner.current
	if (!istype(traitor_mob))
		return

	var/obj/item/implant/uplink/infiltrator/infiltrator_implant = new()
	var/obj/item/implant/weapons_auth/weapons_implant = new()
	infiltrator_implant.implant(traitor_mob, traitor_mob, TRUE, TRUE)
	weapons_implant.implant(traitor_mob, traitor_mob, TRUE, TRUE)
	if(!silent)
		to_chat(traitor_mob, span_boldnotice("[employer] has cunningly implanted you with an [infiltrator_implant.name] to assist in your infiltration. You can trigger the uplink to stealthily access it."))
		to_chat(traitor_mob, span_boldnotice("[employer] has wisely implanted you with a [weapons_implant.name] to allow you to use syndicate weaponry. You can now fire weapons with Syndicate firing pins."))

	// MELBERT TODO; Fix this upstream
	var/datum/component/uplink/made = infiltrator_implant.GetComponent(/datum/component/uplink)
	made?.uplink_handler?.uplink_flag = infiltrator_implant.uplink_flag

	handle_uplink()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/tatoralert.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/traitor/advanced/intiltrator/proc/equip_infiltrator_outfit(strip = FALSE)
	if(!ishuman(owner.current))
		return FALSE
	var/mob/living/carbon/human/human_current = owner.current
	if(strip)
		human_current.delete_equipment()
	human_current.equipOutfit(/datum/outfit/syndicate_infiltrator)
	return TRUE

/datum/antagonist/traitor/advanced/intiltrator/pod_spawn
	name = "Infiltrator (Pod spawn)"
	advanced_antag_path = /datum/advanced_antag_datum/traitor/infiltrator/podspawn

/datum/antagonist/traitor/advanced/intiltrator/pod_spawn/finalize_antag()
	. = ..()
	SStgui.close_user_uis(owner, linked_advanced_datum)
	if(!spawn_infiltrator_pod(owner.current, silent))
		message_admins("Cannot pod-spawn [owner.current] as infiltrator - they have not been launched anywhere. Consider sending them via pod manually.")

/datum/antagonist/traitor/advanced/intiltrator/pod_spawn/proc/spawn_infiltrator_pod(mob/living/infiltrator, silent)
	if(!istype(infiltrator))
		return FALSE

	// Spawns us somewhere in maintenance via drop pod.
	var/list/possible_spawns = list()
	for(var/turf/found_turf in GLOB.xeno_spawn)
		if(istype(get_area(found_turf), /area/maintenance))
			possible_spawns += found_turf
	if(!possible_spawns.len)
		return FALSE

	var/obj/structure/closet/supplypod/infiltrator_pod = new(null, STYLE_SYNDICATE)
	infiltrator_pod.explosionSize = list(0, 0, 1, 1)
	infiltrator_pod.bluespace = TRUE

	var/turf/picked_turf = pick(possible_spawns)
	var/turf/randomized_picked_turf = find_obstruction_free_location(3, picked_turf) || picked_turf

	if(!silent)
		to_chat(infiltrator, span_alertwarning("\nYou are being deployed via drop pod into [get_area_name(randomized_picked_turf, TRUE)] to begin your infiltration of [station_name()]."))
	infiltrator.forceMove(infiltrator_pod)
	return new /obj/effect/pod_landingzone(randomized_picked_turf, infiltrator_pod)

/// infiltrator uplink implant.
/obj/item/implant/uplink/infiltrator
	name = "infiltrator uplink implant"
	uplink_flag = UPLINK_INFILTRATOR

/datum/outfit/syndicate_infiltrator
	name = "Syndicate Infiltrator"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves =  /obj/item/clothing/gloves/color/black
	back = /obj/item/storage/backpack/fireproof
	ears = /obj/item/radio/headset
	id = /obj/item/card/id/advanced/black
	id_trim = /datum/id_trim/syndicom/infiltrator
	skillchips = list(/obj/item/skillchip/disk_verifier)
	backpack_contents = list(/obj/item/storage/box/survival/syndie = 1, /obj/item/knife/combat/survival)

/datum/outfit/syndicate_infiltrator/post_equip(mob/living/carbon/human/human_equipper, visualsOnly)
	. = ..()
	var/obj/item/card/id/worn_id = human_equipper.wear_id
	if(worn_id)
		worn_id.registered_name = human_equipper.real_name
		worn_id.update_label()
		worn_id.update_icon()

/datum/id_trim/syndicom/infiltrator
	assignment = "Syndicate Infiltrator"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
