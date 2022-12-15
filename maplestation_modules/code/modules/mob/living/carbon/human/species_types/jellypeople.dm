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
	return "Jellypeople are weaker Slimepeople."

/datum/species/jelly/get_species_lore()
	return list("Jellyperson lore.")

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
