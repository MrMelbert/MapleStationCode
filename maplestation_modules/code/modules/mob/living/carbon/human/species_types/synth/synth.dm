// -- Synth additions (though barely functional) --

#define BODYPART_ID_SYNTH "synth"

/datum/species/synth
	name = "Synth"
	id = SPECIES_SYNTH
	sexes = FALSE
	inherent_traits = list(
		TRAIT_AGEUSIA,
		TRAIT_NOBREATH,
		TRAIT_NODISMEMBER,
		TRAIT_NOHUNGER,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NO_DNA_COPY,
		TRAIT_VIRUSIMMUNE,
	)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	changesource_flags = MIRROR_BADMIN|MIRROR_PRIDE|MIRROR_MAGIC
	species_language_holder = /datum/language_holder/synthetic

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/synth,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/synth,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/synth,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/synth,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/synth,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/synth,
	)

	/// Reference to the species we're disguised as.
	VAR_FINAL/datum/species/disguise_species
	/// If TRUE, synth limbs will update when attached and detached.
	/// If FALSE, they will retain their disguise appearance forever.
	/// Changing this at runtime will not affect anything
	var/limb_updates_on_change = TRUE
	/// Species which generally work well with synth, and can be disguised as.
	var/list/valid_species = list(
		SPECIES_ABDUCTOR,
		SPECIES_FELINE,
		SPECIES_HUMAN,
		SPECIES_LIZARD,
		SPECIES_MOTH,
		SPECIES_ORNITHID,
	)

	var/datum/action/change_disguise/disguise_action

/datum/species/synth/on_species_gain(mob/living/carbon/human/synth, datum/species/old_species)
	. = ..()
	synth.AddComponent(/datum/component/ion_storm_randomization)
	synth.set_safe_hunger_level()

	var/disguise_type = old_species?.type || /datum/species/human
	if(ispath(disguise_type, /datum/species/synth))
		disguise_type = /datum/species/human

	disguise_as(synth, disguise_type)
	disguise_action = new(src)
	disguise_action.Grant(synth)

/datum/species/synth/on_species_loss(mob/living/carbon/human/synth)
	qdel(synth.GetComponent(/datum/component/ion_storm_randomization))
	drop_disguise(synth)

	for(var/obj/item/bodypart/limb as anything in synth.bodyparts)
		if(initial(limb.limb_id) == BODYPART_ID_SYNTH)
			limb.change_exempt_flags &= ~BP_BLOCK_CHANGE_SPECIES

	QDEL_NULL(disguise_action)
	return ..()

/datum/species/synth/get_species_description()
	return "Synths are disguised robots."

/datum/species/synth/get_species_lore()
	return list("Synth lore.")

/datum/species/synth/create_pref_unique_perks()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "robot",
		SPECIES_PERK_NAME = "Robot Rock",
		SPECIES_PERK_DESC = "Synths are robotic instead of organic, and as such may be affected by or immune to some things \
			normal humanoids are or aren't.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "user-secret",
		SPECIES_PERK_NAME = "Incognito Mode",
		SPECIES_PERK_DESC = "Synths are secretly synthetic androids that disguise as another species.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "shield-alt",
		SPECIES_PERK_NAME = "Silicon Supremecy",
		SPECIES_PERK_DESC = "Being synthetic, Synths gain many resistances that come \
			with silicons. They're immune to viruses, dismemberment, having \
			limbs disabled, and they don't need to eat or breath.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "theater-masks",
		SPECIES_PERK_NAME = "Full Copy",
		SPECIES_PERK_DESC = "Synths take on all the traits of species they disguise as, \
			both positive and negative.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "users-cog",
		SPECIES_PERK_NAME = "Error: Disguise Failure",
		SPECIES_PERK_DESC = "Ion Storms can temporarily mess with your disguise, \
			causing some of your features to change sporatically.",
	))
	return perks

/datum/species/synth/create_pref_language_perk()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "language",
		SPECIES_PERK_NAME = "Language Processor",
		SPECIES_PERK_DESC = "Synths can understand and speak a wide variety of \
			additional languages, including Encoded Audio Language, the language \
			of silicon and synthetics.",
	))

	return perks

/datum/species/synth/handle_body(mob/living/carbon/human/species_human)
	if(disguise_species)
		return disguise_species.handle_body(species_human)
	return ..()

/datum/species/synth/handle_mutant_bodyparts(mob/living/carbon/human/source, forced_colour)
	if(disguise_species)
		return disguise_species.handle_mutant_bodyparts(source, forced_colour)
	return ..()

/datum/species/synth/regenerate_organs(mob/living/carbon/organ_holder, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE)
	. = ..()
	disguise_species?.regenerate_organs(organ_holder, replace_current = FALSE, excluded_zones = excluded_zones, visual_only = visual_only)

/datum/species/synth/proc/disguise_as(mob/living/carbon/human/synth, datum/species/new_species_type)
	if(ispath(new_species_type, /datum/species/synth))
		CRASH("disguise_as a synth as a synth, very funny.")

	if(istype(new_species_type, /datum/species))
		CRASH("disguise_as being passed species datum when it should be passed species typepath")

	if(!isnull(disguise_species))
		drop_disguise(synth, skip_bodyparts = TRUE)

	disguise_species = new new_species_type()

	update_no_equip_flags(synth, no_equip_flags | disguise_species.no_equip_flags)
	sexes = disguise_species.sexes
	name = disguise_species.name
	fixed_mut_color = disguise_species.fixed_mut_color
	hair_color = disguise_species.hair_color

	handle_body(synth)
	handle_mutant_bodyparts(synth)
	regenerate_organs(synth, replace_current = FALSE)

	synth.add_traits(disguise_species.inherent_traits, "synth_disguise_[SPECIES_TRAIT]")

	if(limb_updates_on_change)
		for(var/obj/item/bodypart/part as anything in synth.bodyparts)
			limb_gained(synth, part, update = FALSE)

		synth.update_body_parts()
		RegisterSignal(synth, COMSIG_CARBON_REMOVE_LIMB, PROC_REF(limb_lost_sig))
		RegisterSignal(synth, COMSIG_CARBON_ATTACH_LIMB, PROC_REF(limb_gained_sig))

/datum/species/synth/proc/drop_disguise(mob/living/carbon/human/synth, skip_bodyparts = FALSE)
	update_no_equip_flags(synth, initial(no_equip_flags))
	sexes = initial(sexes)
	name = initial(name)
	fixed_mut_color = initial(fixed_mut_color)
	hair_color = initial(hair_color)

	synth.remove_traits(disguise_species.inherent_traits, "synth_disguise_[SPECIES_TRAIT]")

	if(limb_updates_on_change)
		if(!skip_bodyparts)
			for(var/obj/item/bodypart/part as anything in synth.bodyparts)
				limb_lost(synth, part, update = FALSE)

		synth.update_body_parts()
		UnregisterSignal(synth, COMSIG_CARBON_REMOVE_LIMB)
		UnregisterSignal(synth, COMSIG_CARBON_ATTACH_LIMB)

	QDEL_NULL(disguise_species)
	handle_body(synth)
	handle_mutant_bodyparts(synth)
	regenerate_organs(synth)

/datum/species/synth/proc/limb_lost_sig(mob/living/carbon/human/source, obj/item/bodypart/limb, ...)
	SIGNAL_HANDLER

	if(QDELING(limb))
		return
	if(!limb_lost(source, limb, update = TRUE))
		return
	source.visible_message(span_warning("[limb] changes appearance!"))

/datum/species/synth/proc/limb_lost(mob/living/carbon/human/synth, obj/item/bodypart/limb, update = FALSE)
	if(initial(limb.limb_id) != BODYPART_ID_SYNTH)
		return FALSE

	limb.change_appearance_into(limb, update)
	return TRUE

/datum/species/synth/proc/limb_gained_sig(mob/living/carbon/human/source, obj/item/bodypart/limb, ...)
	SIGNAL_HANDLER

	if(!limb_gained(source, limb, update = TRUE))
		return
	source.visible_message(span_warning("[limb] changes appearance!"))

/datum/species/synth/proc/limb_gained(mob/living/carbon/human/synth, obj/item/bodypart/limb, update = FALSE)
	if(initial(limb.limb_id) != BODYPART_ID_SYNTH)
		return FALSE

	limb.change_appearance_into(disguise_species.bodypart_overrides[limb.body_zone], update)
	return TRUE

/// Like change appearance, but passing it a bodypart will change the appearance to that of the bodypart.
/obj/item/bodypart/proc/change_appearance_into(obj/item/bodypart/other_part, update = TRUE)
	icon_state = initial(other_part.icon_state)
	icon = initial(other_part.icon)
	icon_static = initial(other_part.icon_static)
	icon_greyscale = initial(other_part.icon_greyscale)
	limb_id = initial(other_part.limb_id)
	should_draw_greyscale = initial(other_part.should_draw_greyscale)
	is_dimorphic = initial(other_part.is_dimorphic)

	if(!update)
		return

	if(owner)
		owner.update_body_parts()
	else
		update_icon_dropped()

/datum/action/change_disguise
	name = "Change Disguise Species"
	desc = "Changes your disguise to another species."
	button_icon_state = "chameleon_outfit"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED

/datum/action/change_disguise/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/synth = owner
	var/datum/species/synth/synth_species = synth.dna.species
	var/list/synth_disguise_species = list()
	for(var/species_id in get_selectable_species() & synth_species.valid_species)
		var/datum/species/species_type = GLOB.species_list[species_id]
		if(istype(synth_species.disguise_species, species_type))
			continue

		var/displayed_key = ispath(species_type, /datum/species/synth) ? "(Drop Disguise)" : initial(species_type.name)
		synth_disguise_species[displayed_key] = species_type

	var/picked = tgui_input_list(owner, "Pick a disguise. Note, you do not gain all abilities (or downsides) of the select species.", "Synth Disguise", synth_disguise_species, synth_species.disguise_species?.name)
	if(!picked || QDELETED(src) || QDELETED(synth_species) || QDELETED(synth) || !IsAvailable())
		return
	var/picked_species = synth_disguise_species[picked]
	if(ispath(picked_species, /datum/species/synth))
		if(!isnull(synth_species.disguise_species))
			synth_species.drop_disguise(synth)
		return

	if(!istype(synth_species.disguise_species, picked_species))
		synth_species.disguise_as(synth, synth_disguise_species[picked])
		return

/obj/item/bodypart/head/change_appearance_into(obj/item/bodypart/head/other_part, update = TRUE)
	head_flags = initial(other_part.head_flags)
	return ..()

/obj/item/bodypart/head/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_head"
	should_draw_greyscale = FALSE
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC
	head_flags = NONE
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/chest/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_chest"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC
	wing_types = list(/obj/item/organ/external/wings/functional/angel, /obj/item/organ/external/wings/functional/robotic)
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/arm/right/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_r_arm"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/arm/left/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synt_l_arm"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/leg/right/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_r_leg"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/leg/left/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_l_leg"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

#undef BODYPART_ID_SYNTH
