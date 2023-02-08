//!!!!! WEE WOO WEE WOO BIG FUCKING WARNING ALERT !!!!

// THIS IS A FUCKING TEMPORARY FUCKING FILE UNTIL I PUT SPELLS INTO A THING THAT LETS MULTIPLE PEOPLE GET THEM WEE WEOO

// GOD CANNOT PUNISH YOU MORE THAN ME IF YOU LEAVE THIS IN


/mob/living/carbon/Initialize(mapload)
	. = ..()

	if (src.name == "Mista-Kor'Yesh")
		var/datum/action/cooldown/spell/pointed/convect/convect_spell = new /datum/action/cooldown/spell/pointed/convect
		convect_spell.Grant(src)
