#define STORY_LAZY_TEMPLATE_KEY_CONFIDENTIAL_WORKS "LT_CONFIDENTIALWORKS"

#define STORY_LAZY_TEMPLATE_KEY_LIST_ALL(...) list( \
	"Department of Confidential Works" = STORY_LAZY_TEMPLATE_KEY_CONFIDENTIAL_WORKS, \
)

/datum/lazy_template/story
	map_dir = "maplestation_modules/story_content/_maps/templates/lazy_templates"

/datum/lazy_template/story/confidential_works
	key = STORY_LAZY_TEMPLATE_KEY_CONFIDENTIAL_WORKS
	map_name = "library_confidential_works"

// version of the lazy template loader with story maps instead
ADMIN_VERB(load_story_lazy_template, R_ADMIN, "Load/Jump Story Lazy Template", "Loads a lazy template and/or jumps to it.", ADMIN_CATEGORY_EVENTS)
	var/list/choices = STORY_LAZY_TEMPLATE_KEY_LIST_ALL()
	var/choice = tgui_input_list(user, "Key?", "Lazy Loader", choices)
	if(!choice)
		return

	choice = choices[choice]
	if(!choice)
		to_chat(user, span_warning("No template with that key found, report this!"))
		return

	var/already_loaded = LAZYACCESS(SSmapping.loaded_lazy_templates, choice)
	var/force_load = FALSE
	if(already_loaded && (tgui_alert(user, "Template already loaded.", "", list("Jump", "Load Again")) == "Load Again"))
		force_load = TRUE

	var/datum/turf_reservation/reservation = SSmapping.lazy_load_template(choice, force = force_load)
	if(!reservation)
		to_chat(user, span_boldwarning("Failed to load template!"))
		return

	if(!isobserver(user.mob))
		SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/admin_ghost)
	user.mob.forceMove(reservation.bottom_left_turfs[1])

	message_admins("[key_name_admin(user)] has loaded lazy template '[choice]'")
	to_chat(user, span_boldnicegreen("Template loaded, you have been moved to the bottom left of the reservation."))
