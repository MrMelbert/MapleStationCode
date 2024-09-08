// as of part one, this is just for the prototype. more will be added with higher report detail/verbosity
/obj/item/mana_lens
	name = "Prototype Mana Lens"
	icon = 'maplestation_modules/icons/obj/devices.dmi'
	icon_state = "mana_lens"
	desc = "A prototypical device used to read out the current amount of mana within a subject. The ergonomics are terrible."
	item_flags = NOBLUDGEON
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	drop_sound = 'maplestation_modules/sound/items/drop/device2.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/device.ogg'

/obj/item/mana_lens/interact_with_atom(atom/movable/interacting_with, mob/living/user)
	if (!interacting_with.mana_pool)
		balloon_alert(user, "object has no mana pool!")
		return
	balloon_alert(user, "mana amount: [interacting_with.mana_pool.amount]")

/datum/design/proto_mana_lens
	name = "Prototype Mana Lens"
	desc = "The first prototype of a device capable of reading the prescence of mana."
	id = "mana_lens"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2.5, /datum/material/gold = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/mana_lens

/datum/techweb_node/mana_base
	id = "mana_base"
	starting_node = TRUE
	display_name = "Early Magical Tech"
	description = "The first bits of technology surronding magic."
	design_ids = list(
		"mana_lens", // more will be added to this
	)
