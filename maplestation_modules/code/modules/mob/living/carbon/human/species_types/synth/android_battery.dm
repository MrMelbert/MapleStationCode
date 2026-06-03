//Adds a new android stomach type which has more charge than the android stomach, but makes it impossible to eat.
/obj/item/organ/stomach/ethereal/android/battery_core
	name = "Battery Core"
	desc = "This is a large battery that stores charge for an android. Since it is missing the standard bioreactor, it holds more energy, however the user cannot eat to gain power."
	icon_state = /obj/item/organ/stomach/cybernetic/tier2::icon_state //TEMPORARY SPRITE

	passive_drain_multiplier = 0.3 //drains slower than default
	stomach_blood_transfer_rate = 0 //chems don't work too...


//stop eating

#define NUTRITION_MULTIPLIER 0 //does this even work?
#define BOOZE_MULTIPLIER 0
/obj/item/organ/stomach/ethereal/android/battery_core/effective_charge()
	. = ..()

/obj/item/organ/stomach/ethereal/android/battery_core/handle_chemical(mob/living/carbon/source, datum/reagent/chem, seconds_per_tick, times_fired)
	//No booze, no drink, no food. It is not a stomach, it is a battery!
	return NONE

#undef NUTRITION_MULTIPLIER
#undef BOOZE_MULTIPLIER
