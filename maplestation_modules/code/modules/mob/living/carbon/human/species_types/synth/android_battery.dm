//Adds a new android stomach type which has more charge than the android stomach, but makes it impossible to eat.
/obj/item/organ/stomach/ethereal/android/battery_core
	name = "Battery Core"
	desc = "This is a stomach replacement that stores charge for an android. It replaces the bioreactor with batteries for more energy, as a result the user cannot eat to gain energy."
	icon = 'maplestation_modules/icons/obj/medical/organs/organs.dmi'
	icon_state = "stomach_battery"

	passive_drain_multiplier = 0.3 //drains slower than default robots
	stomach_blood_transfer_rate = 0 //chems don't work too...


//stop eating benefits
#define NUTRITION_MULTIPLIER 0 //does this even work?
#define BOOZE_MULTIPLIER 0
/obj/item/organ/stomach/ethereal/android/battery_core/effective_charge()
	. = ..()

/obj/item/organ/stomach/ethereal/android/battery_core/handle_chemical(mob/living/carbon/source, datum/reagent/chem, seconds_per_tick, times_fired)
	//No booze, no drink, no food. It is not a stomach, it is a battery!
	return NONE

#undef NUTRITION_MULTIPLIER
#undef BOOZE_MULTIPLIER


#define NO_CHARGE "Low Power"
#define HAS_CON_MOD (1 << 0)
#define HAS_MOOD_EVENT (1 << 1)
#define HAS_DEATH_TIMER (1 << 2)

//Tweaked charge code which makes overcharged shocking less often (I hate shocking people so bad.) Pretend it has some overcurrent protection or something.
/obj/item/organ/stomach/ethereal/android/battery_core/handle_charge(mob/living/carbon/carbon, seconds_per_tick, times_fired)
	var/has_flags = NONE
	switch(cell.charge())
		if(-INFINITY to ETHEREAL_CHARGE_NONE)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_no_charge)
			if(!death_timer)
				carbon.add_max_consciousness_value(NO_CHARGE, CONSCIOUSNESS_MAX * 0.4)
				carbon.add_consciousness_modifier(NO_CHARGE, -30)
				death_timer = addtimer(CALLBACK(src, PROC_REF(turn_off), carbon), 30 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_DELETE_ME)
				to_chat(carbon, span_userdanger("Power levels critical: Shutdown in 30 seconds without recharge!"))
			has_flags |= HAS_CON_MOD | HAS_MOOD_EVENT | HAS_DEATH_TIMER

		if(ETHEREAL_CHARGE_NONE to ETHEREAL_CHARGE_LOWPOWER)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_decharged)
			carbon.add_max_consciousness_value(NO_CHARGE, CONSCIOUSNESS_MAX * 0.6)
			carbon.add_consciousness_modifier(NO_CHARGE, -20)
			has_flags |= HAS_CON_MOD | HAS_MOOD_EVENT

		if(ETHEREAL_CHARGE_LOWPOWER to ETHEREAL_CHARGE_NORMAL)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_low_power)
			has_flags |= HAS_MOOD_EVENT

		if(ETHEREAL_CHARGE_NORMAL to ETHEREAL_CHARGE_ALMOSTFULL)
			EMPTY_BLOCK_GUARD

		if(ETHEREAL_CHARGE_ALMOSTFULL to ETHEREAL_CHARGE_FULL)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_charged)
			has_flags |= HAS_MOOD_EVENT

		if(ETHEREAL_CHARGE_FULL to ETHEREAL_CHARGE_OVERLOAD)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_overcharged)
			has_flags |= HAS_MOOD_EVENT

		if(ETHEREAL_CHARGE_OVERLOAD to ETHEREAL_CHARGE_DANGEROUS)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_supercharged)
			has_flags |= HAS_MOOD_EVENT
			if(SPT_PROB(0.5, seconds_per_tick)) // UPDATED FROM 5% to 0.5% each second for the android to explosively release excess energy if it reaches dangerous levels
				discharge_process(carbon)

	carbon.hud_used?.hunger?.update_hunger_bar()
	if(!(has_flags & HAS_MOOD_EVENT))
		carbon.clear_mood_event(ALERT_ETHEREAL_CHARGE)
	if(!(has_flags & HAS_CON_MOD))
		carbon.remove_max_consciousness_value(NO_CHARGE)
		carbon.remove_consciousness_modifier(NO_CHARGE)
	if(!(has_flags & HAS_DEATH_TIMER) && death_timer)
		deltimer(death_timer)
		death_timer = null

#undef NO_CHARGE
#undef HAS_CON_MOD
#undef HAS_MOOD_EVENT
#undef HAS_DEATH_TIMER
