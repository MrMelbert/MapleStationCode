// Eyepatches can also be worn with huds
/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "security eyepatch HUD" // just a rename.

/obj/item/clothing/glasses/eyepatch

/obj/item/clothing/glasses/eyepatch/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stackable_item, \
		wearables = list(/obj/item/clothing/glasses/hud), \
		wearable_descriptor = "a HUD", \
		can_stack = CALLBACK(src, PROC_REF(can_attach_hud)), \
	)

/obj/item/clothing/glasses/eyepatch/proc/can_attach_hud(obj/item/source, obj/item/clothing/glasses/hud/incoming_hud, mob/user)
	// Basically, stops you from attaching HUDglasses. We only want the ones with one eye covered.
	return !(incoming_hud.flags_cover & GLASSESCOVERSEYES)
