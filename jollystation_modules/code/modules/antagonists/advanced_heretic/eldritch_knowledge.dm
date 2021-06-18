/// -- Extra extended/modular knowledge for advanced heretics --
/// "No ascending allowed" knowledge added by advanced heretics.
/datum/eldritch_knowledge/no_ascension
	name = "The Faithless Oath"
	desc = "Gives up your ability to ascend in favor of going about other objectives."
	gain_text = "I took an oath to my gods not to ascend beyond, as the powers were better utilized elsewhere."
	banned_knowledge = list(/datum/eldritch_knowledge/final/ash_final, /datum/eldritch_knowledge/final/rust_final, /datum/eldritch_knowledge/final/void_final, /datum/eldritch_knowledge/final/flesh_final)

/// "No sacrificing allowed" knowledge added by advanced heretics.
/datum/eldritch_knowledge/no_sacrifices
	name = "The Bloodless Oath"
	desc = "Gives up your ability to sacrifice in favor of going about other means."
	gain_text = "I took an oath to my gods not to sacrifice powerless mortals, as my time was better utilized elsewhere."

/// This string of procs below is what replaces sacrificing to be something more interesting than a gib.
/// Basically: You get sent to the shadow realm and are forced to dodge shadow-hands to not die.
/datum/eldritch_knowledge/spell/basic/proc/sacrifice_process(mob/living/carbon/human/sac_target, mob/living/heretic)
	var/turf/sac_loc = get_turf(sac_target)
	var/sleeping_time = 12 SECONDS

	sac_target.visible_message(span_danger("[sac_target] begins to shudder violenty as dark tendrils begin to drag them into thin air!"))
	sac_target.set_handcuffed(new /obj/item/restraints/handcuffs/energy/cult(sac_target))
	sac_target.update_handcuffed()

	if(sac_target.stat == DEAD)
		message_admins("[sac_target] was gibbed by a heretic at [ADMIN_VERBOSEJMP(sac_loc)].")
		log_attack("[sac_target] was gibbed by a heretic at [loc_name(sac_loc)].")
		sac_target.gib() // Ol' reliable
	else
		to_chat(sac_target, span_hypnophrase("Your mind feels torn apart as you fall into a shallow slumber..."))
		message_admins("[sac_target] was non-lethally sacrificed by a heretic at [ADMIN_VERBOSEJMP(sac_loc)].")
		log_attack("[sac_target] was non-lethally sacrificed by a heretic at [loc_name(sac_loc)].")
		sac_target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 115, 150)
		sac_target.SetSleeping(sleeping_time)
		sac_target.SetParalyzed(sleeping_time * 1.2)

		RegisterSignal(sac_target, COMSIG_LIVING_DEATH, .proc/return_target) // Loss condition
		addtimer(CALLBACK(src, .proc/after_target_sleep, sac_target), sleeping_time / 2) // Teleport to the minigame
		addtimer(CALLBACK(src, .proc/after_target_awaken, sac_target), sleeping_time) // Begin the minigame
		addtimer(CALLBACK(src, .proc/return_target, sac_target, FALSE, heretic), 3 MINUTES) // Win condition

/// This proc is called after the target falls asleep.
/// Teleport them to the facility
/datum/eldritch_knowledge/spell/basic/proc/after_target_sleep(mob/living/carbon/human/sac_target)
	var/turf/sac_loc = get_turf(sac_target)
	var/obj/effect/landmark/error/error_landmark = locate(/obj/effect/landmark/error) in GLOB.landmarks_list
	var/turf/picked_turf = error_landmark || locate(4,4,1)
	if(sac_target.stat == DEAD || !picked_turf || !do_teleport(sac_target, picked_turf, forceMove = TRUE, asoundin = 'sound/magic/repulse.ogg', asoundout = 'sound/magic/blind.ogg', no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
		message_admins("[sac_target] was gibbed by a heretic at [ADMIN_VERBOSEJMP(sac_loc)]: [picked_turf? "Teleport failed - [(sac_target.stat == DEAD)? "Target was dead":"do_teleport action failed somehow, likely a bug"]":"No target turf was found"].")
		log_attack("[sac_target] was gibbed by a heretic at [loc_name(sac_loc)].")
		stack_trace("[sac_target] was gibbed by a heretic at [loc_name(sac_loc)]: [picked_turf? "Teleport failed - [(sac_target.stat == DEAD)? "Target was dead":"do_teleport failed"]":"No target turf was found"].")
		sac_target.gib() //ol' reliable
		return

	message_admins("[sac_target] was non-lethally sacrificed by a heretic at [ADMIN_VERBOSEJMP(sac_loc)]. Teleporting to [ADMIN_VERBOSEJMP(picked_turf)].")
	log_attack("[sac_target] was non-lethally sacrificed by a heretic at [loc_name(sac_loc)].")
	to_chat(sac_target, "<span class='big hypnophrase'>Unnatural forces began to claw at your every being from beyond the veil.</span>")
	sac_target.adjustBruteLoss(-100, FALSE)
	sac_target.adjustFireLoss(-100, FALSE)
	sac_target.adjustToxLoss(-50, FALSE, TRUE)
	sac_target.updatehealth()

/// This proc is called after the target wakes up from the initial sleep.
/datum/eldritch_knowledge/spell/basic/proc/after_target_awaken(mob/living/carbon/human/sac_target)
	if(sac_target.stat == DEAD)
		return_target(sac_target)
		return

	var/helgrasp_time = 1 MINUTES
	var/list/chems_to_add = list(/datum/reagent/inverse/helgrasp = (helgrasp_time / (20)))// 1 metab a tick = helgrasp_time / 2 ticks (so, 1 minute = 60 seconds = 30 ticks)
	to_chat(sac_target, span_reallybig(span_hypnophrase("The grasp of the Mansus reveal themselves to you!")))
	sac_target.flash_act()
	sac_target.add_confusion(20)
	sac_target.blur_eyes(15)
	sac_target.Jitter(10)
	sac_target.Dizzy(10)
	sac_target.emote("scream")

	addtimer(CALLBACK(src, .proc/after_helgrasp_ends, sac_target), helgrasp_time)

	to_chat(sac_target, span_hypnophrase("You feel invigorated! Fight to survive!"))
	chems_to_add[/datum/reagent/unholy_determination] = 12

	for(var/reagents_to_add in chems_to_add)
		sac_target.reagents?.add_reagent(reagents_to_add, chems_to_add[reagents_to_add])

	sac_target.apply_necropolis_curse(CURSE_WASTING | CURSE_BLINDING | CURSE_GRASPING)
	SEND_SIGNAL(sac_target, COMSIG_ADD_MOOD_EVENT, "shadow_realm", /datum/mood_event/shadow_realm)

/// This proc is called after helgrasp exits the target's system.
/datum/eldritch_knowledge/spell/basic/proc/after_helgrasp_ends(mob/living/carbon/human/sac_target)
	to_chat(sac_target, span_hypnophrase("The worst is behind you... Not much longer! Hold fast, or expire!"))
	sac_target.reagents?.add_reagent(/datum/reagent/unholy_determination, 6)

/// This proc is called after a set time OR after they die, to return the target to the station.
/datum/eldritch_knowledge/spell/basic/proc/return_target(mob/living/carbon/human/sac_target, gibbed, mob/living/heretic)
	SIGNAL_HANDLER

	UnregisterSignal(sac_target, COMSIG_LIVING_DEATH)
	sac_target.remove_status_effect(STATUS_EFFECT_NECROPOLIS_CURSE)

	if(gibbed || !is_centcom_level(sac_target.z))
		message_admins("Heretic sacrifice_process chain was interruped somehow before the sac target ([sac_target]) could be returned properly. This is bad if an admin wasn't the one interrupting it!")
		CRASH("Heretic sacrifice_process chain ended was interruped somehow before sac target ([sac_target]) to the station.")

	var/turf/sac_loc = get_turf(sac_target)
	/// Teleport them to a random z level
	var/turf/open/floor/safe_turf = find_safe_turf(zlevels = SSmapping.levels_by_trait(ZTRAIT_STATION)[1], extended_safety_checks = TRUE)
	if(!do_teleport(sac_target, safe_turf, forceMove = TRUE, asoundout = 'sound/magic/blind.ogg', no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
		message_admins("[sac_target] was gibbed by a heretic at [ADMIN_VERBOSEJMP(sac_loc)]: [safe_turf? "Teleport failed":"No target turf was found"].")
		log_attack("[sac_target] was gibbed by a heretic at [loc_name(sac_loc)].")
		stack_trace("[sac_target] was gibbed by a heretic at [loc_name(sac_loc)]: [safe_turf? "Teleport failed":"No target turf was found"].")
		sac_target.gib()
		return

	SEND_SIGNAL(sac_target, COMSIG_ADD_MOOD_EVENT, "shadow_realm_survived_sadness", /datum/mood_event/shadow_realm_live_sad)

	if(!sac_target || !safe_turf)
		message_admins("Heretic sacrifice_process chain ended up failing to return their sac target ([sac_target]) to the station. This is probably very bad and means someone was removed from the round!")
		CRASH("Heretic sacrifice_process chain ended up failing to return their sac target ([sac_target]) to the station.")

	var/composed_return_message = ""
	composed_return_message += span_notice("Your victim, [sac_target], was returned to the station - ")
	if(sac_target.stat == DEAD)
		composed_return_message += span_red("dead. ")
	else
		composed_return_message += span_green("alive, but with a shattered mind. ")
	composed_return_message += span_notice("You hear a whisper... ")
	composed_return_message += span_hypnophrase(get_area_name(safe_turf, TRUE))

	to_chat(heretic, composed_return_message)
	if(sac_target.stat == DEAD)
		after_return_dead_target(sac_target, safe_turf)
	else
		after_return_live_target(sac_target, safe_turf)

/// This proc is called from [return_target] if the target returns alive.
/datum/eldritch_knowledge/spell/basic/proc/after_return_live_target(mob/living/carbon/human/sac_target, turf/landing_turf)
	to_chat(sac_target, span_hypnophrase("The fight is over - at great cost. You have been returned to your realm in one piece."))
	to_chat(sac_target, span_hypnophrase("You can hardly remember anything from before and leading up to the experience - all you can think about are those horrific hands..."))

	sac_target.flash_act()
	sac_target.add_confusion(60)
	sac_target.Jitter(60)
	sac_target.blur_eyes(50)
	sac_target.Dizzy(30)
	sac_target.AdjustKnockdown(80)
	sac_target.adjustStaminaLoss(120)
	if(sac_target.has_quirk(/datum/quirk/item_quirk/allergic))
		sac_target.reagents?.add_reagent(/datum/reagent/medicine/synaphydramine, 8)
	else
		sac_target.reagents?.add_reagent(/datum/reagent/medicine/atropine, 8)
	sac_target.reagents?.add_reagent(/datum/reagent/medicine/epinephrine, 8)
	SEND_SIGNAL(sac_target, COMSIG_ADD_MOOD_EVENT, "shadow_realm_survived", /datum/mood_event/shadow_realm_live)

/// This proc is called from [return_target] if the target returns dead.
/datum/eldritch_knowledge/spell/basic/proc/after_return_dead_target(mob/living/carbon/human/sac_target, turf/landing_turf)
	addtimer(CALLBACK(src, .proc/announce_dead_target, landing_turf), rand(1 MINUTES, 2 MINUTES))
	sac_target?.reagents?.del_reagent(/datum/reagent/unholy_determination)
	var/obj/effect/broken_illusion/illusion = new /obj/effect/broken_illusion(landing_turf)
	illusion.name = "Weakened rift in reality"
	illusion.desc = "A rift wide enough for something... or someone to come through."
	illusion.color = COLOR_DARK_RED

/datum/eldritch_knowledge/spell/basic/proc/announce_dead_target(turf/landing_turf)
	priority_announce("Attention, crew. We recorded an anomalous dimensional occurance in: [get_area_name(landing_turf, TRUE)]. We're unsure of what it could be, but something just appeared in the area. We suggest checking it out.", "Central Command Higher Dimensional Affairs")

/datum/mood_event/shadow_realm
	description = "<span class='hypnophrase'>Where am I?!</span>\n"
	mood_change = -15
	timeout = 3 MINUTES

/datum/mood_event/shadow_realm_live
	description = "<span class='greentext'>I'm alive... I'm alive!!</span>\n"
	mood_change = 4
	timeout = 5 MINUTES

/datum/mood_event/shadow_realm_live_sad
	description = "<span class='boldwarning'>The hands! The horrible, horrific hands! I see them when I close my eyes!</span>\n"
	mood_change = -6
	timeout = 10 MINUTES

/datum/reagent/unholy_determination
	name = "Unholy Determination"
	description = "Heals all damage types. Heals burns extra. Stabilizes temperature. Works faster in critical. Stops bleeding."
	reagent_state = LIQUID
	color = "#dcdcdc77"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 7

/datum/reagent/unholy_determination/on_mob_metabolize(mob/living/user)
	ADD_TRAIT(user, TRAIT_COAGULATING, type)
	ADD_TRAIT(user, TRAIT_NOCRITDAMAGE, type)
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, type)
	return ..()

/datum/reagent/unholy_determination/on_mob_end_metabolize(mob/living/user)
	REMOVE_TRAIT(user, TRAIT_COAGULATING, type)
	REMOVE_TRAIT(user, TRAIT_NOCRITDAMAGE, type)
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, type)
	return ..()

/datum/reagent/unholy_determination/on_mob_life(mob/living/carbon/user, delta_time, times_fired)
	var/healing_amount = 2
	/// In softcrit you're strong enough to stay up
	if(user.health <= user.crit_threshold && user.health >= user.hardcrit_threshold)
		if(DT_PROB(15, delta_time))
			to_chat(user, span_hypnophrase("Your body feels like giving up, but you fight on!"))
		healing_amount *= 2
	/// ...But in hardcrit you're in big danger
	if (user.health < user.hardcrit_threshold)
		if(DT_PROB(15, delta_time))
			to_chat(user, span_big(span_hypnophrase("You can't hold on for much longer...")))

	if(user.health > user.crit_threshold && DT_PROB(10, delta_time))
		user.Jitter(10)
		user.Dizzy(5)
		user.add_confusion(5)

	user.adjust_fire_stacks(-3 * REM * delta_time)
	user.losebreath -= (3 * REM * delta_time)
	user.adjustToxLoss(-healing_amount * REM * delta_time, FALSE, TRUE)
	user.adjustOxyLoss(-healing_amount * REM * delta_time, FALSE)
	user.adjustBruteLoss(-healing_amount * 1.5 * REM * delta_time, FALSE)
	user.adjustFireLoss(-healing_amount * 2 * REM * delta_time, FALSE)
	adjust_temperature(user, delta_time)
	adjust_bleed_wounds(user, delta_time)
	user.updatehealth()
	. = ..()

/datum/reagent/unholy_determination/proc/adjust_temperature(mob/living/carbon/user, delta_time)
	var/target_temp = user.get_body_temp_normal(apply_change=FALSE)
	if(user.bodytemperature > target_temp)
		user.adjust_bodytemperature(-50 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
	else if(user.bodytemperature < (target_temp + 1))
		user.adjust_bodytemperature(50 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.coretemperature > target_temp)
			human_user.adjust_coretemperature(-50 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
		else if(human_user.coretemperature < (target_temp + 1))
			human_user.adjust_coretemperature(50 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)

/datum/reagent/unholy_determination/proc/adjust_bleed_wounds(mob/living/carbon/user, delta_time)
	if(!user.blood_volume || !user.all_wounds)
		return

	var/datum/wound/bloodiest_wound

	for(var/datum/wound/iter_wound as anything in user.all_wounds)
		if(iter_wound.blood_flow)
			if(iter_wound.blood_flow > bloodiest_wound?.blood_flow)
				bloodiest_wound = iter_wound

	if(bloodiest_wound)
		bloodiest_wound.blood_flow = max(0, bloodiest_wound.blood_flow - (0.5 * REM * delta_time))
