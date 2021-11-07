//Extends Hivelord, which is also the base for Legions!

/obj/effect/mob_spawn/human/corpse/damaged/legioninfested/Initialize(mapload)
	var/type = pickweight(list("ClownOp")) = 1))
	if("ClownOp")
		name = pick(GLOB.clown_names)
			outfit = /datum/outfit/job/clownop
			belt = null
			backpack_contents = list()
			if(prob(70))
				backpack_contents += pick(list(/obj/item/stamp/clown = 1, /obj/item/reagent_containers/spray/waterflower = 1, /obj/item/food/grown/banana = 1, /obj/item/megaphone/clown = 1, /obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter = 1, /obj/item/pneumatic_cannon/pie = 1))
			if(prob(30))
				backpack_contents += list(/obj/item/stack/sheet/mineral/bananium = pickweight(list( 1 = 3, 2 = 2, 3 = 1)))
			if(prob(10))
				l_pocket = pickweight(list(/obj/item/bikehorn/golden = 3, /obj/item/bikehorn/airhorn= 1 ))
			if(prob(10))
				r_pocket = /obj/item/implanter/sad_trombone
