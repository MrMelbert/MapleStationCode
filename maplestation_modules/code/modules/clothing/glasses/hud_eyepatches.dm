// Eyepatches can also be worn with huds
/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "security eyepatch HUD" // just a rename.

/obj/item/clothing/glasses/eyepatch

/obj/item/clothing/glasses/eyepatch/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stackable_item, \
		wearables = list(/obj/item/clothing/glasses/hud), \
		can_stack = CALLBACK(src, PROC_REF(can_attach_hud)), \
		on_drop = CALLBACK(src, PROC_REF(on_drop_patch)), \
	)

/obj/item/clothing/glasses/eyepatch/proc/can_attach_hud(obj/item/source, obj/item/clothing/glasses/hud/incoming_hud, mob/user)
	// Basically, stops you from attaching HUDglasses. We only want the ones with one eye covered.
	return (incoming_hud.flash_protect == 0 && incoming_hud.tint == 0)

/obj/item/clothing/glasses/eyepatch/proc/on_drop_patch(obj/item/clothing/glasses/hud/equipped_hud, mob/living/carbon/user, silent)
	if(!istype(user))
		return
	if(user.glasses != src)
		return
	// This is HUGE hack but hud glasses rely on the user.glasses var to be set to the hud glasses
	// If this ever changes this must be removed because then it will call dropped twice, which isn't bad but can be weird
	var/obj/item/pre_slot = user.glasses
	user.glasses = equipped_hud
	equipped_hud.dropped(user, silent)
	user.glasses = pre_slot
