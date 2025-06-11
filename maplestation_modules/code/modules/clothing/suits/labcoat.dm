/// -- Modular job labcoats. --
/obj/item/clothing/suit/toggle/labcoat/xenobio
	name = "xenobiologist labcoat"
	desc = "A suit that protects against slime spillage. Has a blueish-purple stripe on the shoulder."
	icon_state = "labcoat_xenobio"
	icon = 'maplestation_modules/icons/obj/clothing/suit.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/suit.dmi'

/obj/item/clothing/suit/toggle/labcoat/ce
	name = "chief engineer's labcoat"
	desc = "Has black and gold panels unlike the standard labcoat model."
	icon_state = "labcoat_ce"
	icon = 'maplestation_modules/icons/obj/clothing/suit.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/suit.dmi'
	resistance_flags = FIRE_PROOF //all CE items should be fireproof

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
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/glass/bottle,
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
		/obj/item/defibrillator/compact,
		)
	armor_type = /datum/armor/science_rd
	species_exception = list(/datum/species/golem)

// Adding combat defib to allowed list of non-modular labcouts and co.
/obj/item/defibrillator/compact
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_SUITSTORE|ITEM_SLOT_DEX_STORAGE
	worn_icon = 'icons/mob/clothing/belt.dmi'

/obj/item/clothing/suit/toggle/labcoat/Initialize(mapload)
	. = ..()
	allowed += /obj/item/defibrillator/compact

/obj/item/clothing/suit/hooded/wintercoat/medical/Initialize(mapload)
	. = ..()
	allowed += /obj/item/defibrillator/compact

/obj/item/clothing/suit/apron/surgical/Initialize(mapload)
	. = ..()
	allowed += /obj/item/defibrillator/compact

/datum/mod_theme/medical/New() // Maybe not necessary because the defib MOD exists
	. = ..()
	allowed_suit_storage += /obj/item/defibrillator/compact
