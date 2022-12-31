// -- Various slime people additions. --
/datum/species/jelly
	species_pain_mod = 0.5
	hair_color = "mutcolor"
	hair_alpha = 150

/datum/species/jelly/New()
	. = ..()
	species_traits |= list(HAIR, FACEHAIR)

/datum/species/jelly/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = COLOR_PINK
	human.hairstyle = "Bob Hair 2"
	human.hair_color = COLOR_PINK
	human.update_body(is_creating = TRUE)

/datum/species/jelly/get_species_description()
	return "The highly adaptive Jellypeople are the cumulative result of an extremely high \
		cellular mutation rate, as well as an inordinate amount of workplace accidents. It's \
		rare to see one in person, but even rarer to work with one, as less permanent Jellypeople exist \
		than there are days in a year."

/datum/species/jelly/get_species_lore()
	return list(
		"They say that the discovery of penicillin occurred when Dr. Alexander Fleming accidentally left a petri dish of bacteria out during a \
		holiday, returning to find a mold which was capable of stopping said bacteria from growing.",

		"It was 317 years later when a similar office accident would occur in a lab orbiting the star Arcturus. Having left a small sample of liquid plasma in a dish \
		for over a week due to negligent laboratory procedures, the second greatest accidental discovery in medicine would occur: the creation of what would come to be known simply as \
		\"Slime\". These living cancers would hijack the cellular reproduction of a living body (most often humanoids), in order to reproduce and mutate exponentially fast. \
		These mutations were found to hold many properties which could not be explained, and formed their own new field of scientific research: Xenobiology.",

		"Within the last 200 years, a rare occurrence has been noted to happen: the anthropomorphization of an individual slime. There are many different ways that this could \
		happen, from mutation toxin never wearing off, to a slime evolving under its own volition. The result of this rare mutation is a race of people without a culture, \
		identifying either with their race before their transformation or with the individual station or planet in which they mutated to their advanced state. \
		Many humanoids which transformed permanently into Jellypeople do so due to medical issues interfering with their body's ability to process mutation toxins.",

		"The oldest Jellyperson alive has their age recorded as 196, despite visibly appearing no older than 9. It's unknown if Jellypeople truly age, or if they simply \
		do not visibly do so. Whatever the case, scientists agree that their regenerative abilities are a direct factor into their long lifespans. Longevity has had its price \
		however, as Jellypeople are a sterile race, leaving themselves as their only lasting legacy.",

		"As of 2562, Nanotrasen is aware of less than 50 Slimepeople in existence, with 14 of these being under their employ."
		)

// Changes jellypeople to look like slimepeople instead of stargazers
// (Because slimepeople are more customizable / less ugly)
/obj/item/bodypart/arm/left/jelly
	limb_id = SPECIES_SLIMEPERSON

/obj/item/bodypart/arm/right/jelly
	limb_id = SPECIES_SLIMEPERSON

/obj/item/bodypart/head/jelly
	limb_id = SPECIES_SLIMEPERSON
	is_dimorphic = FALSE

/obj/item/bodypart/leg/left/jelly
	limb_id = SPECIES_SLIMEPERSON

/obj/item/bodypart/leg/right/jelly
	limb_id = SPECIES_SLIMEPERSON

/obj/item/bodypart/chest/jelly
	limb_id = SPECIES_SLIMEPERSON

// Stargazers inherent jelly limbs so we gotta do this too
/datum/species/jelly/stargazer
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/stargazer,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/stargazer,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/stargazer,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/stargazer,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/stargazer,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/stargazer,
	)
/obj/item/bodypart/head/stargazer
	limb_id = SPECIES_JELLYPERSON
	is_dimorphic = TRUE
	dmg_overlay_type = null

/obj/item/bodypart/chest/stargazer
	limb_id = SPECIES_JELLYPERSON
	is_dimorphic = TRUE
	dmg_overlay_type = null

/obj/item/bodypart/arm/left/stargazer
	limb_id = SPECIES_JELLYPERSON
	dmg_overlay_type = null

/obj/item/bodypart/arm/right/stargazer
	limb_id = SPECIES_JELLYPERSON
	dmg_overlay_type = null

/obj/item/bodypart/leg/left/stargazer
	limb_id = SPECIES_JELLYPERSON
	dmg_overlay_type = null

/obj/item/bodypart/leg/right/stargazer
	limb_id = SPECIES_JELLYPERSON
	dmg_overlay_type = null
