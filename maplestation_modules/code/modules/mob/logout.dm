/// Extension of the mob/logout proc.

/mob/Logout()
	. = ..()
	last_connection_time = world.time
