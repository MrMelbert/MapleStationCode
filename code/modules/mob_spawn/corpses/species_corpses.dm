
//corpses that only differentiate themselves by representing a species

/obj/effect/mob_spawn/corpse/human/skeleton
	//these are also fished in chasms so it wouldn't hurt giving them an apter name than "mob spawner"
	name = "skeleton"
	mob_species = /datum/species/skeleton

/obj/effect/mob_spawn/corpse/human/zombie
	mob_species = /datum/species/zombie

/obj/effect/mob_spawn/corpse/human/monkey
	mob_species = /datum/species/monkey

/obj/effect/mob_spawn/corpse/human/abductor
	name = "abductor"
	mob_name = "alien"
	mob_species = /datum/species/abductor
	outfit = /datum/outfit/abductorcorpse

/datum/outfit/abductorcorpse
	name = "Abductor Corpse"
	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/combat

/obj/effect/mob_spawn/corpse/human/skeleton/mummy
	name = "mummy"
	outfit = /datum/outfit/mummycorpse

/obj/effect/mob_spawn/corpse/human/skeleton/mummy/pharoh
	name = "pharaoh mummy"
	outfit = /datum/outfit/mummycorpse/pharoh

/datum/outfit/mummycorpse
	name = "Mummy"
	uniform = /obj/item/clothing/under/costume/mummy
	head = /obj/item/clothing/mask/mummy

/datum/outfit/mummycorpse/pharoh
	name = "Pharaoh Mummy"
	uniform = /obj/item/clothing/under/costume/mummy
	head = /obj/item/clothing/head/costume/pharaoh
	// r_hand = /obj/item/nullrod/egyptian/cursed
