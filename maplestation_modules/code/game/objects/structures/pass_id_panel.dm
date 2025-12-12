MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel, 28)

/obj/machinery/password_id_panel
	name = "access panel"
	desc = "A panel that controls an airlock. It can be opened via ID card or password, if you know it."
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "keycardpad0"
	base_icon_state = "keycardpad"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF  // revisit when constructable
	mouse_over_pointer = MOUSE_HAND_POINTER
	armor_type = /datum/armor/machinery_button
	power_channel = AREA_USAGE_ENVIRON

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
	/// If TRUE, the panel is currently authorized to open the door.
	var/authorized = FALSE
	/// Cooldown between allowing ui to enter passwords.
	COOLDOWN_DECLARE(enter_cd)

/obj/machinery/password_id_panel/post_machine_initialize()
	. = ..()

	var/already_linked = FALSE
	for(var/obj/machinery/password_id_panel/other_panel as anything in find_panels())
		link_door(other_panel.linked_door)
		password = other_panel.password
		already_linked = TRUE

	if(already_linked)
		return

	if(password == "00000")
		password = randomize_password()
	for(var/job_type in password_jobs)
		GLOB.important_passwords[job_type] ||= list()
		GLOB.important_passwords[job_type][id_tag] = list("[PASSWORD_CODE]" = password, "[PASSWORD_LOCATION]" = password_location)

	var/obj/machinery/door/found_door = find_door()
	if(isnull(found_door))
		log_mapping("No door found with ID tag [id_tag] for password panel!")
		return

	link_door(found_door)

/// Returns all panels with the same id tag, excluding this one and panels not yet initialized.
/obj/machinery/password_id_panel/proc/find_panels()
	. = list()
	for(var/obj/machinery/password_id_panel/panel as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/password_id_panel))
		if(panel == src || panel.id_tag != id_tag)
			continue
		if(!panel.linked_door || panel.password == "00000")
			continue
		if(!is_valid_z_level(get_turf(src), get_turf(panel)))
			continue
		. += panel
	return .

/// Finds the first door which matches this panel's ID tag.
/obj/machinery/password_id_panel/proc/find_door()
	return find_by_id_tag(SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/airlock), id_tag)

/obj/machinery/password_id_panel/proc/link_door(obj/machinery/door/airlock/door)
	if(linked_door == door)
		CRASH("Attempted to link a password panel in [get_area_name(src, TRUE)] to the same door [door] twice!")
	if(linked_door)
		CRASH("Attempted to link a password panel in [get_area_name(src, TRUE)] to a second door [door] when it is already linked to [linked_door]!")
	linked_door = door
	RegisterSignal(linked_door, COMSIG_QDELETING, PROC_REF(on_linked_door_deleted))
	RegisterSignal(linked_door, COMSIG_AIRLOCK_CLOSE, PROC_REF(de_auth))
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
		UnregisterSignal(linked_door, COMSIG_AIRLOCK_CLOSE)
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

/obj/machinery/password_id_panel/proc/de_auth(...)
	SIGNAL_HANDLER
	authorized = FALSE
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
	return (valid_state() || (obj_flags & EMAGGED)) && check_access(id)

/// Verifies the current input is the correct password and the panel is in a valid state.
/obj/machinery/password_id_panel/proc/valid_code(mob/living/user)
	return (valid_state() || (obj_flags & EMAGGED)) && current_input == password

/// Additional checks that need to be true for the panel to work.
/obj/machinery/password_id_panel/proc/valid_state()
	return TRUE

/// Called when access is denied, either by ID or password.
/obj/machinery/password_id_panel/proc/access_denied(mob/user)
	balloon_alert(user, "access denied")
	if(linked_door?.doorDeni)
		playsound(src, linked_door?.doorDeni, 50, FALSE)

/// Called when access is granted, either by ID or password.
/obj/machinery/password_id_panel/proc/access_granted(mob/user)
	balloon_alert(user, "access granted")
	if(linked_door && !linked_door.operating)
		if(linked_door.density)
			linked_door.secure_open()
			authorized = TRUE
			update_appearance()
		else
			linked_door.secure_close()
	current_input = ""

/// Checks if the door is "locked"
/obj/machinery/password_id_panel/proc/is_locked()
	return !!linked_door && !authorized

/obj/machinery/password_id_panel/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][!is_operational || !is_locked()]"

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
				authorized = TRUE
				update_appearance()
			else
				access_denied(usr)
				current_input = ""
			return TRUE
		if("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
			if(length(current_input) == 5)
				return
			// if emagged, input is ignored and we just fill in the right character
			current_input += (obj_flags & EMAGGED) ? password[length(current_input) + 1] : digit
			return TRUE

/obj/machinery/password_id_panel/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE

	obj_flags |= EMAGGED
	playsound(src, SFX_SPARKS, 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	access_granted(user)
	if(emag_card)
		to_chat(user, span_notice("You swipe [emag_card] through [src], the magnetic strip causing sparks to fly!"))
		add_hiddenprint(user)
	else
		to_chat(user, span_notice("You tamper with [src], causing sparks to fly!"))
		add_fingerprint(user)
	current_input = password // now you know!
	authorized = TRUE
	update_appearance()
	return TRUE

/obj/machinery/password_id_panel/ninjadrain_act(mob/living/carbon/human/ninja, obj/item/mod/module/hacker/hacking_module)
	return emag_act(ninja, null) ? COMPONENT_CANCEL_ATTACK_CHAIN : NONE

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

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/armory, 28)

/obj/machinery/password_id_panel/execution
	id_tag = "EXECUTION_PASSWORD_PANEL"
	ai_accessible = FALSE
	req_access = list(ACCESS_ARMORY)
	password_jobs = list(
		/datum/job/head_of_security,
		/datum/job/warden,
	)
	password_location = "the Execution Chamber"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/execution, 28)

/obj/machinery/password_id_panel/visitation
	id_tag = "VISITATION_PASSWORD_PANEL"
	req_access = list(ACCESS_BRIG)
	password_jobs = list(
		/datum/job/head_of_security,
		/datum/job/security_officer,
		/datum/job/warden,
	)
	password_location = "the Visitation Area"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/visitation, 28)

/obj/machinery/password_id_panel/teleporter
	id_tag = "TELEPORTER_PASSWORD_PANEL"
	req_access = list(ACCESS_TELEPORTER)
	password_jobs = list(
		/datum/job/captain,
		/datum/job/chief_engineer,
		/datum/job/research_director,
	)
	password_location = "the Teleporter Room"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/teleporter, 28)

/obj/machinery/password_id_panel/eva
	id_tag = "EVA_PASSWORD_PANEL"
	req_access = list(ACCESS_EVA)
	password_jobs = list(
		/datum/job/chief_engineer,
		/datum/job/paramedic,
	)
	password_location = "EVA"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/eva, 28)

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

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/tech_storage, 28)

/obj/machinery/password_id_panel/telecomms
	id_tag = "TELECOMMS_PASSWORD_PANEL"
	req_access = list(ACCESS_TCOMMS)
	password_jobs = list(
		/datum/job/chief_engineer,
		/datum/job/station_engineer,
	)
	password_location = "the Telecomms Room"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/telecomms, 28)

/obj/machinery/password_id_panel/virology
	id_tag = "VIROLOGY_PASSWORD_PANEL"
	req_access = list(ACCESS_VIROLOGY)
	password_jobs = list(
		/datum/job/chief_medical_officer,
		/datum/job/doctor,
		/datum/job/virologist,
	)
	password_location = "the Virology Lab"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/virology, 28)

/obj/machinery/password_id_panel/crematorium
	id_tag = "CREMATORIUM_PASSWORD_PANEL"
	req_access = list(ACCESS_CREMATORIUM)
	password_jobs = list(
		/datum/job/chaplain,
	)
	password_location = "the Crematorium"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/crematorium, 28)

/obj/machinery/password_id_panel/vault
	id_tag = "VAULT_PASSWORD_PANEL"
	req_access = list(ACCESS_VAULT)
	password_jobs = list(
		/datum/job/captain,
		/datum/job/head_of_personnel,
		/datum/job/quartermaster,
	)
	password_location = "the Vault"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/vault, 28)

/obj/machinery/password_id_panel/gateway
	id_tag = "GATEWAY_PASSWORD_PANEL"
	req_access = list(ACCESS_GATEWAY)
	password_jobs = list(
		/datum/job/captain,
	)
	password_location = "the Gateway Room"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/password_id_panel/gateway, 28)
