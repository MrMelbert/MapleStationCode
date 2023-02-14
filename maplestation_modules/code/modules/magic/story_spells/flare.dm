/datum/component/uses_mana/story_spell/conjure_item/flare
/datum/component/uses_mana/story_spell/conjure_item/flare/get_attunement_dispositions()
	MAGIC_ELEMENT_LIGHT

#define FLARE_MANA_COST 30

/datum/component/uses_mana/story_spell/conjure_item/flare/get_mana_required(...)
	. = ..()
	var/datum/action/cooldown/spell/conjure_item/flare/flare_spell = parent
	return (FLARE_MANA_COST * flare_spell.owner.get_casting_cost_mult())

/datum/component/uses_mana/story_spell/conjure_item/flare/react_to_successful_use(atom/cast_on)
	. = ..()

	drain_mana()

/datum/action/cooldown/spell/conjure_item/flare
	name = "Flare"
	desc = "Conjure lumens into a glob to be thrown to light an area. Right-click the spell icon to set the light color."
	icon_icon = 'icons/obj/candle.dmi'
	button_icon_state = "candle1"

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

//Will have the flare start on and slowly burn through its fuel, when it runs out it will fizzle, fade out and delete itself. Similar to magic lockers from the staff.
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

/*WIP: Not sure how to call the color picker on Rightclick and make it work! Way to select a new color for flare before conjuring it.
/datum/action/cooldown/spell/conjure_item/flare/Trigger(trigger_flags, atom/target)
	if (trigger_flags & TRIGGER_SECONDARY_ACTION)
		get_new_color()
		return FALSE

	. = ..()


/datum/action/cooldown/spell/conjure_item/flare/proc/get_new_color()
	var/mob/user = usr
	var/new_color
	while(!new_color)
		new_color = input(user, "Choose a new color for flare.", "Light Color", new_color) as color|null
		if(!new_color)
			return
		if(is_color_dark(new_color, 50) ) //Colors too dark are rejected
			to_chat(user, span_warning("That color is too dark! Choose a lighter one."))
			new_color = null
	color = new_color
	update_appearance()
	return
*/
