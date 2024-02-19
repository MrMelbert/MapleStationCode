/obj/item/clothing/head/wig/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stackable_item, \
		wearables = list(/obj/item/clothing/head), \
		wearable_descriptor = "a hat", \
		can_stack = CALLBACK(src, PROC_REF(can_attach_hat)), \
	)

/obj/item/clothing/head/wig/proc/can_attach_hat(obj/item/source, obj/item/clothing/head/incoming_head, mob/user)
	if(incoming_head.clothing_flags & STACKABLE_HELMET_EXEMPT)
		balloon_alert(user, "invalid hat!")
		return FALSE
	return TRUE
