/datum/component/uses_mana/story_spell/touch/shock_touch
	var/shock_touch_attunement_amount = 0.5
	var/shock_touch_cost = 50

/datum/component/uses_mana/story_spell/touch/shock_touch/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/electric] += shock_touch_attunement_amount

/datum/component/uses_mana/story_spell/touch/shock_touch/get_mana_required(...)
	return ..() * shock_touch_cost

// Magical shock touch can just subtype normal shock touch relatievly painlessly
/datum/action/cooldown/spell/touch/shock/magical
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE

/datum/action/cooldown/spell/touch/shock/magical/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/touch/shock_touch)

// Shock mutation needs to address people with magic shock touch
/datum/mutation/human/shock

/datum/mutation/human/shock/grant_power()
	if(isnull(owner))
		return FALSE

	var/datum/action/cooldown/spell/touch/shock/magical/magic_shock = locate() in owner.actions
	if(isnull(magic_shock))
		return ..()

	to_chat(owner, span_notice("Your hands feel like they're buzzing with electricity."))
	var/datum/component/uses_mana/story_spell/touch/shock_touch/touch = magic_shock.GetComponent(/datum/component/uses_mana/story_spell/touch/shock_touch)
	touch?.shock_touch_cost = 0
	power_path = null

/datum/mutation/human/shock/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return

	var/datum/action/cooldown/spell/touch/shock/magical/magic_shock = locate() in owner.actions
	if(isnull(magic_shock))
		return

	to_chat(owner, span_warning("Your hands feel numb once more."))
	var/datum/component/uses_mana/story_spell/touch/shock_touch/touch = magic_shock.GetComponent(/datum/component/uses_mana/story_spell/touch/shock_touch)
	touch?.shock_touch_cost = initial(touch.shock_touch_cost)
