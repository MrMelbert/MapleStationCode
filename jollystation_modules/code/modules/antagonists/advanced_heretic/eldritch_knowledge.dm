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

/datum/map_template/heretic_sacrifice_level
	name = "Heretic Sacrifice Level"
	mappath = "_maps/templates/_heretic_template.dmm"

/datum/eldritch_knowledge/spell/basic
	/// The heretic who owns this knowledge.
	var/mob/living/master_heretic
	/// Lazylist of all the people this heretic has selected as a heart target.
	var/list/target_blacklist
	/// What heretic type our master heretic is (path_void, path_flesh, path_ash, path_rust, or null)
	var/heretic_type = null

/datum/eldritch_knowledge/spell/basic/on_gain(mob/user)
	. = ..()
	master_heretic = user
	if(!GLOB.heretic_sacrifice_landmarks.len)
		INVOKE_ASYNC(src, .proc/generate_heretic_z_level)

/datum/eldritch_knowledge/spell/basic/on_lose(mob/user)
	master_heretic = null
	LAZYNULL(target_blacklist)
	return ..()

/*
 * Generate the heretic z-level for sacrificed people.
 */
/datum/eldritch_knowledge/spell/basic/proc/generate_heretic_z_level()
	var/datum/map_template/heretic_sacrifice_level/new_level = new()
	if(!new_level.load_new_z())
		CRASH("Failed to initialize heretic sacrifice z-level!")

/*
 * This proc is called from [proc/on_finished_recipe] after the [heretic] successfully sacrifices [sac_target]
 *
 * This proc sets off a chain that sends the person sacrificed to the shadow realm to dodge hands
 * instead of straight up getting gibbed.
 */
/datum/eldritch_knowledge/spell/basic/proc/sacrifice_process(mob/living/carbon/human/sac_target)
	if(!sac_target)
		CRASH("sacrifice_process() called with null sac_target!")

	var/datum/antagonist/heretic/our_heretic = master_heretic?.mind?.has_antag_datum(/datum/antagonist/heretic)
	if(!our_heretic)
		CRASH("sacrifice_process() called [master_heretic? "without a heretic linked":"without a heretic antag datum found"]!")

	if(!heretic_type)
		if(locate(/datum/eldritch_knowledge/base_void) in our_heretic.researched_knowledge)
			heretic_type = PATH_VOID
		else if(locate(/datum/eldritch_knowledge/base_rust) in our_heretic.researched_knowledge)
			heretic_type = PATH_RUST
		else if(locate(/datum/eldritch_knowledge/base_ash) in our_heretic.researched_knowledge)
			heretic_type = PATH_ASH
		else if(locate(/datum/eldritch_knowledge/base_flesh) in our_heretic.researched_knowledge)
			heretic_type = PATH_FLESH

	var/turf/sac_loc = get_turf(sac_target)
	var/sleeping_time = 12 SECONDS

	sac_target.visible_message(span_danger("[sac_target] begins to shudder violenty as dark tendrils begin to drag them into thin air!"))
	sac_target.set_handcuffed(new /obj/item/restraints/handcuffs/energy/cult(sac_target))
	sac_target.update_handcuffed()
	sac_target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 85, 150)

	if(!heal_and_revive_target(sac_target, 50)) // If our target is dead, and we fail to revive them, just disembowel them and be done
		disembowel_target(sac_target)
		return

	if(sac_target.AdjustUnconscious(sleeping_time))
		to_chat(sac_target, span_hypnophrase("Your mind feels torn apart as you fall into a shallow slumber..."))
	else
		to_chat(sac_target, span_hypnophrase("Your mind begins to tear apart as you watch dark tendrils envelop you."))
	sac_target.AdjustParalyzed(sleeping_time * 1.2)
	sac_target.AdjustImmobilized(sleeping_time * 1.2)

	message_admins("[sac_target] was non-lethally sacrificed by a heretic at [ADMIN_VERBOSEJMP(sac_loc)].")
	log_attack("[sac_target] was non-lethally sacrificed by a heretic at [loc_name(sac_loc)].")

	addtimer(CALLBACK(src, .proc/after_target_sleep, sac_target), sleeping_time / 2) // Teleport to the minigame
	addtimer(CALLBACK(src, .proc/after_target_awaken, sac_target), sleeping_time) // Begin the minigame
	addtimer(CALLBACK(src, .proc/return_target, sac_target, FALSE), 3 MINUTES) // Win condition

/*
 * This proc is called from [proc/sacrifice_process] after the [sac_target] falls asleep, shortly after the sacrifice occurs.
 *
 * The [sac_target] is teleported to the heretic room asleep. If it fails to teleport, it instead disembowels them and stops the chain.
 * If they are sacrificed while dead, it revives them, too.
 */
/datum/eldritch_knowledge/spell/basic/proc/after_target_sleep(mob/living/carbon/human/sac_target)
	var/turf/sac_loc = get_turf(sac_target)
	var/obj/effect/landmark/heretic/destination
	switch(heretic_type)
		if(PATH_VOID)
			destination = locate(/obj/effect/landmark/heretic/void) in GLOB.heretic_sacrifice_landmarks
		if(PATH_FLESH)
			destination = locate(/obj/effect/landmark/heretic/flesh) in GLOB.heretic_sacrifice_landmarks
		if(PATH_RUST)
			destination = locate(/obj/effect/landmark/heretic/rust) in GLOB.heretic_sacrifice_landmarks
		else
			destination = locate(/obj/effect/landmark/heretic/ash) in GLOB.heretic_sacrifice_landmarks

	var/turf/picked_turf = get_turf(destination)
	if(!destination || !picked_turf || !do_teleport(sac_target, picked_turf, asoundin = 'sound/magic/repulse.ogg', asoundout = 'sound/magic/blind.ogg', no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
		message_admins("[sac_target] teleported failed at [ADMIN_VERBOSEJMP(sac_loc)]: Teleport failed - [picked_turf ? "do_teleport action failed somehow, likely a bug":"no target turf was found"].")
		stack_trace("[sac_target] was disemboweled by a heretic at [loc_name(sac_loc)]: [picked_turf? "Teleport failed - [(sac_target.stat == DEAD)? "target was dead":"do_teleport failed"]":"no target turf was found"].")
		disembowel_target()
		return

	if(!heal_and_revive_target(sac_target, 75)) // If our target died during the short timer, and we fail to revive them, just disembowel them and be done
		disembowel_target(sac_target)
		return

	message_admins("[sac_target] was non-lethally sacrificed by a heretic at [ADMIN_VERBOSEJMP(sac_loc)]. Teleporting to [ADMIN_VERBOSEJMP(picked_turf)].")
	log_attack("[sac_target] was non-lethally sacrificed by a heretic at [loc_name(sac_loc)].")
	to_chat(sac_target, span_big(span_hypnophrase("Unnatural forces begin to claw at your every being from beyond the veil.")))

	RegisterSignal(sac_target, COMSIG_MOVABLE_Z_CHANGED, .proc/target_lost)
	RegisterSignal(sac_target, COMSIG_LIVING_DEATH, .proc/return_target) // Loss condition

/*
 * This proc is called from [proc/sacrifice_process] after the [sac_target] wakes up.
 *
 * The [sac_target] gets injected with a chemical to keep them kicking and helgrasp.
 * Then they get given the cursed status effect and the challenge begins.
 */
/datum/eldritch_knowledge/spell/basic/proc/after_target_awaken(mob/living/carbon/human/sac_target)
	var/helgrasp_time = 1 MINUTES

	sac_target.reagents?.add_reagent(/datum/reagent/unholy_determination, 12)
	sac_target.reagents?.add_reagent(/datum/reagent/inverse/helgrasp, helgrasp_time / 20) // 1 metab a tick = helgrasp_time / 2 ticks (so, 1 minute = 60 seconds = 30 ticks)

	addtimer(CALLBACK(src, .proc/after_helgrasp_ends, sac_target), helgrasp_time)
	SEND_SIGNAL(sac_target, COMSIG_ADD_MOOD_EVENT, "shadow_realm", /datum/mood_event/shadow_realm)

	sac_target.apply_necropolis_curse(CURSE_BLINDING | CURSE_GRASPING)
	sac_target.flash_act()
	sac_target.blur_eyes(15)
	sac_target.Jitter(10)
	sac_target.Dizzy(10)
	sac_target.hallucination += 12
	sac_target.emote("scream")

	to_chat(sac_target, span_reallybig(span_hypnophrase("The grasp of the Mansus reveal themselves to you!")))
	to_chat(sac_target, span_hypnophrase("You feel invigorated! Fight to survive!"))

/*
 * This proc is called from [proc/sacrifice_process] after the helgrasp runs out in the [sac_target].
 *
 * It gives them a message letting them know it's getting easier, and gives them a boost to help survive.
 */
/datum/eldritch_knowledge/spell/basic/proc/after_helgrasp_ends(mob/living/carbon/human/sac_target)
	to_chat(sac_target, span_hypnophrase("The worst is behind you... Not much longer! Hold fast, or expire!"))
	sac_target.reagents?.add_reagent(/datum/reagent/unholy_determination, 6)

/*
 * This proc is called from [proc/sacrifice_process] if the target survives the shadow realm, or [COMSIG_LIVING_DEATH] if they don't.
 *
 * It teleports [sac_target] back to a random safe turf on the station (or observer spawn if it fails to find a safe turf)
 * It clears their status effects, unregisters any signals associated with the shadow realm, and sends a message
 * to the [heretic] about whether [sac_target] survived, and where they ended up.
 *
 * [gibbed] is sent from the signal, if the [sac_target] somehow dies via gibbing while in the shadow realm.
 */
/datum/eldritch_knowledge/spell/basic/proc/return_target(mob/living/carbon/human/sac_target, gibbed)
	SIGNAL_HANDLER

	if(gibbed)
		return

	UnregisterSignal(sac_target, COMSIG_MOVABLE_Z_CHANGED)
	UnregisterSignal(sac_target, COMSIG_LIVING_DEATH)
	sac_target.remove_status_effect(STATUS_EFFECT_NECROPOLIS_CURSE)

	/// Teleport them to a random safe coordinate on the station z level.
	var/turf/open/floor/safe_turf = find_safe_turf(extended_safety_checks = TRUE)
	var/obj/effect/landmark/observer_start/backup_loc = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	if(!safe_turf)
		safe_turf = get_turf(backup_loc)
	if(!do_teleport(sac_target, safe_turf, asoundout = 'sound/magic/blind.ogg', no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
		message_admins("[sac_target] failed teleport. Forcemoving to observer spawn. You may want to investigate this!")
		stack_trace("[sac_target] failed teleport. Forcemoving to observer spawn.")
		safe_turf = get_turf(backup_loc)
		sac_target.forceMove(safe_turf)

	var/composed_return_message = ""
	composed_return_message += span_notice("Your victim, [sac_target], was returned to the station - ")
	SEND_SIGNAL(sac_target, COMSIG_CLEAR_MOOD_EVENT, "shadow_realm")
	SEND_SIGNAL(sac_target, COMSIG_ADD_MOOD_EVENT, "shadow_realm_survived_sadness", /datum/mood_event/shadow_realm_live_sad)
	if(sac_target.stat == DEAD)
		INVOKE_ASYNC(src, .proc/after_return_dead_target, sac_target, safe_turf)
		composed_return_message += span_red("dead. ")
	else
		INVOKE_ASYNC(src, .proc/after_return_live_target, sac_target, safe_turf)
		composed_return_message += span_green("alive, but with a shattered mind. ")
	composed_return_message += span_notice("You hear a whisper... ")
	composed_return_message += span_hypnophrase(get_area_name(safe_turf, TRUE))
	if(master_heretic)
		to_chat(master_heretic, composed_return_message)

/*
 * If they somehow cheese the shadow realm by teleporting out, kill them and return them properly.
 */
/datum/eldritch_knowledge/spell/basic/proc/target_lost(mob/living/carbon/human/sac_target, old_z, new_z)
	SIGNAL_HANDLER

	to_chat(sac_target, span_userdanger("Your attempt to escape the realm is not taken kindly!"))
	disembowel_target(sac_target)
	sac_target.death()
	return_target(sac_target, FALSE)

/*
 * This proc is called from [proc/return_target] if the target survives the shadow realm.
 *
 * After teleporting [sac_target] back to [landing_turf] alive,
 * it gives them a bit of additional chems to help them along, and some moodlets.
 */
/datum/eldritch_knowledge/spell/basic/proc/after_return_live_target(mob/living/carbon/human/sac_target, turf/landing_turf)
	to_chat(sac_target, span_hypnophrase("The fight is over - but at great cost. You have been returned to your realm in one piece."))
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

/*
 * This proc is called from [proc/return_target] if the target dies in the shadow realm.
 *
 * After teleporting [sac_target] back to [landing_turf] dead,
 *  it spawns a special broken illusion to hint to the rescuers what happened.
 * After 1 to 2 minutes, a centcom announcement is sent detailing where the person landed.
 */
/datum/eldritch_knowledge/spell/basic/proc/after_return_dead_target(mob/living/carbon/human/sac_target, turf/landing_turf)
	addtimer(CALLBACK(src, .proc/announce_dead_target, landing_turf), rand(1 MINUTES, 2 MINUTES))
	sac_target?.reagents?.del_reagent(/datum/reagent/unholy_determination)
	var/obj/effect/broken_illusion/illusion = new /obj/effect/broken_illusion(landing_turf)
	illusion.name = "Weakened rift in reality"
	illusion.desc = "A rift wide enough for something... or someone to come through."
	illusion.color = COLOR_DARK_RED

/*
 * Makes a centcom announcement about our dead person returning to [landing_turf].
 */
/datum/eldritch_knowledge/spell/basic/proc/announce_dead_target(turf/landing_turf)
	priority_announce("Attention, crew. We recorded an anomalous dimensional occurance in: [get_area_name(landing_turf, TRUE)]. We're unsure of what it could be, but something just appeared in the area. We suggest checking it out.", "Central Command Higher Dimensional Affairs")

/*
 * Heals up the [sac_target] to up to [heal_to] brute and burn, and [heal_to / 2] tox and oxy.
 *
 * If the target is dead, also revives them and heals up their organs / restores blood slightly.
 *
 * returns TRUE if the mob is alive, or FALSE if they're dead.
 */
/datum/eldritch_knowledge/spell/basic/proc/heal_and_revive_target(mob/living/carbon/human/sac_target, heal_to = 75)
	var/brute_to_heal = heal_to - sac_target.getBruteLoss()
	var/burn_to_heal = heal_to - sac_target.getFireLoss()
	var/tox_to_heal = (heal_to/2) - sac_target.getToxLoss()
	var/oxy_to_heal = (heal_to/2) - sac_target.getOxyLoss()
	if(brute_to_heal < 0)
		sac_target.adjustBruteLoss(brute_to_heal, FALSE)
	if(burn_to_heal < 0)
		sac_target.adjustFireLoss(burn_to_heal, FALSE)
	if(tox_to_heal < 0)
		sac_target.adjustToxLoss(tox_to_heal, FALSE, TRUE)
	if(oxy_to_heal < 0)
		sac_target.adjustOxyLoss(oxy_to_heal, FALSE, TRUE)

	var/overall_health = sac_target.getBruteLoss() + sac_target.getFireLoss() + sac_target.getToxLoss() + sac_target.getOxyLoss()
	if(overall_health < 200 && sac_target.stat == DEAD)
		sac_target.revive(full_heal = FALSE, admin_revive = FALSE, excess_healing = 10)
		sac_target.visible_message(span_danger("[sac_target]'s heart begins to beat with an unholy force as they return from death!"))
	sac_target.updatehealth()

	return sac_target.stat != DEAD

/*
 * "We fucked up" proc that gets called if something goes wrong. Disembowels the [sac_target].
 */
/datum/eldritch_knowledge/spell/basic/proc/disembowel_target(mob/living/carbon/human/sac_target)
	var/turf/sac_loc = get_turf(sac_target)
	var/obj/item/bodypart/chest/our_chest = sac_target.get_bodypart(BODY_ZONE_CHEST)
	our_chest.dismember()
	message_admins("[sac_target] was disemboweled by a heretic at [ADMIN_VERBOSEJMP(sac_loc)].")
	log_attack("[sac_target] was disemboweled by a heretic at [loc_name(sac_loc)].")
	sac_target.visible_message(
		span_danger("[sac_target]'s organs are pulled out of their chest by shadowy hands!"),
		span_userdanger("Your organs are violently pulled out of your chest by shadowy hands!")
		)

/// Some moodlets for the shadow realm.
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

/*
 * A super buff reagent that's given to someone in the shadow realm
 * that pretty much prevents them from dying unless they're just not moving
 */
/datum/reagent/unholy_determination
	name = "Unholy Determination"
	description = "Heals all damage types. Heals burns extra. Stabilizes temperature. Works faster in critical. Stops bleeding."
	reagent_state = LIQUID
	color = "#dcdcdc77"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 7
	pain_modifier = 0.5

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
	var/healing_amount = -1.5
	/// In softcrit you're strong enough to stay up
	if(user.health <= user.crit_threshold && user.health >= user.hardcrit_threshold)
		if(DT_PROB(5, delta_time))
			to_chat(user, span_hypnophrase("Your body feels like giving up, but you fight on!"))
		healing_amount *= 2
	/// ...But in hardcrit you're in big danger
	if (user.health < user.hardcrit_threshold)
		if(DT_PROB(5, delta_time))
			to_chat(user, span_big(span_hypnophrase("You can't hold on for much longer...")))
		healing_amount *= -0.5

	if(user.health > user.crit_threshold && DT_PROB(4, delta_time))
		user.Jitter(10)
		user.Dizzy(5)
		user.hallucination = min(user.hallucination + 3, 24)
	if(DT_PROB(1, delta_time))
		playsound(user, pick(GLOB.creepy_ambience), 50, TRUE)

	user.set_fire_stacks(max(0, user.fire_stacks + healing_amount * 1.33 * REM * delta_time))
	user.losebreath = max(0, user.losebreath + healing_amount * 0.66 * REM * delta_time)
	user.adjustToxLoss(healing_amount * REM * delta_time, FALSE, TRUE)
	user.adjustOxyLoss(healing_amount * REM * delta_time, FALSE)
	user.adjustBruteLoss(healing_amount * REM * delta_time, FALSE)
	user.adjustFireLoss(healing_amount * 2 * REM * delta_time, FALSE)
	user.cause_pain(BODY_ZONES_LIMBS + BODY_ZONE_HEAD, healing_amount / 4)
	user.cause_pain(BODY_ZONE_CHEST, healing_amount / 2)
	if(user.blood_volume < BLOOD_VOLUME_NORMAL)
		user.blood_volume = user.blood_volume + (2 * REM * delta_time)
	adjust_temperature(user, delta_time)
	adjust_bleed_wounds(user, delta_time)
	. = ..()
	. = TRUE

/*
 * Regulate their temperature to normal body temperature.
 */
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

/*
 * Slow and stop blood loss.
 */
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
