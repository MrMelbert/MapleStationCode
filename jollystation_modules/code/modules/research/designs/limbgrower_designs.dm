//makes the fox tail printable

/datum/design/foxtail
	name = "Fox Tail"
	id = "foxtail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/cat/fox
	category = list("other")

/obj/item/disk/design_disk/limbs/felinid
	limb_designs = list(/datum/design/cat_tail, /datum/design/cat_ears, /datum/design/foxtail)
