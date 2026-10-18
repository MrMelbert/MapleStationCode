#define SENDING_MANA_COST 7
#define SENDING_PSIONIC_MANA_REFUND 7 // partially for the gimmick, and because this was cheap to begin with

/datum/action/cooldown/spell/list_target/telepathy/mana
	name = "Sending"
	desc = "Using mana, telepathically transmits a message to the target."
	var/mana_cost = SENDING_MANA_COST

/datum/action/cooldown/spell/list_target/telepathy/mana/New(Target, original)
	. = ..()

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = mana_cost, \
	)

/datum/action/cooldown/spell/list_target/telepathy/mana/after_cast(...)
	. = ..()
	var/mob/living/carbon/psychic = owner
	if(!psychic)
		return
	// originally planned for it to replace the cost, but this is more reliable for reducing the cost (and owner is added after the component, so its null)
	if(HAS_TRAIT(psychic, TRAIT_FULL_PSIONIC)) // if we have sufficient psionic quirks, we get a refund on the mana. feel free to update this if more varieties are added
		psychic.safe_adjust_personal_mana(SENDING_PSIONIC_MANA_REFUND)

#undef SENDING_MANA_COST
#undef SENDING_PSIONIC_MANA_REFUND
