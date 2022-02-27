// -- Subtype of the summon dagger to give the proper summon item --

/// Don't use this one...
/datum/action/innate/cult/blood_spell/dagger
	blacklisted_by_default = TRUE

/// Use this one
/datum/action/innate/cult/blood_spell/dagger/advanced
	blacklisted_by_default = FALSE
	summoned_type = /obj/item/melee/cultblade/advanced_dagger

/datum/action/innate/cult/blood_spell/equipment
	magic_path = /obj/item/melee/blood_magic/armor/advanced

/obj/item/melee/blood_magic/armor/advanced

/obj/item/melee/blood_magic/armor/advanced/afterattack(atom/target, mob/living/carbon/user, proximity)
	. = ..()
	if(!IS_CULTIST(user) || !iscarbon(user) || !proximity)
		return
	var/obj/item/melee/cultblade/dagger/spawned_bad_dagger = locate() in user.held_items
	if(spawned_bad_dagger)
		qdel(spawned_bad_dagger)
		user.put_in_hands(new /obj/item/melee/cultblade/advanced_dagger(user))
