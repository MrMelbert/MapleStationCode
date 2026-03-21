/// Sprite update, also moved the random names & descriptions from the green slots to normal slots. Now all slot machines on NT stations are gifts from U.M.E.F.!
/obj/machinery/computer/slot_machine
	icon = 'maplestation_modules/icons/obj/machines/computer.dmi'
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

/obj/machinery/computer/slot_machine/Initialize(mapload)
	. = ..()
	name = pick(possible_names)
	var/static/list/slot_type_descriptions
	if(!length(slot_type_descriptions))
		slot_type_descriptions = world.file2list("maplestation_modules/strings/slots.txt")
	if(length(slot_type_descriptions))
		this_slot_type = pick(slot_type_descriptions)

/obj/machinery/computer/slot_machine/examine(mob/user)
	. = ..()
	. += this_slot_type
	. += span_notice("All proceeds go to continued U.M.E.F. research into advanced gambling techniques!")
