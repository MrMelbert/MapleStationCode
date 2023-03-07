/datum/component/uses_mana/story_spell/airhike
	var/attunement_amount = 0.5
	var/airhike_cost = 30

/datum/component/uses_mana/story_spell/airhike/get_attunement_dispositions()
	. = ..()
	.[MAGIC_ELEMENT_WIND] += attunement_amount

/datum/component/uses_mana/story_spell/airhike/get_mana_required(...)
	. = ..()
	var/datum/action/cooldown/spell/airhike/airhike_spell = parent
	return (airhike_cost * airhike_spell.owner.get_casting_cost_mult())

/datum/component/uses_mana/story_spell/airhike/react_to_successful_use(atom/cast_on)
	. = ..()

	drain_mana()

/datum/action/cooldown/spell/airhike
	name = "Air Hike"
	desc = "Force wind beneath one's feet for a boost of movement where you're facing."
	button_icon_state = "blink"

	sound = 'sound/effects/stealthoff.ogg'
	school = SCHOOL_TRANSLOCATION

	invocation = "Zo Ka Cha Zo!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	//-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpdistance = 3
	var/jumpspeed = 3

/datum/action/cooldown/spell/airhike/New(Target, original)
	. = ..()

	AddComponent(/datum/component/uses_mana/story_spell/airhike)

/datum/action/cooldown/spell/airhike/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/airhike/cast(mob/living/carbon/cast_on)
	. = ..()

	var/atom/target = get_edge_target_turf(cast_on, cast_on.dir) //gets the user's direction

	ADD_TRAIT(cast_on, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)  //Throwing itself doesn't protect mobs against lava (because gulag).
	if (cast_on.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE, callback = TRAIT_CALLBACK_REMOVE(cast_on, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)))
		cast_on.visible_message(span_warning("[usr] dashes forward into the air!"))
	else
		to_chat(cast_on, span_warning("Something prevents you from dashing forward!"))
