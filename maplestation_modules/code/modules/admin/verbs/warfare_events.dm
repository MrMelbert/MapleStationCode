/client/proc/warfareEvent()
	set name = "Warfare Module"
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

/datum/force_event/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WarfareEvent")
		ui.open()

/datum/force_event/ui_state(mob/user)
	return GLOB.fun_state

/datum/force_event/ui_static_data(mob/user)
	var/static/list/category_to_icons
	if(!category_to_icons)
		category_to_icons = list(
			EVENT_CATEGORY_AI = "robot",
			EVENT_CATEGORY_ANOMALIES = "cloud-bolt",
			EVENT_CATEGORY_BUREAUCRATIC = "print",
			EVENT_CATEGORY_ENGINEERING = "wrench",
			EVENT_CATEGORY_ENTITIES = "ghost",
			EVENT_CATEGORY_FRIENDLY = "face-smile",
			EVENT_CATEGORY_HEALTH = "brain",
			EVENT_CATEGORY_HOLIDAY = "calendar",
			EVENT_CATEGORY_INVASION = "user-group",
			EVENT_CATEGORY_JANITORIAL = "bath",
			EVENT_CATEGORY_SPACE = "meteor",
			EVENT_CATEGORY_WIZARD = "hat-wizard",
		)
	var/list/data = list()

	var/list/categories_seen = list()
	var/list/categories = list()

	var/list/events = list()

	for(var/datum/round_event_control/event_control as anything in SSevents.control)
		//add category
		if(!categories_seen[event_control.category])
			categories_seen[event_control.category] = TRUE
			UNTYPED_LIST_ADD(categories, list(
				"name" = event_control.category,
				"icon" = category_to_icons[event_control.category],
			))
		//add event, with one value matching up the category
		UNTYPED_LIST_ADD(events, list(
			"name" = event_control.name,
			"description" = event_control.description,
			"type" = event_control.type,
			"category" = event_control.category,
			"has_customization" = !!length(event_control.admin_setup),
		))
	data["categories"] = categories
	data["events"] = events
	return data
