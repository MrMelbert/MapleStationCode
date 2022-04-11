/// -- Modular presets for tablets, I guess if you really wanted to. --
/obj/item/modular_computer/tablet/preset/advanced/command/cargo/Initialize()
	. = ..()
	var/obj/item/computer_hardware/hard_drive/small/hard_drive = find_hardware_by_name("solid state drive")
	hard_drive.store_file(new /datum/computer_file/program/shipping)
