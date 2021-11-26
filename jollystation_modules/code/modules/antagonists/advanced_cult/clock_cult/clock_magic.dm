
/datum/action/item_action/cult
	var/examine_hint
	var/active = FALSE
	var/invocation
	var/charges = 1
	var/base_desc
	var/datum/action/innate/cult/blood_magic/magic_source // don't think about it too much

/datum/action/item_action/cult/New(Target, datum/action/innate/cult/blood_magic/new_magic)
	. = ..()
	if(new_magic)
		magic_source = new_magic
	base_desc = desc
	desc += "<br><b><u>Has [charges] use\s remaining</u></b>."

/datum/action/item_action/cult/Grant(mob/M)
	if(!IS_CULTIST(M) || M != magic_source?.owner)
		Remove(owner)
		return

	return ..()

/datum/action/item_action/cult/Destroy()
	if(active)
		unregister_all_signals()
	if(magic_source)
		magic_source.spells -= src
		magic_source = null
	return ..()

/datum/action/item_action/cult/Trigger()
	var/obj/item/item_target = target
	for(var/datum/action/item_action/cult/spell in item_target.actions)
		if(spell != src && spell.active)
			spell.deactivate()

	if(active)
		deactivate()
	else
		activate()

/datum/action/item_action/cult/proc/activate()
	active = TRUE
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(target, COMSIG_ITEM_ATTACK, .proc/try_spell_effects)
	RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/drop_deactivate)
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/equip_deactivate)

/datum/action/item_action/cult/proc/deactivate()
	active = FALSE
	unregister_all_signals()

/datum/action/item_action/cult/proc/unregister_all_signals()
	UnregisterSignal(target, list(COMSIG_PARENT_EXAMINE, COMSIG_ITEM_ATTACK, COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED))

/datum/action/item_action/cult/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!IS_CULTIST(user))
		return

	examine_list += span_alloy("[name] is currently readied on [target], which will [examine_hint]")

/datum/action/item_action/cult/proc/try_spell_effects(datum/source, mob/living/victm, mob/living/user)
	SIGNAL_HANDLER

	if(!IS_CULTIST(user))
		return

	if(victm == user)
		if(do_self_spell_effects(user))
			. = COMPONENT_NO_AFTERATTACK

	else if(!IS_CULTIST(victm))
		if(do_hit_spell_effects(victm, user))
			. = COMPONENT_NO_AFTERATTACK

	if(. == COMPONENT_NO_AFTERATTACK)
		INVOKE_ASYNC(src, .proc/after_successful_spell, user)

/datum/action/item_action/cult/proc/drop_deactivate(datum/source, mob/living/user)
	SIGNAL_HANDLER

	deactivate()

/datum/action/item_action/cult/proc/equip_deactivate(datum/source, mob/living/taker)
	SIGNAL_HANDLER

	if(IS_CULTIST(taker))
		return

	deactivate()

/datum/action/item_action/cult/proc/do_self_spell_effects(mob/living/user)

/datum/action/item_action/cult/proc/do_hit_spell_effects(mob/living/victm, mob/living/user)

/datum/action/item_action/cult/proc/after_successful_spell(mob/living/user)
	if(invocation)
		user.whisper(invocation, language = /datum/language/ratvarian, forced = "cult invocation")
	if(--charges <= 0)
		qdel(src)

/datum/action/item_action/cult/clock_spell
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_clockcult.dmi'
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough

/datum/action/innate/cult/clock_spell
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_clockcult.dmi'
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough

	var/charges = 1
	var/datum/action/innate/cult/blood_magic/all_magic
	var/base_desc //To allow for updating tooltips
	var/invocation

/datum/action/innate/cult/clock_spell/Grant(mob/living/owner, datum/action/innate/cult/blood_magic/magic_source)
	base_desc = desc
	desc += "<br><b><u>Has [charges] use\s remaining</u></b>."
	all_magic = magic_source
	. = ..()
	button.locked = TRUE
	button.ordered = FALSE

/datum/action/innate/cult/clock_spell/Remove()
	if(all_magic)
		all_magic.spells -= src
		all_magic = null
	return ..()

/datum/action/innate/cult/clock_spell/IsAvailable()
	if(!IS_CULTIST(owner) || owner.incapacitated() || charges <= 0)
		return FALSE
	return ..()

/datum/action/innate/cult/blood_magic/advanced/clock
	name = "Prepare Clockwork Magic"
	desc = "Invoke clockwork magic into your slab. This is easier by a <b>sigil of power</b>."
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough
