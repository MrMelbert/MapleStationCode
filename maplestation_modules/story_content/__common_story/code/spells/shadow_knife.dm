/datum/action/cooldown/spell/conjure_item/ice_knife/shadow_knife
	name = "Shadow Knife"
	desc = "Summon a temporary knife from pure shadow."
	background_icon_state = "bg_cult"
	overlay_icon_state = "bg_cult_border"
	mana_cost = 0
	item_type = /obj/item/knife/combat/ice/shadow

	cooldown_time = 90 SECONDS
	invocation = "Tai'loda."

/obj/item/knife/combat/ice/shadow
	name = "shadow knife"
	color = "#000000"
	desc = "A knife made of concentrated shadow. It won't exist forever. Nothing does."
	force = 15
	throwforce = 15

/obj/item/knife/combat/ice/shadow/Initialize(mapload)
	. = ..()
	expire_time = world.time + 40 SECONDS
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

// Expires on drop unlike the regular knife.
/obj/item/knife/combat/ice/shadow/proc/on_drop(atom/source)
	expire()
