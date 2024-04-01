/obj/machinery/sleeper
	name = "sleeper"
	desc = "An enclosed machine used to stabilize and heal patients."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	base_icon_state = "sleeper"
	density = TRUE
	obj_flags = BLOCKS_CONSTRUCTION
	state_open = TRUE
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

/obj/machinery/sleeper/RefreshParts()
	. = ..()
	var/matterbin_rating = 0
	for(var/datum/stock_part/matter_bin/matterbins in component_parts)
		matterbin_rating += matterbins.tier
	efficiency = initial(efficiency) * max(matterbin_rating, 1)
	min_health = initial(min_health) * max(matterbin_rating, 1)

	available_chems.Cut()
	for(var/datum/stock_part/servo/servos in component_parts)
		for(var/i in 1 to servos.tier)
			available_chems |= possible_chems[i]

	reset_chem_buttons()

/obj/machinery/sleeper/update_icon_state()
	icon_state = "[base_icon_state][state_open ? "-open" : null]"
	return ..()

/obj/machinery/sleeper/container_resist_act(mob/living/user)
	visible_message(span_notice("[occupant] emerges from [src]!"),
		span_notice("You climb out of [src]!"))
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


/obj/machinery/sleeper/MouseDrop_T(atom/movable/dropping, mob/user)
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
	. = !(state_open || panel_open || (obj_flags & NO_DECONSTRUCTION)) && I.tool_behaviour == TOOL_CROWBAR
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

/obj/machinery/sleeper/AltClick(mob/user)
	. = ..()
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	if(user.loc == loc)
		return
	if(!user.can_perform_action(src, NEED_DEXTERITY|ALLOW_SILICON_REACH|FORBID_TELEKINESIS_REACH))
		return

	if(state_open)
		var/mob/living/carbon/scooped = locate() in loc
		if(scooped)
			try_close_machine(scooped, user)
		else
			close_machine()
	else
		open_machine()

/obj/machinery/sleeper/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click [src] to [state_open ? "close" : "open"] it.")

/obj/machinery/sleeper/process()
	use_power(idle_power_usage)

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
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
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

/obj/machinery/sleeper/stasis/set_occupant(atom/movable/new_occupant)
	var/mob/living/old_occupant_living = occupant
	var/mob/living/new_occupant_living = new_occupant
	. = ..()
	if(isliving(new_occupant_living))
		new_occupant_living.enter_stasis(STASIS_MACHINE_EFFECT)
		RegisterSignal(new_occupant_living, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE, PROC_REF(stasis_move_eject))
	if(isliving(old_occupant_living))
		old_occupant_living.exit_stasis(STASIS_MACHINE_EFFECT)
		UnregisterSignal(old_occupant_living, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE)

/obj/machinery/sleeper/stasis/proc/stasis_move_eject(mob/source, ...)
	SIGNAL_HANDLER
	if(!source.can_resist())
		return NONE

	// Need to register a signal as stasis immobilizes you
	container_resist_act(source)
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
	COOLDOWN_START(src, open_close_cd, 1 SECONDS)
	QDEL_NULL(particles)

/obj/machinery/sleeper/stasis/process(seconds_per_tick)
	. = ..()
	var/mob/living/patient = occupant
	if(istype(patient) && !isnull(patient.reagents))
		if(HAS_TRAIT(patient, TRAIT_CRITICAL_CONDITION))
			var/epi_amount = patient.reagents.get_reagent_amount(/datum/reagent/medicine/epinephrine)
			if(epi_amount < 10)
				patient.reagents.add_reagent(/datum/reagent/medicine/epinephrine, 10 - epi_amount)

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
