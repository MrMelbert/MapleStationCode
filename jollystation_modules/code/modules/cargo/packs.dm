// -- Modular cargo packs --
/datum/supply_pack/goody/luciferium_bottle
	name = "Luciferium Bottle"
	desc = "Contains one bottle - twenty units - of Luciferium, an extremely dangerous medicine. Use with great caution."
	cost = PAYCHECK_COMMAND * 15
	contraband = TRUE
	contains = list(
		/obj/item/reagent_containers/glass/bottle/luciferium,
		)

/datum/supply_pack/medical/luciferium_bottles
	name = "Luciferium Shipment"
	desc = "Contains three bottles - sixty units - of Luciferium, an extremely dangerous drug that can cure the most absolute of medicinal issues, but cause permanent addiction."
	cost = CARGO_CRATE_VALUE * 30
	access = ACCESS_CMO
	contraband = TRUE
	crate_name = "luciferium Shipment"
	contains = list(
		/obj/item/reagent_containers/glass/bottle/luciferium,
		/obj/item/reagent_containers/glass/bottle/luciferium,
		/obj/item/reagent_containers/glass/bottle/luciferium,
		)

/datum/supply_pack/goody/go_juice_bottle
	name = "Go-Juice Bottle"
	desc = "Contains one bottle - twenty units - of Go-Juice, a potent but addictive combat stimulant."
	cost = PAYCHECK_HARD * 10
	contraband = TRUE
	contains = list(
		/obj/item/reagent_containers/glass/bottle/gojuice,
		)

/datum/supply_pack/medical/go_juice_bottles
	name = "Go-Juice Shipment"
	desc = "Contains three bottles - sixty units - of Go-Juice, a potent but addictive combat stimulant and pain suppressant."
	cost = CARGO_CRATE_VALUE * 10
	contraband = TRUE
	access = ACCESS_ARMORY
	crate_name = "go-juice Shipment"
	contains = list(
		/obj/item/reagent_containers/glass/bottle/gojuice,
		/obj/item/reagent_containers/glass/bottle/gojuice,
		/obj/item/reagent_containers/glass/bottle/gojuice,
		)

/datum/supply_pack/medical/psychoids
	name = "Psychoid Variety Shipment"
	desc = "Contains three randomly selected containers of drugs made from the psychoid leaf - Yayo, Flake, or Psychite Tea - often used to reduce pain and raise moods."
	cost = CARGO_CRATE_VALUE * 8
	access = ACCESS_MEDICAL
	crate_name = "psychoid shipment"
	contains = list(
		/obj/item/reagent_containers/glass/bottle/flake,
		/obj/item/reagent_containers/glass/bottle/yayo,
		/obj/item/reagent_containers/food/drinks/mug/psychite_tea,
		/obj/item/reagent_containers/food/drinks/mug/psychite_tea,
		)

/datum/supply_pack/medical/psychoids/fill(obj/structure/closet/crate/spawned_crate)
	for(var/i in 1 to 3)
		var/item = pick(contains)
		new item(spawned_crate)

/datum/supply_pack/goody/psychite_tea
	name = "Psychite Tea Order"
	desc = "Contains two mugs of Psychite Tea, a slightly addictive but mood boosting tea made from the distant psychoid leaf."
	cost = PAYCHECK_HARD * 8
	contains = list(
		/obj/item/reagent_containers/food/drinks/mug/psychite_tea,
		/obj/item/reagent_containers/food/drinks/mug/psychite_tea,
		)

/datum/supply_pack/goody/oxycodone_syringe
	name = "Oxycodone Syringe"
	desc = "Contains three injections of Oxycodone, an extremely addictive but effective painkiller."
	cost = PAYCHECK_HARD * 8
	contains = list(
		/obj/item/reagent_containers/syringe/oxycodone
		)

/datum/supply_pack/goody/morphine_syringe
	name = "Morphine Syringe"
	desc = "Contains three injections of Morphine, an addictive painkiller used to treat moderate pain."
	cost = PAYCHECK_HARD * 6
	contains = list(
		/obj/item/reagent_containers/syringe/morphine
		)

/datum/supply_pack/goody/aspirin_para_coffee
	name = "Aspirin/paracetamol/caffeine Pill Bottle"
	desc = "Contains a pill bottle of aspirin/paracetamol/caffeine, a combination painkiller used to treat pain with few side effects."
	cost = PAYCHECK_HARD * 12
	contains = list(
		/obj/item/storage/pill_bottle/aspirin_para_coffee_pills
		)

/datum/supply_pack/medical/painkiller_syringes
	name = "Painkiller Syringe Shipment"
	desc = "Contains six syringes of general medicinal painkillers - Ibuprofen, Paracetamol, and Aspirin."
	cost = CARGO_CRATE_VALUE * 7.5
	crate_name = "syringe shipment"
	contains = list(
		/obj/item/reagent_containers/syringe/ibuprofen,
		/obj/item/reagent_containers/syringe/ibuprofen,
		/obj/item/reagent_containers/syringe/paracetamol,
		/obj/item/reagent_containers/syringe/paracetamol,
		/obj/item/reagent_containers/syringe/aspirin,
		/obj/item/reagent_containers/syringe/aspirin,
		)

/datum/supply_pack/medical/painkiller_pens
	name = "Painkiller Medipen Shipment"
	desc = "Contains three emergency painkiller medipens."
	cost = CARGO_CRATE_VALUE * 4
	crate_name = "medipen shipment"
	contains = list(
		/obj/item/reagent_containers/hypospray/medipen/painkiller,
		/obj/item/reagent_containers/hypospray/medipen/painkiller,
		/obj/item/reagent_containers/hypospray/medipen/painkiller,
		)
