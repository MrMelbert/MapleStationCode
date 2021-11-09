//makes the fox tail printable

/datum/design/foxtail
	name = "Fox Tail"
	id = "foxtail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/cat/fox
	category = list("other")

/obj/item/disk/design_disk/limbs/foxtail
	name = "Fox Tail Design Disk"
	limb_designs = list(/datum/design/foxtail)

/datum/design/limb_disk/foxtail
	name = "Fox Tail Design Disk"
	desc = "Contains designs for the limbgrower- a fox tail."
	id = "limbdesign_foxtail"
	build_path = /obj/item/disk/design_disk/limbs/foxtail
