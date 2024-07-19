/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	armor_flag = BULLET
	hitsound_wall = SFX_RICOCHET
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embed_type = /datum/embed_data/bullet
	wound_bonus = 0
	wound_falloff_tile = -5
	embed_falloff_tile = 3

/obj/projectile/bullet/smite
	name = "divine retribution"
	damage = 10

/datum/embed_data/bullet
	embed_chance = 20
	fall_chance = 0.0020
	jostle_chance = 1
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.5
	pain_mult = 3
	rip_time = 5 SECONDS

/datum/embed_data/bullet/on_embed(mob/living/carbon/victim, obj/item/bodypart/limb, obj/item/weapon, harmful = TRUE)
	victim.visible_message(
		span_danger("[weapon] [harmful ? "embeds" : "sticks"] itself [harmful ? "in" : "to"] [victim]'s [limb.plaintext_zone]!"),
		span_userdanger("[weapon] [harmful ? "embeds" : "sticks"] itself [harmful ? "in" : "to"] your [limb.plaintext_zone]!"),
	)
	if(harmful)
		playsound(victim, pick(
			'maplestation_modules/sound/items/bullets/bullet_meat1.ogg',
			'maplestation_modules/sound/items/bullets/bullet_meat2.ogg',
			'maplestation_modules/sound/items/bullets/bullet_meat3.ogg',
			'maplestation_modules/sound/items/bullets/bullet_meat4.ogg',
		), 40)

/turf/closed/wall/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(hitting_projectile.hitsound_wall != SFX_RICOCHET)
		return
	if(hitting_projectile.damage < 16 || hitting_projectile.damage_type != BRUTE)
		return
	if(hardness > 60 || !girder_type || !(flags_ricochet & RICOCHET_HARD))
		return
	var/volume = hitting_projectile.suppressed ? 10 : clamp(hitting_projectile.vol_by_damage() + 33, 10, 100)
	playsound(src, pick(
		'maplestation_modules/sound/items/bullets/bullet_metal1.ogg',
		'maplestation_modules/sound/items/bullets/bullet_metal2.ogg',
		'maplestation_modules/sound/items/bullets/bullet_metal3.ogg',
	), volume, FALSE)

/obj/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(hitting_projectile.hitsound_wall != SFX_RICOCHET)
		return
	if(hitting_projectile.damage < 16 || hitting_projectile.damage_type != BRUTE)
		return
	if(max_integrity < 100 || !(flags_ricochet & RICOCHET_HARD))
		return
	var/volume = hitting_projectile.suppressed ? 10 : clamp(hitting_projectile.vol_by_damage() + 33, 10, 100)
	playsound(src, pick(
		'maplestation_modules/sound/items/bullets/bullet_metal1.ogg',
		'maplestation_modules/sound/items/bullets/bullet_metal2.ogg',
		'maplestation_modules/sound/items/bullets/bullet_metal3.ogg',
	), volume, FALSE)
