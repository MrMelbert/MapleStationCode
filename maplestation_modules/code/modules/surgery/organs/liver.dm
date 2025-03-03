// Liver stuff

// werewolf liver, used for various funny traits, like handling their silver weakness chemically
/obj/item/organ/internal/liver/werewolf

	name = "Beastly liver"
	desc = "A large monstrous liver."
	icon_state = "liver"
	organ_flags = ORGAN_UNREMOVABLE
	// this is a major stop gap: i do want down the line for this to be removable, but this is the easiest way to keep liver in even when untransformed, and prevent werewolves from removing it for 0 downsides
	organ_traits = list(TRAIT_STABLELIVER, TRAIT_SILVER_VULNERABLE)

/obj/item/organ/internal/liver/werewolf/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	. = ..()
	// parent returned COMSIG_MOB_STOP_REAGENT_CHECK or we are failing
	if((. & COMSIG_MOB_STOP_REAGENT_CHECK) || (organ_flags & ORGAN_FAILING))
		return
	if(istype(chem, /datum/reagent/silver))
		organ_owner.adjustStaminaLoss(2 * REM * seconds_per_tick, updating_stamina = TRUE)
		organ_owner.adjustFireLoss(2 * REM * seconds_per_tick, updating_health = TRUE)
		organ_owner.cause_pain(BODY_ZONES_ALL, 1 * REM * seconds_per_tick)
