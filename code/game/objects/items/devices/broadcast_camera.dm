// Unique broadcast camera given to the first Curator
// Only one should exist ideally, if other types are created they must have different camera_networks
// Broadcasts its surroundings to entertainment monitors and its audio to entertainment radio channel
/obj/item/broadcast_camera
	name = "broadcast camera"
	desc = "A large camera that streams its live feed and audio to entertainment monitors across the station, allowing everyone to watch the broadcast."
	desc_controls = "Right-click to change the broadcast name. Alt-click to toggle microphone."
	icon = 'icons/obj/service/broadcast.dmi'
	icon_state = "broadcast_cam0"
	base_icon_state = "broadcast_cam"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	force = 8
	throwforce = 12
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = INDESTRUCTIBLE
	slot_flags = NONE
	light_system = MOVABLE_LIGHT
	light_color = COLOR_SOFT_RED
	light_range = 1
	light_power = 0.3
	light_on = FALSE
	/// Is the microphone turned on
	var/active_microphone = TRUE
	/// The name of the broadcast
	var/broadcast_name = "Curator News"
	/// The networks it broadcasts to, default is CAMERANET_NETWORK_CURATOR
	var/list/camera_networks = list(CAMERANET_NETWORK_CURATOR)
	/// The "virtual" security camera inside of the physical camera
	var/obj/machinery/camera/internal_camera
	/// The "virtual" radio inside of the the physical camera, a la microphone
	var/obj/item/radio/entertainment/microphone/internal_radio

/obj/item/broadcast_camera/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, ALL)
	AddComponent(/datum/component/two_handed, \
		force_unwielded = 8, \
		force_wielded = 12, \
		icon_wielded = "[base_icon_state]1", \
		wield_callback = CALLBACK(src, PROC_REF(on_wield)), \
		unwield_callback = CALLBACK(src, PROC_REF(on_unwield)), \
	)

/obj/item/broadcast_camera/Destroy(force)
	QDEL_NULL(internal_radio)
	QDEL_NULL(internal_camera)

	return ..()

/obj/item/broadcast_camera/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/broadcast_camera/attack_self_secondary(mob/user, modifiers)
	. = ..()
	broadcast_name = tgui_input_text(user = user, title = "Broadcast Name", message = "What will be the name of your broadcast?", default = "[broadcast_name]", max_length = MAX_CHARTER_LEN)

/obj/item/broadcast_camera/examine(mob/user)
	. = ..()
	. += span_notice("The broadcast name is <b>[broadcast_name]</b>.")
	. += span_notice("The microphone is <b>[active_microphone ? "on" : "off"]</b>.")

/// When wielding the camera
/obj/item/broadcast_camera/proc/on_wield()
	if(!iscarbon(loc))
		return
	/// The carbon who wielded the camera, allegedly
	var/mob/living/carbon/wielding_carbon = loc

	// INTERNAL CAMERA
	internal_camera = new(wielding_carbon) // Cameras for some reason do not work inside of obj's
	internal_camera.internal_light = FALSE
	internal_camera.network = camera_networks
	internal_camera.c_tag = "LIVE: [broadcast_name]"
	start_broadcasting_network(camera_networks, "[broadcast_name] is now LIVE!")

	// INTERNAL RADIO
	internal_radio = new(src)
	// Sets the state of the microphone
	set_microphone_state()

	set_light_on(TRUE)
	playsound(source = src, soundin = 'sound/machines/terminal_processing.ogg', vol = 20, vary = FALSE, ignore_walls = FALSE)
	balloon_alert_to_viewers("live!")

/// When unwielding the camera
/obj/item/broadcast_camera/proc/on_unwield()
	QDEL_NULL(internal_camera)
	QDEL_NULL(internal_radio)

	stop_broadcasting_network(camera_networks)

	set_light_on(FALSE)
	playsound(source = src, soundin = 'sound/machines/terminal_prompt_deny.ogg', vol = 20, vary = FALSE, ignore_walls = FALSE)
	balloon_alert_to_viewers("offline")

/obj/item/broadcast_camera/AltClick(mob/user)
	. = ..()
	if(. == FALSE || !user.can_perform_action(src, NEED_DEXTERITY|ALLOW_RESTING|FORBID_TELEKINESIS_REACH))
		return

	active_microphone = !active_microphone

	// Text popup for letting the user know that the microphone has changed state
	balloon_alert(user, "microphone [active_microphone ? "on" : "off"]")

	// If the radio exists as an object, set its state accordingly
	set_microphone_state()

/obj/item/broadcast_camera/proc/set_microphone_state()
	internal_radio?.set_broadcasting(active_microphone)
