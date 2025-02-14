/obj/item/radio/headset/shell
	name = "headset shell"
	desc = "A portable shell integrated with a radio headset."
	icon = 'maplestation_modules/icons/obj/clothing/headsets.dmi'
	icon_state = "shell"
	worn_icon_state = "cent_headset"

/obj/item/radio/headset/shell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/shell, list(
		new /obj/item/circuit_component/headset()
	), SHELL_CAPACITY_SMALL)

/obj/item/circuit_component/headset
	display_name = "Headset"
	desc = "Used to send and receive radio messages."

	var/datum/port/input/message
	var/datum/port/input/send_message
	var/datum/port/input/send_radio_freq
	var/datum/port/input/send_radio
	var/datum/port/input/block_next_radio

	var/datum/port/output/radio_message
	var/datum/port/output/radio_freq
	var/datum/port/output/received_message
	var/datum/port/output/spoken_into
	var/datum/port/output/sent_message
	var/datum/port/output/failure
	var/datum/port/output/entity

	var/blocking_radio = FALSE
	var/obj/item/radio/headset/shell/attached_shell

/obj/item/circuit_component/headset/register_shell(atom/movable/shell)
	RegisterSignal(shell, COMSIG_RADIO_NEW_MESSAGE, PROC_REF(new_message))
	RegisterSignal(shell, COMSIG_RADIO_RECEIVE_MESSAGE, PROC_REF(received_message))
	attached_shell = shell

/obj/item/circuit_component/headset/unregister_shell(atom/movable/shell)
	UnregisterSignal(shell, list(COMSIG_RADIO_NEW_MESSAGE, COMSIG_RADIO_RECEIVE_MESSAGE))
	attached_shell = null

/obj/item/circuit_component/headset/populate_ports()
	message = add_input_port("Message", PORT_TYPE_STRING)
	send_radio_freq = add_input_port("Radio Frequency", PORT_TYPE_NUMBER)
	send_message = add_input_port("Message User", PORT_TYPE_SIGNAL)
	send_radio = add_input_port("Send Radio", PORT_TYPE_SIGNAL)

	block_next_radio = add_input_port("Block Next Message", PORT_TYPE_SIGNAL)

	radio_message = add_output_port("Message", PORT_TYPE_STRING)
	radio_freq = add_output_port("Radio Frequency", PORT_TYPE_NUMBER)
	received_message = add_output_port("Received Radio", PORT_TYPE_SIGNAL)
	spoken_into = add_output_port("Spoken Into", PORT_TYPE_SIGNAL)
	failure = add_output_port("Failed To Radio", PORT_TYPE_SIGNAL)
	sent_message = add_output_port("Successfully Sent Message", PORT_TYPE_SIGNAL)
	entity = add_output_port("User", PORT_TYPE_USER)

/obj/item/circuit_component/headset/proc/new_message(atom/source, mob/living/user, message, channel)
	SIGNAL_HANDLER

	radio_message.set_output(message)
	radio_freq.set_output(GLOB.radiochannels[channel])
	spoken_into.set_output(COMPONENT_SIGNAL)

	if (blocking_radio)
		to_chat(user, span_notice("As you speak, you are met with nothing but quiet static from [source]."))
		return COMPONENT_CANNOT_USE_RADIO

/obj/item/circuit_component/headset/proc/received_message(atom/source, list/data)
	SIGNAL_HANDLER

	radio_message.set_output(data["message"])
	radio_freq.set_output(data["frequency"])
	received_message.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/headset/input_received(datum/port/input/port)
	if (COMPONENT_TRIGGERED_BY(block_next_radio, port))
		blocking_radio = TRUE
		return

	if (COMPONENT_TRIGGERED_BY(send_message, port))
		to_chat(attached_shell.loc, "<span class='greenteamradio'>\[Circuit\] [capitalize("[attached_shell]")] beeps, \"[message.value]\"</span>")
		sent_message.set_output(COMPONENT_SIGNAL)
		return

	if (!COMPONENT_TRIGGERED_BY(send_radio, port))
		return

	if (is_within_radio_jammer_range(attached_shell))
		failure.set_output(COMPONENT_SIGNAL)
		return

	var/freq = send_radio_freq.value || attached_shell.get_frequency()

	if (freq != attached_shell.get_frequency())
		if (!("[freq]" in GLOB.reverseradiochannels))
			failure.set_output(COMPONENT_SIGNAL)
			return

		if (!(GLOB.reverseradiochannels["[freq]"] in attached_shell.channels))
			failure.set_output(COMPONENT_SIGNAL)
			return

	var/atom/movable/virtualspeaker/speaker = new(null, attached_shell, attached_shell)
	var/datum/signal/subspace/vocal/signal = new(attached_shell, freq, speaker, attached_shell.get_selected_language(), message.value, list(attached_shell.speech_span), list())
	INVOKE_ASYNC(src, PROC_REF(send_signal), signal)

/obj/item/circuit_component/headset/proc/send_signal(datum/signal/subspace/vocal/signal)
	signal.send_to_receivers()
	sent_message.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/headset/equipped(mob/user, slot)
	. = ..()
	if(iscarbon(user) && (slot & ITEM_SLOT_EARS))
		entity.set_output(user)
