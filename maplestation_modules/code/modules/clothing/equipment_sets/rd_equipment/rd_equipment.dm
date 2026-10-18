/obj/item/clothing/under/rank/rnd/research_director/holoturtleneck
	name = "holointegrated turtleneck"
	desc = "A black turtleneck paired with jeans. It's missing one sleeve and has a triad of small holoprojectors installed on its neck, back and belt buckle."
	icon = 'maplestation_modules/icons/obj/clothing/rd.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/rd.dmi'
	icon_state = "turtleneck"
	base_icon_state = "turtleneck"
	inhand_icon_state = "bl_suit"
	can_adjust = TRUE
	alt_covers_chest = FALSE
	var/projectors_enabled = TRUE

/obj/item/clothing/under/rank/rnd/research_director/holoturtleneck/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/clothing/under/rank/rnd/research_director/holoturtleneck/click_alt_secondary(mob/user)
	projectors_enabled = !projectors_enabled
	update_appearance()
	update_slot_icon()

/obj/item/clothing/under/rank/rnd/research_director/holoturtleneck/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][projectors_enabled ? "" : "_noholo"]"
	worn_icon_state = "[base_icon_state][adjusted ? "_d" : ""][projectors_enabled ? "" : "_noholo"]"

/obj/item/clothing/under/rank/rnd/research_director/holoturtleneck/update_overlays()
	. = ..()
	if(projectors_enabled)
		. += emissive_appearance(icon, "[icon_state]_e", offset_spokesman = src, alpha = src.alpha)

/obj/item/clothing/under/rank/rnd/research_director/holoturtleneck/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(projectors_enabled && !isinhands)
		. += emissive_appearance(worn_icon, "[icon_state]_e", offset_spokesman = loc, alpha = src.alpha)

/obj/item/clothing/gloves/black/holo
	name = "mixed gloves"
	desc = "A pair of uneven black gloves. Left glove has been cut into nothing more than a strip of fabric with a holoprojector built into it."
	icon = 'maplestation_modules/icons/obj/clothing/rd.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/rd.dmi'
	icon_state = "gloves"
	base_icon_state = "gloves"
	var/projectors_enabled = TRUE

/obj/item/clothing/gloves/black/holo/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/clothing/gloves/black/holo/click_alt_secondary(mob/user)
	projectors_enabled = !projectors_enabled
	update_appearance()
	update_slot_icon()

/obj/item/clothing/gloves/black/holo/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][projectors_enabled ? "" : "_noholo"]"
	worn_icon_state = icon_state

/obj/item/clothing/gloves/black/holo/update_overlays()
	. = ..()
	if(projectors_enabled)
		. += emissive_appearance(icon, "[icon_state]_e", offset_spokesman = src, alpha = src.alpha)

/obj/item/clothing/gloves/black/holo/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(projectors_enabled && !isinhands)
		. += emissive_appearance(worn_icon, "[icon_state]_e", offset_spokesman = loc, alpha = src.alpha)

// Retexture of RD's jacket
/obj/item/clothing/suit/toggle/labcoat/research_director/sidecape
	name = "researcher's shoulder cape"
	desc = "A white shoulder cape decorated with purple stripes made from an acid-proof material."
	icon = 'maplestation_modules/icons/obj/clothing/rd.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/rd.dmi'
	icon_state = "cloak"
	base_icon_state = "cloak"
	slot_flags = ITEM_SLOT_NECK | ITEM_SLOT_OCLOTHING

/obj/item/clothing/suit/toggle/labcoat/research_director/sidecape/equipped(mob/living/user, slot)
	. = ..()
	if (slot == ITEM_SLOT_NECK)
		set_armor(/datum/armor/none)
	else
		set_armor(initial(armor_type))

/obj/item/storage/bag/garment/research_director/PopulateContents()
	. = ..()
	new /obj/item/clothing/suit/toggle/labcoat/research_director/sidecape(src)
	new /obj/item/clothing/under/rank/rnd/research_director/holoturtleneck(src)
	new /obj/item/clothing/gloves/black/holo(src)
