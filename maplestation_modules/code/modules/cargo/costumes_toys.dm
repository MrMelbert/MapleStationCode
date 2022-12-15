/datum/supply_pack/costumes_toys/randomised/tdatet_many
	name = "Big-Bold Booster Pack Pack For TDATET"
	desc = "A bumper load of TDATET Booster Packs of varying series minus red. Half-priced compared to normal retailers for buying in bulk! Collect them all!"
	cost = 500
	contains = list()
	crate_name = "TDATET booster pack pack"

/datum/supply_pack/costumes_toys/randomised/tdatet_many/fill(obj/structure/closet/crate/C)
	var/cardpacktype
	for(var/i in 1 to 10)
		cardpacktype = pick(subtypesof(/obj/item/cardpack/tdatet))
		new cardpacktype(C)

/datum/supply_pack/costumes_toys/tdatet_base
	name = "Bulk Bold Beginner's Base Bargain for TDATET"
	desc = "Contains 5 base pack cards, 5 big red box sets with over 28 red cards each, and 5 complimentary card binders. Great value to invite your friends to play along!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/cardpack/tdatet_base = 5,
					/obj/item/cardpack/tdatet_box = 5,
					/obj/item/storage/card_binder/personal = 5,
				)
	crate_name = "TDATET Beginner Booster 5-pack"
