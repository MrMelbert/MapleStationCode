// -- Reagents that modify pain. --
/datum/reagent/medicine/morphine/on_mob_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_ADD_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]", 0.5)

/datum/reagent/medicine/morphine/on_mob_end_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_REMOVE_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]")

/datum/reagent/medicine/mine_salve/on_mob_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_ADD_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]", 0.75)

/datum/reagent/medicine/mine_salve/on_mob_end_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_REMOVE_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]")

/datum/reagent/determination/on_mob_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_ADD_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]", 0.8)

/datum/reagent/determination/on_mob_end_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_REMOVE_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]")

/datum/reagent/consumable/ethanol/painkiller/on_mob_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_ADD_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]", 0.9)

/datum/reagent/consumable/ethanol/painkiller/on_mob_end_metabolize(mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_CARBON_REMOVE_PAIN_MODIFIER, "[PAIN_MOD_CHEMS]-[name]")
