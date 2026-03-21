/mob/living/basic/bot/medbot
	icon = 'maplestation_modules/icons/mob/silicon/aibots.dmi'
	icon_state = "medbot_generic_idle"
	base_icon_state = "medbot"
	skin = "generic"
	/// The icon_state of the smile
	var/smile_icon_state = "medbot_smile"
	/// Time between smiles
	var/smile_cooldown_time = 30 SECONDS

	COOLDOWN_DECLARE(smile_cooldown)

/mob/living/basic/bot/medbot/Life(seconds_per_tick, times_fired)
	. = ..()
	if(QDELETED(src) || stat == DEAD || !(bot_mode_flags & BOT_MODE_ON) || mode == BOT_HEALING)
		return
	if(!COOLDOWN_FINISHED(src, smile_cooldown))
		return
	handle_smile()

/mob/living/basic/bot/medbot/proc/handle_smile()
	var/mutable_appearance/smile_image = mutable_appearance(icon, smile_icon_state)
	flick_overlay_view(smile_image, 2.3 SECONDS)
	COOLDOWN_START(src, smile_cooldown, rand(smile_cooldown_time-(5 SECONDS), smile_cooldown_time+(5 SECONDS)))

/mob/living/basic/bot/medbot/mysterious
	smile_icon_state = "medbot_frown"

/mob/living/basic/bot/medbot/nukie
	smile_icon_state = "medbot_frown"

/mob/living/basic/bot/medbot/derelict
	smile_icon_state = "medbot_frown"

/obj/item/bot_assembly/medbot
	icon = 'maplestation_modules/icons/mob/silicon/aibots.dmi'
	icon_state = "medbot_assembly_generic"
	base_icon_state = "medbot_assembly"
