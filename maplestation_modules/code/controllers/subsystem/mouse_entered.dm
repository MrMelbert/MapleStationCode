/datum/controller/subsystem/mouse_entered
	var/list/sustained_hovers = list()

/atom/MouseEntered(location, control, params)
	. = ..()
	SSmouse_entered.sustained_hovers[usr.client] = src

/atom/MouseExited(location, control, params)
	. = ..()
	SSmouse_entered.sustained_hovers[usr.client] = null
