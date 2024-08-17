#define AIRHIKE_ATTUNEMENT_WIND 0.5
#define AIRHIKE_MANA_COST 30

/datum/component/uses_mana/story_spell/airhike
	/// Attunement modifier for Wind attunement
	var/airhike_attunement_amount = AIRHIKE_ATTUNEMENT_WIND
	/// Base mana cost
	var/airhike_cost = AIRHIKE_MANA_COST

/* /datum/component/uses_mana/story_spell/airhike/react_to_successful_use(atom/cast_on)
	. = ..()

	drain_mana() */ // since this is near identical to the base proc, this might be superfluous.

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
	cooldown_time = 6 SECONDS

	invocation = "Zo Ka Cha Zo!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	//-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpdistance = 3
	var/jumpspeed = 2
	var/zup = FALSE

	var/mana_cost = AIRHIKE_MANA_COST

/datum/action/cooldown/spell/airhike/New(Target, original)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_WIND] += AIRHIKE_ATTUNEMENT_WIND

	AddComponent(/datum/component/uses_mana/spell, \
		mana_required = mana_cost, \
		attunements = attunements, \
	)

/datum/action/cooldown/spell/airhike/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/airhike/cast(mob/living/carbon/cast_on)
	. = ..()

	var/atom/target = get_edge_target_turf(cast_on, cast_on.dir) //gets the user's direction
	ADD_TRAIT(cast_on, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)  //Throwing itself doesn't protect mobs against lava (because gulag).
	//When Rclick checks there is an open turf above the caster, will send them upwards and forward a single tile.
	if (zup)
		var/turf/original_turf = get_turf(cast_on) //get the user's original turf so they can have a leave message
		cast_on.set_currently_z_moving(CURRENTLY_Z_ASCENDING)
		cast_on.zMove(UP, z_move_flags = ZMOVE_CHECK_PULLEDBY|ZMOVE_INCAPACITATED_CHECKS)
		original_turf.visible_message(span_warning("[cast_on] dashes upwards into the air!"))
		cast_on.visible_message(span_warning("[cast_on] dashes upwards into the air!"))
		jumpdistance = 1
	if (cast_on.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE, callback = TRAIT_CALLBACK_REMOVE(cast_on, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)))
		cast_on.visible_message(span_warning("[cast_on] dashes forward into the air!"))
	else
		to_chat(cast_on, span_warning("Something prevents you from dashing forward!"))
	jumpdistance = 3
	zup = FALSE

//Checks if caster is buckled, which prevents casting spell and using mana
/datum/action/cooldown/spell/airhike/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	if(owner.buckled)
		if(feedback)
			owner.balloon_alert(owner, "can't cast while buckled!")
		return FALSE
	return TRUE

//If Rclicked checks upwards a zlevel to see if caster can move up into an open turf.
/datum/action/cooldown/spell/airhike/Trigger(trigger_flags, atom/target)
	if (trigger_flags & TRIGGER_SECONDARY_ACTION)
		if(usr.can_z_move(UP, z_move_flags = ZMOVE_INCAPACITATED_CHECKS|ZMOVE_FEEDBACK))
			zup = TRUE
			return ..()
		to_chat(usr, span_warning("Something prevents you from dashing upwards!"))
		return FALSE
	return ..()

#undef AIRHIKE_ATTUNEMENT_WIND
#undef AIRHIKE_MANA_COST
