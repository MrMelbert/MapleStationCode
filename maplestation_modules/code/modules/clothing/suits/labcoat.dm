/// -- Modular job labcoats. --
/obj/item/clothing/suit/toggle/labcoat/xenobio
	name = "xenobiologist labcoat"
	desc = "A suit that protects against slime spillage. Has a blueish-purple stripe on the shoulder."
	icon_state = "labcoat_xenobio"
	icon = 'maplestation_modules/icons/obj/clothing/suit.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/suit.dmi'

/obj/item/clothing/suit/toggle/labcoat/toxic
	name = "ordnance technician labcoat"
	desc = "A suit that protects against plasma exposure. Has a turquoise stripe on the shoulder."
	icon_state = "labcoat_ordnance"
	icon = 'maplestation_modules/icons/obj/clothing/suit.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/suit.dmi'

/// -- RD's Alternative Suit. Pretty much a labcoat without the toggle.
/obj/item/clothing/suit/rd_robes
	name = "research robes"
	desc = "Robes intended for the most weil or vile of evil scientists."
	icon_state = "rd_robes"
	icon = 'maplestation_modules/icons/obj/clothing/suit.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/suit.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	allowed = list(
		/obj/item/analyzer,
		/obj/item/biopsy_tool,
		/obj/item/dnainjector,
		/obj/item/flashlight/pen,
		/obj/item/healthanalyzer,
		/obj/item/paper,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/gun/syringe,
		/obj/item/sensor_device,
		/obj/item/soap,
		/obj/item/stack/medical,
		/obj/item/storage/pill_bottle,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/storage/bag/bio,
		)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 50, ACID = 50)
	species_exception = list(/datum/species/golem)
