#define MAGIC_WAND_BASE_CAP 80
#define MAGIC_WAND_BASE_SOFTCAP 60
#define VANISHING_WAND_CAP 20
// wands, their main use is to initiate and manage player magic transfer alongside a few doodads down the lines
/datum/mana_pool/magic_wand
	maximum_mana_capacity = MAGIC_WAND_BASE_CAP
	amount = 0
	softcap = MAGIC_WAND_BASE_SOFTCAP

/datum/mana_pool/magic_wand/stable // same as above, just doesn't have a softcap, and has no risk of passing your cap
	softcap = MAGIC_WAND_BASE_CAP
	default_mana_transfer_ruleset = MANA_TRANSFER_SOFTCAP_NO_PASS

/datum/mana_pool/magic_wand/stable/vanishing
	softcap = VANISHING_WAND_CAP
	maximum_mana_capacity = VANISHING_WAND_CAP

/obj/item/magic_wand
	name = "Makeshift Wand"
	desc = "A 'wand' made out of scraps and reused office materials. Unless this is a part of your religion or something, you should probably ditch this for something better when you can."
	icon = 'maplestation_modules/icons/obj/magic/wands.dmi'
	icon_state = "makeshift"
	w_class = WEIGHT_CLASS_NORMAL // meant to be big and hard to store, additional reason to not use this
	has_initial_mana_pool = TRUE
	var/can_alter_user_transfer = TRUE
	var/can_be_cast_from = TRUE

/obj/item/magic_wand/get_initial_mana_pool_type()
	return /datum/mana_pool/magic_wand

/obj/item/magic_wand/interact_with_atom(atom/movable/interacting_with, mob/living/user, list/modifiers)
	if(isturf(interacting_with))
		return
	var/datum/mana_pool/target_mana_pool = interacting_with.mana_pool
	var/datum/mana_pool/wand_pool = mana_pool

	if(!target_mana_pool)
		return  // no response for this failing, as else it would proc on ~70% of things in the codebase
	if(ismob(interacting_with)) // todo: add exceptions for if we want leeching from mob pools, but i see no case that needs that just this yet
		balloon_alert(user, "can't take from this!")
		return
	if(!user.is_holding(src))
		return

	var/static/list/options = list("Yes", "No")
	var/transfer_confirmation
	var/already_transferring = (wand_pool in target_mana_pool.transferring_to)

	if (!already_transferring)
		transfer_confirmation = (tgui_alert(user, "Do you want to transfer mana from [interacting_with] into your [name]?", "Transfer Mana?", options) == "Yes")
		if(!transfer_confirmation || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
			return
		balloon_alert(user, "transferring mana...")
		target_mana_pool.start_transfer(wand_pool)
	else
		transfer_confirmation = (tgui_alert(user, "Do you want to break the transfer from [interacting_with] into your [name]?", "Break Transfer?", options) == "Yes")
		if(!transfer_confirmation || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
			return
		balloon_alert(user, "cancelled draw")
		target_mana_pool.stop_transfer(wand_pool)
		return

/obj/item/magic_wand/attack_self(mob/user, modifiers)
	. = ..()
	if(!can_alter_user_transfer)
		return
	var/datum/mana_pool/wand_pool = mana_pool
	var/datum/mana_pool/user_pool = user.mana_pool

	var/static/list/options = list("Yes", "No")
	var/transfer_confirmation
	var/already_transferring = (user_pool in wand_pool.transferring_to)

	if (!already_transferring)
		transfer_confirmation = (tgui_alert(user, "Do you want to transfer mana from the [name] into yourself?", "Transfer Mana?", options) == "Yes")
		if(!transfer_confirmation || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
			return
		balloon_alert(user, "transferring mana...")
		wand_pool.start_transfer(user_pool)
	else
		transfer_confirmation = (tgui_alert(user, "Do you want to break the transfer from the [name] into yourself?", "Break Transfer?", options) == "Yes")
		if(!transfer_confirmation || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
			return
		balloon_alert(user, "cancelled draw")
		wand_pool.stop_transfer(user_pool)
		return

/obj/item/magic_wand/equipped(mob/user, slot, initial)
	. = ..()
	if(can_be_cast_from)
		ADD_TRAIT(src, TRAIT_POOL_AVAILABLE_FOR_CAST, INNATE_TRAIT)

/obj/item/magic_wand/dropped(mob/user, silent)
	. = ..()
	if(can_be_cast_from) // paired with the equip logic, added here in case a subtype has other logic
		REMOVE_TRAIT(src, TRAIT_POOL_AVAILABLE_FOR_CAST, INNATE_TRAIT)

/obj/item/magic_wand/techie
	name = "Arcane Field Modulator"
	desc = "An overengineered device produced and researched on board to manipulate and move residual mana within objects."
	icon = 'maplestation_modules/icons/obj/magic/wands.dmi'
	icon_state = "techie"
	w_class = WEIGHT_CLASS_SMALL // Can actually fit in pockets

/obj/item/magic_wand/techie/get_initial_mana_pool_type()
	return /datum/mana_pool/magic_wand/stable

/obj/item/magic_wand/wooden
	name = "Gold-Capped Wooden Wand"
	desc = "A traditional wood body and gold capped wand. Can still manipulate mana surprisingly well for its simplicity."
	icon = 'maplestation_modules/icons/obj/magic/wands.dmi'
	icon_state = "wooden"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic_wand/wooden/get_initial_mana_pool_type()
	return /datum/mana_pool/magic_wand/stable

// currently singleton, but decoupled for sanity's sake incase someone wants to do something similar
/obj/item/magic_wand/temporary
	name = "Temporary Wand Basetype"
	desc = "An ephemeral wand created by the power of Coderbus. Its life span is only brief, and its existence is fleeting. "

	item_flags = ABSTRACT|DROPDEL
	can_alter_user_transfer = FALSE

/obj/item/magic_wand/temporary/equipped(mob/user, slot, initial) // no dropped ver cause this is on a dropdel
	. = ..()
	var/datum/mana_pool/wand_pool = mana_pool
	var/datum/mana_pool/user_pool = user.mana_pool
	wand_pool.start_transfer(user_pool)

// given by the pseudo-spell gained from the psionic quirk
/obj/item/magic_wand/temporary/psionic
	name = "Psychic Mana Tap"
	desc = "An 'extension' of your mind, which allows you to freely draw mana from a capable source"
	icon = 'icons/obj/weapons/hand.dmi'
	lefthand_file = 'icons/mob/inhands/items/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/touchspell_righthand.dmi'
	icon_state = "star"
	inhand_icon_state = "hivehand"
