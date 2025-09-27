// If there's a way to apply status effects from the varedit verbs dropdown please god tell me
/// ++ Effects used by the Sense Equilibrium spell ++
//* + Positive +

/// Understand All Languages
/datum/status_effect/language_comprehension
	id = "language_comprehension"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS
	var/trait_source = MAGIC_TRAIT

/datum/status_effect/language_comprehension/on_creation(mob/living/new_owner, duration = 15 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/language_comprehension/on_apply()
	owner.grant_all_languages(source = trait_source)
	return ..()

/datum/status_effect/language_comprehension/on_remove()
	owner.remove_all_languages(source = trait_source)
	return ..()

/// Huds
/datum/status_effect/temporary_hud
	id = "temporary_hud"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	duration = 30 SECONDS
	/// The trait of hud we give
	var/hud_trait = null

/datum/status_effect/temporary_hud/on_creation(mob/living/new_owner, duration = 15 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/temporary_hud/on_apply()
	if(hud_trait)
		ADD_TRAIT(owner, hud_trait, type)
	return ..()

/datum/status_effect/temporary_hud/on_remove()
	if(hud_trait)
		REMOVE_TRAIT(owner, hud_trait, type)
	return ..()

/datum/status_effect/temporary_hud/med
	id = "temporary_hud_med"
	hud_trait = TRAIT_MEDICAL_HUD

/datum/status_effect/temporary_hud/sec
	id = "temporary_hud_sec"
	hud_trait = TRAIT_SECURITY_HUD

/datum/status_effect/temporary_hud/diag
	id = "temporary_hud_diag"
	hud_trait = TRAIT_DIAGNOSTIC_HUD

/datum/status_effect/mesons
	id = "meson_vision"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	duration = 30 SECONDS

/datum/status_effect/mesons/on_creation(mob/living/new_owner, duration = 15 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/mesons/on_apply()
	ADD_TRAIT(owner, TRAIT_MESON_VISION, type)
	owner.update_sight()
	return ..()

/datum/status_effect/mesons/on_remove()
	REMOVE_TRAIT(owner, TRAIT_MESON_VISION, type)
	owner.update_sight()
	return ..()

/// Night Vision
/datum/status_effect/night_vision
	id = "temporary_night_vision"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS

/datum/status_effect/night_vision/on_creation(mob/living/new_owner, duration = 15 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/night_vision/on_apply()
	owner.lighting_cutoff = LIGHTING_CUTOFF_MEDIUM
	owner.update_sight()
	return ..()

/datum/status_effect/night_vision/on_remove()
	owner.default_lighting_cutoff()
	owner.update_sight()
	return ..()

/// Self-Aware
/datum/status_effect/trait_effect/self_aware
	id = "temporary_self_aware"
	// Just having self-aware felt pretty bare to me, so tenacious should help
	trait_to_add = list(TRAIT_SELF_AWARE, TRAIT_TENACIOUS)

/// Enhanced Palette
/datum/status_effect/trait_effect/enhanced_tastebuds
	id = "enhanced_tastebuds"
	trait_to_add = TRAIT_DETECTIVES_TASTE

/// Echolocation (Not the component, rather this functions more like the reactive sonar module.)
/datum/status_effect/basic_echolocation
	id = "basic_echolocation"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS
	tick_interval = 5 SECONDS
	/// Mobs that are currently in our radius
	var/list/tracked_mobs

/datum/status_effect/basic_echolocation/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/basic_echolocation/on_apply()
	LAZYINITLIST(tracked_mobs)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_owner_ranges))
	return ..()

/datum/status_effect/basic_echolocation/tick(seconds_between_ticks)
	check_owner_ranges()
	return ..()

/datum/status_effect/basic_echolocation/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	for(var/mob/living/creature as anything in tracked_mobs)
		UnregisterSignal(creature, COMSIG_MOVABLE_MOVED)
	LAZYNULL(tracked_mobs)
	return ..()

/// Create a visual at the source of the sound showing where the sound came from.
/datum/status_effect/basic_echolocation/proc/sonar_ping(atom/movable/source, atom/oldloc, direction, forced, list/old_locs)
	SIGNAL_HANDLER

	new /obj/effect/temp_visual/echolocation_ring(owner.loc, owner, source)

/// Check in a radius around us to register movable to any mods in said radius
/datum/status_effect/basic_echolocation/proc/check_owner_ranges(atom/movable/source, atom/oldloc, direction, forced, list/old_locs)
	SIGNAL_HANDLER

	// Check both what we can and cannot see
	var/list/seen_atoms = view(world.view, owner)
	var/list/heard_atoms = range(world.view, owner)
	// Remove any tracked mobs that aren't in range anymore
	if(LAZYLEN(tracked_mobs))
		for(var/mob/living/creature in tracked_mobs)
			if(!(creature in heard_atoms))
				LAZYREMOVE(tracked_mobs, creature)
				UnregisterSignal(creature, COMSIG_MOVABLE_MOVED)
	// If something isn't visible & it isn't already in the list, add it
	for(var/mob/living/creature in heard_atoms)
		if(!(creature in seen_atoms) && !(creature in tracked_mobs))
			LAZYADD(tracked_mobs, creature)
			RegisterSignal(creature, COMSIG_MOVABLE_MOVED, PROC_REF(sonar_ping))

/// Copy-pasted from /obj/effect/temp_visual/sonar_ping, with edits for what it's required to do
/obj/effect/temp_visual/echolocation_ring
	duration = 3 SECONDS
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	randomdir = FALSE
	icon = 'maplestation_modules/icons/effects/misc.dmi'
	icon_state = null
	/// The image shown the echolocator
	var/image/echo_image
	/// The person in the modsuit at the moment, really just used to remove this from their screen
	var/datum/weakref/owner
	/// The location of where the creature just moved
	var/creature_movement_x = 0
	var/creature_movement_y = 0

/obj/effect/temp_visual/echolocation_ring/Initialize(mapload, mob/living/looker, mob/living/creature)
	. = ..()
	if(!looker || !creature)
		return INITIALIZE_HINT_QDEL

	echo_image = image(icon = icon, loc = looker.loc, icon_state = "echo_ring", layer = ABOVE_ALL_MOB_LAYER)
	echo_image.transform = matrix().Scale(0.1)
	echo_image.plane = ABOVE_LIGHTING_PLANE
	// save the location since we're not tracking the creature, but rather where the creature just was
	creature_movement_x = creature.x
	creature_movement_y = creature.y

	echo_image.pixel_w = ((creature.x - looker.x) * 32) + creature.pixel_w
	echo_image.pixel_z = ((creature.y - looker.y) * 32) + creature.pixel_y

	SET_PLANE_EXPLICIT(echo_image, ABOVE_LIGHTING_PLANE, creature)
	owner = WEAKREF(looker)
	looker?.client?.images |= echo_image
	RegisterSignal(looker, COMSIG_MOVABLE_MOVED, PROC_REF(on_user_moved))
	animate(echo_image, duration-1, easing = SINE_EASING | EASE_OUT, transform = matrix().Scale(1.5), alpha = 0)

/// If the user moves, we want to move the effect on top of them so they always see it
/obj/effect/temp_visual/echolocation_ring/proc/on_user_moved(atom/movable/source, atom/oldloc, direction, forced, list/old_locs)
	SIGNAL_HANDLER

	echo_image.loc = source.loc
	echo_image.pixel_w = ((creature_movement_x - source.x) * 32)
	echo_image.pixel_z = ((creature_movement_y - source.y) * 32)

/obj/effect/temp_visual/echolocation_ring/Destroy()
	var/mob/living/previous_user = owner?.resolve()
	if(previous_user)
		previous_user?.client?.images -= echo_image
		UnregisterSignal(previous_user, COMSIG_MOVABLE_MOVED)
	// Null so we don't shit the bed when we delete
	QDEL_NULL(echo_image)
	return ..()

/// Strong Hugs
/datum/status_effect/trait_effect/good_hugs
	id = "good_hugs"
	trait_to_add = TRAIT_FRIENDLY

/// Empath
/datum/status_effect/trait_effect/empath
	id = "empath"
	trait_to_add = TRAIT_EMPATH

/// Light Step
/datum/status_effect/trait_effect/light_step
	id = "light_step"
	trait_to_add = list(TRAIT_LIGHT_STEP, TRAIT_SILENT_FOOTSTEPS)

/// Push Immunity
/datum/status_effect/trait_effect/push_immunity
	id = "push_immunity"
	trait_to_add = list(TRAIT_PUSHIMMUNE, TRAIT_ROD_SUPLEX)

/// Eavesdropping
/datum/status_effect/trait_effect/eavesdropping
	id = "eavesdropping"
	trait_to_add = list(TRAIT_GOOD_HEARING, TRAIT_HEAR_THROUGH_DARKNESS, TRAIT_XRAY_HEARING)

/// Quick Hands
/datum/status_effect/trait_effect/quick_hands
	id = "quick_hands"
	trait_to_add = list(TRAIT_QUICKER_CARRY, TRAIT_QUICK_BUILD, TRAIT_FAST_CUFFING, TRAIT_FAST_TYING)

//* + Negative +

/// Tower of Babel with no alert
/datum/status_effect/tower_of_babel/equilibrium
	id = "tower_of_babel_equilibrium"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	trait_source = MAGIC_TRAIT

/// Phobia brain trauma w/ a duration
/datum/status_effect/sudden_phobia
	id = "sudden_phobia"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS

/datum/status_effect/sudden_phobia/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/sudden_phobia/on_apply()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/afflicted = owner
	afflicted.gain_trauma(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_MAGIC)
	return ..()

/datum/status_effect/sudden_phobia/on_remove()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/afflicted = owner
	afflicted.cure_trauma_type(/datum/brain_trauma/mild/phobia, resilience = TRAUMA_RESILIENCE_MAGIC)
	return ..()

/// Nightmare Vision Goggles effect but a temporary status effect
/datum/status_effect/nightmare_vision
	id = "nightmare_vision"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS

/datum/status_effect/nightmare_vision/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/nightmare_vision/on_apply()
	owner.add_client_colour(/datum/client_colour/glass_colour/nightmare)
	return ..()

/datum/status_effect/nightmare_vision/on_remove()
	owner.remove_client_colour(/datum/client_colour/glass_colour/nightmare)
	return ..()

/// Deaf
/datum/status_effect/trait_effect/deafened
	id = "deafened"
	trait_to_add = TRAIT_DEAF

/// No Taste
/datum/status_effect/trait_effect/tasteless
	id = "tasteless"
	trait_to_add = TRAIT_AGEUSIA

/// Ananas Affinity
/datum/status_effect/ananas_affinity
	id = "ananas_affinity"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS
	/// What they liked to eat before the spell
	var/likes_before_spell

/datum/status_effect/ananas_affinity/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/ananas_affinity/on_apply()
	var/obj/item/organ/internal/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return FALSE
	RegisterSignal(owner, COMSIG_ORGAN_REMOVED, PROC_REF(check_if_tongue))
	likes_before_spell = tongue.liked_foodtypes
	tongue.liked_foodtypes |= PINEAPPLE
	return ..()

/datum/status_effect/ananas_affinity/on_remove()
	var/obj/item/organ/internal/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return ..()
	tongue.liked_foodtypes = likes_before_spell
	return ..()

/datum/status_effect/ananas_affinity/proc/check_if_tongue(obj/item/organ/source, mob/living/carbon/old_owner)
	SIGNAL_HANDLER

	if(!istype(source, /obj/item/organ/internal/tongue))
		return
	var/obj/item/organ/internal/tongue/tongue = source
	if(likes_before_spell)
		tongue.liked_foodtypes = likes_before_spell

	UnregisterSignal(owner, COMSIG_ORGAN_REMOVED)
	qdel(src)
	return

/// Ananas Aversion
/datum/status_effect/ananas_aversion
	id = "ananas_affinity"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS
	/// What they hated before the spell
	var/disliked_before_spell

/datum/status_effect/ananas_aversion/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/ananas_aversion/on_apply()
	var/obj/item/organ/internal/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return FALSE
	RegisterSignal(owner, COMSIG_ORGAN_REMOVED, PROC_REF(check_if_tongue))
	disliked_before_spell = tongue.disliked_foodtypes
	tongue.disliked_foodtypes |= PINEAPPLE
	return ..()

/datum/status_effect/ananas_aversion/on_remove()
	var/obj/item/organ/internal/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return ..()
	tongue.disliked_foodtypes = disliked_before_spell
	return ..()

/datum/status_effect/ananas_aversion/proc/check_if_tongue(obj/item/organ/source, mob/living/carbon/old_owner)
	SIGNAL_HANDLER

	if(!istype(source, /obj/item/organ/internal/tongue))
		return
	var/obj/item/organ/internal/tongue/tongue = source
	if(disliked_before_spell)
		tongue.disliked_foodtypes = disliked_before_spell

	UnregisterSignal(owner, COMSIG_ORGAN_REMOVED)
	qdel(src)
	return

/// Reversed Palette
/datum/status_effect/reversed_palette
	id = "reversed_palette"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS
	/// What they liked to eat before the spell
	var/likes_before_spell
	/// What they hated before the spell
	var/disliked_before_spell

/datum/status_effect/reversed_palette/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/reversed_palette/on_apply()
	var/obj/item/organ/internal/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return FALSE
	RegisterSignal(owner, COMSIG_ORGAN_REMOVED, PROC_REF(check_if_tongue))
	likes_before_spell = tongue.liked_foodtypes
	disliked_before_spell = tongue.disliked_foodtypes
	tongue.disliked_foodtypes = likes_before_spell
	tongue.liked_foodtypes = disliked_before_spell
	return ..()

/datum/status_effect/reversed_palette/on_remove()
	UnregisterSignal(owner, COMSIG_ORGAN_REMOVED)
	var/obj/item/organ/internal/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return ..()
	tongue.disliked_foodtypes = disliked_before_spell
	tongue.liked_foodtypes = likes_before_spell
	return ..()

/datum/status_effect/reversed_palette/proc/check_if_tongue(obj/item/organ/source, mob/living/carbon/old_owner)
	SIGNAL_HANDLER

	if(!istype(source, /obj/item/organ/internal/tongue))
		return
	var/obj/item/organ/internal/tongue/tongue = source
	if(likes_before_spell)
		tongue.liked_foodtypes = likes_before_spell
	if(disliked_before_spell)
		tongue.disliked_foodtypes = disliked_before_spell

	UnregisterSignal(owner, COMSIG_ORGAN_REMOVED)
	qdel(src)
	return

/// Fake Healthiness
/datum/status_effect/grouped/screwy_hud/fake_healthy/equilibrium
	id = "fake_hud_healthy_equilibrium"
	duration = 30 SECONDS

/datum/status_effect/grouped/screwy_hud/fake_healthy/equilibrium/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/// Color Blindness
/datum/status_effect/color_blindness
	id = "color_blindness"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS

/datum/status_effect/color_blindness/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/color_blindness/on_apply()
	owner.add_client_colour(/datum/client_colour/monochrome/colorblind)
	return ..()

/datum/status_effect/color_blindness/on_remove()
	owner.remove_client_colour(/datum/client_colour/monochrome/colorblind)
	return ..()

/// Hemiplegic
/datum/status_effect/trait_effect/hemiplegia
	id = "hemiplegia"
	trait_to_add = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_L_LEG)

/datum/status_effect/trait_effect/hemiplegia/on_apply()
	// Randomly pick between either left or right
	trait_to_add = pick(list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_L_LEG), list(TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_R_LEG))
	return ..()

/// Clumsiness
/datum/status_effect/trait_effect/clumsiness
	id = "clumsiness"
	trait_to_add = TRAIT_CLUMSY

/// Illiterate
/datum/status_effect/trait_effect/illiterate
	id = "illiterate"
	trait_to_add = TRAIT_ILLITERATE

/// Whispering
/datum/status_effect/trait_effect/whispering
	id = "whispering"
	trait_to_add = TRAIT_SOFTSPOKEN

/// Discoordinated
/datum/status_effect/discoordinated/equilibrium
	id = "discoordinated_equilibrium"
	duration = 30 SECONDS
	alert_type = null

/datum/status_effect/discoordinated/equilibrium/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/// Prosopagnosia
/datum/status_effect/prosopagnosia
	id = "prosopagnosia"

/datum/status_effect/prosopagnosia/on_apply()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/grouped/see_no_names/allow_ids, REF(src))

/datum/status_effect/prosopagnosia/on_remove()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/grouped/see_no_names/allow_ids, REF(src))

/// Thermal Weakness
/datum/status_effect/thermal_weakness
	id = "thermal_weakness"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS
	/// The starting values for the cold & heat mods
	var/start_cold_mod
	var/start_heat_mod

/datum/status_effect/thermal_weakness/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

// No matter your race you're gonna get hit HARD by this
/datum/status_effect/thermal_weakness/on_apply()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/afflicted = owner
	start_cold_mod = afflicted.physiology?.cold_mod
	start_heat_mod = afflicted.physiology?.heat_mod
	afflicted.physiology?.cold_mod = 5
	afflicted.physiology?.heat_mod = 5
	return ..()

/datum/status_effect/thermal_weakness/on_remove()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/afflicted = owner
	afflicted.physiology?.cold_mod = start_cold_mod
	afflicted.physiology?.heat_mod = start_heat_mod
	return ..()

/// Hyperalgesia
/datum/status_effect/hyperalgesia
	id = "hyperalgesia"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 30 SECONDS

/datum/status_effect/hyperalgesia/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/hyperalgesia/on_apply()
	owner.set_pain_mod(PAIN_MOD_STATUS_EFFECT, 2)
	return ..()

/datum/status_effect/hyperalgesia/on_remove()
	owner.unset_pain_mod(PAIN_MOD_STATUS_EFFECT)
	return ..()
