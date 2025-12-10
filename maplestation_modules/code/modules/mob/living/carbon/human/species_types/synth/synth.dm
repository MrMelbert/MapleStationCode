// -- Synth additions (though barely functional) --

#define BODYPART_ID_SYNTH "synth"

/mob/living/carbon/human/species/synth
	race = /datum/species/android/synth

/mob/living/carbon/human/species/synth/disguised

/mob/living/carbon/human/species/synth/disguised/Initialize(mapload)
	. = ..()
	var/datum/species/android/synth/synth = dna.species
	synth.disguise_as(src, /datum/species/human)

/datum/species/android/synth
	name = "Humanoid Synthetic"
	id = SPECIES_SYNTH
	sexes = TRUE

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/synth,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/synth,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/synth,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/synth,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/synth,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/synth,
	)

	mutant_organs = list(/obj/item/organ/synth_head_cover = "Helm")

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
	/// Reference to the action we give Synths to change species
	var/datum/action/cooldown/change_disguise/disguise_action
	/// Typepath to species to disguise set on species gain, for code shenanigans
	var/initial_disguise
	/// If health is lower than this %, the synth will start to show signs of damage.
	var/disuise_damage_threshold = 25

/datum/species/android/synth/on_species_gain(mob/living/carbon/human/synth, datum/species/old_species)
	. = ..()
	synth.AddComponent(/datum/component/ion_storm_randomization)

	if(limb_updates_on_change)
		RegisterSignal(synth, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(disguise_damage))

	disguise_action = new(src)
	disguise_action.Grant(synth)

	if(initial_disguise)
		disguise_as(synth, initial_disguise)

/datum/species/android/synth/on_species_loss(mob/living/carbon/human/synth)
	qdel(synth.GetComponent(/datum/component/ion_storm_randomization))
	drop_disguise(synth)
	UnregisterSignal(synth, COMSIG_CARBON_LIMB_DAMAGED)

	for(var/obj/item/bodypart/limb as anything in synth.bodyparts)
		if(initial(limb.limb_id) == BODYPART_ID_SYNTH)
			limb.change_exempt_flags &= ~BP_BLOCK_CHANGE_SPECIES

	QDEL_NULL(disguise_action)
	return ..()

/datum/species/android/synth/get_features()
	. = ..()
	for(var/species_id in valid_species)
		. |= GLOB.species_prototypes[GLOB.species_list[species_id]].get_features()

/datum/species/android/synth/get_filtered_features_per_prefs(datum/preferences/prefs)
	var/list/filtered = list()
	var/chosen_species_id = prefs.read_preference(/datum/preference/choiced/synth_species)
	for(var/species_id in valid_species)
		filtered |= GLOB.species_prototypes[GLOB.species_list[species_id]].get_features()

	return filtered - GLOB.species_prototypes[GLOB.species_list[chosen_species_id]].get_features()

/datum/species/android/synth/get_species_description()
	return "While they appear organic, Synths are secretly Androids disguised as the various species of the Galaxy."

/datum/species/android/synth/get_species_lore()
	return list(
		"The reasons for a Synth's existence can vary. \
		Some were created as robotic assistants with a fresh coat of paint, to acclimate better to their organic counterparts. \
		Others were designed to be spies, infiltrating the ranks of other species to gather information. \
		There are even rumors some Synths are not even aware they ARE synthetic, and truly 'believe' they are the species they are disguised as. \
		Regardless of their origins, Synths are a diverse and mysterious group of beings."
	)

/datum/species/android/synth/create_pref_unique_perks()
	. = ..()
	. += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_MEDKIT,
		SPECIES_PERK_NAME = "Partially Organic",
		SPECIES_PERK_DESC = "Your limbs are part organic, part synthetic. While disguised, \
			both organic (sutures, meshes) and synthetic (welder, cabling) healing methods work on you.",
	))
	. += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_USER_SECRET,
		SPECIES_PERK_NAME = "Incognito Mode",
		SPECIES_PERK_DESC = "Synths are synthetic androids that typically disguise as another species. \
			All characteristics of your disguise species are mimicked, including the negative ones. \
			Physical damage may cause your disguise to fail, revealing your true synthetic nature.",
	))

/datum/species/android/synth/handle_body(mob/living/carbon/human/species_human)
	if(disguise_species)
		return disguise_species.handle_body(species_human)
	return ..()

/datum/species/android/synth/regenerate_organs(mob/living/carbon/organ_holder, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE)
	. = ..()
	disguise_species?.regenerate_organs(organ_holder, replace_current = FALSE, excluded_zones = excluded_zones, visual_only = visual_only)

/datum/species/android/synth/proc/disguise_as(mob/living/carbon/human/synth, datum/species/new_species_type)
	if(ispath(new_species_type, /datum/species/android/synth))
		CRASH("disguise_as a synth as a synth, very funny.")

	if(istype(new_species_type, /datum/species))
		CRASH("disguise_as being passed species datum when it should be passed species typepath")

	drop_disguise(synth, skip_bodyparts = TRUE)

	disguise_species = new new_species_type()

	update_no_equip_flags(synth, no_equip_flags | disguise_species.no_equip_flags)
	sexes = disguise_species.sexes
	name = disguise_species.name
	fixed_mut_color = disguise_species.fixed_mut_color
	hair_color_mode = disguise_species.hair_color_mode

	if(isnull(synth.client?.prefs) || synth.client.prefs.read_preference(/datum/preference/choiced/synth_blood) == "As Disguise")
		exotic_bloodtype = disguise_species.exotic_bloodtype

	synth.add_traits(disguise_species.inherent_traits, "synth_disguise_[SPECIES_TRAIT]")

	regenerate_organs(synth, replace_current = FALSE)

	if(limb_updates_on_change)
		for(var/obj/item/bodypart/part as anything in synth.bodyparts)
			limb_gained(synth, part, update = FALSE)
		RegisterSignal(synth, COMSIG_CARBON_REMOVE_LIMB, PROC_REF(limb_lost_sig))
		RegisterSignal(synth, COMSIG_CARBON_ATTACH_LIMB, PROC_REF(limb_gained_sig))

	synth.update_body(TRUE)

/datum/species/android/synth/proc/drop_disguise(mob/living/carbon/human/synth, skip_bodyparts = FALSE)
	if(isnull(disguise_species))
		return

	update_no_equip_flags(synth, initial(no_equip_flags))
	sexes = initial(sexes)
	name = initial(name)
	fixed_mut_color = initial(fixed_mut_color)
	hair_color_mode = initial(hair_color_mode)

	exotic_bloodtype = /datum/blood_type/oil

	synth.remove_traits(disguise_species.inherent_traits, "synth_disguise_[SPECIES_TRAIT]")

	if(limb_updates_on_change)
		if(!skip_bodyparts)
			for(var/obj/item/bodypart/part as anything in synth.bodyparts)
				limb_lost(synth, part, update = FALSE)
		UnregisterSignal(synth, COMSIG_CARBON_REMOVE_LIMB)
		UnregisterSignal(synth, COMSIG_CARBON_ATTACH_LIMB)

	QDEL_NULL(disguise_species)
	regenerate_organs(synth)
	synth.update_body(TRUE)

/datum/species/android/synth/proc/limb_lost_sig(mob/living/carbon/human/source, obj/item/bodypart/limb, ...)
	SIGNAL_HANDLER

	if(QDELING(limb))
		return
	if(!limb_lost(source, limb, update = TRUE))
		return
	source.visible_message(span_warning("[source]'s [limb.plaintext_zone] changes appearance!"))

/datum/species/android/synth/proc/limb_lost(mob/living/carbon/human/synth, obj/item/bodypart/limb, update = FALSE)
	if(initial(limb.limb_id) != BODYPART_ID_SYNTH)
		return FALSE

	limb.change_appearance_into(limb, update)
	return TRUE

/datum/species/android/synth/proc/limb_gained_sig(mob/living/carbon/human/source, obj/item/bodypart/limb, ...)
	SIGNAL_HANDLER

	if(!limb_gained(source, limb, update = TRUE))
		return
	source.visible_message(span_warning("[source]'s [limb.plaintext_zone] changes appearance!"))

/datum/species/android/synth/proc/limb_gained(mob/living/carbon/human/synth, obj/item/bodypart/limb, update = FALSE)
	if(initial(limb.limb_id) != BODYPART_ID_SYNTH)
		return FALSE

	limb.change_appearance_into(disguise_species.bodypart_overrides[limb.body_zone], update)
	return TRUE

/datum/species/android/synth/proc/disguise_damage(mob/living/carbon/human/synth)
	SIGNAL_HANDLER

	if(!limb_updates_on_change || isnull(disguise_species))
		return

	var/list/obj/item/bodypart/changed_limbs = list()
	for(var/obj/item/bodypart/limb as anything in synth.bodyparts)
		var/below_threshold = (limb.max_damage - limb.get_damage()) / limb.max_damage * 100 <= disuise_damage_threshold
		if(limb.limb_id == BODYPART_ID_SYNTH)
			if(!below_threshold)
				limb_gained(synth, limb, update = FALSE)
				changed_limbs += limb
				if(istype(limb, /obj/item/bodypart/head))
					var/obj/item/organ/tongue/tongue = synth.get_organ_slot(ORGAN_SLOT_TONGUE)
					if(tongue?.temp_say_mod == "whirrs")
						tongue.temp_say_mod = null
		else
			if(below_threshold)
				limb_lost(synth, limb, update = FALSE)
				changed_limbs += limb
				if(istype(limb, /obj/item/bodypart/head))
					var/obj/item/organ/tongue/tongue = synth.get_organ_slot(ORGAN_SLOT_TONGUE)
					tongue?.temp_say_mod = "whirrs"

	var/num_changes = length(changed_limbs)
	if(num_changes > 0)
		if(num_changes == length(synth.bodyparts))
			synth.visible_message(span_danger("[synth] changes appearance!"))
		else if(num_changes == 1)
			synth.visible_message(span_warning("[synth]'s [changed_limbs[1].plaintext_zone] changes appearance!"))
		synth.update_body_parts(TRUE)

/// Like change appearance, but passing it a bodypart will change the appearance to that of the bodypart.
/obj/item/bodypart/proc/change_appearance_into(obj/item/bodypart/other_part, update = TRUE)
	draw_color = initial(other_part.draw_color)
	species_color = initial(other_part.species_color)
	skin_tone = initial(other_part.skin_tone)
	icon_state = initial(other_part.icon_state)
	icon = initial(other_part.icon)
	icon_static = initial(other_part.icon_static)
	icon_greyscale = initial(other_part.icon_greyscale)
	limb_id = initial(other_part.limb_id)
	should_draw_greyscale = initial(other_part.should_draw_greyscale)
	is_dimorphic = initial(other_part.is_dimorphic)
	bodytype = initial(other_part.bodytype)
	bodyshape = initial(other_part.bodyshape)

	if(!update)
		return

	if(owner)
		owner.update_body_parts(TRUE)
	else
		update_icon_dropped()

/datum/action/cooldown/change_disguise
	name = "Change Disguise Species"
	desc = "Changes your disguise to another species."
	button_icon_state = "chameleon_outfit"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED
	cooldown_time = 6 SECONDS

/datum/action/cooldown/change_disguise/Activate(atom/target)
	. = TRUE

	var/mob/living/carbon/human/synth = owner
	var/datum/species/android/synth/synth_species = synth.dna.species
	var/list/synth_disguise_species = list()
	for(var/species_id in get_selectable_species() & synth_species.valid_species)
		var/datum/species/species_type = GLOB.species_list[species_id]
		synth_disguise_species[initial(species_type.name)] = species_type

	synth_disguise_species["(Drop Disguise)"] = /datum/species/android/synth

	var/picked = tgui_input_list(
		owner,
		"Pick a disguise. Note, you do not gain all abilities (or downsides) of the select species.",
		"Synth Disguise",
		synth_disguise_species,
		synth_species.disguise_species?.name,
	)
	if(!picked || QDELETED(src) || QDELETED(synth_species) || QDELETED(synth) || !IsAvailable())
		return
	var/picked_species = synth_disguise_species[picked]
	if(ispath(picked_species, /datum/species/android/synth))
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
	icon_static = 'maplestation_modules/icons/mob/synth_heads.dmi'
	icon = 'maplestation_modules/icons/mob/synth_heads.dmi'
	icon_state = "synth_head"
	should_draw_greyscale = FALSE
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	bodytype = BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC|BIO_BLOODED
	head_flags = HEAD_EYESPRITES | HEAD_EYECOLOR
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/chest/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_chest"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC|BIO_BLOODED
	wing_types = list(/obj/item/organ/wings/functional/angel, /obj/item/organ/wings/functional/robotic)
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/arm/right/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_r_arm"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC|BIO_BLOODED
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/arm/left/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_l_arm"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC|BIO_BLOODED
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/leg/right/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_r_leg"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC|BIO_BLOODED
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/bodypart/leg/left/synth
	limb_id = BODYPART_ID_SYNTH
	icon_static = 'icons/mob/human/bodyparts.dmi'
	icon = 'icons/mob/human/bodyparts.dmi'
	icon_state = "synth_l_leg"
	obj_flags = CONDUCTS_ELECTRICITY
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	brute_modifier = 0.8
	burn_modifier = 0.8
	biological_state = BIO_ROBOTIC|BIO_BLOODED
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES

/obj/item/organ/eyes/robotic/synth
	name = "synth eyes"

// Organ for synth head covers.

/obj/item/organ/synth_head_cover
	name = "Head Cover"
	desc = "It is a cover that goes on a synth head."

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SYNTH_HEAD_COVER

	preference = "feature_synth_head_cover"

	dna_block = DNA_SYNTH_HEAD_COVER_BLOCK
	organ_flags = ORGAN_ROBOTIC

	bodypart_overlay = /datum/bodypart_overlay/mutant/synth_head_cover
	organ_flags = parent_type::organ_flags | ORGAN_EXTERNAL


/obj/item/organ/synth_head_cover/on_bodypart_insert(obj/item/bodypart/head/limb, movement_flags)
	. = ..()
	limb.head_flags &= ~HEAD_EYESPRITES

/obj/item/organ/synth_head_cover/on_bodypart_remove(obj/item/bodypart/head/limb, movement_flags)
	. = ..()
	if(initial(limb.head_flags) & HEAD_EYESPRITES)
		limb.head_flags |= HEAD_EYESPRITES

//-- overlay --
/datum/bodypart_overlay/mutant/synth_head_cover/get_global_feature_list()
	return SSaccessories.synth_head_cover_list

/datum/bodypart_overlay/mutant/synth_head_cover/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	if(bodypart_owner.owner?.obscured_slots & HIDEHAIR)
		return FALSE
	if(bodypart_owner.limb_id == BODYPART_ID_SYNTH) // disguised = no head cover
		return TRUE
	if(IS_ROBOTIC_LIMB(bodypart_owner)) // works on android limbs too
		return TRUE
	return FALSE

/datum/bodypart_overlay/mutant/synth_head_cover
	feature_key = "synth_head_cover"
	layers = ALL_EXTERNAL_OVERLAYS

//-- accessories --
//the path to the icon for the head covers
/datum/sprite_accessory/synth_head_cover
	icon = 'maplestation_modules/icons/mob/synth_heads.dmi'

//head covers
/datum/sprite_accessory/synth_head_cover/none // for those that don't want a cover.
	name = "None"
	icon_state = null

//A kind of helmet looking thing with a big black screen/face cover thing. I dunno what else to call this.
/datum/sprite_accessory/synth_head_cover/helm
	name = "Helm"
	icon_state = "helm"

//helm with white plastic on the sides.
/datum/sprite_accessory/synth_head_cover/helm_white
	name = "White Helm"
	icon_state = "helm_white"

//just the IPC TV that is already in the code base
/datum/sprite_accessory/synth_head_cover/tv_blank
	name = "Tv_blank"
	icon_state = "tv_blank"

//a cool design inspired from cloak pilots in titanfall 2, *sorta*.
/datum/sprite_accessory/synth_head_cover/cloakp
	name = "Cloakp"
	icon_state = "cloakp"

//GUMTEETH's head
/datum/sprite_accessory/synth_head_cover/gumhead
	name = "GUMHEAD"
	icon_state = "gumhead"

// add more here!!


#undef BODYPART_ID_SYNTH
