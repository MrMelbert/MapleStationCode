/// List of huds we give to people wearing Wraith Specs.
#define SPEC_HUDS list(DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED)

// The Wraith Specs.
// Glasses that give you HUDs, night vision, x-ray, and nearsighted correction.
// ...But if you examine anything you'd be unable to see normally, you'll recieve eye damage.
/obj/item/clothing/glasses/wraith_specs
	name = "wraith specs"
	desc = "A set of glasses constructed by worshippers of Rat'var to grant them eyes of a wraith, greatly enhancing their sight."
	icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi'
	icon_state = "wraith_specs"
	worn_icon_state = "wraith_specs"
	inhand_icon_state = "trayson-meson"
	flags_cover = GLASSESCOVERSEYES
	flags_inv = HIDEEYES
	vision_flags = SEE_TURFS|SEE_MOBS|SEE_OBJS
	visor_vars_to_toggle = VISOR_VISIONFLAGS | VISOR_DARKNESSVIEW
	glass_colour_type = /datum/client_colour/glass_colour/yellow
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/wraith_specs/Initialize()
	. = ..()
	INVOKE_ASYNC(src, .proc/weldingvisortoggle)

/obj/item/clothing/glasses/wraith_specs/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user) || isobserver(user))
		. += span_brass("Grants the wearer diagnostic hud, medical hud, night vision, and x-ray vision. Also corrects nearsighted-ness.")
		. += span_brasstalics("Examining things only visible to you via x-ray vision will harm your eyes.")

/obj/item/clothing/glasses/wraith_specs/attack_self(mob/user, modifiers)
	. = ..()
	INVOKE_ASYNC(src, .proc/weldingvisortoggle, user)

/obj/item/clothing/glasses/wraith_specs/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_EYES)
		return
	if(ishuman(user) && !up)
		enable_glasses(user)

/obj/item/clothing/glasses/wraith_specs/dropped(mob/user)
	. = ..()
	if(ishuman(user) && !up)
		disable_glasses(user)

/obj/item/clothing/glasses/wraith_specs/weldingvisortoggle(mob/user)
	if(!can_use(user))
		return FALSE

	if(ishuman(user) && loc == user)
		var/mob/living/carbon/human/human_user = user
		if(human_user.glasses == src)
			if(up) //up = we're putting the glasses down (over our eyes)
				if(!enable_glasses(user))
					return FALSE

			else // not up = we're putting the glasses up (off our eyes)
				disable_glasses(user)

	. = ..()

/obj/item/clothing/glasses/wraith_specs/visor_toggling()
	. = ..()
	worn_icon_state = icon_state // we only want to change our worn_icon_state
	icon_state = initial(icon_state) // our initial icon_state can remain unchanged

/obj/item/clothing/glasses/wraith_specs/can_use(mob/user)
	if(!user) // No user, we assume whatever is calling this can "use" it
		return TRUE
	if(!isliving(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/*
 * Enable the hud and any other features of the goggles.
 * If the user / equipper is not a cultist, hurt them instead.
 */
/obj/item/clothing/glasses/wraith_specs/proc/enable_glasses(mob/living/carbon/human/user)
	if(!IS_CULTIST(user))
		if(user.is_blind())
			return FALSE

		var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
		if(!eyes)
			return FALSE

		to_chat(user, span_danger("[src] shines brightly directly into your eyes, burning them!"))
		user.flash_act()
		user.blur_eyes(5 SECONDS)
		eyes.applyOrganDamage(25)
		user.apply_damage(10, BURN, BODY_ZONE_HEAD)
		user.pain_emote("scream", 6 SECONDS)
		return FALSE

	for(var/hud in SPEC_HUDS)
		var/datum/atom_hud/new_hud = GLOB.huds[hud]
		new_hud.add_hud_to(user)
	ADD_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
	ADD_TRAIT(user, TRAIT_DIAGNOSTIC_HUD, GLASSES_TRAIT)
	RegisterSignal(user, COMSIG_MOB_EXAMINATE, .proc/on_user_examinate)

	darkness_view = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	vision_correction = TRUE
	user.clear_fullscreen("nearsighted")
	user.update_glasses_color(src, TRUE)
	return TRUE

/*
 * Disable the hud and any other features of the goggles.
 */
/obj/item/clothing/glasses/wraith_specs/proc/disable_glasses(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
	REMOVE_TRAIT(user, TRAIT_DIAGNOSTIC_HUD, GLASSES_TRAIT)
	for(var/hud in SPEC_HUDS)
		var/datum/atom_hud/removed_hud = GLOB.huds[hud]
		removed_hud.remove_hud_from(user)
	UnregisterSignal(user, COMSIG_MOB_EXAMINATE)

	darkness_view = 2
	lighting_alpha = null
	vision_correction = FALSE
	if(HAS_TRAIT(user, TRAIT_NEARSIGHT))
		user.overlay_fullscreen("nearsighted", /atom/movable/screen/fullscreen/impaired, 1)
	user.update_glasses_color(src, FALSE)
	return TRUE

/*
 * Signal proc for [COMSIG_MOB_EXAMINATE]
 */
/obj/item/clothing/glasses/wraith_specs/proc/on_user_examinate(datum/source, atom/examined)
	SIGNAL_HANDLER

	if(!ishuman(source))
		return

	var/mob/living/carbon/human/human_source = source
	if(human_source.is_blind())
		return

	var/obj/item/organ/eyes/eyes = human_source.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return

	if((examined in view(human_source.loc)) || (examined in human_source.get_all_contents()))
		return

	to_chat(source, span_danger("Your eyes burn as you fixate on [examined]!"))
	human_source.flash_act(visual = TRUE)
	human_source.blur_eyes(0.5 SECONDS)
	eyes.applyOrganDamage(10)

#undef SPEC_HUDS
