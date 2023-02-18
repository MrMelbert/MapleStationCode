/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null)
    if(HAS_TRAIT(src, TRAIT_SHARPNESS_VULNERABLE) && sharpness)
        damage *= 2
    return ..()
