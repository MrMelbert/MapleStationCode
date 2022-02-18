/// -- "Traitor plus" or "Advanced traitor" - a traitor that is able to set their own goals and objectives when in game. --
/// Loosely based on the ambitions system from skyrat, but made less bad.

/// Proc to give the traitor their uplink and play the sound.
/datum/antagonist/traitor/finalize_antag()
	if(!linked_advanced_datum)
		pick_employer(prob(75) ? FACTION_SYNDICATE : FACTION_NANOTRASEN)
		traitor_flavor = strings(TRAITOR_FLAVOR_FILE, employer)

	if(give_uplink || linked_advanced_datum?.finalized)
		owner.give_uplink(silent = FALSE, antag_datum = src)
		handle_uplink()

	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/tatoralert.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

// MELBERT TODO: UPLINKS DON'T WORK SKREEEE
/// Proc to handled the uplink items and the uplink handler after an uplink is given.
/datum/antagonist/traitor/proc/handle_uplink()
	var/datum/component/uplink/uplink = owner.find_syndicate_uplink()
	if(!uplink)
		CRASH("handle_uplink() has been called on someone with no apparent syndicate uplink. Weird!")

	uplink_ref = WEAKREF(uplink)

	if(uplink_handler)
		uplink.uplink_handler = uplink_handler
	else
		uplink_handler = uplink.uplink_handler

	if(!linked_advanced_datum)
		uplink_handler.has_progression = TRUE
		SStraitor.register_uplink_handler(uplink_handler)

		uplink_handler.has_objectives = TRUE
		uplink_handler.generate_objectives()

		if(uplink_handler.progression_points < SStraitor.current_global_progression)
			uplink_handler.progression_points = SStraitor.current_global_progression * SStraitor.newjoin_progression_coeff

	var/list/uplink_items = list()
	for(var/datum/uplink_item/item as anything in SStraitor.uplink_items)
		if(item.item && !item.cant_discount && (item.purchasable_from & uplink_handler.uplink_flag) && item.cost > 1)
			if(!length(item.restricted_roles) && !length(item.restricted_species))
				uplink_items += item
				continue
			if((uplink_handler.assigned_role in item.restricted_roles) || (uplink_handler.assigned_species in item.restricted_species))
				uplink_items += item
				continue

	uplink_handler.extra_purchasable += create_uplink_sales(uplink_sale_count, /datum/uplink_category/discounts, -1, uplink_items)

/// The Advanced Traitor antagonist datum.
/datum/antagonist/traitor/advanced
	name = "Advanced Traitor" // Changed to just "Traitor" on spawn, but can be changed by the player.
	ui_name = null // We have our own UI
	hijack_speed = 0.5 // Edited to ([starting_tc] / 40).
	employer = "The Syndicate" // Can be changed by the player.
	give_objectives = FALSE
	should_give_codewords = FALSE
	give_uplink = FALSE
	finalize_antag = FALSE
	/// List of objectives traitors can get in addition to the base ones
	var/static/list/traitor_objectives = list(
		"exile" = /datum/objective/exile,
		)
	/// Typepath of what advanced antag datum gets instantiated to this antag.
	var/advanced_antag_path = /datum/advanced_antag_datum/traitor

/datum/antagonist/traitor/advanced/New(give_objectives = FALSE)
	. = ..()
	src.give_objectives = FALSE

/datum/antagonist/traitor/advanced/on_gain()
	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy()
	objectives_to_choose -= blacklisted_similar_objectives
	objectives_to_choose += traitor_objectives

	set_name_on_add()

	linked_advanced_datum = new advanced_antag_path(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/traitor/advanced/proc/set_name_on_add()
	name = "Traitor"

/// Greet the antag with big menacing text.
/datum/antagonist/traitor/advanced/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/traitor/advanced/roundend_report()
	var/list/result = list()

	result += printplayer(owner)
	result += "<b>[owner]</b> was a/an <b>[linked_advanced_datum.name]</b>[employer? " employed by <b>[employer]</b>":""]."
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

/datum/antagonist/traitor/advanced/roundend_report_footer()
	return "<br>And thus ends another story on board [station_name()]."

/// The advanced antag datum for traitor.
/datum/advanced_antag_datum/traitor
	name = "Advanced Traitor"
	employer = "The Syndicate"
	starting_points = 8
	/// Hijack speed = (starting telecrystals * this modifier)
	var/hijack_speed_modifier = 0.025

/datum/advanced_antag_datum/traitor/modify_antag_points()
	var/datum/component/uplink/made_uplink = linked_antagonist.owner.find_syndicate_uplink()
	if(!made_uplink)
		return

	starting_points = get_antag_points_from_goals()
	made_uplink.uplink_handler.telecrystals = starting_points
	linked_antagonist.hijack_speed = (starting_points * hijack_speed_modifier) // 20 tc traitor = 0.5 (default traitor hijack speed)

/datum/advanced_antag_datum/traitor/get_antag_points_from_goals()
	var/finalized_starting_tc = ADV_TRAITOR_INITIAL_TC
	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		finalized_starting_tc += (goal.intensity * ADV_TRAITOR_TC_PER_INTENSITY)

	return min(finalized_starting_tc, ADV_TRAITOR_MAX_TC)

/datum/advanced_antag_datum/traitor/get_finalize_text()
	return "Finalizing will send you your uplink to your preferred location with [get_antag_points_from_goals()] telecrystals. You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/traitor/set_employer(employer)
	. = ..()
	var/datum/antagonist/traitor/our_traitor = linked_antagonist
	our_traitor.employer = src.employer
