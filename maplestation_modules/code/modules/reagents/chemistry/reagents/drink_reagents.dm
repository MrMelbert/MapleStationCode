//New drink reagents for Maplestation.
/datum/reagent/consumable/green_tea //seperate from regular tea because its different in almost every way
	name = "Green Tea"
	description = "Some nice green tea. A very traditional drink in Space Japanese culture."
	color = "#9E8400" // rgb: 158, 132, 0
	quality = DRINK_GOOD
	taste_description = "tart green tea"
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/green_tea
	required_drink_type = /datum/reagent/consumable/green_tea
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "green_teaglass"
	name = "glass of green tea"
	desc = "It just doesn't feel right to drink this without a cup..."

/datum/reagent/consumable/green_tea/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	M.adjust_dizzy(-4 SECONDS * REM * seconds_per_tick)
	M.adjust_jitter(-6 SECONDS * REM * seconds_per_tick)
	M.adjust_drowsiness(-2 SECONDS * REM * seconds_per_tick)
	M.AdjustSleeping(-20 * REM * seconds_per_tick)
	M.adjustToxLoss(-0.5, FALSE) //the major difference between base tea and green tea, this one's a great anti-tox.
	M.adjust_body_temperature(WARM_DRINK * REM * seconds_per_tick, max_temp = M.standard_body_temperature)
	return ..() || TRUE

/datum/reagent/consumable/ice_greentea
	name = "Iced Green Tea"
	description = "A delicious beverage, a classic when mixed with honey." //doesnt actually do anything special with honey
	color = "#AD8500" // rgb: 173, 133, 0
	nutriment_factor = 0
	quality = DRINK_VERYGOOD
	taste_description = "tart cold green tea" //iced green tea has a weird but amazing taste IRL, hard to describe it
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/ice_greentea
	required_drink_type = /datum/reagent/consumable/ice_greentea
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "iced_green_teaglass"
	name = "iced green tea"
	desc = "A delicious beverage for any time of the year. Much better with a lot of sugar." //Now THIS is actually a hint, as sugar rush turns it into Green Hill Tea.

/datum/reagent/consumable/icetea/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	M.adjust_dizzy(-4 SECONDS * REM * seconds_per_tick)
	M.adjust_drowsiness(-2 SECONDS * REM * seconds_per_tick)
	M.AdjustSleeping(-40 * REM * seconds_per_tick)
	M.adjustToxLoss(-0.5, FALSE)
	M.adjust_body_temperature(COLD_DRINK * REM * seconds_per_tick, min_temp = M.standard_body_temperature)
	return ..() || TRUE

/datum/reagent/consumable/green_hill_tea
	name = "Green Hill Tea"
	description = "A beverage that is a strong stimulant, makes people run at sonic speed."
	color = "#1FB800" // rgb: 31, 184, 0
	nutriment_factor = 0
	overdose_threshold = 55
	quality = DRINK_FANTASTIC
	glass_price = DRINK_PRICE_HIGH
	taste_description = "flowers and being able to do anything"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/green_hill_tea
	required_drink_type = /datum/reagent/consumable/green_hill_tea
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "green_hill_tea"
	name = "Green Hill Tea"
	desc = "A strong stimulant, though for some it doesnt matter, as the taste opens your heart."

/datum/reagent/consumable/green_hill_tea/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/green_hill_tea)

/datum/reagent/consumable/green_hill_tea/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/green_hill_tea)
	return ..()

/datum/reagent/consumable/green_hill_tea/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	M.AdjustSleeping(-40 * REM * seconds_per_tick)
	M.adjust_body_temperature(COLD_DRINK * REM * seconds_per_tick, min_temp = M.standard_body_temperature)
	return ..()

/datum/reagent/consumable/green_hill_tea/overdose_process(mob/living/M, seconds_per_tick, times_fired)
	if(!ishuman(M))
		return

	var/mob/living/carbon/human/overdosed_human = M
	overdosed_human.hair_color = "15F" //blue hair, oh no
	overdosed_human.facial_hair_color = "15F"
	overdosed_human.update_body_parts()

/obj/item/reagent_containers/cup/glass/mug/green_tea
	name = "Bonzai Zen tea"
	desc = "A cup of traditional Space Japanese green tea. It is said that it soothes the soul, if drank properly."
	icon_state = "green_tea" //actually unused because of how mugs work... ...for now.
	base_icon_state = "green_tea"
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	list_reagents = list(/datum/reagent/consumable/green_tea = 30)

/datum/reagent/consumable/pilk
	name = "Pilk"
	description = "A horrid bubbling combination of milk and cola. You are a fucking alchemist and no-one can tell you otherwise."
	color = "#BEAE7E" // rgb: 190, 174, 126
	quality = -4 //this is godawful, though i dont think negative quality actually does anything
	nutriment_factor = 2 * REAGENTS_METABOLISM //somehow more filling than pure nutriment
	taste_description = "bubbles, milk, whatever the hell pepis is and a want to die" //pepis is canon now, its the rival brand to Space Cola. Renember to rename this to explicitly say pepis if it gets added in.
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/pilk
	required_drink_type = /datum/reagent/consumable/pilk
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "pilk" //the sprite has what is intended to be foam on top as pilk makes that in real life
	name = "glass of pilk"
	desc = "A horrid bubbling combination of milk and cola. You are a fucking alchemist and no-one can tell you otherwise."

/datum/reagent/consumable/pilk/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	if(isfelinid(M)) //felinids love pilk
		M.add_mood_event("full_on_pilk", /datum/mood_event/full_on_pilk, name)
	else if(isskeleton(M))
		M.adjustBruteLoss(1, FALSE) //ITS POISON
		. = TRUE
	else
		M.adjust_disgust(4 * REM * seconds_per_tick)

	return ..() || .

/datum/reagent/consumable/ethanol/peg_nog
	name = "Peg Nog"
	description = "Its time to get PEGGED!"
	color = "#C1C17B" // rgb: 193, 193, 123
	quality = -6 //its somehow worse
	nutriment_factor = 3 * REAGENTS_METABOLISM //more filling
	boozepwr = 20
	taste_description = "getting pegged" //oh no
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/peg_nog
	required_drink_type = /datum/reagent/consumable/ethanol/peg_nog
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "peg_nog"
	name = "glass of peg nog"
	desc = "Its time to get PEGGED!"

/datum/reagent/consumable/ethanol/peg_nog/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	if(isfelinid(M)) //felinids love peg nog too!
		M.add_mood_event("pegged", /datum/mood_event/pegged, name)
	else if(isskeleton(M))
		M.adjustBruteLoss(2, FALSE) //when drinking this you wish for bone hurting juice
		. = TRUE
	else
		M.adjust_disgust(7 * REM * seconds_per_tick)

	return ..() || .

// Ported from Yogstation
/datum/reagent/consumable/ethanol/justicars_juice
	name = "Justicar's Juice"
	description = "I don't even know what an eminence is, but I want him to recall."
	metabolization_rate = INFINITY
	boozepwr = 30
	quality = DRINK_FANTASTIC
	taste_description = "cogs and brass"

/datum/glass_style/drinking_glass/justicars_juice
	required_drink_type = /datum/reagent/consumable/ethanol/justicars_juice
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "justicars_juice"
	name = "Justicar's Juice"
	desc = "Just looking at this makes your head spin. How the hell is it ticking?"

/datum/reagent/consumable/ethanol/samogon_sonata
	name = "Samogon Sonata"
	description = "Unholy mixture of unholy beverages. Should be illegal."
	boozepwr = 80
	color = "#1a0942"
	quality = DRINK_NICE
	taste_description = "an overwhelming and undescribable taste"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/samogon_sonata
	required_drink_type = /datum/reagent/consumable/ethanol/samogon_sonata
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "samogon_sonata"
	name = "Samogon Sonata"
	desc = "A special, about unknown family recipe that's prone to make you see stars in your sleep. Likely illegal."

/datum/reagent/consumable/ethanol/samogon_sonata/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	switch(current_cycle)
		if(1 to 20)
			M.adjust_confusion(2 SECONDS * REM * seconds_per_tick)
			M.adjust_drowsiness(4 SECONDS * REM * seconds_per_tick)
		if(20 to 50)
			M.Sleeping(15 SECONDS * REM * seconds_per_tick)

	return ..()

/datum/reagent/consumable/ethanol/piledriver
	name = "Piledriver"
	description = "A mix of vodka, coke, rum and orange juice. Fizzy."
	boozepwr = 20
	color = "#e97617"
	quality = DRINK_NICE
	taste_description = "sweet and fizz"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/piledriver
	required_drink_type = /datum/reagent/consumable/ethanol/piledriver
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "piledriver"
	name = "Pile Driver"
	desc = "A drink said to be bitter and somewhat spicy. You better not have a sore throat when drinking it." //Va-11 Hall-A reference moment flushed

/datum/reagent/consumable/ethanol/blood_wine
	name = "Tiziran Blood Wine"
	description = "A Tiziran wine made from fermented blood."
	boozepwr = 20
	quality = DRINK_NICE
	taste_description = "meat and tanginess"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/blood_wine
	required_drink_type = /datum/reagent/consumable/ethanol/blood_wine
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	icon_state = "blood_wine"
	name = "Tiziran Blood Wine"
	desc = "A wine made from fermented blood originating from Tizira. Despite the name, the drink does not taste of blood."

//the big chunk of caffeine-related additions

//Weak-Level Caffeinated Drinks
/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_WEAK * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/consumable/ethanol/irishcoffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_WEAK * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/consumable/pumpkin_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_WEAK * seconds_per_tick) //girl, you are OPPRESSING the coffee
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/medicine/painkiller/aspirin_para_coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_WEAK * seconds_per_tick)

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_WEAK * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/tea_lover)

/datum/reagent/consumable/tea/arnold_palmer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_WEAK * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/tea_lover)

//Coffee-Level Caffeinated Drinks

/datum/reagent/consumable/coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER)) //we love coffee.
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/consumable/ethanol/thirteenloko/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)

/datum/reagent/consumable/icecoffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/consumable/hot_ice_coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/consumable/soy_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/consumable/cafe_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/coffee_lover)

/datum/reagent/consumable/tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/tea_lover)

/datum/reagent/consumable/icetea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/tea_lover)

/datum/reagent/consumable/green_tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/tea_lover)

/datum/reagent/consumable/ice_greentea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_COFFEE * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/tea_lover)

//Energy-Level Caffeinated Drinks

/datum/reagent/consumable/green_hill_tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_ENERGY * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/tea_lover)

/datum/reagent/consumable/grey_bull/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_ENERGY * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/energy_lover)

/datum/reagent/consumable/monkey_energy/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	SEND_SIGNAL(affected_mob, COMSIG_CARBON_DRINK_CAFFEINE, CAFFEINE_POINTS_ENERGY * seconds_per_tick)
	if(HAS_TRAIT(affected_mob, TRAIT_CAFFEINE_LOVER))
		affected_mob.add_mood_event("caffeine_lover", /datum/mood_event/energy_lover)
