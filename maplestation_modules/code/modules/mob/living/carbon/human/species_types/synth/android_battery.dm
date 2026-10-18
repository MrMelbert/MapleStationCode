//Adds a new android stomach type which has more charge than the android stomach, but makes it impossible to eat.
/obj/item/organ/stomach/ethereal/android/battery_core
	name = "Battery Core"
	desc = "A robotic stomach replacement with many layers of batteries instead of a bioreactor."
	icon = 'maplestation_modules/icons/obj/medical/organs/organs.dmi'
	icon_state = "stomach_battery"

	passive_drain_multiplier = 0.3 //drains slower than default robots
	stomach_blood_transfer_rate = 0 //chems don't work too...
	nutrition_multiplier = 0
	booze_multiplier = 0
	discharge_chance = 0.5

/obj/item/organ/stomach/ethereal/android/battery_core/handle_chemical(mob/living/carbon/source, datum/reagent/chem, seconds_per_tick, times_fired)
	//No booze, no drink, no food. It is not a stomach, it is a battery!
	return NONE
