/mob/living/carbon/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	wound_bonus = 0,
	bare_wound_bonus = 0,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
)
	// Spread damage should always have def zone be null
	if(spread_damage)
		def_zone = null

	// Otherwise if def zone is null, we'll get a random bodypart / zone to hit.
	// ALso we'll automatically covnert string def zones into bodyparts to pass into parent call.
	else if(!isbodypart(def_zone))
		var/random_zone = check_zone(def_zone || get_random_valid_zone(def_zone))
		def_zone = get_bodypart(random_zone) || bodyparts[1]

	. = ..()
	// Taking brute or burn to bodyparts gives a damage flash
	if(def_zone && (damagetype == BRUTE || damagetype == BURN))
		damageoverlaytemp += .

	return .

/mob/living/carbon/human/get_damage_mod(damage_type)
	if (!dna?.species?.damage_modifier)
		return ..()
	var/species_mod = (100 - dna.species.damage_modifier) / 100
	return ..() * species_mod

/mob/living/carbon/human/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	wound_bonus = 0,
	bare_wound_bonus = 0,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
)

	// Add relevant DR modifiers into blocked value to pass to parent
	blocked += physiology?.damage_resistance
	blocked += dna?.species?.damage_modifier
	return ..()

/mob/living/carbon/human/get_incoming_damage_modifier(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
)
	var/final_mod = ..()

	switch(damagetype)
		if(BRUTE)
			final_mod *= physiology.brute_mod
		if(BURN)
			final_mod *= physiology.burn_mod
		if(TOX)
			final_mod *= physiology.tox_mod
		if(OXY)
			final_mod *= physiology.oxy_mod
		if(STAMINA)
			final_mod *= physiology.stamina_mod
		if(BRAIN)
			final_mod *= physiology.brain_mod

	return final_mod

//These procs fetch a cumulative total damage from all bodyparts
/mob/living/carbon/getBruteLoss()
	var/amount = 0
	for(var/obj/item/bodypart/part as anything in bodyparts)
		amount += part.brute_dam
	return round(amount, DAMAGE_PRECISION) // melbert todo : floating point memes? i don't know why

/mob/living/carbon/getFireLoss()
	var/amount = 0
	for(var/obj/item/bodypart/part as anything in bodyparts)
		amount += part.burn_dam
	return round(amount, DAMAGE_PRECISION) // melbert todo : floating point memes? i don't know why

/mob/living/carbon/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	if(!can_adjust_brute_loss(amount, forced, required_bodytype))
		return 0
	if(amount > 0)
		. = take_overall_damage(brute = amount, forced = forced, required_bodytype = required_bodytype)
	else
		. = heal_overall_damage(brute = abs(amount), required_bodytype = required_bodytype, forced = forced)

/mob/living/carbon/setBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	var/current = getBruteLoss()
	var/diff = amount - current
	if(!diff)
		return FALSE
	return adjustBruteLoss(diff, updating_health, forced, required_bodytype)

/mob/living/carbon/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	if(!can_adjust_fire_loss(amount, forced, required_bodytype))
		return 0
	if(amount > 0)
		. = take_overall_damage(burn = amount, forced = forced, required_bodytype = required_bodytype)
	else
		. = heal_overall_damage(burn = abs(amount), required_bodytype = required_bodytype, forced = forced)

/mob/living/carbon/setFireLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	var/current = getFireLoss()
	var/diff = amount - current
	if(!diff)
		return FALSE
	return adjustFireLoss(diff, updating_health, forced, required_bodytype)

/mob/living/carbon/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype = ALL)
	if(!can_adjust_tox_loss(amount, forced, required_biotype))
		return 0
	if(!forced && HAS_TRAIT(src, TRAIT_TOXINLOVER)) //damage becomes healing and healing becomes damage
		amount = -amount
		if(HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
			amount = min(amount, 0)
		if(amount > 0)
			blood_volume = max(blood_volume - (5*amount), 0)
		else
			blood_volume = max(blood_volume - amount, 0)
	else if(!forced && HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
		amount = min(amount, 0)
	return ..()

/**
 * If an organ exists in the slot requested, and we are capable of taking damage (we don't have [GODMODE] on), call the damage proc on that organ.
 *
 * Arguments:
 * * slot - organ slot, like [ORGAN_SLOT_HEART]
 * * amount - damage to be done
 * * maximum - currently an arbitrarily large number, can be set so as to limit damage
 * * required_organ_flag - targets only a specific organ type if set to ORGAN_ORGANIC or ORGAN_ROBOTIC
 *
 * Returns: The net change in damage from apply_organ_damage()
 */
/mob/living/carbon/adjustOrganLoss(slot, amount, maximum, required_organ_flag = NONE)
	var/obj/item/organ/affected_organ = get_organ_slot(slot)
	if(!affected_organ || (status_flags & GODMODE))
		return FALSE
	if(required_organ_flag && !(affected_organ.organ_flags & required_organ_flag))
		return FALSE
	return affected_organ.apply_organ_damage(amount, maximum)

/**
 * If an organ exists in the slot requested, and we are capable of taking damage (we don't have [GODMODE] on), call the set damage proc on that organ, which can
 * set or clear the failing variable on that organ, making it either cease or start functions again, unlike adjustOrganLoss.
 *
 * Arguments:
 * * slot - organ slot, like [ORGAN_SLOT_HEART]
 * * amount - damage to be set to
 * * required_organ_flag - targets only a specific organ type if set to ORGAN_ORGANIC or ORGAN_ROBOTIC
 *
 * Returns: The net change in damage from set_organ_damage()
 */
/mob/living/carbon/setOrganLoss(slot, amount, required_organ_flag = NONE)
	var/obj/item/organ/affected_organ = get_organ_slot(slot)
	if(!affected_organ || (status_flags & GODMODE))
		return FALSE
	if(required_organ_flag && !(affected_organ.organ_flags & required_organ_flag))
		return FALSE
	if(affected_organ.damage == amount)
		return FALSE
	return affected_organ.set_organ_damage(amount)

/**
 * If an organ exists in the slot requested, return the amount of damage that organ has
 *
 * Arguments:
 * * slot - organ slot, like [ORGAN_SLOT_HEART]
 */
/mob/living/carbon/get_organ_loss(slot)
	var/obj/item/organ/affected_organ = get_organ_slot(slot)
	if(affected_organ)
		return affected_organ.damage

////////////////////////////////////////////

///Returns a list of damaged bodyparts
/mob/living/carbon/proc/get_damaged_bodyparts(brute = FALSE, burn = FALSE, required_bodytype = NONE, target_zone = null)
	var/list/obj/item/bodypart/parts = list()
	for(var/obj/item/bodypart/part as anything in bodyparts)
		if(required_bodytype && !(part.bodytype & required_bodytype))
			continue
		if(!isnull(target_zone) && part.body_zone != target_zone)
			continue
		if((brute && part.brute_dam) || (burn && part.burn_dam))
			parts += part
	return parts

///Returns a list of damageable bodyparts
/mob/living/carbon/proc/get_damageable_bodyparts(required_bodytype)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(required_bodytype && !(BP.bodytype & required_bodytype))
			continue
		if(BP.brute_dam + BP.burn_dam < BP.max_damage)
			parts += BP
	return parts


///Returns a list of bodyparts with wounds (in case someone has a wound on an otherwise fully healed limb)
/mob/living/carbon/proc/get_wounded_bodyparts(required_bodytype)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(required_bodytype && !(BP.bodytype & required_bodytype))
			continue
		if(LAZYLEN(BP.wounds))
			parts += BP
	return parts

/**
 * Heals ONE bodypart randomly selected from damaged ones.

 * It automatically updates damage overlays if necessary
 *
 * It automatically updates health status
 */
/mob/living/carbon/heal_bodypart_damage(brute = 0, burn = 0, updating_health = TRUE, required_bodytype = NONE, target_zone = null)
	. = FALSE
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute, burn, required_bodytype, target_zone)
	if(!parts.len)
		return

	var/obj/item/bodypart/picked = pick(parts)
	var/damage_calculator = picked.get_damage() //heal_damage returns update status T/F instead of amount healed so we dance gracefully around this
	if(picked.heal_damage(abs(brute), abs(burn), required_bodytype = required_bodytype))
		update_damage_overlays()
	return (damage_calculator - picked.get_damage())


/mob/living/carbon/damage_random_bodypart(
	damage = 0,
	damagetype = BRUTE,
	damageflag = MELEE,
	required_bodytype,
	check_armor = FALSE,
	wound_bonus = 0,
	bare_wound_bonus = 0,
	sharpness = NONE,

)
	var/list/obj/item/bodypart/parts = get_damageable_bodyparts(required_bodytype)
	if(!length(parts))
		return 0

	var/obj/item/bodypart/picked = pick(parts)
	var/armor = check_armor ? run_armor_check(picked, damageflag, silent = TRUE) : 0

	return apply_damage(
		damage = abs(damage),
		damagetype = damagetype,
		def_zone = picked,
		blocked = armor,
		wound_bonus = wound_bonus,
		bare_wound_bonus = bare_wound_bonus,
		sharpness = sharpness,
	)

/mob/living/carbon/heal_overall_damage(brute = 0, burn = 0, stamina = 0, required_bodytype, updating_health = TRUE, forced = FALSE)
	. = FALSE
	// treat negative args as positive
	brute = abs(brute)
	burn = abs(burn)

	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute, burn, required_bodytype)

	var/update = NONE
	while(parts.len && (brute > 0 || burn > 0))
		var/obj/item/bodypart/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam
		. += picked.get_damage()

		update |= picked.heal_damage(brute, burn, updating_health = FALSE, forced = forced, required_bodytype = required_bodytype)

		. -= picked.get_damage() // return the net amount of damage healed

		brute = round(brute - (brute_was - picked.brute_dam), DAMAGE_PRECISION)
		burn = round(burn - (burn_was - picked.burn_dam), DAMAGE_PRECISION)

		parts -= picked

	. = round(., DAMAGE_PRECISION) // melbert todo : floating point memes? i don't know why
	if(!.) // no change? no need to update anything
		return

	if(updating_health)
		updatehealth()
	if(update)
		update_damage_overlays()

/mob/living/carbon/take_overall_damage(brute = 0, burn = 0, forced = FALSE, required_bodytype)
	. = FALSE
	if(!forced && (status_flags & GODMODE))
		return
	// treat negative args as positive
	brute = abs(brute)
	burn = abs(burn)

	var/list/obj/item/bodypart/parts = get_damageable_bodyparts(required_bodytype)
	while(parts.len && (brute > 0 || burn > 0))
		var/obj/item/bodypart/picked = pick(parts)
		var/brute_per_part = round(brute/parts.len, DAMAGE_PRECISION)
		var/burn_per_part = round(burn/parts.len, DAMAGE_PRECISION)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam
		. += picked.get_damage()

		apply_damage(brute_per_part, BRUTE, picked, 0, forced, wound_bonus = CANT_WOUND)
		apply_damage(burn_per_part, BURN, picked, 0, forced, wound_bonus = CANT_WOUND)

		. -= picked.get_damage()

		brute = round(brute - (picked.brute_dam - brute_was), DAMAGE_PRECISION)
		burn = round(burn - (picked.burn_dam - burn_was), DAMAGE_PRECISION)

		parts -= picked

	. = round(., DAMAGE_PRECISION) // melbert todo : floating point memes? i don't know why
