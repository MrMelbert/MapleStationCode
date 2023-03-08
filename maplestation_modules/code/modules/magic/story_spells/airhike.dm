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

//If there isn't enough mana and the Rclick check passes so it won't mess up any future Normal casts
/datum/component/uses_mana/story_spell/airhike/can_activate_check_failure(give_feedback, ...)
	var/datum/action/cooldown/spell/airhike/airhike_spell = parent
	airhike_spell.zup = FALSE
	return ..()

/datum/action/cooldown/spell/airhike
	name = "Air Hike"
	desc = "Force wind beneath one's feet for a boost of movement where you're facing. Right-click the spell icon to attempt to jump up a level and go forward a tile instead."
	button_icon_state = "blink"

	sound = 'sound/effects/stealthoff.ogg'
	school = SCHOOL_TRANSLOCATION

	invocation = "Zo Ka Cha Zo!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	//-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpdistance = 3
	var/jumpspeed = 1
	var/zup = FALSE

/datum/action/cooldown/spell/airhike/New(Target, original)
	. = ..()

	AddComponent(/datum/component/uses_mana/story_spell/airhike)

/datum/action/cooldown/spell/airhike/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/airhike/cast(mob/living/carbon/cast_on)
	. = ..()

	var/atom/target = get_edge_target_turf(cast_on, cast_on.dir) //gets the user's direction
	ADD_TRAIT(cast_on, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)  //Throwing itself doesn't protect mobs against lava (because gulag).
	//When Rclick checks there is an open turf above the caster, will send them upwards and forward a single tile.
	if (zup)
		cast_on.set_currently_z_moving(CURRENTLY_Z_ASCENDING)
		cast_on.zMove(target = get_step_multiz(get_turf(usr), UP), z_move_flags = ZMOVE_CHECK_PULLEDBY|ZMOVE_ALLOW_BUCKLED)
		cast_on.visible_message(span_warning("[usr] dashes upwards into the air!"))
		jumpdistance = 1
	if (cast_on.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE, callback = TRAIT_CALLBACK_REMOVE(cast_on, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)))
		cast_on.visible_message(span_warning("[usr] dashes forward into the air!"))
	else
		to_chat(cast_on, span_warning("Something prevents you from dashing forward!"))
	jumpdistance = 3
	zup = FALSE

//If Rclicked checks upwards a zlevel to see if caster can move up into an open turf.
/datum/action/cooldown/spell/airhike/Trigger(trigger_flags, atom/target)
	if (trigger_flags & TRIGGER_SECONDARY_ACTION)
		var/turf/checking = get_step_multiz(get_turf(usr), UP)
		if(!istype(checking))
			to_chat(usr, span_warning("Something prevents you from dashing upwards!"))
			return FALSE
		if(!checking.zPassIn(usr, UP, get_turf(usr)))
			to_chat(usr, span_warning("Something prevents you from dashing upwards!"))
			return FALSE
		zup = TRUE

	return ..()
