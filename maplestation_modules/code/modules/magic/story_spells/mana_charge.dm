// recover mana on your own. longer recharge.
/datum/action/cooldown/spell/meditate
	name = "Meditation"
	desc = "Regenerate some of your mana by focusing within yourself. Takes a period of time to cast."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "plasmasoul"
	sound = 'sound/magic/staff_healing.ogg'

	school = SCHOOL_UNSET // no idea where this would go tbh
	cooldown_time = 4 MINUTES
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	var/base_mana_recharge = 40 // the mana this recharges before a random varience

	var/random_value_floor = 0
	var/random_value_ceiling = 25

	invocation_self_message = "You begin focusing your mind on manipulating ambient mana."
	invocation = "Focus...."
	invocation_type = INVOCATION_WHISPER
	var/channel_time = 12 SECONDS

/datum/action/cooldown/spell/meditate/before_cast(mob/living/cast_on)
	. = ..()
	if (!cast_on.mana_pool)
		cast_on.balloon_alert(cast_on, "no mana pool!")
		return

/datum/action/cooldown/spell/meditate/cast(mob/living/cast_on)
	. = ..()
	if(!do_after(cast_on, channel_time)) // don't want this casted mid combat
		return . | SPELL_CANCEL_CAST
	var/randy_value = rand(random_value_floor, random_value_ceiling)
	var/mana_to_gain = randy_value + base_mana_recharge
	cast_on.mana_pool.adjust_mana(mana_to_gain)

// recover mana using your own blood. no protections from using this at low blood volume.
/datum/action/cooldown/spell/meditate/lesser_splattercasting
	name = "Lesser Splattercasting"
	desc = "Drain some of your own blood to recover mana. This does not prevent you from bleeding out."
	button_icon = 'icons/effects/bleed.dmi'
	button_icon_state = "bleed10"
	sound = 'sound/weapons/slice.ogg'

	cooldown_time = 2 MINUTES // shorter as its not from no where
	base_mana_recharge = 50
	var/base_bloodloss = 35 // the blood drained before a random variable is added.

	invocation_self_message = "You prepare an incantation to trade some of your blood for mana."
	invocation = "Vy'Thr"
	channel_time = 10 SECONDS

/datum/action/cooldown/spell/meditate/lesser_splattercasting/before_cast(mob/living/cast_on)
	. = ..()
	if (HAS_TRAIT(cast_on, TRAIT_NOBLOOD))
		cast_on.balloon_alert(cast_on, "no blood to use!")
		return

/datum/action/cooldown/spell/meditate/lesser_splattercasting/cast(mob/living/cast_on)
	. = ..()
	var/random_bloodloss_value = rand(random_value_floor, random_value_ceiling)
	var/blood_drain = base_bloodloss + random_bloodloss_value
	cast_on.blood_volume -= blood_drain
	var/turf/location = get_turf(cast_on)
	cast_on.add_splatter_floor(location)
