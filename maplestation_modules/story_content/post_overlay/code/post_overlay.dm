/datum/action/innate/story_post_overlay
	name = "Toggle Post Overlay"
	icon_icon = 'icons/obj/wizard.dmi' //Not making a sprite for something people won't see, so fireball because it looks like a generic soul.
	button_icon_state = "fireball"
	var/overlay_activated = FALSE

/datum/action/innate/story_post_overlay/Activate()
	var/mob/living/carbon/human/user = owner
	if(overlay_activated)
		user.remove_overlay(HALO_LAYER) //Technically removes cult halo, but this is on a character that's aligned with the clock cult anyway
		user.update_body()
		overlay_activated = FALSE

	else
		var/mutable_appearance/overlay = mutable_appearance('maplestation_modules/story_content/post_overlay/icons/post_overlay.dmi', "post_overlay", -HALO_LAYER)
		user.overlays_standing[HALO_LAYER] = overlay //using the halo layer because too lazy to see if there are better layers for something that wont ever conflict
		user.apply_overlay(HALO_LAYER)
		overlay_activated = TRUE

/obj/item/story_post_overlay_granter //Just an item to make getting the overlay easy.
	name = "Post Overlay Granter"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "duffelcurse"
	desc = "If you have this, either an admin wants to do something wacky or something seriously wrong has happened."

/obj/item/story_post_overlay_granter/attack_self(mob/user)
	var/datum/action/innate/story_post_overlay/overlay_action = new /datum/action/innate/story_post_overlay
	overlay_action.Grant(user)
	qdel(src)
