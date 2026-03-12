/datum/species/reploid //not much yet in terms of code, waiting until datum preferences to really expand this into being more than a generic version of humanoid robots.
	name = "Reploid"
	id = SPECIES_REPLOID
	inherent_traits = list(
		TRAIT_NOBLOOD,
		TRAIT_NODISMEMBER,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_TOXIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_USES_SKINTONES,
	) //definitively not virus-immune, also their components are not space-proof nor heat-proof
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/synthetic

/datum/species/reploid/on_species_gain(mob/living/carbon/C)
	. = ..()
	// Adds robot wings to chest wing options (if it is not already robotic)
	var/obj/item/bodypart/chest/chest = C.get_bodypart(BODY_ZONE_CHEST)
	if(!IS_ROBOTIC_LIMB(chest))
		chest.wing_types |= /obj/item/organ/wings/functional/robotic

/datum/species/reploid/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	var/obj/item/bodypart/chest/chest = C.get_bodypart(BODY_ZONE_CHEST)
	if(!IS_ROBOTIC_LIMB(chest))
		chest.wing_types -= /obj/item/organ/wings/functional/robotic
