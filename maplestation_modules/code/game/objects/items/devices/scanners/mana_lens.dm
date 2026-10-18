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
	if (isturf(interacting_with)) // turfs should not ever have mana pools, doing this so it doesn't runtime
		return
	if (!interacting_with.mana_pool)
		balloon_alert(user, "object has no mana pool!")
		return
	balloon_alert(user, "mana amount: [interacting_with.mana_pool.amount]")
