// -- Modular cargo packs --

#define GROUP_DRUGS "Prescriptions (Goodies)"

/datum/supply_pack/goody/luciferium_bottle
	name = "Luciferium Bottle"
	desc = "Contains one bottle - twenty units - of Luciferium, an extremely dangerous medicine. Use with great caution."
	group = GROUP_DRUGS
	cost = PAYCHECK_COMMAND * 15
	contraband = TRUE
	contains = list(
		/obj/item/reagent_containers/glass/bottle/luciferium,
		)

/datum/supply_pack/medical/luciferium_bottles
	name = "Luciferium Shipment"
	desc = "Contains three bottles - sixty units - of Luciferium, an extremely dangerous drug that can cure the most absolute of medicinal issues, but cause permanent addiction. Requires CMO access to open."
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
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 10
	contraband = TRUE
	contains = list(
		/obj/item/reagent_containers/glass/bottle/gojuice,
		)

/datum/supply_pack/medical/go_juice_bottles
	name = "Go-Juice Shipment"
	desc = "Contains three bottles - sixty units - of Go-Juice, a potent but addictive combat stimulant and pain suppressant. Requires armory access to open."
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
	desc = "Contains three randomly selected containers of drugs made from the psychoid leaf - Yayo, Flake, or Psychite Tea - often used to reduce pain and raise moods. Requires medical access to open."
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
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 8
	contains = list(
		/obj/item/reagent_containers/food/drinks/mug/psychite_tea,
		/obj/item/reagent_containers/food/drinks/mug/psychite_tea,
		)

/datum/supply_pack/goody/oxycodone_syringe
	name = "Oxycodone Syringe"
	desc = "Contains three injections of Oxycodone, an extremely addictive but effective painkiller."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 4
	contains = list(
		/obj/item/reagent_containers/syringe/oxycodone
		)

/datum/supply_pack/goody/morphine_syringe
	name = "Morphine Syringe"
	desc = "Contains three injections of Morphine, an addictive painkiller used to treat moderate pain."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 3
	contains = list(
		/obj/item/reagent_containers/syringe/morphine
		)


/obj/item/storage/pill_bottle/prescription/aspirin_para_coffee
	pill_type = /obj/item/reagent_containers/pill/aspirin_para_coffee
	num_pills = 3

/datum/supply_pack/goody/aspirin_para_coffee
	name = "Aspirin/paracetamol/caffeine Prescription"
	desc = "Contains a pill bottle of aspirin/paracetamol/caffeine, a combination painkiller used to treat pain with few side effects."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 7.5
	contains = list(
		/obj/item/storage/pill_bottle/prescription/aspirin_para_coffee
		)

/obj/item/storage/pill_bottle/prescription/paracetamol
	pill_type = /obj/item/reagent_containers/pill/paracetamol
	num_pills = 3

/datum/supply_pack/goody/paracetamol
	name = "Paracetamol Prescription"
	desc = "Contains a pill bottle of Paracetamol."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 5
	contains = list(
		/obj/item/storage/pill_bottle/prescription/paracetamol
		)

/obj/item/storage/pill_bottle/prescription/aspirin
	pill_type = /obj/item/reagent_containers/pill/aspirin
	num_pills = 3

/datum/supply_pack/goody/aspirin
	name = "Aspirin Prescription"
	desc = "Contains a pill bottle of Aspirin."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 5
	contains = list(
		/obj/item/storage/pill_bottle/prescription/aspirin
		)

/obj/item/storage/pill_bottle/prescription/ibuprofen
	pill_type = /obj/item/reagent_containers/pill/ibuprofen
	num_pills = 3

/datum/supply_pack/goody/ibuprofen
	name = "Ibuprofen Prescription"
	desc = "Contains a pill bottle of Ibuprofen."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 5
	contains = list(
		/obj/item/storage/pill_bottle/prescription/ibuprofen
		)

/obj/item/storage/pill_bottle/prescription/happiness
	pill_type = /obj/item/reagent_containers/pill/happinesspsych
	num_pills = 5

/datum/supply_pack/goody/happiness
	name = "Mood Stabilizer Prescription"
	desc = "Contains a pill bottle of Mood Stabilizers. May contain Happiness."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 5
	contains = list(
		/obj/item/storage/pill_bottle/prescription/happiness
		)

/obj/item/storage/pill_bottle/prescription/psicodine
	pill_type = /obj/item/reagent_containers/pill/psicodine
	num_pills = 3

/datum/supply_pack/goody/happiness
	name = "Psicodine Prescription"
	desc = "Contains a pill bottle of Psicodine."
	group = GROUP_DRUGS
	cost = PAYCHECK_HARD * 5
	contains = list(
		/obj/item/storage/pill_bottle/prescription/psicodine
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
