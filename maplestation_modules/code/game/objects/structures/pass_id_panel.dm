/// Tracks what jobs know what passwords
/// Assoc - job type = list(password id = list("location" = place the password is for, "password" = the actual password))
GLOBAL_LIST_INIT(important_passwords, list())

#define PASSWORD_LOCATION "location"
#define PASSWORD_CODE "password"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel, 32)

/obj/machinery/password_id_panel
	name = "access panel"
	desc = "A panel that controls an airlock. It can be opened via ID card or password, if you know it."
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "keycardpad0"
	base_icon_state = "keycardpad"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	/// Password to open the door rather than having access from an ID card.
	var/password = "00000"
	/// What the user has currently inputted.
	var/current_input
	/// The door this panel is linked to.
	var/obj/machinery/door/airlock/linked_door
	/// If TRUE, the AI or silicons can tap the panel to open the door.
	var/ai_accessible = TRUE
	/// These job datums spawn with the memory of this password.
	var/list/password_jobs
	/// The location to use in the memory for this password.
	var/password_location

	COOLDOWN_DECLARE(enter_cd)

/obj/machinery/password_id_panel/post_machine_initialize()
	. = ..()
	if(password == "00000")
		password = randomize_password()
	for(var/job_type in password_jobs)
		GLOB.important_passwords[job_type] ||= list()
		GLOB.important_passwords[job_type][id_tag] = list("[PASSWORD_CODE]" = password, "[PASSWORD_LOCATION]" = password_location)

	linked_door = find_by_id_tag(SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/airlock), id_tag)
	if(isnull(linked_door))
		log_mapping("No door found with ID tag [id_tag] for password panel!")
		return

	RegisterSignal(linked_door, COMSIG_QDELETING, PROC_REF(on_linked_door_deleted))
	req_access = linked_door.req_access?.Copy()
	req_one_access = linked_door.req_one_access?.Copy()
	linked_door.can_open_with_hands = FALSE
	linked_door.safe = FALSE
	linked_door.autoclose = FALSE
	linked_door.secure_close()
	update_appearance()

/obj/machinery/password_id_panel/Destroy()
	if(!QDELETED(linked_door))
		linked_door.can_open_with_hands = initial(linked_door.can_open_with_hands)
		linked_door.safe = initial(linked_door.safe)
		linked_door.autoclose = initial(linked_door.autoclose)
		UnregisterSignal(linked_door, COMSIG_QDELETING)
	linked_door = null
	return ..()

/obj/machinery/password_id_panel/examine(mob/user)
	. = ..()
	if(user.mind?.assigned_role.type in password_jobs)
		. += span_green("You know the password: [password].")

/obj/machinery/password_id_panel/proc/on_linked_door_deleted(...)
	SIGNAL_HANDLER

	UnregisterSignal(linked_door, COMSIG_QDELETING)
	linked_door = null

	if(QDELING(src))
		return
	update_appearance()

/obj/machinery/password_id_panel/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/obj/item/card/id/id = tool.GetID()
	if(isnull(id))
		return NONE

	playsound(src, 'sound/machines/card_slide.ogg', 45, TRUE)
	if(!is_operational || !linked_door || !linked_door.is_operational)
		balloon_alert(user, "nothing happens!")
		return ITEM_INTERACT_BLOCKING
	if(!valid_id(user, id))
		access_denied(user)
		return ITEM_INTERACT_BLOCKING

	access_granted(user)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/password_id_panel/interact(mob/user)
	if(isAdminGhostAI(user) || issilicon(user))
		if(isAdminGhostAI(user) || ai_accessible)
			access_granted(user)
		else
			access_denied(user)
		return TRUE
	return ..()

/// Returns a random 5 digit password.
/obj/machinery/password_id_panel/proc/randomize_password()
	return "[rand(0, 9)][rand(0, 9)][rand(0, 9)][rand(0, 9)][rand(0, 9)]"

/// Verifies the passed ID card can open this door.
/obj/machinery/password_id_panel/proc/valid_id(mob/living/user, obj/item/card/id/id)
	return valid_state() && check_access(id)

/// Verifies the current input is the correct password and the panel is in a valid state.
/obj/machinery/password_id_panel/proc/valid_code(mob/living/user)
	return valid_state() && current_input == password

/// Additional checks that need to be true for the panel to work.
/obj/machinery/password_id_panel/proc/valid_state()
	return TRUE

/// Called when access is denied, either by ID or password.
/obj/machinery/password_id_panel/proc/access_denied(mob/user)
	balloon_alert(user, "access denied")
	if(linked_door?.density)
		linked_door?.run_animation(DOOR_DENY_ANIMATION)

/// Called when access is granted, either by ID or password.
/obj/machinery/password_id_panel/proc/access_granted(mob/user)
	balloon_alert(user, "access granted")
	if(linked_door)
		if(linked_door.density)
			linked_door.secure_open()
		else
			linked_door.secure_close()
	update_appearance()
	current_input = ""

/// Checks if the door is "locked", ie, shut and not actively opening
/obj/machinery/password_id_panel/proc/is_locked()
	return !!linked_door && linked_door.density && !linked_door.operating

/obj/machinery/password_id_panel/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][is_operational || !is_locked()]"

/obj/machinery/password_id_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LockedSafe", "Access Panel")
		ui.open()

/obj/machinery/password_id_panel/ui_data(mob/user)
	var/list/data = list()
	data["input_code"] = current_input || "*****"
	data["locked"] = is_locked()
	data["lock_code"] = TRUE
	return data

/obj/machinery/password_id_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || action != "keypad")
		return TRUE

	playsound(src, SFX_TERMINAL_TYPE, 40, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	var/digit = params["digit"]
	switch(digit)
		if("C")
			current_input = ""
			if(linked_door && !linked_door.density && !linked_door.operating)
				linked_door.secure_close()
			return TRUE
		if("E")
			if(!COOLDOWN_FINISHED(src, enter_cd))
				return
			COOLDOWN_START(src, enter_cd, 1 SECONDS)
			if(valid_code(usr))
				access_granted(usr)
			else
				access_denied(usr)
				current_input = ""
			return TRUE
		if("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
			if(length(current_input) == 5)
				return
			current_input += digit
			return TRUE

/datum/job/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	for(var/password_id, password_info in GLOB.important_passwords[type])
		spawned.add_mob_memory(/datum/memory/key/important_password, location = password_info[PASSWORD_LOCATION], password = password_info[PASSWORD_CODE])

/obj/machinery/password_id_panel/armory
	id_tag = "ARMORY_PASSWORD_PANEL"
	req_access = list(ACCESS_ARMORY)
	password_jobs = list(
		/datum/job/head_of_security,
		/datum/job/warden,
	)
	password_location = "the Armory"

/obj/machinery/password_id_panel/armory/valid_state()
	return SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_BLUE

/obj/machinery/password_id_panel/armory/examine(mob/user)
	. = ..()
	. += span_notice("All access attempts are denied unless the station is at [/datum/security_level/blue::name] alert or higher.")

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/armory, 32)

/obj/machinery/password_id_panel/execution
	id_tag = "EXECUTION_PASSWORD_PANEL"
	ai_accessible = FALSE
	req_access = list(ACCESS_ARMORY)
	password_jobs = list(
		/datum/job/head_of_security,
		/datum/job/warden,
	)
	password_location = "the Execution Chamber"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/execution, 32)

/obj/machinery/password_id_panel/visitation
	id_tag = "VISITATION_PASSWORD_PANEL"
	req_access = list(ACCESS_BRIG)
	password_jobs = list(
		/datum/job/head_of_security,
		/datum/job/security_officer,
		/datum/job/warden,
	)
	password_location = "the Visitation Area"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/visitation, 32)

/obj/machinery/password_id_panel/teleporter
	id_tag = "TELEPORTER_PASSWORD_PANEL"
	req_access = list(ACCESS_TELEPORTER)
	password_jobs = list(
		/datum/job/captain,
		/datum/job/chief_engineer,
		/datum/job/research_director,
	)
	password_location = "the Teleporter Room"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/teleporter, 32)

/obj/machinery/password_id_panel/eva
	id_tag = "EVA_PASSWORD_PANEL"
	req_access = list(ACCESS_EVA)
	password_jobs = list(
		/datum/job/chief_engineer,
		/datum/job/paramedic,
	)
	password_location = "EVA"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/eva, 32)

/obj/machinery/password_id_panel/tech_storage
	id_tag = "TECH_STORAGE_PASSWORD_PANEL"
	req_access = list(ACCESS_TECH_STORAGE)
	password_jobs = list(
		/datum/job/chief_engineer,
		/datum/job/research_director,
		/datum/job/roboticist,
		/datum/job/station_engineer,
	)
	password_location = "Tech Storage"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/tech_storage, 32)

/obj/machinery/password_id_panel/telecomms
	id_tag = "TELECOMMS_PASSWORD_PANEL"
	req_access = list(ACCESS_TCOMMS)
	password_jobs = list(
		/datum/job/chief_engineer,
		/datum/job/station_engineer,
	)
	password_location = "the Telecomms Room"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/telecomms, 32)

/obj/machinery/password_id_panel/virology
	id_tag = "VIROLOGY_PASSWORD_PANEL"
	req_access = list(ACCESS_VIROLOGY)
	password_jobs = list(
		/datum/job/chief_medical_officer,
		/datum/job/doctor,
		/datum/job/virologist,
	)
	password_location = "the Virology Lab"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/virology, 32)

/obj/machinery/password_id_panel/crematorium
	id_tag = "CREMATORIUM_PASSWORD_PANEL"
	req_access = list(ACCESS_CREMATORIUM)
	password_jobs = list(
		/datum/job/chaplain,
	)
	password_location = "the Crematorium"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/crematorium, 32)

/obj/machinery/password_id_panel/vault
	id_tag = "VAULT_PASSWORD_PANEL"
	req_access = list(ACCESS_VAULT)
	password_jobs = list(
		/datum/job/captain,
		/datum/job/head_of_personnel,
		/datum/job/quartermaster,
	)
	password_location = "the Vault"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/vault, 32)

/obj/machinery/password_id_panel/gateway
	id_tag = "GATEWAY_PASSWORD_PANEL"
	req_access = list(ACCESS_GATEWAY)
	password_jobs = list(
		/datum/job/captain,
	)
	password_location = "the Gateway Room"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/gateway, 32)
