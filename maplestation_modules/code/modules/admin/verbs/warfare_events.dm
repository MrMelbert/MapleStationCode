/client/proc/warfareEvent()
	set name = "Start Warfare Module"
	set category = "Admin.Events"

	if(!holder || !check_rights(R_FUN))
		return

	holder.warfareEvent()

/datum/admins/proc/warfareEvent()
	if(!check_rights(R_FUN))
		return

	var/datum/warfare_event/ui = new(usr)
	ui.ui_interact(usr)

/datum/warfare_event
