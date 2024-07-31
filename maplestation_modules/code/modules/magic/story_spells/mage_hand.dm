#define MAGE_HAND_MANA_COST 20

// Yeah, it's just a spell that gives you telekinesis for a short period, sue me
/datum/action/cooldown/spell/apply_mutations/mage_hand
	name = "Mage Hand"
	desc = "Magically grab an item from a distance."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "mage_hand"
	sound = null // it's supposed to be stealthy

	cooldown_time = 20 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	var/mana_cost = MAGE_HAND_MANA_COST

	school = SCHOOL_CONJURATION // or SCHOOL_TRANSLOCATION, or even SCHOOL_PSYCHIC
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_MIND
	mutations_to_add = list(/datum/mutation/human/telekinesis/mage_hand)

/datum/action/cooldown/spell/apply_mutations/mage_hand/New(Target)
	. = ..()
	mutation_duration = cooldown_time * 0.5
	AddComponent(/datum/component/uses_mana/spell, \
		mana_consumed = mana_cost, \
		)

/datum/action/cooldown/spell/apply_mutations/mage_hand/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return
	RegisterSignals(grant_to, list(COMSIG_CARBON_GAIN_MUTATION, COMSIG_CARBON_LOSE_MUTATION), PROC_REF(update_status_on_signal))

/datum/action/cooldown/spell/apply_mutations/mage_hand/Remove(mob/living/remove_from)
	. = ..()
	UnregisterSignal(remove_from, list(COMSIG_CARBON_GAIN_MUTATION, COMSIG_CARBON_LOSE_MUTATION))

/datum/action/cooldown/spell/apply_mutations/mage_hand/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/caster = owner
	if(caster.dna?.check_mutation(/datum/mutation/human/telekinesis))
		if(feedback)
			caster.balloon_alert(caster, "already telekinetic!")
		return FALSE

	return TRUE

// Small override for apply mutations to lock and mutadoneproof added mutations
/datum/action/cooldown/spell/apply_mutations/cast(mob/living/carbon/human/cast_on)
	. = ..()
	for(var/muttype in mutations_to_add)
		var/datum/mutation/human/corresponding = locate(muttype) in cast_on.dna.mutations
		if(isnull(corresponding))
			continue
		corresponding.locked = TRUE
		corresponding.scrambled = TRUE
		corresponding.mutadone_proof = TRUE

// Telekinesis but mage hand
/datum/mutation/human/telekinesis/mage_hand
	name = "Mage Hand"
	desc = "A magical inclination that allows the holder to interact with objects through thought."
	locked = TRUE
	instability = 0
	text_gain_indication = span_notice("You prepare your Mage Hand. <b>Click on something to grab it!</b>")
	text_lose_indication = span_notice("Your Mage Hand fades away.")

/datum/mutation/human/telekinesis/mage_hand/get_visual_indicator()
	return

#undef MAGE_HAND_MANA_COST
