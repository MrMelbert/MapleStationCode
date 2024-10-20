#define FLARE_LIGHT_ATTUNEMENT 0.5
#define FLARE_BASE_MANA_COST 30

/datum/action/cooldown/spell/conjure_item/flare
	name = "Flare"
	desc = "Conjure lumens into a glob to be held or thrown to light an area. Right-click the spell icon to set the light color."
	button_icon = 'icons/obj/candle.dmi'
	button_icon_state = "candle1"

	sound = 'sound/items/match_strike.ogg'

	item_type = /obj/item/flashlight/glowstick/magic
	delete_old = FALSE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	/// What color the flare created appears to be
	var/flare_color
	/// What the mana cost is, affected by Lesser variant.
	var/mana_cost = FLARE_BASE_MANA_COST

//Variant that conjures a weaker version
/datum/spellbook_item/spell/conjure_item/flare/apply_params(datum/action/cooldown/spell/conjure_item/flare/our_spell, lesser)
	if (lesser)
		our_spell.item_type = /obj/item/flashlight/glowstick/magic/lesser
		our_spell.mana_cost = 10
		our_spell.cooldown_time = 2 MINUTES
		our_spell.name = "Lesser Flare"
		our_spell.desc = "Conjure lumens into a glob to be held or thrown to light an area. Right-click the spell icon to set the light color. This weaker version burns up quicker and has a considerable cooldown between conjures."
	return

/datum/action/cooldown/spell/conjure_item/flare/make_item()
	var/obj/item/created = ..()
	created.color = flare_color
	created.set_light_color(flare_color)
	return created

/datum/action/cooldown/spell/conjure_item/flare/New(Target, original)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_LIGHT] += FLARE_LIGHT_ATTUNEMENT

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = mana_cost, \
		attunements = attunements, \
	)

/obj/item/flashlight/glowstick/magic
	name = "self sustaining flare"
	desc = "Lumens that stays alight similar to a candle."
	icon = 'maplestation_modules/icons/obj/magic_particles.dmi'
	icon_state = "mage_flare"
	base_icon_state = "mage_flare"
	color = COLOR_VERY_SOFT_YELLOW
	actions_types = null
	//If it should decay and delete itself after it uses all its fuel
	var/auto_destroy = TRUE

/obj/item/flashlight/glowstick/magic/Initialize(mapload)
	. = ..()
	fuel = rand(5 MINUTES, 10 MINUTES)
	set_light_on(TRUE)

/obj/item/flashlight/glowstick/magic/lesser
	name = "lesser self sustaining flare"
	desc = "Lumens that stays alight similar to a candle. This one's small and appears unstable to sustain itself for long."
	light_range = 3

/obj/item/flashlight/glowstick/magic/lesser/Initialize(mapload)
	. = ..()
	fuel = rand(1 MINUTES, 5 MINUTES)

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

//Way to select a new color for flare before conjuring it.
/datum/action/cooldown/spell/conjure_item/flare/Trigger(trigger_flags, atom/target)
	if (trigger_flags & TRIGGER_SECONDARY_ACTION)
		flare_color = get_new_color(usr)
		return FALSE

	return ..()

/datum/action/cooldown/spell/conjure_item/flare/proc/get_new_color(mob/user)
	var/new_color
	new_color = input(user, "Choose a new color for the flare.", "Light Color", new_color) as color|null
	return new_color

#undef FLARE_LIGHT_ATTUNEMENT
#undef FLARE_BASE_MANA_COST
