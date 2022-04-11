/// -- Modular armor items. --
// BO Armor
/obj/item/clothing/suit/armor/vest/bridge_officer
	name = "bridge officer's armor vest"
	desc = "A somewhat flexible but stiff suit of armor. It reminds you of a simpler time."
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 15, BIO = 0, FIRE = 100, ACID = 90, WOUND = 10)

//Unused, but we're keeping it
/obj/item/clothing/suit/armor/vest/bridge_officer/large
	name = "bridge officer's large armor vest"
	desc = "A larger, yet still comfortable suit of armor worn by Bridge Officers who prefer function over form."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"

//AP Armor
/obj/item/clothing/suit/armor/vest/asset_protection
	name = "asset protection's armor vest"
	desc = "A rigid vest of armor worn by Asset Protection. Rigid and stiff, just like your attitude."
	icon_state = "bulletproof"
	inhand_icon_state = "bulletproof"
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 30, BIO = 0, FIRE = 100, ACID = 90, WOUND = 10)

/obj/item/clothing/suit/armor/vest/asset_protection/large
	name = "asset protection's large armor vest"
	desc = "A SUPPOSEDLY bulkier, heavier armor that Asset Protection can use when the situation calls for it. Feels identical to your other one."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"

// Subtype of the toggle icon component (i know, ew) for GAGS items
/datum/component/toggle_icon/greyscale
	/// Config when toggled.
	var/toggled_config
	/// Worn config when toggled.
	var/toggled_config_worn

/datum/component/toggle_icon/greyscale/Initialize(toggle_noun = "buttons", config, worn_config)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

	if(!config || !worn_config)
		stack_trace("[type] component initialized without a greyscale config / worn greyscale config!")
		return COMPONENT_INCOMPATIBLE

	src.toggled_config = config
	src.toggled_config_worn = worn_config

/datum/component/toggle_icon/greyscale/do_icon_toggle(atom/source, mob/living/user)
	. = ..()
	if(isitem(source))
		var/obj/item/item_source = source

		if(toggled)
			item_source.set_greyscale(new_config = toggled_config, new_worn_config = toggled_config_worn)
		else
			item_source.set_greyscale(new_config = initial(item_source.greyscale_config), new_worn_config = initial(item_source.greyscale_config_worn))

		item_source.update_slot_icon()

// GAGS parade uniform, because why not
/obj/item/clothing/suit/greyscale_parade
	name = "tailored parade jacket"
	desc = "No armor, all fashion, unfortunately."
	icon_state = "formal"
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
		/obj/item/flashlight,
		/obj/item/lighter,
		/obj/item/storage/box/matches,
		/obj/item/modular_computer/tablet,
		/obj/item/pda,
		/obj/item/toy,
		/obj/item/stamp,
		/obj/item/pen,
		/obj/item/radio,
		/obj/item/knife,
		/obj/item/reagent_containers/food/drinks/bottle,
		/obj/item/reagent_containers/food/drinks/flask,
		/obj/item/storage/fancy/candle_box,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/assembly/flash/handheld,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
	)

	greyscale_colors = "#DDDDDD"
	greyscale_config = /datum/greyscale_config/parade_formal
	greyscale_config_worn = /datum/greyscale_config/parade_formal_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/greyscale_parade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon/greyscale, "buttons", /datum/greyscale_config/parade_formal_open, /datum/greyscale_config/parade_formal_open_worn)
