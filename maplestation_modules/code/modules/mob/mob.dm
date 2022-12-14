/mob
	/// Last time a client was connected to this mob.
	var/last_connection_time = 0

/mob/Logout()
	. = ..()
	last_connection_time = world.time
