/// -- Loadout suits (the outer, exosuit kind) --
/obj/item/clothing/suit/hooded/cloak/goliath_heirloom
	name = "heirloom goliath cloak"
	icon_state = "goliath_cloak"
	desc = "A thick and rugged cape made out of materials from monsters native to the planet known as Lavaland. This one is quite old and has survived quite a beating, and offers little to no protection anymore."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/pickaxe, /obj/item/knife/combat/bone, /obj/item/knife/combat/survival)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath_heirloom
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/head/hooded/cloakhood/goliath_heirloom
	name = "heirloom goliath cloak hood"
	icon_state = "golhood"
	desc = "A snug hood made out of materials from goliaths and watchers. This hood is quite worn and offers very little protection now."
	clothing_flags = SNUG_FIT
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	transparent_protection = HIDEMASK

/obj/item/clothing/suit/toggle/suspenders/greyscale
	name = "tailored suspenders"
	desc = "A set of custom made suspender straps."
	greyscale_colors = "#ffffff"
