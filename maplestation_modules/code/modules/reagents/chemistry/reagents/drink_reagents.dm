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

//Starfruit drinks
//All the drinks are good-minimum because it requires a 1k import and then growing

/datum/reagent/consumable/starfruit_juice
	name = "Starfruit Juice"
	description = "The raw essence of a starfruit."
	color = "#6d3890"
	taste_description = "lush cosmic sugar"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/starfruit_soda
	name = "Stellar Twist"
	description = "A drink overly tired moms could hide in their thermos."
	boozepwr = 35
	color = "#434294"
	quality = DRINK_GOOD
	taste_description = "sweet stellar adventures"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starfruit_soda
	required_drink_type = /datum/reagent/consumable/ethanol/starfruit_soda
	name = "Stellar Twist"
	desc = "An alcoholic starfruit soda, you can see the carbonation in the glass."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starsoda"

/datum/reagent/consumable/ethanol/starfruit_lubricant
	name = "Stellar Lubricant"
	description = "A drink overly tired moms could hide in their thermos. Now for Synths!"
	boozepwr = 35
	color = "#45b33b"
	quality = DRINK_GOOD
	taste_description = "sweet stellar adventures"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starfruit_lubricant
	required_drink_type = /datum/reagent/consumable/ethanol/starfruit_lubricant
	name = "Stellar Lubricant"
	desc = "An alcoholic synth friendly starfruit soda, you can see the carbonation in the glass."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starsodasynth"

/datum/reagent/consumable/starfruit_latte
	name = "Starlit Latte"
	description = "A subtly sweet coffee seemingly out of this world."
	nutriment_factor = 8
	color = "#361329"
	quality = DRINK_GOOD
	taste_description = "hauntingly familiar allure"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starfruit_latte
	required_drink_type = /datum/reagent/consumable/starfruit_latte
	name = "mug of starlit latte"
	desc = "A simple coffee flavored with sweet starfruit juice. It takes you on a journey to a place you’ve never been, yet somehow know by heart."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starfruit_latte"

/datum/reagent/consumable/starbeam_shake
	name = "Starbeam Shake"
	description = "A delightful shake made with a rare starfruit."
	color = "#a551be"
	nutriment_factor = 0
	quality = DRINK_GOOD
	taste_description = "smooth starlight"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starbeam_shake
	required_drink_type = /datum/reagent/consumable/starbeam_shake
	name = "starbeam shake"
	desc = "A thick and creamy drink that takes you for a journey in the stars."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "voidshake"

/datum/reagent/consumable/ethanol/forgotten_star
	name = "Forgotten Star"
	description = "A cosmic cry of a bygone era."
	boozepwr = 55
	color = "#434294"
	quality = DRINK_GOOD
	taste_description = "dreamy, tropical starlit sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/forgotten_star
	required_drink_type = /datum/reagent/consumable/ethanol/forgotten_star
	name = "Forgotten Star"
	desc = "An alcoholic starfruit cocktail, you can almost make out a distant star system in the glass."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "forgottenstar"

/datum/reagent/consumable/ethanol/astral_flame
	name = "Astral Flame"
	description = "Enticing flames."
	boozepwr = 55
	color = "#6b3481"
	quality = DRINK_GOOD
	taste_description = "enticing warmth"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/astral_flame
	required_drink_type = /datum/reagent/consumable/ethanol/astral_flame
	name = "Astral Flame"
	desc = "An alcoholic starfruit mojito, the flame in the glass tempts you closer."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "astralflame"

/datum/reagent/consumable/ethanol/space_muse
	name = "Space Muse"
	description = "A snapshot straight from your local telescope."
	boozepwr = 35
	color = "#7cb1e2"
	quality = DRINK_GOOD
	taste_description = "haughty cosmic thought"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/space_muse
	required_drink_type = /datum/reagent/consumable/ethanol/space_muse
	name = "Space Muse"
	desc = "An alcoholic cocktail that draws you in with subtle bites of mint and starfruit."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "spacemuse"

/datum/reagent/consumable/starfruit_jelly
	name = "Starfruit Jelly"
	description = "A rare sweet fruit jelly."
	nutriment_factor = 10
	color = "#6d3890"
	taste_description = "starfruit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/starfruit_jelly

//Manual with the drink recipes, to make recipe browsing more interesting
/obj/item/book/manual/starfruit
	name = "Starfruit Drinks and Brewing"
	icon = 'maplestation_modules/icons/obj/starfruitbook.dmi'
	icon_state = "cookbook"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/starfruitbook_lhand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/starfruitbook_rhand.dmi'
	starting_author = "His Highness, Horatio Gilidan"
	starting_title = "Starfruit Drinks and Brewing"
	starting_content = {"<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<style>
h1 {font-size: 18px; margin: 15px 0px 5px;}
h2 {font-size: 15px; margin: 15px 0px 5px;}
li {margin: 2px 0px 2px 15px;}
ul {list-style: none; margin: 5px; padding: 0px;}
ol {margin: 5px; padding: 0px 15px;}
</style>
</head>
<body>

<h2>Murian Starfruit Beverage Recipes from all around the Nations of Mu, provided by the Heart of Cremona:</h2>

<b>Starfruit Soda:</b> An alcoholic soda with a distinctly fruity taste and a common fixture in most Gilidan bars. Distinctly enjoyed by young adults and old moms alike.<br>
Two parts starfruit juice, two parts rum, one part cognac, one part soda water.<br>

<b>Starfruit Lubricant:</b> A drink commonly enjoyed by the synthetic diaspora of Mu, it's surprisingly drinkable to organics, provided you can stand the oily taste.<br>
One part starfruit juice, one part synthetic oil.<br>

<b>Starlit Latte:</b> A classic recipe from the sailors of Aquatia as a replacement to goat locker coffee, this latte doesn't actually use any dairy products. \
The natural creaminess of starfruit juice is enough to dilute the bitterness of coffee to a pleasant sensation.<br>
One part starfruit juice, one part coffee.<br>

<b>Starbeam Shake:</b> A fruity yet aromatically deep milkshake, this one is extremely popular with children and adults alike. \
Notably brought all of the suitors to the yard during the Celestium Succession Crisis.<br>
One part starfruit juice, one part vanilla dream, one part ice.<br>

<b>Forgotten Star:</b> An extremely rich alcoholic drink from the beaches of Agrosia, a somewhat spiced up take on the Piña Colada. It evokes memories of nice vacations.<br>
One part starfruit juice, one part creme de coconut, one part white russian, one part pineapple juice, one part bitters.

<b>Astral Flame:</b> A strong drink with the fire of Solara. It's both warming and with a minty aftertaste to bring an edge to the flames.<br>
One Part starfruit juice, one part navy rum, one part lime juice, one part soda water, one part menthol.

<b>Space Muse:</b> A simple yet complex drink, often seen in the hands of the intelligentsia of Equitas. Originally a poor man's drink, it's now associated with the nobility.<br>
One part starfruit juice, one part creme de menthe, one part vodka.
</body>
</html>
"}
