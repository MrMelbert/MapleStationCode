//for determining which type of heartbeat sound is playing
///Heartbeat is beating fast for hard crit
#define BEAT_FAST 1
///Heartbeat is beating slow for soft crit
#define BEAT_SLOW 2
///Heartbeat is gone... He's dead Jim :(
#define BEAT_NONE 0

/obj/item/organ/internal/heart
	name = "heart"
	desc = "I feel bad for the heartless bastard who lost this."
	icon_state = "heart-on"
	base_icon_state = "heart"
	visual = FALSE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_HEART
	item_flags = NO_BLOOD_ON_ITEM
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = 2.5 * STANDARD_ORGAN_DECAY //designed to fail around 6 minutes after death

	low_threshold_passed = span_info("Prickles of pain appear then die out from within your chest...")
	high_threshold_passed = span_warning("Something inside your chest hurts, and the pain isn't subsiding. You notice yourself breathing far faster than before.")
	now_fixed = span_info("Your heart begins to beat again.")
	high_threshold_cleared = span_info("The pain in your chest has died down, and your breathing becomes more relaxed.")

	attack_verb_continuous = list("beats", "thumps")
	attack_verb_simple = list("beat", "thump")

	// Heart attack code is in code/modules/mob/living/carbon/human/life.dm

	/// Whether the heart is currently beating.
	/// Do not set this directly. Use Restart() and Stop() instead.
	VAR_PRIVATE/beating = TRUE
	/// Tracks what sfx is currently playing
	var/playing_heartbeat_sfx = BEAT_SLOW
	/// whether the heart's been operated on to fix some of its damages
	var/operated = FALSE

/obj/item/organ/internal/heart/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[beating ? "on" : "off"]"

/obj/item/organ/internal/heart/Remove(mob/living/carbon/heartless, special, movement_flags)
	. = ..()
	if(!special)
		addtimer(CALLBACK(src, PROC_REF(stop_if_unowned)), 12 SECONDS)
	playing_heartbeat_sfx = BEAT_NONE
	owner?.stop_sound_channel(CHANNEL_HEARTBEAT)

/obj/item/organ/internal/heart/proc/stop_if_unowned()
	if(QDELETED(src))
		return
	if(IS_ROBOTIC_ORGAN(src))
		return
	if(isnull(owner))
		Stop()

/obj/item/organ/internal/heart/attack_self(mob/user)
	. = ..()
	if(.)
		return

	if(!beating)
		user.visible_message(
			span_notice("[user] squeezes [src] to make it beat again!"),
			span_notice("You squeeze [src] to make it beat again!"),
		)
		Restart()
		addtimer(CALLBACK(src, PROC_REF(stop_if_unowned)), 8 SECONDS)
		return TRUE

/obj/item/organ/internal/heart/proc/Stop()
	if(!beating)
		return FALSE

	beating = FALSE
	update_appearance()
	playing_heartbeat_sfx = BEAT_NONE
	if(!isnull(owner))
		owner.stop_sound_channel(CHANNEL_HEARTBEAT)
		owner.apply_status_effect(/datum/status_effect/heart_attack)
		SShealth_updates.queue_update(owner, UPDATE_MEDHUD_STATUS|UPDATE_MEDHUD_HEALTH)
	return TRUE

/obj/item/organ/internal/heart/proc/Restart()
	if(beating)
		return FALSE

	beating = TRUE
	update_appearance()
	if(!isnull(owner))
		owner.remove_status_effect(/datum/status_effect/heart_attack)
		SShealth_updates.queue_update(owner, UPDATE_MEDHUD_STATUS|UPDATE_MEDHUD_HEALTH)
	return TRUE

/obj/item/organ/internal/heart/OnEatFrom(eater, feeder)
	. = ..()
	Stop()

/// Checks if the heart is beating.
/// Can be overridden to add more conditions for more complex hearts.
/obj/item/organ/internal/heart/proc/is_beating()
	return beating

/obj/item/organ/internal/heart/get_status_text(advanced, add_tooltips)
	if(!beating && !(organ_flags & ORGAN_FAILING) && owner.needs_heart() && owner.stat != DEAD)
		return conditional_tooltip("<font color='#cc3333'>Cardiac Arrest</font>", "Defibrillate immediately. Similar electric shocks may work in emergencies.", add_tooltips)
	return ..()

/obj/item/organ/internal/heart/show_on_condensed_scans()
	// Always show if the guy needs a heart (so its status can be monitored)
	return ..() || owner.needs_heart()

/obj/item/organ/internal/heart/on_life(seconds_per_tick, times_fired)
	. = ..()

	// If the owner doesn't need a heart, we don't need to do anything with it.
	if(!owner.needs_heart())
		return

	// Handle "sudden" heart attack
	if(!beating || (organ_flags & ORGAN_FAILING))
		if(owner.can_heartattack() && Stop())
			if(owner.stat <= SOFT_CRIT && !owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB))
				owner.visible_message(span_danger("[owner] clutches at [owner.p_their()] chest as if [owner.p_their()] heart is stopping!"))
			to_chat(owner, span_userdanger("You feel a terrible pain in your chest, as if your heart has stopped!"))
		return

	if(!owner.client?.prefs.read_preference(/datum/preference/toggle/heartbeat))
		return

	var/heartrate = get_heart_rate()
	switch(heartrate)
		if(1 to SLOW_HEARTBEAT_THRESHOLD)
			if(playing_heartbeat_sfx != BEAT_SLOW)
				playing_heartbeat_sfx = BEAT_SLOW
				SEND_SOUND(owner, sound('sound/health/slowbeat.ogg', repeat = TRUE, channel = CHANNEL_HEARTBEAT, volume = 40))
		if(0, SLOW_HEARTBEAT_THRESHOLD to FAST_HEARTBEAT_THRESHOLD)
			if(playing_heartbeat_sfx != BEAT_NONE)
				playing_heartbeat_sfx = BEAT_NONE
				owner.stop_sound_channel(CHANNEL_HEARTBEAT)
		if(FAST_HEARTBEAT_THRESHOLD to INFINITY)
			if(playing_heartbeat_sfx != BEAT_FAST)
				playing_heartbeat_sfx = BEAT_FAST
				SEND_SOUND(owner, sound('sound/health/fastbeat.ogg', repeat = TRUE, channel = CHANNEL_HEARTBEAT, volume = 40))

/obj/item/organ/internal/heart/get_availability(datum/species/owner_species, mob/living/owner_mob)
	return owner_species.mutantheart

/// Gets the mob's heart rate as bpm (0 to 200(+))
/mob/living/proc/get_bpm()
	var/heart_rate = get_heart_rate()
	if(heart_rate <= 0)
		return 0

	return heart_rate * 10 + rand(-10, 15)

/// Gets the mob's heart rate scaled from 0 to 20(+)
/mob/living/proc/get_heart_rate()
	if(stat == DEAD)
		return 0

	return rand(7, 9)

/mob/living/carbon/human/get_heart_rate()
	var/obj/item/organ/internal/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
	return heart?.get_heart_rate() || 0

/// Gets the heart rate of the heart, scaled from 0 to 20(+)
/obj/item/organ/internal/heart/proc/get_heart_rate()
	if(!is_beating() || isnull(owner))
		return 0

	var/base_amount = 8
	base_amount += COUNT_TRAIT_SOURCES(owner, TRAIT_HEART_RATE_BOOST)
	base_amount -= COUNT_TRAIT_SOURCES(owner, TRAIT_HEART_RATE_SLOW)
	base_amount += round(owner.getOxyLoss() / 50, 0.5)
	base_amount += round(owner.pain_controller?.get_total_pain() / 50, 0.5)
	base_amount += round(owner.pain_controller?.traumatic_shock / 25, 0.5)
	base_amount += round((BLOOD_VOLUME_NORMAL - owner.blood_volume) / 250, 0.5)
	base_amount -= round((CONSCIOUSNESS_MAX - owner.consciousness) / 33, 0.5)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		base_amount += round((human_owner.sprint_length_max - human_owner.sprint_length) / human_owner.sprint_length_max, 0.1)
	var/damage_multiplier = clamp(2.5 * ((maxHealth - damage) / maxHealth), 0.5, 1)

	return clamp(round(base_amount * damage_multiplier, 0.5), 1, 100)

/obj/item/organ/internal/heart/feel_for_damage(self_aware)
	if(owner.needs_heart() && (!beating || (organ_flags & ORGAN_FAILING)))
		return span_boldwarning("[self_aware ? "Your heart is not beating!" : "You don't feel your heart beating."]")
	if(damage < low_threshold)
		return ""
	if(damage < high_threshold)
		return span_warning("[self_aware ? "Your heart hurts." : "It hurts, and your heart rate feels irregular."]")
	return span_boldwarning("[self_aware ? "Your heart seriously hurts!" : "It seriously hurts, and your heart rate is all over the place."]")

/obj/item/organ/internal/heart/cursed
	name = "cursed heart"
	desc = "A heart that, when inserted, will force you to pump it manually."
	icon_state = "cursedheart-off"
	base_icon_state = "cursedheart"
	decay_factor = 0
	var/pump_delay = 3 SECONDS
	var/blood_loss = BLOOD_VOLUME_NORMAL * 0.2
	var/heal_brute = 0
	var/heal_burn = 0
	var/heal_oxy = 0

/obj/item/organ/internal/heart/cursed/attack(mob/living/carbon/human/accursed, mob/living/carbon/human/user, obj/target)
	if(accursed == user && istype(accursed))
		playsound(user,'sound/effects/singlebeat.ogg',40,TRUE)
		user.temporarilyRemoveItemFromInventory(src, TRUE)
		Insert(user)
	else
		return ..()

/obj/item/organ/internal/heart/cursed/on_mob_insert(mob/living/carbon/accursed)
	. = ..()

	accursed.AddComponent(/datum/component/manual_heart, pump_delay = pump_delay, blood_loss = blood_loss, heal_brute = heal_brute, heal_burn = heal_burn, heal_oxy = heal_oxy)

/obj/item/organ/internal/heart/cursed/on_mob_remove(mob/living/carbon/accursed, special = FALSE)
	. = ..()

	qdel(accursed.GetComponent(/datum/component/manual_heart))

/obj/item/organ/internal/heart/cybernetic
	name = "basic cybernetic heart"
	desc = "A basic electronic device designed to mimic the functions of an organic human heart."
	icon_state = "heart-c-on"
	base_icon_state = "heart-c"
	organ_flags = ORGAN_ROBOTIC
	maxHealth = STANDARD_ORGAN_THRESHOLD*0.75 //This also hits defib timer, so a bit higher than its less important counterparts
	failing_desc = "seems to be broken."

	var/dose_available = FALSE
	var/rid = /datum/reagent/medicine/epinephrine
	var/ramount = 10
	var/emp_vulnerability = 80 //Chance of permanent effects if emp-ed.

/obj/item/organ/internal/heart/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	// Some effects are byassed if our owner (should it exist) doesn't need a heart
	var/owner_needs_us = owner?.needs_heart()

	if(owner_needs_us && !COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.set_dizzy_if_lower(20 SECONDS)
		owner.losebreath += 10
		COOLDOWN_START(src, severe_cooldown, 20 SECONDS)

	if(prob(emp_vulnerability/severity)) //Chance of permanent effects
		organ_flags |= ORGAN_EMP //Starts organ faliure - gonna need replacing soon.
		Stop()
		addtimer(CALLBACK(src, PROC_REF(Restart)), 10 SECONDS)
		if(owner_needs_us)
			owner.visible_message(
				span_danger("[owner] clutches at [owner.p_their()] chest as if [owner.p_their()] heart is stopping!"),
				span_userdanger("You feel a terrible pain in your chest, as if your heart has stopped!"),
			)

/obj/item/organ/internal/heart/cybernetic/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(dose_available && owner.health <= 0 && !owner.reagents.has_reagent(rid))
		used_dose()

/obj/item/organ/internal/heart/cybernetic/proc/used_dose()
	owner.reagents.add_reagent(rid, ramount)
	dose_available = FALSE

/obj/item/organ/internal/heart/cybernetic/tier2
	name = "cybernetic heart"
	desc = "An electronic device designed to mimic the functions of an organic human heart. Also holds an emergency dose of epinephrine, used automatically after facing severe trauma."
	icon_state = "heart-c-u-on"
	base_icon_state = "heart-c-u"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	dose_available = TRUE
	emp_vulnerability = 40

/obj/item/organ/internal/heart/cybernetic/tier3
	name = "upgraded cybernetic heart"
	desc = "An electronic device designed to mimic the functions of an organic human heart. Also holds an emergency dose of epinephrine, used automatically after facing severe trauma. This upgraded model can regenerate its dose after use."
	icon_state = "heart-c-u2-on"
	base_icon_state = "heart-c-u2"
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	dose_available = TRUE
	emp_vulnerability = 20

/obj/item/organ/internal/heart/cybernetic/tier3/used_dose()
	. = ..()
	addtimer(VARSET_CALLBACK(src, dose_available, TRUE), 5 MINUTES)

/obj/item/organ/internal/heart/cybernetic/surplus
	name = "surplus prosthetic heart"
	desc = "A fragile mockery of a human heart that resembles a water pump more than an actual heart. \
		Offers no protection against EMPs."
	icon_state = "heart-c-s-on"
	base_icon_state = "heart-c-s"
	maxHealth = STANDARD_ORGAN_THRESHOLD*0.5
	emp_vulnerability = 100

//surplus organs are so awful that they explode when removed, unless failing
/obj/item/organ/internal/heart/cybernetic/surplus/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dangerous_surgical_removal)

/obj/item/organ/internal/heart/freedom
	name = "heart of freedom"
	desc = "This heart pumps with the passion to give... something freedom."
	organ_flags = ORGAN_ROBOTIC  //the power of freedom prevents heart attacks
	/// The cooldown until the next time this heart can give the host an adrenaline boost.
	COOLDOWN_DECLARE(adrenaline_cooldown)

/obj/item/organ/internal/heart/freedom/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(owner.health < 5 && COOLDOWN_FINISHED(src, adrenaline_cooldown))
		COOLDOWN_START(src, adrenaline_cooldown, rand(25 SECONDS, 1 MINUTES))
		to_chat(owner, span_userdanger("You feel yourself dying, but you refuse to give up!"))
		owner.heal_overall_damage(brute = 15, burn = 15, required_bodytype = BODYTYPE_ORGANIC)
		if(owner.reagents.get_reagent_amount(/datum/reagent/medicine/ephedrine) < 20)
			owner.reagents.add_reagent(/datum/reagent/medicine/ephedrine, 10)
