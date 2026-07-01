/datum/mood_event/conditional/roundstart
	timeout = 5 MINUTES
	mood_change = 1
	description = "Another day, another dollar."

/datum/mood_event/conditional/roundstart/condition_fulfilled(mob/living/who, ...)
	return TRUE

/datum/mood_event/conditional/roundstart/stowaway
	mood_change = -1
	priority = 70

/datum/mood_event/conditional/roundstart/stowaway/add_effects(...)
	description = pick("Where am I..?", "I shouldn't be here...", "How did I even get here..?")

/datum/mood_event/conditional/roundstart/stowaway/condition_fulfilled(mob/living/who)
	return istype(who.mind?.assigned_role, /datum/job/stowaway)

// /datum/mood_event/conditional/roundstart/all_nighter
// 	mood_change = -2
// 	description = "Ugh, stayed up all night..."
// 	priority = 60

// /datum/mood_event/conditional/roundstart/all_nighter/condition_fulfilled(mob/living/who)
// 	return who.has_quirk(/datum/quirk/all_nighter)

/datum/mood_event/conditional/roundstart/caffeine_addict
	mood_change = -1
	description = "I need my morning coffee..."
	priority = 59

/datum/mood_event/conditional/roundstart/caffeine_addict/condition_fulfilled(mob/living/who)
	return who.has_quirk(/datum/quirk/caffeinated)

/datum/mood_event/conditional/roundstart/nt_fanatic
	mood_change = 2
	description = "I love working for Nanotrasen."
	priority = 52

/datum/mood_event/conditional/roundstart/nt_fanatic/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/nt/loyalist)

/datum/mood_event/conditional/roundstart/nt_hater
	mood_change = -2
	description = "Another day working for the company that ruined my life..."
	priority = 51

/datum/mood_event/conditional/roundstart/nt_hater/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/nt/disillusioned)

/datum/mood_event/conditional/roundstart/diligent
	mood_change = 2
	description = "Ready to get to work."
	priority = 50

/datum/mood_event/conditional/roundstart/diligent/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/slacking/diligent) || HAS_PERSONALITY(who, /datum/personality/industrious)

/datum/mood_event/conditional/roundstart/paranoid
	mood_change = 0
	description = "I hope nothing bad happens today..."
	priority = 49

/datum/mood_event/conditional/roundstart/paranoid/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/paranoid)

/datum/mood_event/conditional/roundstart/lazy
	mood_change = -1
	priority = 48

/datum/mood_event/conditional/roundstart/lazy/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/slacking/lazy)

//
//
//
//
//
//

/datum/mood_event/conditional/latejoin
	timeout = 2 MINUTES
	mood_change = 1
	description = "Late to the party."

/datum/mood_event/conditional/latejoin/condition_fulfilled(mob/living/who, ...)
	return TRUE

// /datum/mood_event/conditional/latejoin/all_nighter
// 	mood_change = -2
// 	description = "Ugh, stayed up all night... Missed my alarm..."
// 	priority = 60

// /datum/mood_event/conditional/latejoin/all_nighter/condition_fulfilled(mob/living/who)
// 	return who.has_quirk(/datum/quirk/all_nighter)

/datum/mood_event/conditional/latejoin/caffeine_addict
	mood_change = -1
	description = "Missed my alarm... I need my morning coffee."
	priority = 59

/datum/mood_event/conditional/latejoin/nt_fanatic
	mood_change = 2
	description = "I hope they forgive me for being late."
	priority = 52

/datum/mood_event/conditional/latejoin/nt_fanatic/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/nt/loyalist)

/datum/mood_event/conditional/latejoin/nt_hater
	mood_change = -2
	description = "I hope they don't fire me for being late..."
	priority = 51

/datum/mood_event/conditional/latejoin/nt_hater/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/nt/disillusioned)

/datum/mood_event/conditional/latejoin/diligent
	mood_change = -1
	description = "Can't believe I was late!"
	priority = 50

/datum/mood_event/conditional/latejoin/diligent/condition_fulfilled(mob/living/who)
	return HAS_PERSONALITY(who, /datum/personality/slacking/diligent) || HAS_PERSONALITY(who, /datum/personality/industrious)

/datum/mood_event/conditional/latejoin/paranoid
	mood_change = -1
	description = "I hope the station was safe while I was gone..."
	priority = 49
