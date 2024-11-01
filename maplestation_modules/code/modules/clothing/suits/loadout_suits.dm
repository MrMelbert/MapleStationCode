/// -- Loadout suits (the outer, exosuit kind) --
/obj/item/clothing/suit/hooded/cloak/goliath/heirloom
	name = "heirloom goliath cloak"
	icon_state = "goliath_cloak"
	desc = "A thick and rugged cape made out of materials from monsters \
		native to the planet known as Lavaland. This one is quite old \
		and has survived quite a beating, and offers little to no protection anymore."
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath/heirloom
	armor_type = /datum/armor/none

/obj/item/clothing/head/hooded/cloakhood/goliath/heirloom
	name = "heirloom goliath cloak hood"
	desc = "A snug hood made out of materials from goliaths and watchers. \
		This hood is quite worn and offers very little protection now."
	armor_type = /datum/armor/none

/obj/item/clothing/suit/toggle/suspenders/greyscale
	name = "tailored suspenders"
	desc = "A set of custom made suspender straps."
	greyscale_colors = "#ffffff"

/obj/item/clothing/suit/toggle/flannel
	name = "flannel jacket"
	desc = "A jacket or shirt made of flannel. Made for the Space Canadian wilderness and smells faintly of maple syrup."
	icon = 'maplestation_modules/icons/obj/clothing/suit.dmi'
	icon_state = "flannel"
	worn_icon = 'maplestation_modules/icons/mob/clothing/suit.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/toggle/flannel/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/flashlight,
		/obj/item/lighter,
		/obj/item/modular_computer/pda,
		/obj/item/radio,
		/obj/item/storage/bag/books,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/toy,
		/obj/item/hatchet, //This is a jacket for real lumberjacks
	)

/obj/item/clothing/suit/toggle/chesedjacket
	name = "Well-Kept Jacket"
	desc = "A tidily kept blue jacket, hand tailored and made by someone with a clear dedication to their craft."
	icon = 'maplestation_modules/icons/obj/clothing/suit.dmi'
	icon_state = "chesed_jacket"
	worn_icon = 'maplestation_modules/icons/mob/clothing/suit.dmi'
	blood_overlay_type = "armor"
	clothing_traits = list(TRAIT_CAFFEINE_LOVER)
