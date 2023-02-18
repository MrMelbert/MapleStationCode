// --- baby mode dress ---
/obj/item/clothing/under/dress/nndress
	name = "blue dress"
	desc = "A small blue dress. Incredibly silky and poofy."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
	icon_state = "nndress"

// --- second outfit ---
/obj/item/clothing/under/dress/nnseconddress
	name = "fancy blue dress"
	desc = "A decorated blue dress. Appears silky, but feels rough upon touching it.."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
	icon_state = "nnseconddress"
	resistance_flags = INDESTRUCTIBLE
	clothing_traits = list(TRAIT_VENTCRAWLER_ALWAYS, TRAIT_NOBREATH, TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_CAN_USE_FLIGHT_POTION, TRAIT_SHARPNESS_VULNERABLE) //gives nono her funny traits
	var/heat_mod = FALSE

/obj/item/clothing/under/dress/nnseconddress/equipped(mob/user, slot) //gives nono her weaknesses
	. = ..()
	if(!ishuman(user) || !(slot & slot_flags))
		return
	heat_mod = TRUE
	RegisterSignal(user, COMSIG_HUMAN_BURNING, PROC_REF(on_burn))
	var/mob/living/carbon/human/wearer = user
	wearer.physiology.burn_mod /= 0.5

/obj/item/clothing/under/dress/nnseconddress/dropped(mob/user)
	. = ..()
	if(heat_mod)
		if(!ishuman(user) || QDELING(user))
			return
		var/mob/living/carbon/human/wearer = user
		wearer.physiology.burn_mod *= 0.5
		heat_mod = FALSE

/obj/item/clothing/under/dress/nnseconddress/proc/on_burn(mob/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/wearer = source
	wearer.apply_damage(5, STAMINA)

/obj/item/clothing/shoes/nnredshoes
	name = "fake red shoes"
	desc = "Red Mary Janes with a shining texture. Gliding your finger over it, it feels like sandpaper.."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
	icon_state = "nnshoes"

/obj/item/clothing/head/costume/nnbluebonnet
	name = "blue bonnet"
	desc = "A decorated bonnet with various charms."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
	icon_state = "nnbonnet"
