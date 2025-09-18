SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_stage = INITSTAGE_EARLY
	/// The path to the title screen image
	var/file_path
	/// The icon to use for the title screen
	var/icon/icon
	/// The previous title screen icon (from the last round)
	var/icon/previous_icon
	/// Reference to the turf in the lobby, which is where we hold the title screen
	var/turf/closed/indestructible/splashscreen/splash_turf
	/// Holds the maptext that displays initialization information on the title screen
	var/init_stat_maptext
	/// Tracks when stats have been faded out for everyone
	var/stats_faded = FALSE
	/// Holds the maptext that displays the playing music on the title screen
	var/music_maptext

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

	music_maptext = ""
	music_maptext += "<span class='maptext'>"
	music_maptext += "<span class='big'>"
	music_maptext += "Now playing: [music_string]"
	music_maptext += "</span>"
	music_maptext += "</span>"

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
	if(isnum(seconds))
		seconds = round(seconds, 0.1)
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
	init_stat_maptext = "<span class='maptext'>"
	init_stat_maptext += "<span class='big'>"
	if(SSticker?.current_state == GAME_STATE_PREGAME)
		var/total_time_formatted = "[total_init_time]s"
		switch(total_init_time)
			if(0 to 60)
				total_time_formatted = "<font color='green'>[total_init_time]s</font>"
			if(60 to 120)
				total_time_formatted = "<font color='yellow'>[total_init_time]s</font>"
			if(120 to INFINITY)
				total_time_formatted = "<font color='red'>[total_init_time]s</font>"

		init_stat_maptext += "Game Ready! ([total_time_formatted])"
	else
		init_stat_maptext += "Initializing game"
		for(var/i in 1 to num_dots)
			init_stat_maptext += "."
	init_stat_maptext += "</span><br>"
	for(var/sstype in init_infos)
		var/list/init_data = init_infos[sstype]
		var/init_name = init_data[1]
		var/init_stage = init_data[2]
		var/init_time = isnum(init_data[3]) ? "([init_data[3]]s)" : ""
		init_stat_maptext += "<br>[init_name] [init_stage] [init_time]"
	init_stat_maptext += "<br></span>"
	for(var/mob/dead/new_player/lobbyguy as anything in GLOB.new_player_list)
		for(var/atom/movable/screen/lobby_init_text/text in lobbyguy.hud_used?.static_inventory)
			text.maptext = SStitle.init_stat_maptext

/// Simply fades out the initialization text
/datum/controller/subsystem/title/proc/fade_init_text()
	for(var/mob/dead/new_player/lobbyguy as anything in GLOB.new_player_list)
		for(var/atom/movable/screen/lobby_init_text/text in lobbyguy.hud_used?.static_inventory)
			animate(text, alpha = 0, time = 8 SECONDS)
	stats_faded = TRUE
