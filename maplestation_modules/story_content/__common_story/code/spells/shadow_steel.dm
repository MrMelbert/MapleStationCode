/datum/action/cooldown/spell/pointed/projectile/furious_steel/shadow_steel
	name = "Shadow Steel"
	desc = "Summon two shadow blades which orbit you. \
		While orbiting you, these blades will protect you from from attacks, but will be consumed on use. \
		Additionally, you can click to fire the blades at a target, dealing damage and causing bleeding."
	background_icon_state = "bg_cult"
	overlay_icon_state = "bg_cult_border"

	invocation = span_notice("<b>%CASTER</b> holds out their arm forwards, commanding a blade to fire.")
	invocation_self_message = span_notice("You hold your arm forward.")
	invocation_type = INVOCATION_EMOTE

	active_msg = "You summon forth two blades from darkness."
	deactive_msg = "You conceal your black blades."
	cast_range = 20
	projectile_type = /obj/projectile/shadow_steel
	projectile_amount = 2

	time_between_blades = 1 SECONDS

	applied_status = /datum/status_effect/protective_blades/shadow

/obj/projectile/shadow_steel
	name = "blade"
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "knife"
	speed = 2
	damage = 15
	sharpness = SHARP_EDGED
	wound_bonus = 20
	pass_flags = PASSTABLE | PASSFLAPS

/obj/projectile/shadow_steel/Initialize(mapload)
	. = ..()
	add_filter("knife_color", 1, list("type" = "color", "color" = "#000000"))
	add_filter("knife", 2, list("type" = "outline", "color" = "#640000", "size" = 1))

/obj/projectile/shadow_steel/prehit_pierce(atom/hit)
	if(isliving(hit) && isliving(firer))
		var/mob/living/caster = firer
		var/mob/living/victim = hit
		if(caster == victim)
			return PROJECTILE_PIERCE_PHASE

		if(caster.mind) // probably not going to be used in this one but whatever
			var/datum/antagonist/heretic_monster/monster = victim.mind?.has_antag_datum(/datum/antagonist/heretic_monster)
			if(monster?.master == caster.mind)
				return PROJECTILE_PIERCE_PHASE

		if(victim.can_block_magic(MAGIC_RESISTANCE))
			visible_message(span_warning("[src] drops to the ground and dissolves on contact [victim]!"))
			return PROJECTILE_DELETE_WITHOUT_HITTING

	return ..()

/datum/status_effect/protective_blades/shadow

/// overriden to make it use shadow blades
/datum/status_effect/protective_blades/shadow/create_blade()
	if(QDELETED(src) || QDELETED(owner))
		return

	var/obj/effect/floating_blade/shadow/blade = new(get_turf(owner))
	blades += blade
	blade.orbit(owner, blade_orbit_radius)
	RegisterSignal(blade, COMSIG_QDELETING, PROC_REF(remove_blade))
	playsound(get_turf(owner), 'sound/items/unsheath.ogg', 33, TRUE)

/obj/effect/floating_blade/shadow
	name = "shadow knife"
	glow_color = "#640000"

/obj/effect/floating_blade/shadow/Initialize(mapload)
	. = ..()
	add_filter("knife_color", 1, list("type" = "color", "color" = "#000000"))
