/// Removes all the loot and achievements from megafauna for bitrunning related
/mob/living/simple_animal/hostile/megafauna/proc/make_virtual_megafauna()
	var/new_max = clamp(maxHealth * 0.5, 600, 1300)
	maxHealth = new_max
	health = new_max

	true_spawn = FALSE

	// NON-MODULE CHANGE: its a proc here instead of an element so its just a singular var assignment
	achievement_type = null

	// remove the crusher loot element's arguments also to remove it appropriately
	RemoveElement(\
		/datum/element/crusher_loot,\
		trophy_type = crusher_loot,\
		guaranteed_drop = 0.6,\
		drop_immediately = del_on_death,\
	)

	loot.Cut()
	loot += /obj/structure/closet/crate/secure/bitrunning/encrypted
