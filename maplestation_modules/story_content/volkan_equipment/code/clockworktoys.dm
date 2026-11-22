#define SPECIAL_ATTACK_HEAL 1
#define SPECIAL_ATTACK_DAMAGE 2
#define SPECIAL_ATTACK_UTILITY 3
#define SPECIAL_ATTACK_OTHER 4

#define MAX_BATTLE_LENGTH 50

/obj/item/toy/mecha/clockwork
	name = "clockwork toy"
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/clockworkgifts.dmi'
	desc = "A metal clockwork toy with a small windup key underneath."
	icon_state = "bug"
	verb_say = "clicks"
	verb_ask = "ticks"
	verb_exclaim = "clacks"
	verb_yell = "clacks"
	max_combat_health = 4
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "Bzz!!!"

/obj/item/toy/mecha/clockwork/Initialize(mapload)
	. = ..()
	RemoveElement(/datum/element/series, /obj/item/toy/mecha, "Mini-Mecha action figures")
	AddElement(/datum/element/series, /obj/item/toy/mecha/clockwork, "CaLE's Handmade Clockwork Toys")

/**
* A Modular redo of this proc. It is the exact same thing as the original but with different verbs, etc. I want this cool thing but they are not plastic!
*/
/obj/item/toy/mecha/clockwork/mecha_brawl(obj/item/toy/mecha/attacker, mob/living/carbon/attacker_controller, mob/living/carbon/opponent)
	//A GOOD DAY FOR A SWELL BATTLE!
	attacker_controller.visible_message(span_danger("[attacker_controller.name] collides [attacker] with [src]! Looks like they're preparing for a little battle!"), \
						span_danger("You collide [attacker] into [src], sparking a battle!"), \
						span_hear("You hear metal clinking onto metal!"), COMBAT_MESSAGE_RANGE)

	/// Who's in control of the defender (src)?
	var/mob/living/carbon/src_controller = (opponent)? opponent : attacker_controller
	/// How long has the battle been going?
	var/battle_length = 0

	in_combat = TRUE
	attacker.in_combat = TRUE

	//1.5 second cooldown * 20 = 30 second cooldown after a fight
	timer = world.time + cooldown*cooldown_multiplier
	attacker.timer = world.time + attacker.cooldown*attacker.cooldown_multiplier

	sleep(1 SECONDS)
	//--THE BATTLE BEGINS--
	while(combat_health > 0 && attacker.combat_health > 0 && battle_length < MAX_BATTLE_LENGTH)
		if(!combat_sleep(0.5 SECONDS, attacker, attacker_controller, opponent)) //combat_sleep checks everything we need to have checked for combat to continue
			break

		//before we do anything - deal with charged attacks
		if(special_attack_charged)
			src_controller.visible_message(span_danger("[src] unleashes its special attack!!"), \
							span_danger("You unleash [src]'s special attack!"))
			special_attack_move(attacker)
		else if(attacker.special_attack_charged)

			attacker_controller.visible_message(span_danger("[attacker] unleashes its special attack!!"), \
								span_danger("You unleash [attacker]'s special attack!"))
			attacker.special_attack_move(src)
		else
			//process the cooldowns
			if(special_attack_cooldown > 0)
				special_attack_cooldown--
			if(attacker.special_attack_cooldown > 0)
				attacker.special_attack_cooldown--

			//combat commences
			switch(rand(1,8))
				if(1 to 3) //attacker wins
					if(attacker.special_attack_cooldown == 0 && attacker.combat_health <= round(attacker.max_combat_health/3)) //if health is less than 1/3 and special off CD, use it
						attacker.special_attack_charged = TRUE
						attacker_controller.visible_message(span_danger("[attacker] begins charging its special attack!!"), \
											span_danger("You begin charging [attacker]'s special attack!"))
					else //just attack
						attacker.SpinAnimation(5, 0)
						playsound(attacker, 'sound/effects/footstep/rustystep1.ogg', 30, TRUE)
						combat_health--
						attacker_controller.visible_message(span_danger("[attacker] devastates [src]!"), \
											span_danger("You ram [attacker] into [src]!"), \
											span_hear("You hear metal clinking!"), COMBAT_MESSAGE_RANGE)
						if(prob(5))
							combat_health--
							playsound(src, 'sound/effects/meteorimpact.ogg', 20, TRUE)
							attacker_controller.visible_message(span_boldwarning("...and lands a CRIPPLING BLOW!"), \
												span_boldwarning("...and you land a CRIPPLING blow on [src]!"), null, COMBAT_MESSAGE_RANGE)

				if(4) //both lose
					attacker.SpinAnimation(5, 0)
					SpinAnimation(5, 0)
					combat_health--
					attacker.combat_health--
					do_sparks(2, FALSE, src)
					do_sparks(2, FALSE, attacker)
					if(prob(50))
						attacker_controller.visible_message(span_danger("[attacker] and [src] clash dramatically, causing sparks to fly!"), \
											span_danger("[attacker] and [src] clash dramatically, causing sparks to fly!"), \
											span_hear("You hear metal clinking!"), COMBAT_MESSAGE_RANGE)
					else
						src_controller.visible_message(span_danger("[src] and [attacker] clash dramatically, causing sparks to fly!"), \
										span_danger("[src] and [attacker] clash dramatically, causing sparks to fly!"), \
										span_hear("You hear metal clinking!"), COMBAT_MESSAGE_RANGE)
				if(5) //both win
					playsound(attacker, 'sound/weapons/parry.ogg', 20, TRUE)
					if(prob(50))
						attacker_controller.visible_message(span_danger("[src]'s attack deflects off of [attacker]."), \
											span_danger("[src]'s attack deflects off of [attacker]."), \
											span_hear("You hear metal clinking!"), COMBAT_MESSAGE_RANGE)
					else
						src_controller.visible_message(span_danger("[attacker]'s attack deflects off of [src]."), \
										span_danger("[attacker]'s attack deflects off of [src]."), \
										span_hear("You hear metal clinking!"), COMBAT_MESSAGE_RANGE)

				if(6 to 8) //defender wins
					if(special_attack_cooldown == 0 && combat_health <= round(max_combat_health/3)) //if health is less than 1/3 and special off CD, use it
						special_attack_charged = TRUE
						src_controller.visible_message(span_danger("[src] begins charging its special attack!!"), \
										span_danger("You begin charging [src]'s special attack!"))
					else //just attack
						SpinAnimation(5, 0)
						playsound(src, 'sound/effects/footstep/rustystep1.ogg', 30, TRUE)
						attacker.combat_health--
						src_controller.visible_message(span_danger("[src] smashes [attacker]!"), \
										span_danger("You smash [src] into [attacker]!"), \
										span_hear("You hear metal clinking!"), COMBAT_MESSAGE_RANGE)
						if(prob(5))
							attacker.combat_health--
							playsound(attacker, 'sound/effects/meteorimpact.ogg', 20, TRUE)
							src_controller.visible_message(span_boldwarning("...and lands a CRIPPLING BLOW!"), \
											span_boldwarning("...and you land a CRIPPLING blow on [attacker]!"), null, COMBAT_MESSAGE_RANGE)
				else
					attacker_controller.visible_message(span_notice("[src] and [attacker] stand around awkwardly."), \
										span_notice("You don't know what to do next."))

		battle_length++
		sleep(0.5 SECONDS)

	/// Lines chosen for the winning mech
	var/list/winlines = list("Tktktktk!", "You hear a happy buzz!*")

	if(attacker.combat_health <= 0 && combat_health <= 0) //both lose
		playsound(src, 'sound/machines/warning-buzzer.ogg', 20, TRUE)
		attacker_controller.visible_message(span_boldnotice("MUTUALLY ASSURED DESTRUCTION!! [src] and [attacker] both end up losing!"), \
							span_boldnotice("Both [src] and [attacker] have lost!"))
	else if(attacker.combat_health <= 0) //src wins
		wins++
		attacker.losses++
		playsound(attacker, 'sound/effects/light_flicker.ogg', 20, TRUE)
		attacker_controller.visible_message(span_notice("[attacker] falls apart!"), \
							span_notice("[attacker] falls apart!"), null, COMBAT_MESSAGE_RANGE)
		say("[pick(winlines)]")
		src_controller.visible_message(span_notice("[src] destroys [attacker] and walks away victorious!"), \
						span_notice("You raise up [src] victoriously over [attacker]!"))
	else if (combat_health <= 0) //attacker wins
		attacker.wins++
		losses++
		playsound(src, 'sound/effects/light_flicker.ogg', 20, TRUE)
		src_controller.visible_message(span_notice("[src] collapses!"), \
						span_notice("[src] collapses!"), null, COMBAT_MESSAGE_RANGE)
		attacker.say("[pick(winlines)]")
		attacker_controller.visible_message(span_notice("[attacker] demolishes [src] and walks away victorious!"), \
							"[span_notice("You raise up [attacker] proudly over [src]")]!")
	else //both win?
		say("CLkclkclk!")
		//don't want to make this a one sided conversation
		quiet? attacker.say("CLkclkclk!") : attacker.say("Buzzes!*")

	in_combat = FALSE
	attacker.in_combat = FALSE

	combat_health = max_combat_health
	attacker.combat_health = attacker.max_combat_health

	return


/obj/item/toy/mecha/clockwork/snake
	name = "clockwork snake"
	icon_state = "snake"
	max_combat_health = 4
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "Sssssss..."

/obj/item/toy/mecha/clockwork/mothroach
	name = "clockwork mothroach"
	icon_state = "mothroach"
	max_combat_health = 5
	special_attack_type = SPECIAL_ATTACK_HEAL
	special_attack_cry = "Bzzzz!"

/obj/item/toy/mecha/clockwork/bird
	name = "clockwork parakeet"
	icon_state = "bird"
	max_combat_health = 3
	special_attack_type = SPECIAL_ATTACK_UTILITY
	special_attack_cry = "Keeek!"

/obj/item/toy/mecha/clockwork/cat
	name = "clockwork cat"
	icon_state = "cat"
	max_combat_health = 3
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "Meow!"
