//Rapid status, a way to make a lot of changes to a mob quickly, albeit preset. Hopefully eventually replaced with JSON. Pretty much taken from the "make me tanky" menu
#define VV_STORY_RAPID_STATUS "story_rapid_status"

/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_STORY_RAPID_STATUS, "Story Rapid Status")

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()

	if(href_list[VV_STORY_RAPID_STATUS])
		if(!check_rights(R_SPAWN))
			return

		var/list/options = list(
				"Herald of Cosmos",
			)

		var/result = tgui_input_list(usr, "Pick something. You can also cancel with \"Cancel\".", "Rapid Status", options + "Cancel")
		if(QDELETED(src) || !result || result == "Cancel")
			return
		var/picked = result

		if(!picked)
			return
		message_admins("[key_name(usr)] has rapidly given [key_name(src)] the following preset: [picked]")
		log_admin("[key_name(usr)] has rapidly given [key_name(src)] the following preset: [picked]")

		switch(picked)
			if("Herald of Cosmos") // kind of like a super-ascended cosmic heretic without a stargazer and a bit of void sidepathing, no regeneration or total protection beyond ehp/speed means they can be worn down. very op
				src?.mind.add_antag_datum(/datum/antagonist/heretic)
				var/datum/antagonist/heretic/our_heretic = src?.mind.has_antag_datum(/datum/antagonist/heretic)
				var/list/knowledges_to_grant = list( // cosmic heretic with a sidepath, some void spells and no ascension
					/datum/heretic_knowledge/limited_amount/starting/base_cosmic,
					/datum/heretic_knowledge/cosmic_grasp,
					/datum/heretic_knowledge/spell/cosmic_runes,
					/datum/heretic_knowledge/mark/cosmic_mark,
					/datum/heretic_knowledge/spell/star_touch,
					/datum/heretic_knowledge/spell/star_blast,
					/datum/heretic_knowledge/blade_upgrade/cosmic,
					/datum/heretic_knowledge/spell/cosmic_expansion,
					/datum/heretic_knowledge/cold_snap,
					/datum/heretic_knowledge/spell/void_phase,
					/datum/heretic_knowledge/spell/void_pull,
					/datum/heretic_knowledge/spell/space_phase,
				)
				if(our_heretic) // in case this entire chain broke along the way
					our_heretic.ascended = TRUE
					for(var/i in knowledges_to_grant)
						our_heretic.gain_knowledge(i)

					// the cosmic heretic ascension upgrades
					var/datum/heretic_knowledge/blade_upgrade/cosmic/blade_upgrade = our_heretic.get_knowledge(/datum/heretic_knowledge/blade_upgrade/cosmic)
					blade_upgrade.combo_duration = 10 SECONDS
					blade_upgrade.combo_duration_amount = 10 SECONDS
					blade_upgrade.max_combo_duration = 30 SECONDS
					blade_upgrade.increase_amount = 2 SECONDS

					var/datum/action/cooldown/spell/touch/star_touch/star_touch_spell = locate() in actions
					if(star_touch_spell)
						star_touch_spell.ascended = TRUE

					var/datum/action/cooldown/spell/conjure/cosmic_expansion/cosmic_expansion_spell = locate() in actions
					cosmic_expansion_spell?.ascended = TRUE

				physiology.brute_mod = 0.25
				physiology.burn_mod = 0.25
				physiology.tox_mod = 0.5
				physiology.oxy_mod = 0.5
				physiology.stamina_mod = 0.5
				physiology.stun_mod = 0.5
				physiology.bleed_mod = 0
				set_pain_mod("badmin", 0.6)
				add_consciousness_modifier("badmin", 30)

				var/obj/item/bodypart/arm/left_arm = get_bodypart(BODY_ZONE_L_ARM) // your fists are now claws
				left_arm.unarmed_attack_verbs = list("slash")
				left_arm.grappled_attack_verb = "lacerate"
				left_arm.unarmed_attack_effect = ATTACK_EFFECT_CLAW
				left_arm.unarmed_attack_sound = 'sound/weapons/slash.ogg'
				left_arm.unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
				left_arm.unarmed_damage_low = 25
				left_arm.unarmed_damage_high = 25
				left_arm.unarmed_effectiveness = 30
				left_arm.appendage_noun = "clawed hand"

				var/obj/item/bodypart/arm/right_arm = get_bodypart(BODY_ZONE_R_ARM)
				right_arm.unarmed_attack_verbs = list("slash")
				right_arm.grappled_attack_verb = "lacerate"
				right_arm.unarmed_attack_effect = ATTACK_EFFECT_CLAW
				right_arm.unarmed_attack_sound = 'sound/weapons/slash.ogg'
				right_arm.unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
				right_arm.unarmed_damage_low = 25
				right_arm.unarmed_damage_high = 25
				right_arm.unarmed_effectiveness = 30
				right_arm.appendage_noun = "clawed hand"

				var/obj/item/bodypart/leg/left_leg = get_bodypart(BODY_ZONE_L_LEG) // weaker, but allows proper damage after downing somebody
				left_leg.unarmed_damage_low = 18
				left_leg.unarmed_damage_high = 18
				left_leg.unarmed_effectiveness = 20

				var/obj/item/bodypart/leg/right_leg = get_bodypart(BODY_ZONE_R_LEG)
				right_leg.unarmed_damage_low = 18
				right_leg.unarmed_damage_high = 18
				right_leg.unarmed_effectiveness = 20

				ADD_TRAIT(src, TRAIT_SLEEPIMMUNE, REF(src)) //needed to prevent chem cheese using wellcheers and sulfonal

