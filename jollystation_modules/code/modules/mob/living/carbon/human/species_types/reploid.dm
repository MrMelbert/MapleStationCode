/datum/species/reploid //not much yet in terms of code, waiting until datum preferences to really expand this into being more than a generic version of humanoid robots.
	name = "Reploid"
	id = SPECIES_REPLOID
	species_traits = list(NOBLOOD,EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_FLESH)
	default_color = "FFFFFF"
	use_skintones = 1
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_NODISMEMBER,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOMETABOLISM,
		TRAIT_TOXIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_NOCLONELOSS,
	) //definitively not virus-immune, also their components are not space-proof nor heat-proof
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	wings_icons = list("Robotic")
	species_language_holder = /datum/language_holder/synthetic

/datum/species/reploid/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.set_safe_hunger_level()
