/datum/story_rapid_status/cosmos
	selectable = FALSE

/datum/story_rapid_status/cosmos/proc/clawify(mob/living/carbon/human/selected, bodyzone, damage_low, damage_high, effectiveness)
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
