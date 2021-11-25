// -- Subtype of the summon dagger to give the proper summon item --

/// Don't use this one...
/datum/action/innate/cult/blood_spell/dagger
	blacklisted_by_default = TRUE

/// Use this one
/datum/action/innate/cult/blood_spell/dagger/advanced
	blacklisted_by_default = FALSE
	summoned_type = /obj/item/melee/cultblade/advanced_dagger
