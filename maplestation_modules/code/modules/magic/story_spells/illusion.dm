/datum/component/uses_mana/story_spell/pointed/illusion
	var/illusion_attunement = 0.5
	var/illusion_cost = 25

/datum/component/uses_mana/story_spell/pointed/illusion/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/light] = illusion_attunement

/datum/component/uses_mana/story_spell/pointed/illusion/get_mana_required(...)
	return ..() * illusion_cost

/datum/action/cooldown/spell/pointed/illusion
	name = "Illusion"
	desc = "Summon an illusion at the target location. Less effective in dark areas."
	sound = 'sound/effects/magic.ogg'

	cooldown_time = 2 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	school = SCHOOL_CONJURATION

	aim_assist = FALSE
	cast_range = 20 // For camera memes

	/// Duration of the illusionary mob
	var/conjured_duration = 8 SECONDS
	/// HP of the illusionary mob
	var/conjured_hp = 10

/datum/action/cooldown/spell/pointed/illusion/is_valid_target(atom/cast_on)
	var/turf/castturf = get_turf(cast_on)
	return isopenturf(castturf) && !isgroundlessturf(castturf)

/datum/action/cooldown/spell/pointed/illusion/cast(atom/cast_on)
	. = ..()
	var/turf/castturf = get_turf(cast_on)
	var/mob/copy_target = select_copy_target()
	var/mob/living/simple_animal/hostile/illusion/conjured/decoy = new(castturf)
	decoy.alpha = clamp(255 * castturf.get_lumcount(), 75, 225) // alpha is based on how bright the turf is. Darker = weaker illusion
	decoy.fake_spin()
	if(!isnull(copy_target))
		decoy.Copy_Parent(copy_target, conjured_duration, conjured_hp)

	owner?.emote("snap")

/// Determines what mob to copy for the illusion
/datum/action/cooldown/spell/pointed/illusion/proc/select_copy_target()
	RETURN_TYPE(/mob)
	return owner

// Illusion subtype for summon illusion
/mob/living/simple_animal/hostile/illusion/conjured
	AIStatus = AI_OFF
	density = FALSE
	melee_damage_lower = 0
	melee_damage_upper = 0
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE

/mob/living/simple_animal/hostile/illusion/conjured/proc/fake_spin()
	flags_1 |= IS_SPINNING_1

	for(var/i in 1 to 4)
		stoplag(0.1 SECONDS)
		if(QDELETED(src))
			return

		switch(dir)
			if(NORTH)
				setDir(EAST)
			if(SOUTH)
				setDir(WEST)
			if(EAST)
				setDir(SOUTH)
			if(WEST)
				setDir(NORTH)

	flags_1 &= ~IS_SPINNING_1
