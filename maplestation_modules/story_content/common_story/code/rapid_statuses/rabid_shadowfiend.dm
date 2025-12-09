/datum/story_rapid_status/rabid_shadowfiend
	name = "Rabid Shadowfiend"

	var/list/datum/action/cooldown/spell/spells_to_grant = list(
		/datum/action/cooldown/spell/jaunt/shadow_walk,
		/datum/action/cooldown/spell/aoe/flicker_lights,
		/datum/action/cooldown/spell/conjure_item/ice_knife/shadow_knife,
	)

/datum/story_rapid_status/rabid_shadowfiend/apply(mob/living/carbon/human/selected)
	grant_spell_list(selected, spells_to_grant, TRUE)

	clawify(selected, BODY_ZONE_L_ARM, 10, 15, 20)
	clawify(selected, BODY_ZONE_R_ARM, 10, 15, 20)

	return TRUE

/datum/story_rapid_status/rabid_shadowfiend/proc/clawify(mob/living/carbon/human/selected, bodyzone, damage_low, damage_high, effectiveness)
	var/obj/item/bodypart/arm/selected_arm = selected.get_bodypart(bodyzone) // your fists are now claws
	selected_arm.unarmed_attack_verbs = list("slash")
	selected_arm.grappled_attack_verb = "lacerate"
	selected_arm.unarmed_attack_effect = ATTACK_EFFECT_CLAW
	selected_arm.unarmed_attack_sound = 'sound/weapons/slash.ogg'
	selected_arm.unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
	selected_arm.unarmed_damage_low = damage_low
	selected_arm.unarmed_damage_high = damage_high
	selected_arm.unarmed_effectiveness = effectiveness
	selected_arm.appendage_noun = "clawed hand"


/datum/story_rapid_status/rabid_shadowfiend/strong
	name = "Rabid Shadowfiend (Strong)"

	spells_to_grant = list(
		/datum/action/cooldown/spell/jaunt/shadow_walk,
		/datum/action/cooldown/spell/aoe/flicker_lights,
		/datum/action/cooldown/spell/conjure_item/ice_knife/shadow_knife,
		/datum/action/cooldown/spell/pointed/projectile/furious_steel/shadow_steel,
	)

