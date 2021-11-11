
/datum/team/advanced_cult
	name = "Advanced Cult"
	member_name = "Cultist"
	var/datum/mind/original_cultist
	var/style

/datum/team/advanced_cult/New(starting_members)
	. = ..()
	if(starting_members && !islist(starting_members))
		original_cultist = starting_members

/datum/team/advanced_cult/Destroy(force, ...)
	original_cultist = null
	return ..()
