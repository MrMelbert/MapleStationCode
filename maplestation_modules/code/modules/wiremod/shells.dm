
/obj/item/radio/headset/shell
	name = "headset shell"
	desc = "A portable shell integrated with a radio headset."
	icon = 'maplestation_modules/icons/obj/clothing/headsets.dmi'
	icon_state = "shell"

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
	var/datum/port/output/failure

	var/blocking_radio = FALSE

/obj/item/circuit_component/headset/register_shell(atom/movable/shell)
	RegisterSignal(shell, COMSIG_RADIO_NEW_MESSAGE, PROC_REF(new_message))
	RegisterSignal(shell, COMSIG_RADIO_RECEIVE_MESSAGE, PROC_REF(received_message))

/obj/item/circuit_component/headset/unregister_shell(atom/movable/shell)
	UnregisterSignal(shell, list(COMSIG_RADIO_NEW_MESSAGE, COMSIG_RADIO_RECEIVE_MESSAGE))

/obj/item/circuit_component/headset/populate_ports()
	message = add_input_port("Message", PORT_TYPE_STRING)
	send_message = add_input_port("Message User", PORT_TYPE_SIGNAL)
	send_radio_freq = add_input_port("Radio Frequency", PORT_TYPE_NUMBER)
	send_radio = add_input_port("Send Radio", PORT_TYPE_SIGNAL)

	block_next_radio = add_input_port("Block Next Message", PORT_TYPE_SIGNAL)

	radio_message = add_output_port("Message", PORT_TYPE_STRING)
	radio_freq = add_output_port("Radio Frequency", PORT_TYPE_NUMBER)
	received_message = add_output_port("Received Radio", PORT_TYPE_SIGNAL)
	spoken_into = add_output_port("Spoken Into", PORT_TYPE_SIGNAL)
	failure = add_output_port("Failed To Radio", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/headset/proc/new_message(datum/source, mob/living/user, message, channel)
	SIGNAL_HANDLER

	radio_message.set_output(message)
	radio_freq.set_output(GLOB.radiochannels[channel])
	spoken_into.set_output(COMPONENT_SIGNAL)

	if (blocking_radio)
		return COMPONENT_CANNOT_USE_RADIO

/obj/item/circuit_component/headset/proc/received_message(datum/source, list/data)
	SIGNAL_HANDLER

	radio_message.set_output(data["message"])
	radio_freq.set_output(data["frequency"])
	received_message.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/headset/input_received(datum/port/input/port)
	if (COMPONENT_TRIGGERED_BY)

