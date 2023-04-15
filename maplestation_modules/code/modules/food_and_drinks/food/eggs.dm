///Eggcellent///

#define EGGS_BABY 50
#define EGGS_EASY 25
#define EGGS_NORMAL 10
#define EGGS_HARD 5
#define EGGS_TRUE_HERO 2
#define EGGS_NAMELESS_HERO 1

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
	var/mob/living/carbon/human/current_challenger = null
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
	/// I'll be honest I can't remember what this is for but if it doesn't have it it breaks
	var/amount_list_position = 1

/obj/item/food/omelette/eggcellent_plate/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_FOOD_CONSUMED, .proc/on_consume)

/obj/item/food/omelette/eggcellent_plate/attack(mob/living/guy, mob/living/user)
	if(!current_challenger)
		current_challenger = guy
		priority_announce("[current_challenger] has begun the Eggcellent Challenge! [current_challenger.p_they(TRUE)] [current_challenger.p_have()] [set_time] minutes to complete this task!", "Sacred Egg Enrichment Center")
	bite_consumption = rand(1, difficulty)
	timer_id = addtimer(CALLBACK(src, .proc/failed_eggs), set_time MINUTES, TIMER_STOPPABLE)
	. = ..()

/obj/item/food/omelette/eggcellent_plate/AltClick(mob/user)
	. = ..()
	if(!current_challenger)
		set_time = input(user, "Input minutes allowed for challenge", "Eggcellent Challenge") as num|null


/obj/item/food/omelette/eggcellent_plate/CtrlShiftClick(mob/user)
	. = ..()
	if(current_challenger)
		return
	var/list_len = length(difficulty_list)
	amount_list_position = (amount_list_position % list_len) + 1
	difficulty = difficulty_list[amount_list_position]
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
		if(!(EGGS_BABY || EGGS_EASY || EGGS_NORMAL || EGGS_HARD || EGGS_TRUE_HERO || EGGS_NAMELESS_HERO))
			CRASH("Non-applicable egg difficulty detected")
	balloon_alert(user, "Difficulty set to [diff_name]")

/obj/item/food/omelette/eggcellent_plate/examine(mob/user)
	. = ..()
	if(current_challenger && !(user == current_challenger))
		. += span_notice("It looks like [current_challenger] has already begun [current_challenger.p_their()] conquest of this dish. Attempting to assist [current_challenger.p_them()] would be an unimaginable sin.")
	else
		. += "The challenger will have [set_time] minutes to finish this dish."
		. += span_notice("Alt-Clicking this will allow you to change the amount of time that a challenger has to finish this dish.")
		. += "The current difficulty is set to [diff_name]"
		. += span_notice("Control-Shift-Clicking this will allow you to change the difficulty of the challenge.")
		if(difficulty <= EGGS_TRUE_HERO && set_time >= 45 || !(difficulty <= EGGS_TRUE_HERO) && set_time >= 30)
			var/below_time
			switch(difficulty)
				if(EGGS_TRUE_HERO || EGGS_NAMELESS_HERO)
					below_time = 45
				else
					below_time = 30
			. += span_tinynotice("To turn off Trial Run mode for the current difficulty, set timer below [below_time] minutes.")

/obj/item/food/omelette/eggcellent_plate/proc/on_consume(atom/eggs, mob/egg_eater, mob/egg_feeder)
	SIGNAL_HANDLER
	if(!isliving(usr))
		return
	if(usr == current_challenger)
		deltimer(timer_id)
		spawn_crown(usr)
		UnregisterSignal(src, COMSIG_FOOD_CONSUMED)
	else
		deltimer(timer_id)
		spawn_bomb(usr)
		priority_announce("[usr] has attempted to aid in [current_challenger]'s challenge, a sin which will not be forgiven. Measures have been taken to have [usr.p_them()] atone for this crime.", "Sacred Egg Enrichment Center")
		UnregisterSignal(src, COMSIG_FOOD_CONSUMED)

/obj/item/food/omelette/eggcellent_plate/proc/spawn_crown(mob/user)
	if(difficulty <= EGGS_TRUE_HERO && set_time >= 45 || !(difficulty <= EGGS_TRUE_HERO) && set_time >= 30)
		priority_announce("[current_challenger] has completed their test run of the Eggcellent Challenge! [current_challenger.p_they(TRUE)] can try again within a shorter timeframe to attempt to gain [current_challenger.p_their()] true prize!", "Sacred Egg Enrichment Center")
		return
	var/obj/item/clothing/head/crown
	if(difficulty == EGGS_BABY)
		priority_announce("[current_challenger] has finished [current_challenger.p_their()] 'My First Egg Challenge' playset! We're sure they'll grow up to be quite the capable warrior one day!", "Sacred Egg Enrichment Center")
		return
	else if (difficulty <= EGGS_TRUE_HERO)
		priority_announce("[current_challenger] has completed the challenge! [current_challenger.p_their(TRUE)] rightful crown has been delivered unto [current_challenger.p_them()]!", "Sacred Egg Enrichment Center")
		crown = /obj/item/clothing/head/eggcellent_hat
		crown.name = span_mind_control("Eggcellent Hat")
	else
		priority_announce("[current_challenger] has completed the challenge! [current_challenger.p_their(TRUE)] prize has been delivered unto [current_challenger.p_them()] according to their difficulty!", "Sacred Egg Enrichment Center")
		new /obj/item/clothing/head/eggcellent_hat(user.loc)
		switch(difficulty)
			if(EGGS_EASY)
				crown = /obj/item/clothing/head/cone
				crown.name = "Beginner's Crown"
			if(EGGS_NORMAL)
				crown = /obj/item/clothing/head/beret
				crown.desc = "A rather nice beret as a reward for completing the Eggcelent challenge."
			if(EGGS_HARD)
				crown = /obj/item/clothing/head/eggcellent_hat
				crown.desc = "Closer inspection shows this to be a cheap knockoff of the real deal. Still, it took a good amount of skill to get this far."
				crown.color = COLOR_VERY_SOFT_YELLOW // cheap materials went bad
	podspawn(list(
		"target" = get_turf(user),
		"style" = STYLE_BLUESPACE,
		"spawn" = crown,
	))

/obj/item/food/omelette/eggcellent_plate/proc/spawn_bomb(mob/user)
	var/obj/item/grenade/frag/P = new /obj/item/grenade/frag(user.loc)
	P.active = TRUE
	addtimer(CALLBACK(P, /obj/item/grenade/proc/detonate), rand(2,15))

/obj/item/food/omelette/eggcellent_plate/proc/failed_eggs()
	priority_announce("[current_challenger] has failed to finish [current_challenger.p_their()] quest in the given timeframe. Measures have been taken accordingly.", "Sacred Egg Enrichment Center")
	spawn_bomb(current_challenger)
	qdel(src)

#undef EGGS_BABY
#undef EGGS_EASY
#undef EGGS_NORMAL
#undef EGGS_HARD
#undef EGGS_TRUE_HERO
#undef EGGS_NAMELESS_HERO
