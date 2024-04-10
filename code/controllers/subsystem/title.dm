SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE
	init_stage = INITSTAGE_EARLY
	/// The path to the title screen image
	var/file_path
	/// The icon to use for the title screen
	var/icon/icon
	/// The previous title screen icon (from the last round)
	var/icon/previous_icon
	/// Reference to the turf in the lobby, which is where we hold the title screen
	var/turf/closed/indestructible/splashscreen/splash_turf
	/// A holder for maptext that displays initialization information on the title screen
	var/obj/effect/abstract/maptext_holder/init/init_stat_holder
	/// A holder for maptext that displays the playing music on the title screen
	var/obj/effect/abstract/maptext_holder/music/music_holder

	/// A list of initialization information
	var/list/init_infos = list()
	/// Tracks the number of dots to display
	var/num_dots = 1
	/// The total time taken to initialize the game
	var/total_init_time = -1

/datum/controller/subsystem/title/Initialize()
	if(file_path && icon)
		return SS_INIT_SUCCESS

	if(fexists("data/previous_title.dat"))
		var/previous_path = file2text("data/previous_title.dat")
		if(istext(previous_path))
			previous_icon = new(previous_icon)
	fdel("data/previous_title.dat")

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()
	var/use_rare_screens = prob(1)

	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if((L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png")) || (L.len > 1 && ((use_rare_screens && LOWER_TEXT(L[1]) == "rare") || (LOWER_TEXT(L[1]) == LOWER_TEXT(SSmapping.config.map_name)))))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/runtime/default_title.dmi"

	ASSERT(fexists(file_path))

	icon = new(fcopy_rsc(file_path))

	if(splash_turf)
		splash_turf.icon = icon
		splash_turf.handle_generic_titlescreen_sizes()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/title/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				if(splash_turf)
					splash_turf.icon = icon

/datum/controller/subsystem/title/Shutdown()
	if(file_path)
		var/F = file("data/previous_title.dat")
		WRITE_FILE(F, file_path)

	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/atom/movable/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)

/datum/controller/subsystem/title/Recover()
	icon = SStitle.icon
	splash_turf = SStitle.splash_turf
	file_path = SStitle.file_path
	previous_icon = SStitle.previous_icon
	init_infos = SStitle.init_infos

/// Updates the text displayed on the title screen for lobby music
/datum/controller/subsystem/title/proc/update_music_text(music_string)
	if(CONFIG_GET(flag/disallow_title_music))
		return
	if(!music_string)
		return
	if(!music_holder)
		if(!splash_turf)
			return
		music_holder = new(splash_turf)

	music_holder.pixel_x = initial(music_holder.pixel_x) - (length(music_string) * 8)
	music_holder.maptext = ""
	music_holder.maptext += "<span class='maptext'>"
	music_holder.maptext += "<span class='big'>"
	music_holder.maptext += "Now playing: [music_string]"
	music_holder.maptext += "</span>"
	music_holder.maptext += "</span>"

/// Max number of init entries to display
/// If this is exceeded, the oldest entry will be removed (but it generally should not be exceeded)
#define MAX_INIT_TEXT 40

/**
 * Adds an entry to the initialization information list
 *
 * * init_category: The category of the initialization information - this must be a unique key, such as a typepath.
 * Tt's not displayed to the player, so don't worry about making it pretty.
 * * name: The name of the initialization information. This is displayed to the player.
 * * stage: The "stage" of the initialization information, such as "loading" / "complete" / "failed".
 * * seconds: The number of seconds this initialization information took. Optional.
 * * override: If TRUE, this will overwrite any existing entry with the same init_category.
 * Othewise, it will try to update the existing entry's state and time.
 * * major_update: Indicates this init text is a major update, which will update a "dot" animation.
 */
/datum/controller/subsystem/title/proc/add_init_text(init_category, name, stage, seconds, override = FALSE, major_update = FALSE)
	if(override || !init_infos[init_category])
		init_infos[init_category] = list(name, stage, seconds)
	else
		init_infos[init_category][2] = stage
		init_infos[init_category][3] += seconds
	if(major_update)
		num_dots = (num_dots % 6 + 1)
	if(length(init_infos) > MAX_INIT_TEXT)
		init_infos.Cut(1, length(init_infos) - MAX_INIT_TEXT + 1)
	update_init_text()

#undef MAX_INIT_TEXT

/// Removes the passed category from the initialization information list
/datum/controller/subsystem/title/proc/remove_init_text(init_category)
	init_infos -= init_category
	update_init_text()

/// Updates the displayed initialization text according to all initialization information
/datum/controller/subsystem/title/proc/update_init_text()
	if(!init_stat_holder)
		if(!splash_turf)
			return
		init_stat_holder = new(splash_turf)

	init_stat_holder.maptext = "<span class='maptext'>"
	init_stat_holder.maptext += "<span class='big'>"
	if(SSticker?.current_state == GAME_STATE_PREGAME)
		var/total_time_formatted = "[total_init_time]s"
		switch(total_init_time)
			if(0 to 60)
				total_time_formatted = "<font color='green'>[total_init_time]s</font>"
			if(60 to 120)
				total_time_formatted = "<font color='yellow'>[total_init_time]s</font>"
			if(120 to INFINITY)
				total_time_formatted = "<font color='red'>[total_init_time]s</font>"

		init_stat_holder.maptext += "Game Ready! ([total_time_formatted])"
	else
		init_stat_holder.maptext += "Initializing game"
		for(var/i in 1 to num_dots)
			init_stat_holder.maptext += "."
	init_stat_holder.maptext += "</span><br>"
	for(var/sstype in init_infos)
		var/list/init_data = init_infos[sstype]
		var/init_name = init_data[1]
		var/init_stage = init_data[2]
		var/init_time = isnum(init_data[3]) ? "([init_data[3]]s)" : ""
		init_stat_holder.maptext += "<br>[init_name] [init_stage] [init_time]"
	init_stat_holder.maptext += "<br></span>"

/// Simply fades out the initialization text
/datum/controller/subsystem/title/proc/fade_init_text()
	update_init_text()
	animate(init_stat_holder, alpha = 0, time = 8 SECONDS)

/// Abstract holder for maptext on the lobby screen
/obj/effect/abstract/maptext_holder
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = SPLASHSCREEN_PLANE
	/// Conceals the holder from clients who don't want to see it
	var/image/hide_me

/obj/effect/abstract/maptext_holder/Initialize(mapload)
	. = ..()
	for(var/mob/dead/new_player/lobby_goer as anything in GLOB.new_player_list)
		check_client(lobby_goer.client)

/// Check if the client should see or should not see the initialization information. Updates accordingly.
/obj/effect/abstract/maptext_holder/proc/check_client(client/seer)
	if(isnull(seer))
		return
	if(!check_preferences(seer))
		hide_from_client(seer)
		return
	show_to_client(seer)

/// Return TRUE if this maptext holder should be visible to the client
/obj/effect/abstract/maptext_holder/proc/check_preferences(client/seer)
	// default check for widescreen, because elements at the edge of the screen are cut off and i'm too lazy to fix it
	return seer.prefs.read_preference(/datum/preference/toggle/widescreen)

/// Hides the initialization information from the client
/obj/effect/abstract/maptext_holder/proc/hide_from_client(client/seer)
	if(isnull(hide_me))
		hide_me = image(loc = src)
		hide_me.override = TRUE
	seer?.images |= hide_me

/// Shows the initialization information to the client (if already hidden, otherwise nothing happens)
/obj/effect/abstract/maptext_holder/proc/show_to_client(client/seer)
	seer?.images -= hide_me

/obj/effect/abstract/maptext_holder/init
	maptext_height = 500
	maptext_width = 200
	maptext_x = 12
	maptext_y = 12
	pixel_x = -64

/obj/effect/abstract/maptext_holder/init/check_preferences(client/seer)
	return ..() && seer.prefs.read_preference(/datum/preference/toggle/show_init_stats)

/obj/effect/abstract/maptext_holder/music
	icon = 'maplestation_modules/icons/hud/lobby_spinner.dmi'
	icon_state = "spinner"
	maptext_height = 64
	maptext_width = 200
	maptext_x = 36
	maptext_y = 6
	pixel_y = 6
	pixel_x = 420

/obj/effect/abstract/maptext_holder/music/check_preferences(client/seer)
	return ..() && seer.prefs.read_preference(/datum/preference/toggle/sound_lobby)
