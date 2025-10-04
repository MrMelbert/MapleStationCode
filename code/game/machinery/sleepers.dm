/obj/machinery/sleeper
	name = "sleeper"
	desc = "An enclosed machine used to stabilize and heal patients."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	base_icon_state = "sleeper"
	density = FALSE
	obj_flags = BLOCKS_CONSTRUCTION
	state_open = TRUE
	interaction_flags_mouse_drop = NEED_DEXTERITY
	circuit = /obj/item/circuitboard/machine/sleeper

	payment_department = ACCOUNT_MED
	fair_market_price = 5

	///How much chems is allowed to be in a patient at once, before we force them to wait for the reagent to process.
	var/efficiency = 1
	///The minimum damage required to use any chem other than Epinephrine.
	var/min_health = -25
	///Whether the machine can be operated by the person inside of it.
	var/controls_inside = FALSE
	///Whether this sleeper can be deconstructed and drop the board, if its on mapload.
	var/deconstructable = FALSE
	///Message sent when a user enters the machine.
	var/enter_message = span_boldnotice("You feel cool air surround you. You go numb as your senses turn inward.")

	var/resist_time = 0 SECONDS

	///List of currently available chems.
	var/list/available_chems = list()
	///Used when emagged to scramble which chem is used, eg: mutadone -> morphine
	var/list/chem_buttons
	///All chems this sleeper will get, depending on the parts inside.
	var/list/possible_chems = list(
		list(
			/datum/reagent/medicine/epinephrine,
			/datum/reagent/medicine/painkiller/morphine, // NON-MODULE CHANGE
			/datum/reagent/medicine/c2/convermol,
			/datum/reagent/medicine/c2/libital,
			/datum/reagent/medicine/c2/aiuri,
		),
		list(
			/datum/reagent/medicine/oculine,
			/datum/reagent/medicine/inacusiate,
		),
		list(
			/datum/reagent/medicine/c2/multiver,
			/datum/reagent/medicine/mutadone,
			/datum/reagent/medicine/mannitol,
			/datum/reagent/medicine/salbutamol,
			/datum/reagent/medicine/pen_acid,
		),
		list(
			/datum/reagent/medicine/omnizine,
		),
	)

/obj/machinery/sleeper/Initialize(mapload)
	. = ..()
	if(mapload && !deconstructable)
		LAZYREMOVE(component_parts, circuit)
		QDEL_NULL(circuit)
	occupant_typecache = GLOB.typecache_living
	update_appearance()
	reset_chem_buttons()

/obj/machinery/sleeper/on_set_panel_open(old_value)
	. = ..()
	if(panel_open)
		set_machine_stat(machine_stat | MAINT)
	else
		set_machine_stat(machine_stat & ~MAINT)

/obj/machinery/sleeper/RefreshParts()
	. = ..()
	var/matterbin_rating
	for(var/datum/stock_part/matter_bin/matterbins in component_parts)
		matterbin_rating += matterbins.tier
	efficiency = initial(efficiency) * matterbin_rating
	min_health = initial(min_health) * matterbin_rating

	available_chems.Cut()
	for(var/datum/stock_part/servo/servos in component_parts)
		for(var/i in 1 to min(servos.tier, length(possible_chems)))
			available_chems |= possible_chems[i]

	reset_chem_buttons()

/obj/machinery/sleeper/update_icon_state()
	icon_state = "[base_icon_state][state_open ? "-open" : null]"
	return ..()

/obj/machinery/sleeper/container_resist_act(mob/living/user)
	if(resist_time > 0)
		to_chat(user, span_notice("You pull at the release lever."))
		if(!do_after(user, resist_time, src))
			return
	user.visible_message(
		span_notice("[occupant] emerges from [src]!"),
		span_notice("You climb out of [src]!"),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	open_machine()

/obj/machinery/sleeper/Exited(atom/movable/gone, direction)
	. = ..()
	if (!state_open && gone == occupant)
		container_resist_act(gone)

/obj/machinery/sleeper/relaymove(mob/living/user, direction)
	if (!state_open)
		container_resist_act(user)

/obj/machinery/sleeper/open_machine(drop = TRUE, density_to_set = FALSE)
	if(!state_open && !panel_open)
		flick("[initial(icon_state)]-anim", src)
	return ..()

/obj/machinery/sleeper/close_machine(mob/user, density_to_set = TRUE)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		flick("[initial(icon_state)]-anim", src)
		..()
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(mob_occupant, "[enter_message]")

/obj/machinery/sleeper/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(is_operational && occupant)
		open_machine()

/obj/machinery/sleeper/mouse_drop_receive(atom/target, mob/user, params)
	if(!iscarbon(target))
		return
	close_machine(target)

/obj/machinery/sleeper/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(occupant)
		to_chat(user, span_warning("[src] is currently occupied!"))
		return TRUE
	if(state_open)
		to_chat(user, span_warning("[src] must be closed to [panel_open ? "close" : "open"] its maintenance hatch!"))
		return TRUE
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
		return TRUE
	return FALSE

/obj/machinery/sleeper/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_change_direction_wrench(user, I))
		return TRUE
	return FALSE

/obj/machinery/sleeper/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_pry_open(I))
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE
	return FALSE

/obj/machinery/sleeper/default_pry_open(obj/item/I) //wew
	. = !(state_open || panel_open) && I.tool_behaviour == TOOL_CROWBAR
	if(.)
		I.play_tool_sound(src, 50)
		visible_message(span_notice("[usr] pries open [src]."), span_notice("You pry open [src]."))
		open_machine()

/obj/machinery/sleeper/ui_state(mob/user)
	if(!controls_inside)
		return GLOB.notcontained_state
	return GLOB.default_state

/obj/machinery/sleeper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", name)
		ui.open()

/obj/machinery/sleeper/click_alt(mob/user)
	if(state_open)
		close_machine()
	else
		open_machine()
	return CLICK_ACTION_SUCCESS

/obj/machinery/sleeper/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click [src] to [state_open ? "close" : "open"] it.")

/obj/machinery/sleeper/process()
	use_energy(idle_power_usage)

/obj/machinery/sleeper/nap_violation(mob/violator)
	. = ..()
	open_machine()

/obj/machinery/sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = !!occupant
	data["open"] = state_open

	data["chems"] = list()
	for(var/chem in available_chems)
		var/datum/reagent/R = GLOB.chemical_reagents_list[chem]
		data["chems"] += list(
			list(
				"name" = R.name,
				"id" = R.type,
				"allowed" = chem_allowed(chem),
			),
		)

	data["occupant"] = list()
	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		data["occupant"]["name"] = mob_occupant.name
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "good"
			if(SOFT_CRIT)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "average"
			if(UNCONSCIOUS, HARD_CRIT)
				data["occupant"]["stat"] = "Unconscious"
				data["occupant"]["statstate"] = "average"
			if(DEAD)
				data["occupant"]["stat"] = "Dead"
				data["occupant"]["statstate"] = "bad"
		data["occupant"]["health"] = mob_occupant.health
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_LIKELY_DEAD
		data["occupant"]["bruteLoss"] = mob_occupant.getBruteLoss()
		data["occupant"]["oxyLoss"] = mob_occupant.getOxyLoss()
		data["occupant"]["toxLoss"] = mob_occupant.getToxLoss()
		data["occupant"]["fireLoss"] = mob_occupant.getFireLoss()
		data["occupant"]["brainLoss"] = mob_occupant.get_organ_loss(ORGAN_SLOT_BRAIN)
		data["occupant"]["reagents"] = list()
		if(mob_occupant.reagents && mob_occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in mob_occupant.reagents.reagent_list)
				if(R.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems
					continue
				data["occupant"]["reagents"] += list(
					list(
						"name" = R.name,
						"volume" = R.volume,
					),
				)

	return data

/obj/machinery/sleeper/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/living/mob_occupant = occupant
	check_nap_violations()
	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("inject")
			var/chem = text2path(params["chem"])
			if(!is_operational || !mob_occupant || isnull(chem))
				return
			if(mob_occupant.health < min_health && !ispath(chem, /datum/reagent/medicine/epinephrine))
				return
			if(inject_chem(chem, usr))
				. = TRUE
				if((obj_flags & EMAGGED) && prob(5))
					to_chat(usr, span_warning("Chemical system re-route detected, results may not be as expected!"))

/obj/machinery/sleeper/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE

	balloon_alert(user, "interface scrambled")
	obj_flags |= EMAGGED

	var/list/av_chem = available_chems.Copy()
	for(var/chem in av_chem)
		chem_buttons[chem] = pick_n_take(av_chem) //no dupes, allow for random buttons to still be correct
	return TRUE

/obj/machinery/sleeper/proc/inject_chem(chem, mob/user)
	if((chem in available_chems) && chem_allowed(chem))
		occupant.reagents.add_reagent(chem_buttons[chem], 10) //emag effect kicks in here so that the "intended" chem is used for all checks, for extra FUUU
		if(user)
			log_combat(user, occupant, "injected [chem] into", addition = "via [src]")
		return TRUE

/obj/machinery/sleeper/proc/chem_allowed(chem)
	var/mob/living/mob_occupant = occupant
	if(!mob_occupant || !mob_occupant.reagents)
		return
	var/amount = mob_occupant.reagents.get_reagent_amount(chem) + 10 <= 20 * efficiency
	var/occ_health = mob_occupant.health > min_health || chem == /datum/reagent/medicine/epinephrine
	return amount && occ_health

/obj/machinery/sleeper/proc/reset_chem_buttons()
	obj_flags &= ~EMAGGED
	LAZYINITLIST(chem_buttons)
	for(var/chem in available_chems)
		chem_buttons[chem] = chem

/**
 * Syndicate version
 * Can be controlled from the inside and can be deconstructed.
 */
/obj/machinery/sleeper/syndie
	icon_state = "sleeper_s"
	base_icon_state = "sleeper_s"
	controls_inside = TRUE
	deconstructable = TRUE

///Fully upgraded variant, the circuit using tier 4 parts.
/obj/machinery/sleeper/syndie/fullupgrade
	circuit = /obj/item/circuitboard/machine/sleeper/fullupgrade

/obj/machinery/sleeper/self_control
	controls_inside = TRUE

/obj/machinery/sleeper/old
	icon_state = "oldpod"
	base_icon_state = "oldpod"

/obj/machinery/sleeper/party
	name = "party pod"
	desc = "'Sleeper' units were once known for their healing properties, until a lengthy investigation revealed they were also dosing patients with deadly lead acetate. This appears to be one of those old 'sleeper' units repurposed as a 'Party Pod'. It’s probably not a good idea to use it."
	icon_state = "partypod"
	base_icon_state = "partypod"
	circuit = /obj/item/circuitboard/machine/sleeper/party
	controls_inside = TRUE
	deconstructable = TRUE
	enter_message = span_boldnotice("You're surrounded by some funky music inside the chamber. You zone out as you feel waves of krunk vibe within you.")

	//Exclusively uses non-lethal, "fun" chems. At an obvious downside.
	possible_chems = list(
		list(
			/datum/reagent/consumable/ethanol/beer,
			/datum/reagent/consumable/laughter,
		),
		list(
			/datum/reagent/spraytan,
			/datum/reagent/barbers_aid,
		),
		list(
			/datum/reagent/colorful_reagent,
			/datum/reagent/hair_dye,
		),
		list(
			/datum/reagent/drug/space_drugs,
			/datum/reagent/baldium,
		),
	)
	///Chemicals that need to have a touch or vapor reaction to be applied, not the standard chamber reaction.
	var/spray_chems = list(
		/datum/reagent/spraytan,
		/datum/reagent/hair_dye,
		/datum/reagent/baldium,
		/datum/reagent/barbers_aid,
	)

/obj/machinery/sleeper/party/inject_chem(chem, mob/user)
	if(obj_flags & EMAGGED)
		occupant.reagents.add_reagent(/datum/reagent/toxin/leadacetate, 4)
	else if (prob(20)) //You're injecting chemicals into yourself from a recalled, decrepit medical machine. What did you expect?
		occupant.reagents.add_reagent(/datum/reagent/toxin/leadacetate, rand(1,3))
	if(chem in spray_chems)
		var/datum/reagents/holder = new()
		holder.add_reagent(chem_buttons[chem], 10) //I hope this is the correct way to do this.
		holder.trans_to(occupant, 10, methods = VAPOR)
		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
		if(user)
			log_combat(user, occupant, "sprayed [chem] into", addition = "via [src]")
		return TRUE
	return ..()

GLOBAL_LIST_INIT(cryo_sleepers, list())

#define IS_SPAWNING "spawning"

/obj/machinery/sleeper/cryo
	name = "cryogenic pod"
	desc = "An enclosed machine designed to put subjects in a state of suspended animation for long-term storage."
	icon = 'maplestation_modules/icons/obj/machines/sleeper.dmi'
	icon_state = "cryopod"
	base_icon_state = "cryopod"
	// circuit = /obj/item/circuitboard/machine/sleeper/cryo
	enter_message = span_boldnotice("You feel a cold chill as you enter the pod. \
		You feel your body go numb as you enter a state of suspended animation.")
	possible_chems = null
	state_open = FALSE
	density = TRUE
	resist_time = 0.5 SECONDS

	var/throw_alert = TRUE

/obj/machinery/sleeper/cryo/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)
	GLOB.cryo_sleepers += src
	open_machine()

/obj/machinery/sleeper/cryo/Destroy()
	GLOB.cryo_sleepers -= src
	return ..()

/obj/machinery/sleeper/cryo/examine(mob/user)
	. = ..()
	if(isliving(occupant) && user != occupant)
		var/mob/living/occupant_l = occupant
		var/obj/item/card/id/their_id = occupant_l.get_idcard()
		. += span_notice("Inside, you can see [occupant][their_id ? ", the [their_id.assignment]" : ""][HAS_TRAIT(occupant, TRAIT_KNOCKEDOUT) ? " - sound asleep" : ""].")

/obj/machinery/sleeper/cryo/set_occupant(atom/movable/new_occupant)
	var/mob/living/old_occupant = occupant
	. = ..()
	var/mob/living/new_occupant_l = new_occupant
	var/skey = REF(src)
	if(istype(old_occupant))
		old_occupant.remove_status_effect(/datum/status_effect/grouped/stasis, skey)
		// REMOVE_TRAIT(old_occupant, TRAIT_KNOCKEDOUT, IS_SPAWNING)
		// REMOVE_TRAIT(old_occupant, TRAIT_MUTE, skey)
		REMOVE_TRAIT(old_occupant, TRAIT_BLOCK_HEADSET_USE, skey)
		REMOVE_TRAIT(old_occupant, TRAIT_SOFTSPOKEN, skey)
		UnregisterSignal(old_occupant, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE)
		if(throw_alert)
			old_occupant.clear_alert(skey)
	if(istype(new_occupant_l))
		new_occupant_l.apply_status_effect(/datum/status_effect/grouped/stasis, skey)
		// ADD_TRAIT(new_occupant_l, TRAIT_MUTE, skey)
		ADD_TRAIT(new_occupant_l, TRAIT_BLOCK_HEADSET_USE, skey)
		ADD_TRAIT(new_occupant_l, TRAIT_SOFTSPOKEN, skey)
		RegisterSignal(new_occupant_l, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE, PROC_REF(early_move_check))
		if(throw_alert)
			new_occupant_l.throw_alert(skey, /atom/movable/screen/alert/cryosleep)

/obj/machinery/sleeper/cryo/proc/early_move_check(mob/living/mob_occupant, new_loc, direct)
	SIGNAL_HANDLER

	if(mob_occupant.incapacitated(IGNORE_STASIS) || DOING_INTERACTION_WITH_TARGET(mob_occupant, src))
		return NONE
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, relaymove), mob_occupant, direct)
	return COMSIG_MOB_CLIENT_BLOCK_PRE_LIVING_MOVE

/obj/machinery/sleeper/cryo/close_machine(mob/user, density_to_set)
	. = ..()
	if(isliving(occupant))
		playsound(src, 'sound/effects/spray.ogg', 5, TRUE, frequency = 0.5)

/obj/machinery/sleeper/cryo/close_machine(mob/user, density_to_set)
	. = ..()
	if(isliving(occupant))
		playsound(src, 'sound/machines/fan_stop.ogg', 50, TRUE)

/obj/machinery/sleeper/cryo/JoinPlayerHere(mob/living/joining_mob, buckle)
	if(occupant || !ishuman(joining_mob))
		return ..()
	throw_alert = FALSE
	if(state_open)
		close_machine()
	set_occupant(joining_mob)
	joining_mob.forceMove(src)
	ADD_TRAIT(joining_mob, TRAIT_KNOCKEDOUT, IS_SPAWNING)
	addtimer(TRAIT_CALLBACK_REMOVE(joining_mob, TRAIT_KNOCKEDOUT, IS_SPAWNING), rand(8, 12) * 1 SECONDS)
	throw_alert = TRUE

/obj/machinery/sleeper/cryo/default_deconstruction_crowbar(obj/item/crowbar, ignore_panel = 0, custom_deconstruct = FALSE)
	return FALSE

/obj/machinery/sleeper/cryo/default_deconstruction_screwdriver(mob/living/user, icon_state, base_icon_state, obj/item/screwdriver)
	return FALSE

/obj/machinery/sleeper/cryo/default_change_direction_wrench(mob/living/user, obj/item/wrench)
	return FALSE

/obj/machinery/sleeper/cryo/open_machine(drop = TRUE, density_to_set = FALSE)
	density_to_set = TRUE
	return ..()

/// Checks if this can generically be used as a latejoin spawnpoint
/obj/machinery/sleeper/cryo/proc/can_latejoin(datum/job/joining)
	if(!isnull(occupant))
		return FALSE
	if(istype(joining, /datum/job/prisoner))
		if(!istype(get_area(src), /area/station/security/prison))
			return FALSE
	else
		if(!istype(get_area(src), /area/station/commons))
			return FALSE
	return TRUE

/// Checks if the passed item should avoid deletion when being despawned
/obj/machinery/sleeper/cryo/proc/saveable_item(obj/item/save_me)
	if(save_me.resistance_flags & INDESTRUCTIBLE)
		return TRUE
	if(GLOB.steal_item_handler.objectives_by_path[save_me.type])
		return TRUE
	return FALSE

/obj/machinery/sleeper/cryo/proc/despawn_occupant()
	if(!isliving(occupant))
		return
	var/drop_loc = drop_location()
	var/mob/living/mob_occupant = occupant

	set_occupant(null)
	mob_occupant.ghostize(FALSE)

	for(var/obj/item/save_me in mob_occupant.get_all_contents())
		if(saveable_item(save_me))
			mob_occupant.transferItemToLoc(save_me, drop_loc, force = TRUE, silent = TRUE)

	qdel(mob_occupant)
	open_machine()

	var/datum/record/associated_record = find_record(mob_occupant.real_name)
	var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
	if(!QDELETED(associated_record) && !QDELETED(announcer))
		announcer.announce("DESPAWN", mob_occupant.name, associated_record.rank, list())

	deadchat_broadcast(
		"<span class='game'> has entered cryogenic storage.</span>",
		"<span class='game'><span class='name'>[mob_occupant.real_name]</span> ([associated_record?.rank || "Unknown"])</span>",
		turf_target = get_turf(src),
		message_type = DEADCHAT_ARRIVALRATTLE,
	)

#undef IS_SPAWNING

/atom/movable/screen/alert/cryosleep
	name = "Cryosleep"
	desc = "Click this button to despawn your character."
	mouse_over_pointer = MOUSE_HAND_POINTER
	icon_state = "cold"

/atom/movable/screen/alert/cryosleep/Click(location, control, params)
	. = ..()
	if(!.)
		return .
	var/obj/machinery/sleeper/cryo/sleeper = owner.loc
	if(!istype(sleeper))
		stack_trace("[type] was clicked by [usr] without being in a sleeper.")
		return FALSE

	var/are_you_sure = tgui_alert(usr, "Are you sure you want to despawn your character?", "Despawn Character", list("Yes", "No"), 5 SECONDS)
	if(are_you_sure != "Yes" || QDELETED(src) || QDELETED(sleeper) || sleeper.occupant != usr)
		return FALSE

	sleeper.despawn_occupant()
	return TRUE
