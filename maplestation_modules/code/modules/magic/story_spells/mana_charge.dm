// spell that recharges your mana by drawing from leylines, temporarily inaccessible because leyline access is weird, and they're underpowered rn
/datum/action/cooldown/spell/leyline_charge
	name = "Leyline Charge"
	desc = "Regenerate some of your mana by channeling straight from the leylines themselves."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "plasmasoul"
	sound = 'sound/magic/staff_healing.ogg'

	school = SCHOOL_UNSET // no idea where this would go tbh
	cooldown_time = 2 MINUTES
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	invocation = "AS'P'RE"
	invocation_type = INVOCATION_WHISPER
	var/channel_time = 7 SECONDS


/datum/action/cooldown/spell/leyline_charge/before_cast(mob/living/cast_on)
	. = ..()
	if (!cast_on.mana_pool)
		cast_on.balloon_alert(cast_on, "no mana pool!")
		return
	if(!do_after(cast_on, channel_time)) // don't want this casted mid combat
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/leyline_charge/cast(mob/living/cast_on)
	. = ..()
	var/randy_value = rand(0,25) // generate a random number, which will be-
	var/mana_to_gain = randy_value + 20 // added to the base amount, to get a semi-inconsistent regen amount
	var/list/datum/mana_pool/leyline/accessable_leylines = list(get_accessable_leylines())
	if(!accessable_leylines.len)
		cast_on.balloon_alert(cast_on, "no accessable leylines!")
		return
	var/datum/mana_pool/leyline/random_leyline = accessable_leylines[rand(0, accessable_leylines.len)] // get a random leyline
	random_leyline.transfer_specific_mana(cast_on.mana_pool, mana_to_gain, decrement_budget = TRUE)

// recover mana on your own. longer recharge. more is planned, hopefully
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

	invocation = "Focus...."
	invocation_type = INVOCATION_WHISPER
	var/channel_time = 12 SECONDS

/datum/action/cooldown/spell/meditate/before_cast(mob/living/cast_on)
	. = ..()
	if (!cast_on.mana_pool)
		cast_on.balloon_alert(cast_on, "no mana pool!")
		return
	to_chat(cast_on, span_alert("You begin focusing your mind on manipulating ambient mana."))
	if(!do_after(cast_on, channel_time)) // don't want this casted mid combat
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/meditate/cast(mob/living/cast_on)
	. = ..()
	var/randy_value = rand(0,25)
	var/mana_to_gain = randy_value + 40
	cast_on.mana_pool.adjust_mana(mana_to_gain)
