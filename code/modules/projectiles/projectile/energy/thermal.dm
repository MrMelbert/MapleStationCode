/obj/projectile/energy/inferno
	name = "molten nanite bullet"
	icon_state = "infernoshot"
	generic_name = "bullet"
	damage = 20
	damage_type = BURN
	armor_flag = ENERGY
	armour_penetration = 10
	reflectable = NONE
	wound_bonus = 0
	bare_wound_bonus = 10
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser

/obj/projectile/energy/inferno/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(!isliving(target))
		return

	var/mob/living/cold_target = target
	var/how_cold_is_target = cold_target.body_temperature
	var/danger_zone = cold_target.bodytemp_cold_damage_limit - 10 CELCIUS
	if(how_cold_is_target < danger_zone)
		explosion(cold_target, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 2, flame_range = 3) //maybe stand back a bit
		cold_target.adjust_body_temperature(50 KELVIN, max_temp = cold_target.standard_body_temperature) //avoid repeat explosions
		playsound(cold_target, 'sound/weapons/sear.ogg', 30, TRUE, -1)

/obj/projectile/energy/cryo
	name = "frozen nanite bullet"
	icon_state = "cryoshot"
	generic_name = "bullet"
	damage = 20
	damage_type = BRUTE
	armour_penetration = 10
	armor_flag = ENERGY
	sharpness = SHARP_POINTY //it's a big ol' shard of ice
	reflectable = NONE
	wound_bonus = 0
	bare_wound_bonus = 10

/obj/projectile/energy/cryo/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(!isliving(target))
		return

	var/mob/living/hot_target = target
	var/how_hot_is_target = hot_target.body_temperature
	var/danger_zone = hot_target.bodytemp_heat_damage_limit + 10 CELCIUS
	if(how_hot_is_target > danger_zone)
		hot_target.Knockdown(10 SECONDS)
		hot_target.apply_damage(20, BURN, spread_damage = TRUE)
		hot_target.adjust_body_temperature(-50 KELVIN, min_temp = hot_target.standard_body_temperature) //avoid repeat knockdowns
		playsound(hot_target, 'sound/weapons/sonic_jackhammer.ogg', 30, TRUE, -1)
