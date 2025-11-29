// wands, basically magic wrenches, their main use is to initiate and manage player magic transfer
/obj/item/magic_wand
	name = "Makeshift Wand"
	desc = "A 'wand' made out of scraps and reused office materials. Unless this is a part of your religion or something, you should probably ditch this for something better when you can."
	icon = 'maplestation_modules/icons/obj/magic/wands.dmi'
	icon_state = "makeshift"
	w_class = WEIGHT_CLASS_NORMAL // meant to be big and hard to store, additional reason to not use this

/obj/item/magic_wand/interact_with_atom(atom/movable/interacting_with, mob/living/user, list/modifiers)
	var/datum/mana_pool/target_mana_pool = interacting_with.mana_pool
	var/datum/mana_pool/user_pool = user.mana_pool

	if(!target_mana_pool)
		return  // no response for this failing, as else it would proc on ~70% of things in the codebase
	if(!user_pool) // potentially superfluous, but a failsafe
		balloon_alert(user, "you have no mana pool!")
		return
	if(ismob(interacting_with)) // todo: add exceptions for if we want leeching from mob pools
		balloon_alert(user, "can't take from this!")
		return

	var/already_transferring = (user in target_mana_pool.transferring_to)
	if (already_transferring)
		balloon_alert(user, "canceled draw")
		target_mana_pool.stop_transfer(user_pool)
		return
/*	if(!user.is_holding(src))
		balloon_alert(user, "firmly grasp it!")
		return */

	var/static/list/options = list("Yes", "No")
	var/transfer_confirmation = (tgui_alert(user, "Do you want to transfer mana from [interacting_with]?", "Transfer Mana?", options) == "Yes")
	if(!transfer_confirmation || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
		return
	balloon_alert(user, "transferring mana...")
	target_mana_pool.start_transfer(user_pool)

/* /obj/item/magic_wand/attack_self(mob/user, modifiers)
	. = ..()
	var/already_transferring = (user in mana_pool.transferring_to)
	if (already_transferring)
		balloon_alert(user, "canceled draw")
		mana_pool.stop_transfer(user.mana_pool)
		return */

/obj/item/magic_wand/techie
	name = "Arcane Field Modulator"
	desc = "An overengineered device produced and researched on board to manipulate and move residual mana within objects."
	icon = 'maplestation_modules/icons/obj/magic/wands.dmi'
	icon_state = "techie"
	w_class = WEIGHT_CLASS_SMALL // Can actually fit in pockets

/obj/item/magic_wand/wooden
	name = "Gold-Capped Wooden Wand"
	desc = "A traditional wood body and gold capped wand. Can still manipulate mana surprisingly well for its simplicity."
	icon = 'maplestation_modules/icons/obj/magic/wands.dmi'
	icon_state = "wooden"
	w_class = WEIGHT_CLASS_SMALL

// currently singleton, but decoupled for sanity's sake incase someone wants to do something similar
/obj/item/magic_wand/temporary
	name = "Temporary Wand Basetype"
	desc = "An ephemeral wand created by the power of Coderbus. Its life span is only brief, and its existence is fleeting. "

	item_flags = ABSTRACT|DROPDEL

// given by the pseudo-spell gained from the psionic quirk
/obj/item/magic_wand/temporary/psionic
	name = "Psychic Mana Tap"
	desc = "An 'extension' of your mind, which allows you to freely draw mana from a capable source"
	icon = 'icons/obj/weapons/hand.dmi'
	lefthand_file = 'icons/mob/inhands/items/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/touchspell_righthand.dmi'
	icon_state = "star"
	inhand_icon_state = "hivehand"
