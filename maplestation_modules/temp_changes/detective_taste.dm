//
// The areas in the main code this touches are:
// /datum/reagent/proc/get_taste_description(mob/living/taster) in code\modules\reagents\chemistry\reagents.dm
// code\__DEFINES\traits\declarations.dm
//

/obj/item/skillchip/job/detectives_taste
	name = "DET.ekt skillchip"
	desc = "Detective \"Encyclopedic Knowledge of Tastes\" v1.21"
	auto_traits = list(TRAIT_DETECTIVES_TASTE)
	skill_name = "Detective's Taste"
	skill_description = "Deduce the minute chemical compositions of any liquid substance just by swishing it around your mouth for a bit."
	skill_icon = "vial"
	activate_message = span_notice("An explosion of flavors hit your mouth as you remember the secret tastebuds long forgotten.")
	deactivate_message = span_notice("Your mouth dulls to the hidden tastes of the world.")

/datum/outfit/job/detective

	skillchips = list(/obj/item/skillchip/job/detectives_taste)

/datum/reagent/blood/get_taste_description(mob/living/taster)
	if(isnull(taster))
		return ..()
	if(!HAS_TRAIT(taster, TRAIT_DETECTIVES_TASTE))
		return ..()
	var/datum/blood_type/blood_type = GLOB.blood_types[data?["blood_type"]]
	if(!blood_type)
		return ..()
	return list("[blood_type.name] type blood" = 1)

