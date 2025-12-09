/datum/spellbook_item/spell
	entry_type = SPELLBOOK_SPELL
	var/datum/action/our_action_typepath

/datum/spellbook_item/spell/apply(mob/living/carbon/human/target, list/params)
	if(isdummy(target)) //if we're just adding spells, why would we want them to be given to the dummy?
		return

	. = ..()

	var/datum/action/our_spell = new our_action_typepath(target.mind || target)
	if (islist(params))
		apply_params(arglist(list(our_spell) + params))
	else
		stack_trace("[src]'s apply had [params] passed down as a non-list! This is against design!")
	our_spell.Grant(target)

/// Exists primarily for convenience.
/datum/spellbook_item/spell/proc/apply_params(/datum/action/our_spell, ...)
	return
