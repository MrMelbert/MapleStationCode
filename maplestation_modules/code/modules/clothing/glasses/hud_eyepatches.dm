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
		on_drop = CALLBACK(src, PROC_REF(on_drop_patch)), \
	)

/obj/item/clothing/glasses/eyepatch/proc/can_attach_hud(obj/item/source, obj/item/clothing/glasses/hud/incoming_hud, mob/user)
	// Basically, stops you from attaching HUDglasses. We only want the ones with one eye covered.
	return !(incoming_hud.flags_cover & GLASSESCOVERSEYES)

/obj/item/clothing/glasses/eyepatch/proc/on_drop_patch(obj/item/clothing/glasses/hud/equipped_hud, mob/living/carbon/user, silent)
	if(!equipped_hud.hud_type)
		return

	// A bit of a hack but HUD code checks that user.glasses == equipped_hud
	// Which it is not here
	// So even though equipping the hud works fine, unequipping it will fail
	var/datum/atom_hud/our_hud = GLOB.huds[equipped_hud.hud_type]
	our_hud.hide_from(user)
