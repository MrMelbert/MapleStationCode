#define SENDING_MANA_COST 7

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

#undef SENDING_MANA_COST
