// nature shrine, consumes flowers to generate mana.
// this lists of flowers based on the amount of mana generated

#define NATURE_SHRINE_MANA_LOW list(
		/obj/item/food/grown/poppy,
		/obj/item/food/grown/sunflower,
)
#define NATURE_SHRINE_MANA_LOW_COUNT = 10

#define NATURE_SHRINE_MANA_MED list(
		/obj/item/food/grown/poppy/lily,
		/obj/item/food/grown/poppy/geranium,
		/obj/item/food/grown/sunflower/moonflower,

)
#define NATURE_SHRINE_MANA_MED_COUNT = 20

#define NATURE_SHRINE_MANA_HIGH list(
		/obj/item/food/grown/poppy/geranium/fraxinella,
		/obj/item/food/grown/poppy/lily/trumpet,
		/obj/item/food/grown/novaflower,
)
#define NATURE_SHRINE_MANA_HIGH_COUNT = 30

/datum/mana_pool/magic_altar/nature
	maximum_mana_capacity = 750
	softcap = 500
	amount = 0
	max_donation_rate_per_second = 2

/obj/structure/magic_altar/nature
	name = "The Stump Which Watches"
	desc = "A peculiar stump. It feels like the hole in the center is looking at you. It looks like you can cover its gaze with some flowers, though."
	icon_state = "magicstump_base"

/obj/structure/magic_altar/nature/get_initial_mana_pool_type()
	return /datum/mana_pool/magic_altar/nature

/obj/structure/magic_altar/nature/attackby(obj/item/attack_item, mob/living/user, params)
	..()
	if (attack_item in NATURE_SHRINE_MANA_LOW)
		mana_pool += NATURE_SHRINE_MANA_LOW_COUNT
		QDEL_NULL(attack_item)
		return
	if (attack_item in NATURE_SHRINE_MANA_MED)
		mana_pool += NATURE_SHRINE_MANA_MED_COUNT
		QDEL_NULL(attack_item)
		return
	if (attack_item in NATURE_SHRINE_MANA_HIGH)
		mana_pool += NATURE_SHRINE_MANA_HIGH_COUNT
		QDEL_NULL(attack_item)
		return
