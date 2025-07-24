// wands, basically magic wrenches, their main use is to initiate and manage player magic transfer
/obj/item/magic_wand
	name = "Makeshift Wand"
	desc = "A 'wand' made out of scraps and reused office materials. Unless this is a part of your religion or something, you should probably ditch this for something better."
	icon = 'maplestation_modules/icons/obj/magic/wands.dmi'
	icon_state = "makeshift"
	w_class = WEIGHT_CLASS_NORMAL // meant to be big and hard to store, additional reason to not use this

/obj/item/magic_wand/interact_with_atom(atom/movable/interacting_with, mob/living/user, list/modifiers)
	var/datum/mana_pool/target_mana_pool = interacting_with.mana_pool
	var/datum/mana_pool/user_pool = user.mana_pool
	var/already_transferring = (user in mana_pool.transferring_to)

	if(!target_mana_pool)
		return  // no response for this failing, as else it would proc on ~70% of things in the codebase
	if(!user_pool) // potentially superfluous, but a failsafe
		balloon_alert(user, "you have no mana pool!")
		return
	if(ismob(interacting_with)) // todo: add exceptions for if we want leeching from mob pools
		balloon_alert(user, "can't take from this!")
		return
	if (already_transferring)
		balloon_alert(user, "canceled draw")
		mana_pool.stop_transfer(user.mana_pool)
		return
	if(!user.is_holding(src))
		balloon_alert(user, "firmly grasp it!")
		return

	var/static/list/options = list("Yes", "No")
	var/transfer_confirmation = (tgui_alert(user, "Do you want to transfer mana from [interacting_with]?", "Transfer Mana?", options) == "Yes")
	if(!transfer_confirmation || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
		return
	balloon_alert(user, "transferring mana....")
	target_mana_pool.start_transfer(user_pool)

/* /obj/item/magic_wand/attack_self(mob/user, modifiers)
	. = ..()
	var/already_transferring = (user in mana_pool.transferring_to)
	if (already_transferring)
		balloon_alert(user, "canceled draw")
		mana_pool.stop_transfer(user.mana_pool)
		return */
