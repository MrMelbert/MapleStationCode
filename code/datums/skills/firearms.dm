/datum/skill/firearms
	name = "Firearms"
	title = "Gunner"
	blurb = "Don't shoot yourself in the foot."
	earned_by = "training at the firing range (or shooting people)"
	grants_you = "reduced accuracy penalties when using firearms while wounded"
	modifiers = list(
		SKILL_RANDS_MODIFIER = list(
			SKILL_LEVEL_NONE = 5,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = -5,
			SKILL_LEVEL_JOURNEYMAN = -5,
			SKILL_LEVEL_EXPERT = -10,
			SKILL_LEVEL_MASTER = -10,
			SKILL_LEVEL_LEGENDARY = -20,
		),
	)
	skill_flags = SKILL_ALWAYS_PRINT

/**
 * Awards firearms XP to the firer of a projectile.
 * Grants up to 100 xp
 *
 * * max_skill_level - If the firer's skill level is beyond this, no XP is awarded (equal is fine)
 */
/obj/projectile/proc/award_firearms_exp(max_skill_level = SKILL_LEVEL_LEGENDARY)
	if(!isliving(firer))
		return
	var/mob/living/firer_mob = firer
	if(isnull(firer_mob.mind) || firer_mob.mind.get_skill_level(/datum/skill/firearms) > max_skill_level)
		return
	var/xp_gain = 0
	if(istype(fired_from, /obj/item/gun/energy))
		var/obj/item/gun/energy/lasgun = fired_from
		var/obj/item/ammo_casing/energy/lasgun_ammo = lasgun.ammo_type[lasgun.select]
		xp_gain = istype(lasgun_ammo) ? clamp(lasgun_ammo.e_cost * 0.34, 0, 100) : 30
	else if(istype(fired_from, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/balgun = fired_from
		xp_gain = clamp(200 / (balgun.magazine?.max_ammo || 10), 0, 100)
	if(xp_gain <= 0)
		return
	// closer hits give less xp, encourage actually aiming and not standing right by the target
	firer_mob.mind.adjust_experience(/datum/skill/firearms, xp_gain * clamp(get_dist(firer, src) / 10, 0.2, 1.2))
