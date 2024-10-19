// Liver stuff
/obj/item/organ/internal/liver
	/// Typecache of food we can eat that will never give us disease.
	var/list/disease_free_foods

// Lizard liver to Let Them Eat Rat
/obj/item/organ/internal/liver/lizard
	name = "lizardperson liver"
	desc = "A liver native to a Lizardperson of Tiziran... or maybe one of its colonies."
	color = COLOR_VERY_DARK_LIME_GREEN

/obj/item/organ/internal/liver/lizard/Initialize(mapload)
	. = ..()
	disease_free_foods = typecacheof(/obj/item/food/deadmouse)

/obj/item/organ/internal/liver/werewolf

	name = "Beastly liver"
	desc = "A large monstrous liver."
	icon_state = "liver"
	organ_traits = list(TRAIT_STABLELIVER, ORGAN_UNREMOVABLE)
	///Var for brute healing via blood
	var/blood_brute_healing = 2.5
	///Var for burn healing via blood
	var/blood_burn_healing = 2.5

/obj/item/organ/internal/liver/werewolf/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	. = ..()
	// parent returned COMSIG_MOB_STOP_REAGENT_CHECK or we are failing
	if((. & COMSIG_MOB_STOP_REAGENT_CHECK) || (organ_flags & ORGAN_FAILING))
		return
	if(istype(chem, /datum/reagent/silver))
		organ_owner.adjustStaminaLoss(7.5 * REM * seconds_per_tick, updating_stamina = TRUE)
		organ_owner.adjustFireLoss(5.0 * REM * seconds_per_tick, updating_health = TRUE)
