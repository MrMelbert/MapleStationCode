/obj/machinery/sleeper
	name = "sleeper"
	desc = "An enclosed machine used to stabilize and heal patients."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	base_icon_state = "sleeper"
	density = TRUE
	obj_flags = BLOCKS_CONSTRUCTION
	state_open = TRUE
	interaction_flags_mouse_drop = NEED_DEXTERITY
	circuit = /obj/item/circuitboard/machine/sleeper
	examine_feedback_on_ui = TRUE

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
	var/list/list/possible_chems = list(
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
	var/matterbin_rating = 0
	for(var/datum/stock_part/matter_bin/matterbins in component_parts)
		matterbin_rating += matterbins.tier
	efficiency = initial(efficiency) * max(matterbin_rating, 1)
	min_health = initial(min_health) * max(matterbin_rating, 1)

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

/obj/machinery/sleeper/open_machine(drop = TRUE, density_to_set = TRUE)
	if(!state_open && !panel_open)
		flick("[initial(icon_state)]-anim", src)

	var/mob/living/old_occupant_living = occupant
	. = ..()
	if(isliving(old_occupant_living))
		// Tries to move us to the tile in front
		old_occupant_living.Move(get_step(src, dir))

/obj/machinery/sleeper/close_machine(atom/movable/target, density_to_set = TRUE)
	if(!isnull(target) && !ismob(target))
		return
	if(!state_open || panel_open)
		return
	if(!is_operational)
		return

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
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	if(!iscarbon(dropping))
		return

	try_close_machine(dropping, user)

/obj/machinery/sleeper/proc/try_close_machine(mob/living/carbon/target, mob/living/user, time_to_enter = 5 SECONDS)
	. = FALSE

	if(!insert_check(target, user))
		return .

	user.face_atom(src)
	if(user == target)
		time_to_enter *= 0.5
		user.visible_message(
			span_notice("[user] starts climbing into [src]."),
			span_notice("You start climbing into [src]."),
		)
	else
		user.visible_message(
			span_notice("[user] starts placing [target] into [src]."),
			span_notice("You start placing [target] into [src]."),
		)

	if(time_to_enter > 0)
		. = do_after(user, time_to_enter, src, extra_checks = CALLBACK(src, PROC_REF(insert_check), target, user))

	if(.)
		close_machine(target)

	if(occupant == target)
		if(user == target)
			user.visible_message(
				span_notice("[user] climbs into [src]."),
				span_notice("You climb into [src]."),
			)
		else
			user.visible_message(
				span_notice("[user] places [target] into [src]."),
				span_notice("You place [target] into [src]."),
			)

	else
		if(user == target)
			user.visible_message(
				span_warning("[user] fails to climb into [src]."),
				span_warning("You fail to climb into [src]."),
			)
		else
			user.visible_message(
				span_warning("[user] fails to place [target] into [src]."),
				span_warning("You fail to place [target] into [src]."),
			)

	return .

/obj/machinery/sleeper/proc/insert_check(atom/movable/dropping, mob/user)
	if(!state_open || panel_open || !isnull(occupant))
		return FALSE
	if(!user.Adjacent(dropping) || !Adjacent(dropping))
		return FALSE
	if(!user.can_perform_action(src, NEED_DEXTERITY|ALLOW_SILICON_REACH|FORBID_TELEKINESIS_REACH))
		return FALSE
	return TRUE

/obj/machinery/sleeper/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(occupant)
		balloon_alert(user, "occupied!")
		return TRUE
	if(state_open)
		balloon_alert(user, "close it first!")
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
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return CLICK_ACTION_BLOCKING
	if(user.loc == loc)
		return CLICK_ACTION_BLOCKING
	if(!user.can_perform_action(src, NEED_DEXTERITY|ALLOW_SILICON_REACH|FORBID_TELEKINESIS_REACH))
		return CLICK_ACTION_BLOCKING
	if(state_open)
		var/mob/living/carbon/scooped = locate() in loc
		if(scooped)
			try_close_machine(scooped, user)
		else
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
				"volume" = reagents?.get_reagent_amount(chem) || 0,
			),
		)

	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		data["occupant"] = list()
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
			if(inject_chem(chem, usr, params["amount"]))
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

/obj/machinery/sleeper/stasis
	name = "stasis pod"
	desc = "An enclosed machine used stabilize patients and keep them in a state of stasis."
	deconstructable = TRUE
	min_health = -INFINITY
	circuit = /obj/item/circuitboard/machine/sleeper/stasis
	possible_chems = list(
		list(),
		list(),
		list(),
		list(),
	)
	/// Cooldown to prevent sound spam / instantly jumping out of a pod
	COOLDOWN_DECLARE(open_close_cd)

	/// If TRUE we can inject chems into the patient
	var/has_chem_support = TRUE
	/// If TRUE we process medicine reagents despite stasis
	var/has_processing = TRUE

/obj/machinery/sleeper/stasis/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_StasisPod", name)
		ui.open()

/obj/machinery/sleeper/stasis/Initialize(mapload)
	. = ..()
	if(!has_chem_support)
		return

	create_reagents(50, OPENCONTAINER)
	RegisterSignals(reagents, list(
		COMSIG_REAGENTS_ADD_REAGENT,
		COMSIG_REAGENTS_NEW_REAGENT,
		COMSIG_REAGENTS_DEL_REAGENT,
		COMSIG_REAGENTS_CLEAR_REAGENTS,
	), PROC_REF(update_chems))

	if(mapload)
		reagents.add_reagent(/datum/reagent/medicine/epinephrine, 40)
		reagents.add_reagent(/datum/reagent/medicine/coagulant, 10)

/obj/machinery/sleeper/stasis/proc/update_chems(...)
	SIGNAL_HANDLER

	if(!has_chem_support)
		return

	possible_chems[1].Cut()
	for(var/datum/reagent/med as anything in reagents.reagent_list)
		if(istype(med, /datum/reagent/medicine) || (obj_flags & EMAGGED))
			possible_chems[1] |= med.type
	RefreshParts()

/obj/machinery/sleeper/stasis/chem_allowed(chem)
	if(!has_chem_support)
		return FALSE

	return occupant?.reagents?.get_reagent_amount(chem) <= 5 && reagents.get_reagent_amount(chem) > 0

/obj/machinery/sleeper/stasis/inject_chem(chem, mob/user, amount = 10)
	if(!(chem in available_chems) || !chem_allowed(chem))
		return FALSE
	amount = clamp(amount, 0, 10)
	if(amount <= 0)
		return FALSE
	if(amount > reagents.get_reagent_amount(chem))
		return FALSE

	return reagents.trans_to(
		target = occupant,
		amount = amount,
		target_id = chem_buttons[chem],
		transferred_by = user,
		methods = TOUCH,
	)

/obj/machinery/sleeper/stasis/set_occupant(atom/movable/new_occupant)
	var/mob/living/old_occupant_living = occupant
	var/mob/living/new_occupant_living = new_occupant
	. = ..()
	if(isliving(new_occupant_living))
		new_occupant_living.enter_stasis(STASIS_MACHINE_EFFECT)
		new_occupant_living.add_traits(list(
			TRAIT_BLOCK_HEADSET_USE,
			TRAIT_SOFTSPOKEN,
			TRAIT_RADSTORM_IMMUNE,
		), REF(src))
		RegisterSignal(new_occupant_living, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE, PROC_REF(stasis_move_eject))

	if(isliving(old_occupant_living))
		old_occupant_living.exit_stasis(STASIS_MACHINE_EFFECT)
		old_occupant_living.remove_traits(list(
			TRAIT_BLOCK_HEADSET_USE,
			TRAIT_SOFTSPOKEN,
			TRAIT_RADSTORM_IMMUNE,
		), REF(src))
		UnregisterSignal(old_occupant_living, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE)

/obj/machinery/sleeper/stasis/proc/stasis_move_eject(mob/source, ...)
	SIGNAL_HANDLER
	if(!source.can_resist() || DOING_INTERACTION_WITH_TARGET(source, src))
		return NONE
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, relaymove), source, direct)
	return COMSIG_MOB_CLIENT_BLOCK_PRE_LIVING_MOVE

/obj/machinery/sleeper/stasis/open_machine(drop, density_to_set)
	if(!COOLDOWN_FINISHED(src, open_close_cd))
		return

	. = ..()
	playsound(src, 'sound/effects/spray.ogg', 25, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE, frequency = 0.4)
	COOLDOWN_START(src, open_close_cd, 1 SECONDS)
	if(!(dir & NORTH))
		particles = new /particles/cryo_fog(dir)

/obj/machinery/sleeper/stasis/close_machine(user, density_to_set)
	if(!COOLDOWN_FINISHED(src, open_close_cd))
		return

	. = ..()
	playsound(src, 'sound/effects/spray.ogg', 25, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE, frequency = 0.5)
	playsound(src, 'sound/machines/fan_stop.ogg', 50, TRUE)
	COOLDOWN_START(src, open_close_cd, 1 SECONDS)
	QDEL_NULL(particles)

/obj/machinery/sleeper/stasis/process(seconds_per_tick)
	. = ..()
	if(!has_processing)
		return

	var/mob/living/patient = occupant
	if(istype(patient) && !isnull(patient.reagents))
		var/update = FALSE
		for(var/datum/reagent/medicine/medicine in patient.reagents.reagent_list)
			update ||= patient.reagents.metabolize_reagent(patient, medicine, seconds_per_tick, SSmobs.times_fired, can_overdose = TRUE)
		if(update)
			patient.updatehealth()

	if(istype(particles, /particles/cryo_fog))
		if(particles.count == round(initial(particles.count) * 0.5, 6))
			particles.spawning = 1

		if(particles.count <= 0)
			QDEL_NULL(particles)
		else
			particles.count -= 6

/particles/cryo_fog
	icon = 'maplestation_modules/icons/effects/particles.dmi'
	icon_state = list("chill_1" = 2, "chill_2" = 2, "chill_3" = 1)
	count = 48
	spawning = 3
	lifespan = 1.5 SECONDS
	fade = 0.5 SECONDS
	gravity = list(0, -0.1, 0)
	spin = 0.25
	grow = 0.05
	color = "#cafaff77"

/particles/cryo_fog/New(dir)
	switch(dir)
		if(SOUTH)
			position = generator(GEN_VECTOR, list(-8, -10, 0), list(6, -10, 0), NORMAL_RAND)
		if(EAST)
			position = generator(GEN_VECTOR, list(-10, -10, 0), list(16, -10, 0), NORMAL_RAND)
		if(WEST)
			position = generator(GEN_VECTOR, list(-16, -10, 0), list(10, -10, 0), NORMAL_RAND)

GLOBAL_LIST_INIT(cryo_sleepers, list())

#define IS_SPAWNING "spawning"

/obj/machinery/sleeper/stasis/cryo
	name = "long-term crew storage pod"
	desc = "An enclosed machine designed to put subjects in a state of suspended animation for long-term storage."
	icon = 'maplestation_modules/icons/obj/machines/sleeper.dmi'
	icon_state = "cryopod"
	base_icon_state = "cryopod"
	deconstructable = FALSE
	// circuit = /obj/item/circuitboard/machine/sleeper/cryo
	enter_message = span_boldnotice("You feel a cold chill as you enter the pod. \
		You feel your body go numb as you enter a state of suspended animation.")
	possible_chems = null
	state_open = FALSE
	density = TRUE
	resist_time = 0.5 SECONDS
	has_chem_support = FALSE
	has_processing = FALSE

	var/throw_alert = TRUE

/obj/machinery/sleeper/stasis/cryo/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)
	GLOB.cryo_sleepers += src
	open_machine()

/obj/machinery/sleeper/stasis/cryo/ui_interact(mob/user, datum/tgui/ui)
	return

/obj/machinery/sleeper/stasis/cryo/Destroy()
	GLOB.cryo_sleepers -= src
	return ..()

/obj/machinery/sleeper/stasis/cryo/examine(mob/user)
	. = ..()
	if(isliving(occupant) && user != occupant)
		var/mob/living/occupant_l = occupant
		var/obj/item/card/id/their_id = occupant_l.get_idcard()
		. += span_notice("Inside, you can see [occupant][their_id ? ", the [their_id.assignment]" : ""][(HAS_TRAIT(occupant, TRAIT_KNOCKEDOUT) || (occupant_l.key && !occupant_l.client)) ? " - sound asleep" : ""].")
	else if(isliving(user))
		. += span_info(span_slightly_smaller("You can enter the pod to be put into stasis temporarily, or to despawn your character."))
		. += span_info(span_slightly_smaller("This machine is not intended to be used medicinally. Avoid placing wounded patients inside, even in emergencies."))

/obj/machinery/sleeper/stasis/cryo/set_occupant(atom/movable/new_occupant)
	if(!throw_alert)
		return ..()

	var/mob/living/old_occupant = occupant
	. = ..()
	var/mob/living/new_occupant_l = new_occupant
	var/skey = REF(src)
	if(istype(old_occupant))
		old_occupant.clear_alert(skey)
	if(istype(new_occupant_l))
		new_occupant_l.throw_alert(skey, /atom/movable/screen/alert/cryosleep)
		// if they have a mind, we can consider despawning them, however:
		// ...if the mind is active, they are being forced to be "here", so we should be on the safe side and leave them
		// ...if they have a key, but no client, they're just disconnected. leave them in the pod for if they return
		// ...if they have a client, they're actively in the game, definitely don't despawn them
		// ...if they have an ai controller, then it's probably just an NPC, so it doesn't need to be despawned
		if(new_occupant_l.mind && !new_occupant_l.mind.active && !new_occupant_l.key && !new_occupant_l.client && !new_occupant_l.ai_controller)
			addtimer(CALLBACK(src, PROC_REF(auto_despawn), new_occupant_l), 5 MINUTES)

/obj/machinery/sleeper/stasis/cryo/proc/auto_despawn(mob/living/mob_occupant)
	if(QDELETED(mob_occupant) || occupant != mob_occupant)
		return
	despawn_occupant()

/obj/machinery/sleeper/stasis/cryo/JoinPlayerHere(mob/living/joining_mob, buckle)
	if(occupant || !ishuman(joining_mob))
		return ..()
	throw_alert = FALSE
	if(state_open)
		close_machine()
	set_occupant(joining_mob)
	joining_mob.forceMove(src)
	ADD_TRAIT(joining_mob, TRAIT_NO_EYELIDS, IS_SPAWNING) // this is solely here to prevent the record picture from having closed eyes
	ADD_TRAIT(joining_mob, TRAIT_KNOCKEDOUT, IS_SPAWNING)
	addtimer(CALLBACK(src, PROC_REF(finish_joining_player), joining_mob), rand(8, 12) SECONDS)
	throw_alert = TRUE

/obj/machinery/sleeper/stasis/cryo/proc/finish_joining_player(mob/living/joining_mob)
	REMOVE_TRAITS_IN(joining_mob, IS_SPAWNING)

/obj/machinery/sleeper/stasis/cryo/default_deconstruction_crowbar(obj/item/crowbar, ignore_panel = 0, custom_deconstruct = FALSE)
	return FALSE

/obj/machinery/sleeper/stasis/cryo/default_deconstruction_screwdriver(mob/living/user, icon_state, base_icon_state, obj/item/screwdriver)
	return FALSE

/obj/machinery/sleeper/stasis/cryo/default_change_direction_wrench(mob/living/user, obj/item/wrench)
	return FALSE

/obj/machinery/sleeper/stasis/cryo/open_machine(drop = TRUE, density_to_set = FALSE)
	density_to_set = TRUE
	return ..()

/// Checks if this can generically be used as a latejoin spawnpoint
/obj/machinery/sleeper/stasis/cryo/proc/can_latejoin(datum/job/joining)
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
/obj/machinery/sleeper/stasis/cryo/proc/saveable_item(obj/item/save_me)
	if(save_me.resistance_flags & INDESTRUCTIBLE)
		return TRUE
	if(GLOB.steal_item_handler.objectives_by_path[save_me.type])
		return TRUE
	return FALSE

/obj/machinery/sleeper/stasis/cryo/proc/despawn_occupant()
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

	var/datum/record/crew/associated_record = find_record(mob_occupant.real_name)
	var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
	if(!QDELETED(associated_record) && !QDELETED(announcer))
		announcer.announce("DESPAWN", mob_occupant.name, associated_record.rank, list())
		associated_record.physical_status = PHYSICAL_UNCONSCIOUS
		associated_record.medical_notes += new /datum/medical_note("Record Database", "In long-term crew storage.")

	deadchat_broadcast(
		" has entered long-term crew storage storage.",
		"[span_name(mob_occupant.real_name)] ([associated_record?.rank || "Unknown"])",
		turf_target = get_turf(src),
		message_type = DEADCHAT_ARRIVALRATTLE,
	)

#undef IS_SPAWNING

/atom/movable/screen/alert/cryosleep
	name = "Enter Crew Storage"
	desc = "You are free to idle in stasis for as long as you need, but you may also click this button to despawn your character."
	mouse_over_pointer = MOUSE_HAND_POINTER
	icon_state = "cold"

/atom/movable/screen/alert/cryosleep/Click(location, control, params)
	. = ..()
	if(!.)
		return .
	var/obj/machinery/sleeper/stasis/cryo/sleeper = owner.loc
	if(!istype(sleeper))
		stack_trace("[type] was clicked by [usr] without being in a sleeper.")
		return FALSE

	var/are_you_sure = tgui_alert(usr, "Are you sure you want to despawn your character?", "Despawn Character", list("Yes", "No"), 5 SECONDS)
	if(are_you_sure != "Yes" || QDELETED(src) || QDELETED(sleeper) || sleeper.occupant != usr)
		return FALSE

	sleeper.despawn_occupant()
	return TRUE

/area/station/commons/long_term_storage
	name = "Long-Term Crew Storage"
