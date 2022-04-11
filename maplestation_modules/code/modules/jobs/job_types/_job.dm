// -- Job datum definitions --
/datum/job
	/// Bitflags of factions this job itself can be associated with.
	/// Alternative to checking for faction on the mind, since faction isn't very consistent
	var/faction_alignment

/datum/id_trim
	/// Icon file for the sechud.
	var/sechud_icon = 'icons/mob/huds/hud.dmi'
