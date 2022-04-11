//New drink reagents for Jollystation.
/datum/reagent/consumable/green_tea //seperate from regular tea because its different in almost every way
	name = "Green Tea"
	description = "Some nice green tea. A very traditional drink in Space Japanese culture."
	color = "#9E8400" // rgb: 158, 132, 0
	quality = DRINK_GOOD
	taste_description = "tart green tea"
	glass_icon_state = "green_teaglass"
	glass_icon_file = 'maplestation_modules/icons/obj/drinks.dmi'
	glass_name = "glass of green tea"
	glass_desc = "It just doesn't feel right to drink this without a cup..."
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/green_tea/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (2 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (1 * REM * delta_time), 0)
	M.jitteriness = max(M.jitteriness - (3 * REM * delta_time), 0)
	M.AdjustSleeping(-20 * REM * delta_time)
	M.adjustToxLoss(-0.5, 0) //the major difference between base tea and green tea, this one's a great anti-tox.
	M.adjust_bodytemperature(20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	..()
	. = TRUE

/datum/reagent/consumable/ice_greentea
	name = "Iced Green Tea"
	description = "A delicious beverage, a classic when mixed with honey." //doesnt actually do anything special with honey
	color = "#AD8500" // rgb: 173, 133, 0
	nutriment_factor = 0
	quality = DRINK_VERYGOOD
	taste_description = "tart cold green tea" //iced green tea has a weird but amazing taste IRL, hard to describe it
	glass_icon_state = "iced_green_teaglass"
	glass_icon_file = 'maplestation_modules/icons/obj/drinks.dmi'
	glass_name = "iced green tea"
	glass_desc = "A delicious beverage for any time of the year. Much better with a lot of sugar." //Now THIS is actually a hint, as sugar rush turns it into Green Hill Tea.
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/icetea/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (2 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (1 * REM * delta_time), 0)
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjustToxLoss(-0.5, 0)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()
	. = TRUE

/datum/reagent/consumable/green_hill_tea
	name = "Green Hill Tea"
	description = "A beverage that is a strong stimulant, makes people run at sonic speed."
	color = "#1FB800" // rgb: 31, 184, 0
	nutriment_factor = 0
	overdose_threshold = 55
	quality = DRINK_FANTASTIC
	glass_price = DRINK_PRICE_HIGH
	taste_description = "flowers and being able to do anything"
	glass_icon_state = "green_hill_tea"
	glass_icon_file = 'maplestation_modules/icons/obj/drinks.dmi'
	glass_name = "Green Hill Tea"
	glass_desc = "A strong stimulant, though for some it doesnt matter, as the taste opens your heart."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/green_hill_tea/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/green_hill_tea)

/datum/reagent/consumable/green_hill_tea/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/green_hill_tea)
	..()

/datum/reagent/consumable/green_hill_tea/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()
	. = TRUE

/datum/reagent/consumable/green_hill_tea/overdose_process(mob/living/M, delta_time, times_fired)
	if(!ishuman(M))
		return

	var/mob/living/carbon/human/overdosed_human = M
	overdosed_human.hair_color = "15F" //blue hair, oh no
	overdosed_human.facial_hair_color = "15F"
	overdosed_human.update_hair()
	..()

/obj/item/reagent_containers/food/drinks/mug/green_tea //admin-only because there's no way to obtain a cup version of green tea
	name = "Bonzai Zen tea"
	desc = "A cup of traditional Space Japanese green tea. It is said that it soothes the soul, if drank properly."
	icon_state = "green_tea_cup" //actually unused because of how mugs work... ...for now.
	icon = 'maplestation_modules/icons/obj/drinks.dmi'
	list_reagents = list(/datum/reagent/consumable/green_tea = 30)

/datum/reagent/consumable/pilk
	name = "Pilk"
	description = "A horrid bubbling combination of milk and cola. You are a fucking alchemist and no-one can tell you otherwise."
	color = "#BEAE7E" // rgb: 190, 174, 126
	quality = -4 //this is godawful, though i dont think negative quality actually does anything
	nutriment_factor = 2 * REAGENTS_METABOLISM //somehow more filling than pure nutriment
	taste_description = "bubbles, milk, whatever the hell pepis is and a want to die" //pepis is canon now, its the rival brand to Space Cola. Renember to rename this to explicitly say pepis if it gets added in.
	glass_icon_state = "pilk" //the sprite has what is intended to be foam on top as pilk makes that in real life
	glass_icon_file = 'maplestation_modules/icons/obj/drinks.dmi'
	glass_name = "glass of pilk"
	glass_desc = "A horrid bubbling combination of milk and cola. You are a fucking alchemist and no-one can tell you otherwise."
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/pilk/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(!isfelinid(M)) //felinids love pilk
		if(isskeleton(M))
			M.adjustBruteLoss(1, 0) //ITS POISON
		else
			M.adjust_disgust(4 * REM * delta_time)
	else
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "full_on_pilk", /datum/mood_event/full_on_pilk, name)
	..()

/datum/reagent/consumable/ethanol/peg_nog
	name = "Peg Nog"
	description = "Its time to get PEGGED!"
	color = "#C1C17B" // rgb: 193, 193, 123
	quality = -6 //its somehow worse
	nutriment_factor = 3 * REAGENTS_METABOLISM //more filling
	boozepwr = 20
	taste_description = "getting pegged" //oh no
	glass_icon_state = "peg_nog"
	glass_icon_file = 'maplestation_modules/icons/obj/drinks.dmi'
	glass_name = "glass of peg nog"
	glass_desc = "Its time to get PEGGED!"
	glass_price = DRINK_PRICE_MEDIUM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/peg_nog/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(!isfelinid(M)) //felinids love peg nog too!
		if(isskeleton(M))
			M.adjustBruteLoss(2, 0) //when drinking this you wish for bone hurting juice
		else
			M.adjust_disgust(7 * REM * delta_time)
	else
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "pegged", /datum/mood_event/pegged, name)
	..()
