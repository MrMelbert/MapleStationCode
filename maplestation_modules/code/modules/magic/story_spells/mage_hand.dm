/datum/component/uses_mana/story_spell/mage_hand
	var/mage_hand_cost = 20

/datum/component/uses_mana/story_spell/mage_hand/get_mana_required(...)
	return ..() * mage_hand_cost

// Yeah, it's just a spell that gives you telekinesis for a short period, sue me
/datum/action/cooldown/spell/apply_mutations/mage_hand
	name = "Mage Hand"
	desc = "Magically grab an item from a distance."
	sound = null

	cooldown_time = 20 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	school = SCHOOL_PSYCHIC
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_MIND
	mutations_to_add = list(/datum/mutation/human/telekinesis)

/datum/action/cooldown/spell/apply_mutations/mage_hand/New(Target)
	. = ..()
	mutation_duration = cooldown_time * 0.5
	AddComponent(/datum/component/uses_mana/story_spell/mage_hand)

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
