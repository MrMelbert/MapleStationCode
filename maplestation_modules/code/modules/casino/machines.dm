// Random slot names, 1 free spin per machine, and a random amount of max money from 500 to 1 million credits.
/obj/machinery/computer/slot_machine/green
	name = "AGENT GREEN'S MEAN MACHINE"
	desc = "A sign on the side says \"ALL MACHINES START WITH 1 FREE SPIN!\""
	balance = 5
	/// Possible names that this machine can have.
	var/list/possible_names = list(
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
	// I went way overboard with these to be honest

/obj/machinery/computer/slot_machine/green/Initialize(mapload)
	. = ..()
	name = pick(possible_names)
	money = rand(500,1000000)
	this_slot_type = pick(world.file2list("maplestation_modules/strings/slots.txt"))

/obj/machinery/computer/slot_machine/green/examine(mob/user)
	. = ..()
	. += this_slot_type
	. += span_notice("All proceeds go to continued U.M.E.F. research into advanced gambling techniques!")

/obj/machinery/computer/slot_machine/boss
	name = "THE BOSS' PRIVATE SLOTS"
	desc = "Now THOSE are odds I like to see!"
	money = 1000000
	// Every symbol is a 7
	symbols = list("<font color='red'>7</font>" = 100)

/obj/machinery/roulette/green
	name = "AGENT GREEN'S BIG SPIN"
	anchored = TRUE
	// Names need to be set when you swipe the ID anyway, so these are more just suggestions
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
