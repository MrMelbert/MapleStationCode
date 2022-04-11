/datum/action/item_action/ritual_item
	name = "Draw Rune"
	desc = "Use your ritual item to create a powerful."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"

/datum/action/item_action/ritual_item/Grant(mob/M)
	if(!IS_CULTIST(M))
		Remove(owner)
		return

	. = ..()
	button.screen_loc = "6:157,4:-2"
	button.moved = "6:157,4:-2"

/datum/action/item_action/ritual_item/Trigger(trigger_flags)
	for(var/obj/item/held_item as anything in owner.held_items) // In case we were already holding a dagger
		if(istype(held_item, target.type))
			held_item.attack_self(owner)
			return
	var/obj/item/target_item = target
	if(owner.can_equip(target_item, ITEM_SLOT_HANDS))
		owner.temporarilyRemoveItemFromInventory(target_item)
		owner.put_in_hands(target_item)
		target_item.attack_self(owner)
		return

	if(!isliving(owner))
		to_chat(owner, span_warning("You lack the necessary living force for this action."))
		return

	var/mob/living/living_owner = owner
	if (living_owner.usable_hands <= 0)
		to_chat(living_owner, span_warning("You don't have any usable hands!"))
	else
		to_chat(living_owner, span_warning("Your hands are full!"))
