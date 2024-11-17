/obj/machinery/computer/slot_machine
	icon = 'maplestation_modules/icons/obj/machines/computer.dmi'


// Random slot names, 1 free spin per machine, random extra description of what it looks like, and a random amount of max money from 500 to 1 million credits.
/obj/machinery/computer/slot_machine/green
	name = "AGENT GREEN'S MEAN MACHINE"
	desc = "A sign on the side says \"ALL MACHINES START WITH 1 FREE SPIN!\""
	balance = 5
	/// Possible names that this machine can have.
	var/static/list/possible_names = list(
		"AGENT GREEN'S MEAN MACHINE",
		"BOSS BUX",
		"PAYCHECK QUEST",
		"RICKOLO'S RICHES",
		"GLAN'S GOLD",
		"RITZ'S RACKS",
		"AGENT RUSH",
		"AGENT BIG WIN",
		"THE BOSS ZHU ZHAO FU",
		"DR. MONSTER'S MONSTER WINS",
		"SUPER BUFFALO",
		"BOSS KINGS",
		"AGENT BUFFALO",
	)
	/// Added descriptor of what the machine looks like.
	var/this_slot_type = "It's a standard slot machine housing some mechanical reels with symbols on each one."

/obj/machinery/computer/slot_machine/green/Initialize(mapload)
	. = ..()
	name = pick(possible_names)
	money = rand(500,1000000)
	this_slot_type = pick(GLOB.slot_type_descriptions)

/obj/machinery/computer/slot_machine/green/examine(mob/user)
	. = ..()
	. += this_slot_type
	. += span_notice("All proceeds go to continued U.M.E.F. research into advanced gambling techniques!")

/// Always Jackpots
/obj/machinery/computer/slot_machine/boss
	name = "THE BOSS' PRIVATE SLOTS"
	desc = "Now THOSE are odds I like to see!"
	money = 1000000

// It DOES always jackpot though the visuals aren't always matching that fact
/obj/machinery/computer/slot_machine/boss/ui_static_data(mob/user)
	var/list/data = ..()
	data["icons"] = list(list(
		"icon" = FA_ICON_7,
		"value" = 1,
		"colour" = "red"
		))
	return data

/obj/machinery/roulette/green
	name = "AGENT GREEN'S BIG SPIN"
	anchored = TRUE
	// Names need to be set when you swipe the ID anyway, so these are more just suggestions.
	// We didn't realize that when we made it lol.
	var/list/possible_names = list(
		"AGENT GREEN'S BIG SPIN",
		"AGENT SPIN'S ADVENTURE",
	)

/obj/machinery/roulette/green/Initialize(mapload)
	. = ..()
	name = pick(possible_names)

/obj/machinery/biogenerator/infinite
	biomass = INFINITY
	max_output = 300
