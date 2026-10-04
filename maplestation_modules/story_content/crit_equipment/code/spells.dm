// TODO LIST:
// Add "burning out" effect (consciousness modifier most likely, heart issues, literally burning up)
// Add recovery from burning out effect (healing over time? healing from sleeping state?)
// Add enhanced strength
// Add lifesteal
// Add "overdrive" secondary mode (right click on spell icon while already active)
// Fix up mood damage calcs
// Testing

/datum/action/cooldown/spell/spirit_force_camellia
	name = "Spirit Force - A Vengeful Bloom"
	desc = "Utilize the latent wrath within your spirit. It will give you the strength to forge ahead."
	button_icon_state = "charge"

	sound = 'sound/magic/charge.ogg'

	school = SCHOOL_HOLY
	cooldown_time = 60 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/spirit_force_camellia/cast(mob/living/cast_on)
	. = ..()

	if(cast_on.has_status_effect(/datum/status_effect/spirit_force_camellia))
		cast_on.remove_status_effect(/datum/status_effect/spirit_force_camellia)

	if(cast_on.mob_mood.sanity <= SANITY_UNSTABLE)
		return SPELL_CANCEL_CAST

	cast_on.apply_status_effect(/datum/status_effect/spirit_force_camellia)

/datum/mood_event/spirit_force_camellia
	description = "My spirit is on fire."
	mood_change = 4

/datum/mood_event/spirit_force_camellia/add_effects()
	RegisterSignal(owner, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(update_mood))

/datum/mood_event/spirit_force_camellia/remove_effects()
	UnregisterSignal(owner, COMSIG_MOB_AFTER_APPLY_DAMAGE)

/datum/mood_event/spirit_force_camellia/proc/update_mood(atom/source, damage)
	var/old_mood = mood_change
	mood_change -= damage * 0.1 //add a max mood change malus and make it not count negative damage
	if(old_mood != mood_change)
		owner.mob_mood.update_mood()

/datum/status_effect/spirit_force_camellia
	id = "spirit_force_camellia"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/spirit_force_camellia

/datum/status_effect/spirit_force_camellia/on_apply()
	owner.add_mood_event("spirit_force_camellia", /datum/mood_event/spirit_force_camellia)
	owner.add_filter("spirit_force", 2, list("type" = "drop_shadow", "x" = 0, "y" = 1, "color" = COLOR_DARK_RED, "size" = 2))
	owner.add_consciousness_modifier("spirit_force", 0)
	return ..()

/datum/status_effect/spirit_force_camellia/on_remove()
	owner.clear_mood_event("spirit_force_camellia")
	owner.remove_filter("spirit_force")

/datum/status_effect/spirit_force_camellia/tick(seconds_between_ticks)
	. = ..()

	if(owner.mob_mood.sanity <= SANITY_UNSTABLE)
		qdel(src)

/atom/movable/screen/alert/status_effect/spirit_force_camellia
	name = "Spirit Force"
	desc = "You have enhanced power and lifesteal, but this is taxing on your soul. Damage also applies to your mood and consciousness. Low sanity will turn off this spell."
	icon_state = "lightningorb"


/datum/action/cooldown/spell/pointed/unlock_chromatic_world
	name = "Unlock - ???"
	desc = "The world knows better than to stand in your way. Use on a supported object to unlock it."
	button_icon = 'maplestation_modules/story_content/crit_equipment/icons/unlock_spell.dmi'
	button_icon_state = "unlock"

	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"

	sound = 'sound/magic/blink.ogg'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 8 SECONDS

	active_msg = "You prepare to unlock a target..."
	deactive_msg = "You dispel your unlocking focus."

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/pointed/unlock_chromatic_world/is_valid_target(atom/cast_on)
	if(istype(cast_on, /obj/machinery/door/airlock))
		return cast_on

	if(isliving(cast_on))
		var/mob/living/check_him = cast_on

		if(locate(/obj/item/storage/belt/olivia_blade_sheath) in check_him.get_contents())
			return TRUE
		else
			owner.balloon_alert(owner, "nothing to unlock!")
			return FALSE

	else
		return FALSE

/datum/action/cooldown/spell/pointed/unlock_chromatic_world/cast(atom/cast_on)
	. = ..()

	if(istype(cast_on, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock_to_open = cast_on
		airlock_to_open.open(FORCING_DOOR_CHECKS)

	if(isliving(cast_on))
		var/mob/living/check_him = cast_on
		var/obj/item/storage/belt/olivia_blade_sheath/sheath_to_find = locate() in check_him.get_contents()
		if(sheath_to_find.toggle_sheath_lock())
			cast_on.balloon_alert(owner, "blade unlocked!")
		else if (sheath_to_find) // just in case is_valid_target didnt do its job
			cast_on.balloon_alert(owner, "blade locked!")

/// Used to define who's in the devil's webs
#define TRAIT_DEVIL_WEBBED "devil_webbed"

/// I'm not typing that whole thing out every single time its referenced
#define PARAPLEGIC_EFFECT "Savage Spider's Ultimate Technique - Induce Paraplegia (足の感覚がありません)"

// i might move this away from traits and just require story status in order to get into a global list, this SUCKS
/datum/action/cooldown/spell/spiders_webs
	name = "The Spider's Webs"
	desc = "Adjust the webs you have woven on somebody else. You can only have one effect active at once."
	button_icon = 'maplestation_modules/story_content/crit_equipment/icons/unlock_spell.dmi'
	button_icon_state = "webs"

	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"

	sound = null

	school = SCHOOL_FORBIDDEN
	cooldown_time = 10 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	var/list/evil_status_effects_of_doom = list(
		"Clear Effect",
		"Slowdown",
		"Mana Drain",
		PARAPLEGIC_EFFECT,
	)

/datum/action/cooldown/spell/spiders_webs/PreActivate(atom/caster)
	var/list/webbed_up_peeps = list()
	for(var/mob/living/literally_any_mob in world) // i am so sorry
		if(HAS_TRAIT(literally_any_mob, TRAIT_DEVIL_WEBBED))
			webbed_up_peeps += literally_any_mob

	if(!length(webbed_up_peeps))
		caster.balloon_alert(caster, "no target!")
		return FALSE

	if(QDELETED(src) || QDELETED(caster) || !can_cast_spell())
		return FALSE

	if(length(webbed_up_peeps) > 1)
		var/mob/chosen = tgui_input_list(caster, "Choose a target.", name, sort_names(webbed_up_peeps))
		return Activate(chosen)

	if(length(webbed_up_peeps) == 1)
		return Activate(webbed_up_peeps[1])

/datum/action/cooldown/spell/spiders_webs/cast(mob/living/cast_on)
	. = ..()

	var/chosen_effect = tgui_input_list(owner, "Choose an effect.", name, evil_status_effects_of_doom)
	switch(chosen_effect)

		if("Clear Effect")
			cast_on.remove_status_effect(/datum/status_effect/devil_webbed) //This removes based on id rather than specifically checking type

		if("Slowdown")
			cast_on.apply_status_effect(/datum/status_effect/devil_webbed/slowdown)

		if("Mana Drain")
			cast_on.apply_status_effect(/datum/status_effect/devil_webbed/mana_drain)

		if(PARAPLEGIC_EFFECT)
			cast_on.apply_status_effect(/datum/status_effect/devil_webbed/paraplegic)


/datum/status_effect/devil_webbed
	id = "devil_webbed"
	duration = -1
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/devil_webbed

/atom/movable/screen/alert/status_effect/devil_webbed
	name = "broken effect"
	desc = "If you're seeing this, someone forgot to set alert_type."
	icon_state = "paralysis"

// quick fix so that replacing the effect with another one doesn't end up keeping the maluses
/datum/status_effect/devil_webbed/be_replaced()
	on_remove()
	. = ..()

/datum/status_effect/devil_webbed/slowdown
	alert_type = /atom/movable/screen/alert/status_effect/devil_webbed/slowdown

/datum/status_effect/devil_webbed/slowdown/on_apply()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/devil_web_slowdown)

	return ..()

/datum/status_effect/devil_webbed/slowdown/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/devil_web_slowdown)

/atom/movable/screen/alert/status_effect/devil_webbed/slowdown
	name = "Slowdown"
	desc = "Your legs feel as if they're being restrained by strings."

/datum/movespeed_modifier/devil_web_slowdown
	multiplicative_slowdown = 1.5


/datum/status_effect/devil_webbed/mana_drain
	alert_type = /atom/movable/screen/alert/status_effect/devil_webbed/mana_drain
	// carbon owner, cached since we're doing things on tick
	var/mob/living/carbon/carbon_owner

/datum/status_effect/devil_webbed/mana_drain/on_apply()
	if(!iscarbon(owner))
		return FALSE
	carbon_owner = owner
	return ..()

/datum/status_effect/devil_webbed/mana_drain/tick(seconds_between_ticks)
	if(carbon_owner?.mana_pool)
		carbon_owner.safe_adjust_personal_mana(-5 * seconds_between_ticks)

/atom/movable/screen/alert/status_effect/devil_webbed/mana_drain
	name = "Mana Drain"
	desc = "Your whole body feels tight, and you feel yourself getting weaker and weaker..."

/datum/status_effect/devil_webbed/paraplegic
	alert_type = /atom/movable/screen/alert/status_effect/devil_webbed/paraplegic

/datum/status_effect/devil_webbed/paraplegic/on_apply()
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner?.has_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic)) // damn
		return FALSE
	human_owner?.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

	return ..()

/datum/status_effect/devil_webbed/paraplegic/on_remove()
	var/mob/living/carbon/human/human_owner = owner
	human_owner?.cure_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

/atom/movable/screen/alert/status_effect/devil_webbed/paraplegic
	name = "Paraplegic"
	desc = "You feel a strong constriction around your legs. You can't use them anymore."

