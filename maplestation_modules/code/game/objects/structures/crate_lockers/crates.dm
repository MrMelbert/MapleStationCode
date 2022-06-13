/// -- Modular Crates, and crates galore! ---

/// -- Resource cache crates used for resource related events. --
/obj/structure/closet/crate/resource_cache
	name = "resource cache"
	desc = "A steel crate filled to the brim with resources."
	/// Assoc list of resources to amounts
	var/list/obj/item/stack/resources = list()
	/// Whether bonus mats will get added to the crate on spawn.
	var/bonus_mats = TRUE

/obj/structure/closet/crate/resource_cache/PopulateContents()
	. = ..()
	// Add in our resources from the assoc list of resources
	resources = string_assoc_list(resources)
	for(var/contents in resources)
		var/amount = resources[contents]
		new contents(src, amount)

	// A chance to add in some extra metal or glass
	if(bonus_mats && prob(66))
		switch(rand(1, 200))
			if(1 to 9)
				new /obj/item/stack/sheet/iron(src, 5)
			if(10 to 24)
				new /obj/item/stack/sheet/iron(src, 10)
			if(15 to 34)
				new /obj/item/stack/sheet/glass(src, 5)
			if(35 to 49)
				new /obj/item/stack/sheet/glass(src, 10)
			if(50 to 59)
				new /obj/item/stack/sheet/mineral/gold(src, 4)
			if(60 to 69)
				new /obj/item/stack/sheet/mineral/silver(src, 8)

/// Special crates are specialized and can have rare materials
/obj/structure/closet/crate/resource_cache/special
	desc = "A steel crate filled to the brim with resources. You don't really recognize the branding."
	icon_state = "securecrate"

/// Syndicate crates can have syndie contraband hidden away, and contain syndie building mats
/obj/structure/closet/crate/resource_cache/syndicate
	name = "syndicate resource cache"
	desc = "A steel crate filled to the brim with resources. This one is from the syndicate."
	icon_state = "secgearcrate"
	// The max amount of TC we can spend hidden contraband
	var/contraband_value = 8

/obj/structure/closet/crate/resource_cache/syndicate/PopulateContents()
	. = ..()
	if(!bonus_mats)
		return
	// 5% chance that a syndicate crate spawns with some syndicate contraband.
	if(prob(95))
		return

	contraband_value += rand(-3, 2)
	message_admins("A [name] at [ADMIN_VERBOSEJMP(loc)] was populated with contraband syndicate items (tc value = [contraband_value]).")
	log_game("A [name] at [loc_name(loc)] was populated with contraband syndicate items (tc value = [contraband_value]).")
	var/list/uplink_items = list()
	for(var/datum/uplink_item/item_path as anything in SStraitor.uplink_items_by_type)
		var/datum/uplink_item/item = SStraitor.uplink_items_by_type[item_path]
		if(item.purchasable_from & UPLINK_TRAITORS && item.item)
			uplink_items += item

	while(contraband_value)
		var/datum/uplink_item/uplink_item = pick(uplink_items)
		if(!uplink_item.surplus || prob(100 - uplink_item.surplus))
			continue
		if(contraband_value < uplink_item.cost)
			continue
		contraband_value -= uplink_item.cost
		new uplink_item.item(src)

/// Centcom crates have usual advanced building mats found on NT stations
/obj/structure/closet/crate/resource_cache/centcom
	name = "nanotrasen resource cache"
	desc = "A steel crate filled to the brim with resources. This one is from centcom."
	icon_state = "plasmacrate"

/// Normal crates just have normal resources
/obj/structure/closet/crate/resource_cache/normal

/// Basic building mats (metal and glass)
//---
/obj/structure/closet/crate/resource_cache/normal/metals
	icon_state = "engi_crate"
	resources = list(
		/obj/item/stack/sheet/iron = 40,
		/obj/item/stack/sheet/glass = 30,
		)

/obj/structure/closet/crate/resource_cache/normal/metals/low
	resources = list(
		/obj/item/stack/sheet/iron = 20,
		/obj/item/stack/sheet/glass = 15,
		)

/obj/structure/closet/crate/resource_cache/normal/metals/high
	resources = list(
		/obj/item/stack/sheet/iron = 75,
		/obj/item/stack/sheet/glass = 60,
		)
//---

/// Rare metals (silver and gold)
//---
/obj/structure/closet/crate/resource_cache/normal/rare_metals
	icon_state = "engi_secure_crate"
	resources = list(
		/obj/item/stack/sheet/mineral/gold = 15,
		/obj/item/stack/sheet/mineral/silver = 20,
		/obj/item/stack/sheet/mineral/titanium = 25,
		)

/obj/structure/closet/crate/resource_cache/normal/rare_metals/low
	resources = list(
		/obj/item/stack/sheet/mineral/gold = 5,
		/obj/item/stack/sheet/mineral/silver = 8,
		/obj/item/stack/sheet/mineral/titanium = 15,
		)

/obj/structure/closet/crate/resource_cache/normal/rare_metals/high
	resources = list(
		/obj/item/stack/sheet/mineral/gold = 20,
		/obj/item/stack/sheet/mineral/silver = 25,
		/obj/item/stack/sheet/mineral/titanium = 30,
		)
//---

/// Rare gems (diamonds, bluespace crystals)
//---
/obj/structure/closet/crate/resource_cache/normal/rare_gems
	icon_state = "engi_secure_crate"
	resources = list(
		/obj/item/stack/sheet/mineral/diamond = 8,
		/obj/item/stack/sheet/bluespace_crystal = 6,
		)

/obj/structure/closet/crate/resource_cache/normal/rare_gems/low
	resources = list(
		/obj/item/stack/sheet/mineral/diamond = 4,
		/obj/item/stack/sheet/bluespace_crystal = 3,
		)

/obj/structure/closet/crate/resource_cache/normal/rare_gems/high
	resources = list(
		/obj/item/stack/sheet/mineral/diamond = 10,
		/obj/item/stack/sheet/bluespace_crystal = 8,
		)
//---

/// Hazardous resources (plasma and uranium)
//---
/obj/structure/closet/crate/resource_cache/normal/hazardous_metals
	icon_state = "radiation"
	resources = list(
		/obj/item/stack/sheet/mineral/uranium = 10,
		/obj/item/stack/sheet/mineral/plasma = 25,
		)

/obj/structure/closet/crate/resource_cache/normal/hazardous_metals/low
	resources = list(
		/obj/item/stack/sheet/mineral/uranium = 5,
		/obj/item/stack/sheet/mineral/plasma = 12,
		)

/obj/structure/closet/crate/resource_cache/normal/hazardous_metals/high
	resources = list(
		/obj/item/stack/sheet/mineral/uranium = 15,
		/obj/item/stack/sheet/mineral/plasma = 30,
		)
//---

/// Basic materials (cardboard, metal, plastic, wood, glass)
//---
/obj/structure/closet/crate/resource_cache/normal/basic_materials
	resources = list(
		/obj/item/stack/sheet/cardboard = 20,
		/obj/item/stack/sheet/iron = 50,
		/obj/item/stack/sheet/glass = 20,
		)

/obj/structure/closet/crate/resource_cache/normal/poor_materials
	resources = list(
		/obj/item/stack/sheet/cardboard = 20,
		/obj/item/stack/sheet/mineral/wood = 50,
		/obj/item/stack/sheet/plastic = 12,
		/obj/item/stack/sheet/iron = 25,
		)
//---

/// Weird crates (Random stuff)
//---
/obj/structure/closet/crate/resource_cache/special/weird_materials_cult
	icon_state = "weaponcrate"
	resources = list(
		/obj/item/stack/sheet/runed_metal = 20,
		/obj/item/stack/sheet/iron = 20,
		/obj/item/stack/sheet/glass = 20,
		)

/obj/structure/closet/crate/resource_cache/special/weird_materials_aliens
	icon_state = "weaponcrate"
	resources = list(
		/obj/item/stack/sheet/mineral/abductor = 20,
		/obj/item/stack/sheet/iron = 20,
		/obj/item/stack/sheet/glass = 20,
		)

/obj/structure/closet/crate/resource_cache/special/many_metals
	bonus_mats = FALSE
	resources = list(
		/obj/item/stack/sheet/iron = 30,
		/obj/item/stack/sheet/glass = 25,
		/obj/item/stack/sheet/mineral/gold = 8,
		/obj/item/stack/sheet/mineral/silver = 12,
		/obj/item/stack/sheet/mineral/titanium = 15,
		)

/obj/structure/closet/crate/resource_cache/special/many_rare_mats
	bonus_mats = FALSE
	resources = list(
		/obj/item/stack/sheet/mineral/gold = 8,
		/obj/item/stack/sheet/mineral/silver = 12,
		/obj/item/stack/sheet/mineral/titanium = 20,
		/obj/item/stack/sheet/mineral/uranium = 10,
		/obj/item/stack/sheet/mineral/plasma = 15,
		)

/obj/structure/closet/crate/resource_cache/special/diamonds
	bonus_mats = FALSE
	resources = list(
		/obj/item/stack/sheet/mineral/diamond = 12,
		)

/obj/structure/closet/crate/resource_cache/special/bananium
	bonus_mats = FALSE
	resources = list(
		/obj/item/stack/sheet/mineral/bananium = 10,
		)

/obj/structure/closet/crate/resource_cache/lizard_things
	name = "\improper lizard empire trade goods"
	desc = "A rough hide crate. This one was made by the Lizard Empire, and contains various trade goods of their people."
	icon_state = "necrocrate"
	resources = list(
		/obj/item/stack/sheet/sinew = 5,
		/obj/item/stack/sheet/animalhide/goliath_hide = 5,
		/obj/item/stack/sheet/bone = 10,
		)

/obj/structure/closet/crate/resource_cache/magic_things
	name = "\improper crate of insquisition contraband"
	desc = "A coarse wooden crate, with a broken seal of thick wax over the lid. Maybe opening this is a bad idea?"
	icon_state = "wooden"
	bonus_mats = FALSE
	resources = list(
		/obj/item/stack/sheet/mineral/mythril = 2,
		/obj/item/stack/sheet/mineral/adamantine = 4,
		/obj/item/stack/sheet/hauntium = 6,
		/obj/item/stack/sheet/mineral/runite = 12,
		/obj/item/stack/sheet/runed_metal = 20,
		)

// Yes, this crate can have literally any stack item.
// No, it's blacklisted from the events that use it for a reason.
/obj/structure/closet/crate/resource_cache/random_materials
	desc = "A steel crate. This one seems like trouble."

/obj/structure/closet/crate/resource_cache/random_materials/Initialize()
	for(var/i in 1 to rand(2, 4))
		resources += list(pick(subtypesof(/obj/item/stack)) = round(rand(1, 50),5))
	. = ..()

//---

/// Syndie stuff (Random stuff)
//---
/obj/structure/closet/crate/resource_cache/syndicate/building_mats
	resources = list(
		/obj/item/stack/sheet/mineral/plastitanium = 50,
		/obj/item/stack/sheet/plastitaniumglass = 30,
		)
//---

/// Centcom stuff (Random stuff)
//---
/obj/structure/closet/crate/resource_cache/centcom/building_mats
	resources = list(
		/obj/item/stack/sheet/plasteel = 50,
		/obj/item/stack/sheet/plasmarglass = 30,
		)
//---
// -- End resource caches. --
