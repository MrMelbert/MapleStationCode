/// Global list of instantiated cult theme datums - assoc list of [name] to [instantiated datum]
GLOBAL_LIST_EMPTY(cult_themes)

/proc/generate_cult_themes()
	for(var/datum/cult_theme/theme as anything in subtypesof(/datum/cult_theme))
		GLOB.cult_themes[initial(theme.name)] = new theme()

/datum/cult_theme
	/// The name of the theme. Something like "Nar'sian cult".
	var/name
	/// Default deity of the theme.
	var/default_deity
	/// The faction this cult gives.
	var/faction
	/// The language this cult gives. Typepath.
	var/datum/language/language
	/// The sound effect that is played when someone joins the cult.
	var/on_gain_sound
	/// The item this cult uses to make rituals. Typepath.
	var/obj/item/ritual_item
	/// The materials this cult uses to make things. Typepath.
	var/obj/item/ritual_materials
	var/list/allowed_runes

/// Called when the cult theme is chosen in the UI.
/// Gives a short explanantion of the cult type.
/datum/cult_theme/proc/on_chose_breakdown(mob/living/cultist)
	CRASH("Cult theme [type] did not implement on_chose_breakdown!")

/// Called when a new cultist is made.
/datum/cult_theme/proc/on_cultist_made(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	if(faction)
		cultist.faction |= faction

	if(language)
		cultist.grant_language(language, TRUE, TRUE, LANGUAGE_CULTIST)

	cultist.playsound_local(get_turf(cultist), on_gain_sound, 80, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	give_spells(cultist_datum, cultist)

/// Called when a new cult team is made. [cultist_mind] is the leader of the cult.
/datum/cult_theme/proc/on_cultist_team_made(datum/team/advanced_cult/cult_team, datum/mind/cultist_mind)
	equip_cultist(cultist_mind.current)

/// Called when a cultist is removed from the cult.
/datum/cult_theme/proc/on_cultist_lost(mob/living/cultist)
	if(faction)
		cultist.faction -= faction

	if(language)
		cultist.remove_language(language, TRUE, TRUE, LANGUAGE_CULTIST)


/// Called when a cult leader creates a new cult team.
/datum/cult_theme/proc/equip_cultist(mob/living/cultist)
	if(!ishuman(cultist))
		return
	var/mob/living/carbon/human/human_cultist = cultist
	if(!human_cultist.back)
		to_chat(cultist, "You did not have a backpack so you weren't given your ritual items correctly. Contact your local god!")
		return

	var/obj/item/new_ritual_item = new ritual_item(human_cultist.loc)
	var/obj/item/new_ritual_mats = new ritual_materials(human_cultist.loc)

	var/failed_to_equip_a_slot = FALSE
	if(!human_cultist.equip_to_slot_or_del(new_ritual_item, ITEM_SLOT_BACKPACK, TRUE))
		failed_to_equip_a_slot = TRUE
	if(!human_cultist.equip_to_slot_or_del(new_ritual_mats, ITEM_SLOT_BACKPACK, TRUE))
		failed_to_equip_a_slot = TRUE

	if(failed_to_equip_a_slot)
		to_chat(cultist, "You weren't given one or both of your ritual items correctly. Contact your local god!")
	else
		SEND_SIGNAL(human_cultist.back, COMSIG_TRY_STORAGE_SHOW, human_cultist)

/// Called when the cultist is made.
/datum/cult_theme/proc/give_spells(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	CRASH("Cult theme [type] did not implement give_spells!")

/datum/cult_theme/proc/get_allowed_runes(datum/antagonist/advanced_cult/cultist_datum)
	if(!LAZYLEN(GLOB.rune_types))
		GLOB.rune_types = list()
		var/static/list/possible_rune_types = (subtypesof(/obj/effect/rune) - /obj/effect/rune/malformed)
		for(var/obj/effect/rune/rune as anything in possible_rune_types)
			GLOB.rune_types[initial(rune.cultist_name)] = rune

	return allowed_runes.Copy()

/datum/cult_theme/narsie
	name = CULT_STYLE_NARSIE
	default_deity = "Nar'sie"
	faction = "cult"
	language = /datum/language/narsie
	on_gain_sound = 'sound/ambience/antag/bloodcult.ogg'
	ritual_item = /obj/item/melee/cultblade/dagger/advanced
	ritual_materials = /obj/item/stack/sheet/runed_metal/ten
	allowed_runes =  list(
		"Offer",
		"Empower",
		"Teleport",
		"Revive",
		"Barrier",
		"Summon Cultist",
		"Boil Blood",
		"Spirit Realm"
	)

/datum/cult_theme/narsie/on_chose_breakdown(mob/living/cultist)
	to_chat(cultist, span_cultbold("The [name] is a cult that focuses on strength and brute force."))

/datum/cult_theme/narsie/on_cultist_made(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	. = ..()
	if(!ishuman(cultist))
		return

	var/datum/team/advanced_cult/our_team = cultist_datum.get_team()
	if(our_team.cult_risen)
		our_team.arise_given_cultist(cultist, no_sound = TRUE)
	if(our_team.cult_ascendent)
		our_team.ascend_given_cultist(cultist, no_sound = TRUE)

/datum/cult_theme/narsie/on_cultist_lost(mob/living/cultist)
	. = ..()
	if(!ishuman(cultist))
		return

	var/mob/living/carbon/human/human_cultist = cultist
	var/obj/item/organ/eyes/cultist_eyes = human_cultist.getorganslot(ORGAN_SLOT_EYES)
	human_cultist.eye_color = cultist_eyes.old_eye_color
	human_cultist.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
	REMOVE_TRAIT(human_cultist, TRAIT_UNNATURAL_RED_GLOWY_EYES, CULT_TRAIT)
	human_cultist.remove_overlay(HALO_LAYER)
	human_cultist.update_body()

/datum/cult_theme/narsie/on_cultist_team_made(datum/team/advanced_cult/cult_team, datum/mind/cultist_mind)
	cult_team.arise_button = new()
	cult_team.arise_button.Grant(cultist_mind.current)
	cult_team.ascend_button = new()
	cult_team.ascend_button.Grant(cultist_mind.current)

/datum/cult_theme/narsie/give_spells(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	var/datum/action/innate/cult/blood_magic/advanced/new_magic = new()
	for(var/datum/action/innate/cult/blood_spell/magic as anything in subtypesof(/datum/action/innate/cult/blood_spell))
		if(initial(magic.blacklisted_by_default))
			continue
		LAZYADD(new_magic.all_allowed_spell_types, magic)
	cultist_datum.our_magic = new_magic
	cultist_datum.our_magic.Grant(cultist)

/datum/cult_theme/narsie/get_allowed_runes(datum/antagonist/advanced_cult/cultist_datum)
	. = ..()
	var/datum/advanced_antag_datum/cultist/cultist = cultist_datum.linked_advanced_datum
	if(cultist.no_conversion)
		. -= "Offer"
		. -= "Revive"
		. -= "Summon Cultist"
		. -= "Boil Blood"

/datum/cult_theme/ratvarcult
	name = CULT_STYLE_RATVAR
	default_deity = "Rat'var"
	faction = "cult"
	on_gain_sound = 'sound/magic/clockwork/ark_activation.ogg'
	ritual_item = /obj/item/clockwork_slab
	ritual_materials = /obj/item/stack/sheet/bronze/ten
	allowed_runes =  list(
		"Offer",
		"Empower",
		"Teleport",
	)

/datum/cult_theme/ratvarcult/on_chose_breakdown(mob/living/cultist)
	to_chat(cultist, span_heavy_brass("The [name] is a cult that focuses on stealth and cunning."))
