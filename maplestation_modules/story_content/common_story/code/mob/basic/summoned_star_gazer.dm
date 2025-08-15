/// Weaker version of the star gazer, meant to be fought instead of being an invincible gigafighter
/mob/living/basic/heretic_summon/star_gazer/summoned
	maxHealth = 750
	health = 750
	obj_damage = 60
	melee_damage_lower = 25
	melee_damage_upper = 25
	damage_coeff = list(BRUTE = 1, BURN = 0.8, TOX = 0, STAMINA = 0, OXY = 0)

/mob/living/basic/heretic_summon/star_gazer/summoned/Initialize(mapload)
	. = ..()
	RemoveElement(/datum/element/death_explosion) // slightly hacky way of disabling the death explosion without editing the base star gazer
	RemoveElement(/datum/element/effect_trail)
	RemoveComponentSource(REF(src), /datum/component/regenerator)
