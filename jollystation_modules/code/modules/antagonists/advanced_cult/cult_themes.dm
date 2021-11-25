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
	/// Whether scribing a rune takes blood / causes damage.
	var/scribing_takes_blood = TRUE
	/// Sound that plays when this cult draws a rune
	var/scribe_sound
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
	/// List of runes this cult theme can invoke.
	var/list/allowed_runes

/// Called when the cult theme is chosen in the UI.
/// Gives a short explanantion of the cult type.
/datum/cult_theme/proc/on_chose_breakdown(mob/living/cultist)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement on_chose_breakdown!")

/// Helper proc to use that gets a fitting span for the cult theme.
/datum/cult_theme/proc/our_cult_span(message, bold = FALSE, italics = FALSE, large = FALSE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement cult_span!")

/// Called when a new cultist is made.
/datum/cult_theme/proc/on_cultist_made(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	SHOULD_CALL_PARENT(TRUE)

	if(faction)
		cultist.faction |= faction

	if(language)
		cultist.grant_language(language, TRUE, TRUE, LANGUAGE_CULTIST)

	cultist.playsound_local(get_turf(cultist), on_gain_sound, 80, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	give_spells(cultist_datum, cultist)

/// Called when a new cult team is made. [cultist_mind] is the leader of the cult.
/datum/cult_theme/proc/on_cultist_team_made(datum/team/advanced_cult/cult_team, datum/mind/cultist_mind)
	SHOULD_CALL_PARENT(TRUE)

	equip_cultist(cultist_mind.current)

/// Called when a cultist is removed from the cult.
/datum/cult_theme/proc/on_cultist_lost(mob/living/cultist)
	SHOULD_CALL_PARENT(TRUE)

	if(faction)
		cultist.faction -= faction

	if(language)
		cultist.remove_language(language, TRUE, TRUE, LANGUAGE_CULTIST)


/// Called when a cult leader creates a new cult team.
/datum/cult_theme/proc/equip_cultist(mob/living/cultist)
	SHOULD_NOT_OVERRIDE(TRUE)

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
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement give_spells!")

/datum/cult_theme/proc/get_allowed_runes(datum/antagonist/advanced_cult/cultist_datum)
	SHOULD_CALL_PARENT(TRUE)
	return LAZYCOPY(allowed_runes)

/datum/cult_theme/proc/get_start_making_rune_text(mob/living/cultist)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_start_making_rune_text!")

/datum/cult_theme/proc/get_end_making_rune_text(mob/living/cultist)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_end_making_rune_text!")

/datum/cult_theme/proc/get_start_invoking_magic_text(added_magic)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_start_invoking_magic_text!")

/datum/cult_theme/proc/get_end_invoking_magic_text(added_magic)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_end_invoking_magic_text!")
