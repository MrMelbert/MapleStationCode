/datum/component/uses_mana/story_spell/conjure_item/flare

/datum/component/uses_mana/story_spell/conjure_item/flare/get_mana_required(...)
	. = ..()
	var/datum/action/cooldown/spell/conjure_item/flare/flare_spell = parent
	return (30 * flare_spell.owner.get_casting_cost_mult())

/datum/component/uses_mana/story_spell/conjure_item/flare/react_to_successful_use(atom/cast_on)
	. = ..()

	drain_mana()

/datum/action/cooldown/spell/conjure_item/flare
	name = "Flare"
	desc = "Conjure lumens into a glob to be thrown to light an area."

	sound = 'sound/items/match_strike.ogg'

	item_type = /obj/item/flashlight/glowstick/magic
	delete_old = FALSE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/conjure_item/flare/New(Target, original)
	. = ..()

	AddComponent(/datum/component/uses_mana/story_spell/conjure_item/flare)

/obj/item/flashlight/glowstick/magic
	name = "self sustaining flare"
	desc = "Lumens that stays alight similar to a candle."
	icon = 'maplestation_modules/icons/obj/magic_particles.dmi'
	icon_state = "mage_flare"
	base_icon_state = "mage_flare"
	color = LIGHT_COLOR_YELLOW
	on = TRUE
	var/auto_destroy = TRUE

/obj/item/flashlight/glowstick/magic/Initialize(mapload)
	. = ..()
	if (auto_destroy)
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/magic/turn_off()
	. = ..()
	unmagify()
	playsound(src, 'sound/chemistry/bufferadd.ogg', 75, TRUE)

///Give it the lesser magic icon and tell it to delete itself
/obj/item/flashlight/glowstick/magic/proc/unmagify()
	icon_state = "flare_decay"
	update_appearance()

	addtimer(CALLBACK(src, PROC_REF(decay)), 15 SECONDS)

/obj/item/flashlight/glowstick/magic/proc/decay()
	animate(src, alpha = 0, time = 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(decay_finished)), 3 SECONDS)

/obj/item/flashlight/glowstick/magic/proc/decay_finished()
	qdel(src)
