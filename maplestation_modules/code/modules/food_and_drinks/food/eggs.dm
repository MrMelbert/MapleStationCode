///Eggcellent///

// Difficulties (changes how many reagents per bite you can eat. With roughly 55+ reagents, this thing is SLOW.)
#define EGGS_BABY 50
#define EGGS_EASY 25
#define EGGS_NORMAL 10
#define EGGS_HARD 5
#define EGGS_TRUE_HERO 2
#define EGGS_NAMELESS_HERO 1

// The maximum time that you can set the challenge to in order to gain a prize
#define HIGH_DIF_TIME_LIM 20
#define LOW_DIF_TIME_LIM 15

/obj/item/food/omelette/eggcellent_plate	//FUCK THIS
	name = "The Eggcellent"
	desc = "A hulking mass of eggs, cheese, and chili. It comes with two biscuits to 'help' make the experience easier. If you eat all of it in one sitting, you might win a prize!"
	icon = 'maplestation_modules/icons/obj/food/eggs.dmi'
	icon_state = "eggcellent_plate"
	food_reagents = list(/datum/reagent/consumable/nutriment = 50, /datum/reagent/consumable/nutriment/vitamin = 5)
	bite_consumption = EGGS_TRUE_HERO
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("egg" = 1, "cheese" = 1, "biscuit" = 2, "obesity" = 10)
	foodtypes = MEAT | BREAKFAST | DAIRY | GRAIN
	/// Our challenger
	var/datum/weakref/current_challenger_weak = null
	/// The time given to finish
	var/timer_id
	/// The player's set time in minutes
	var/set_time = 10
	/// The upper limit on how many reagents are eaten per bite
	var/difficulty = EGGS_NORMAL
	/// List of all possible difficulties
	var/list/difficulty_list = list(EGGS_BABY, EGGS_EASY, EGGS_NORMAL, EGGS_HARD, EGGS_TRUE_HERO, EGGS_NAMELESS_HERO)
	/// Name of the difficulty
	var/diff_name = "Normal"

/obj/item/food/omelette/eggcellent_plate/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_FOOD_CONSUMED, PROC_REF(on_consume))
	RegisterSignal(src, COMSIG_FOOD_EATEN, PROC_REF(begin_challenge))

/obj/item/food/omelette/eggcellent_plate/proc/begin_challenge(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER
	if(!current_challenger_weak)
		current_challenger_weak = WEAKREF(eater)
		var/mob/living/current_challenger = eater
		peer_pressure("[current_challenger] has begun the Eggcellent Challenge! [current_challenger.p_They()] [current_challenger.p_have()] [set_time] minutes to complete this task!")
		timer_id = addtimer(CALLBACK(src, PROC_REF(failed_eggs)), set_time * 1 MINUTES, TIMER_STOPPABLE)
	bite_consumption = rand(1, difficulty)

/obj/item/food/omelette/eggcellent_plate/click_alt(mob/user)
	if(!current_challenger_weak)
		set_time = tgui_input_number(user, "Input minutes allowed for challenge", "Eggcellent Challenge", default = 10, max_value = 60, min_value = 1) || 10
	return CLICK_ACTION_SUCCESS

/obj/item/food/omelette/eggcellent_plate/click_ctrl_shift(mob/user)
	if(current_challenger_weak)
		return
	if (difficulty == EGGS_NAMELESS_HERO)
		difficulty = difficulty_list[difficulty_list.Find(EGGS_BABY)]
	else
		difficulty = difficulty_list[difficulty_list.Find(difficulty) + 1]
	switch(difficulty)
		if(EGGS_BABY)
			diff_name = "Baby's First Eggs"
		if(EGGS_EASY)
			diff_name = "Easy"
		if(EGGS_NORMAL)
			diff_name = "Normal"
		if(EGGS_HARD)
			diff_name = "Hard"
		if(EGGS_TRUE_HERO)
			diff_name = "TRUE HERO"
		if(EGGS_NAMELESS_HERO)
			diff_name = "NAMELESS HERO"
		else
			CRASH("Non-applicable egg difficulty detected")
	balloon_alert(user, "difficulty set to [diff_name]")

/obj/item/food/omelette/eggcellent_plate/examine(mob/user)
	. = ..()
	var/mob/living/current_challenger = current_challenger_weak?.resolve()
	if(!isnull(current_challenger) && current_challenger != user)
		. += span_notice("It looks like [current_challenger] has already begun [current_challenger.p_their()] conquest of this dish. Attempting to assist [current_challenger.p_them()] would be an unimaginable sin.")
	else
		. += "The challenger will have [set_time] minutes to finish this dish."
		. += span_notice("Alt-Clicking this will allow you to change the amount of time that a challenger has to finish this dish.")
		. += "The current difficulty is set to [diff_name]"
		. += span_notice("Control-Shift-Clicking this will allow you to change the difficulty of the challenge.")
		if((difficulty <= EGGS_TRUE_HERO && set_time >= HIGH_DIF_TIME_LIM) || ((difficulty > EGGS_TRUE_HERO) && set_time >= LOW_DIF_TIME_LIM))
			. += span_tinynotice("To turn off Trial Run mode for the current difficulty, set timer below [difficulty > EGGS_TRUE_HERO ? HIGH_DIF_TIME_LIM : LOW_DIF_TIME_LIM] minutes.")

/obj/item/food/omelette/eggcellent_plate/proc/on_consume(atom/eggs, mob/egg_eater, mob/egg_feeder)
	SIGNAL_HANDLER
	var/mob/living/current_challenger = current_challenger_weak.resolve()
	if(!isliving(egg_eater))
		return
	if(IS_WEAKREF_OF(egg_eater, current_challenger_weak))
		spawn_crown(egg_eater)
	else
		spawn_bomb(egg_eater)
		peer_pressure("[usr] has attempted to aid in [current_challenger]'s challenge, a sin which will not be forgiven. Measures have been taken to have [usr.p_them()] atone for this crime.")

	UnregisterSignal(src, COMSIG_FOOD_CONSUMED)
	UnregisterSignal(src, COMSIG_FOOD_EATEN)
	deltimer(timer_id)

/obj/item/food/omelette/eggcellent_plate/proc/spawn_crown(mob/user)
	var/mob/living/current_challenger = current_challenger_weak.resolve()
	if((difficulty <= EGGS_TRUE_HERO && set_time >= HIGH_DIF_TIME_LIM) || ((difficulty > EGGS_TRUE_HERO) && set_time >= LOW_DIF_TIME_LIM))
		peer_pressure("[current_challenger] has completed their test run of the Eggcellent Challenge! [current_challenger.p_They()] can try again within a shorter timeframe to attempt to gain [current_challenger.p_their()] true prize!")
		return
	var/obj/item/clothing/head/crown
	if(difficulty == EGGS_BABY)
		peer_pressure("[current_challenger] has finished [current_challenger.p_their()] 'My First Egg Challenge' playset! We're sure they'll grow up to be quite the capable warrior one day!")
		return
	else if (difficulty <= EGGS_TRUE_HERO)
		peer_pressure("[current_challenger] has completed the challenge! [current_challenger.p_Their()] rightful crown has been delivered unto [current_challenger.p_them()]!")
		crown = new /obj/item/clothing/head/eggcellent_hat
		crown.name = span_mind_control("Eggcellent Hat")
	else
		peer_pressure("[current_challenger] has completed the challenge! [current_challenger.p_Their()] prize has been delivered unto [current_challenger.p_them()] according to their difficulty!")
		switch(difficulty)
			if(EGGS_EASY)
				crown = new /obj/item/clothing/head/cone
				crown.name = "Beginner's Crown"
			if(EGGS_NORMAL)
				crown = new /obj/item/clothing/head/beret
				crown.desc = "A rather nice beret as a reward for completing the Eggcelent challenge."
			if(EGGS_HARD)
				crown = new /obj/item/clothing/head/eggcellent_hat
				crown.desc = "Closer inspection shows this to be a cheap knockoff of the real deal. Still, it took a good amount of skill to get this far."
				crown.color = COLOR_VERY_SOFT_YELLOW // cheap materials went bad
	podspawn(list(
		"target" = get_turf(user),
		"style" = /datum/pod_style/advanced,
		"spawn" = crown,
	))

/obj/item/food/omelette/eggcellent_plate/proc/spawn_bomb(mob/user)
	var/obj/item/grenade/frag/failure_grenade = new /obj/item/grenade/frag(user.loc)
	failure_grenade.active = TRUE
	addtimer(CALLBACK(failure_grenade, TYPE_PROC_REF(/obj/item/grenade, detonate), rand(0.2 SECONDS, 1.3 SECONDS)))

/obj/item/food/omelette/eggcellent_plate/proc/failed_eggs()
	var/mob/living/current_challenger = current_challenger_weak.resolve()
	peer_pressure("[current_challenger] has failed to finish [current_challenger.p_their()] quest in the given timeframe. Measures have been taken accordingly.")
	spawn_bomb(current_challenger)
	qdel(src)

/obj/item/food/omelette/eggcellent_plate/proc/peer_pressure(flavor_text)
	priority_announce(flavor_text, title = "Sacred House of Egg Learning & Litigation", has_important_message = TRUE, players = viewers(loc))

#undef EGGS_BABY
#undef EGGS_EASY
#undef EGGS_NORMAL
#undef EGGS_HARD
#undef EGGS_TRUE_HERO
#undef EGGS_NAMELESS_HERO

#undef HIGH_DIF_TIME_LIM
#undef LOW_DIF_TIME_LIM
