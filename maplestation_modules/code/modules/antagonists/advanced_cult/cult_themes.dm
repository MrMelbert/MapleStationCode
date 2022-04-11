/// Global list of instantiated cult theme datums - assoc list of [name] to [instantiated datum]
GLOBAL_LIST(cult_themes)

/// Generate all chosable cult themes as an assoc list.
/proc/generate_cult_themes()
	for(var/datum/cult_theme/theme as anything in subtypesof(/datum/cult_theme))
		LAZYSET(GLOB.cult_themes, initial(theme.name), new theme())

// Cult theme datum. Used to... theme cultists.
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
	/// The name of the hud applied by this theme.
	var/cultist_hud_name = "cult"
	/// The name of the hud applied to the cult master by this theme.
	var/cultist_lead_hud_name = "cultmaster"
	/// The icon file we grab our hud from
	var/cultist_hud_icon = 'icons/mob/huds/antag_hud.dmi'
	/// The language this cult gives. Typepath.
	var/datum/language/language
	/// The sound effect that is played when someone joins the cult.
	var/on_gain_sound
	/// The type of magic invoker we give to cultists. Typepath.
	var/datum/action/innate/cult/blood_magic/advanced/magic_type
	/// The parent paths of magic spells we can invoke. Typepath.
	var/list/datum/action/magic_subtypes
	/// The item this cult uses to make rituals. Typepath.
	var/obj/item/ritual_item
	/// The materials this cult uses to make things. Typepath.
	var/obj/item/ritual_materials
	/// List of runes this cult theme can invoke.
	var/list/allowed_runes

/*
 * Called when the cult theme is chosen in the UI.
 *
 * Gives a short explanantion of the cult type.
 */
/datum/cult_theme/proc/on_chose_breakdown(mob/living/cultist)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement on_chose_breakdown!")


 /*
  * Helper proc to use that gets a fitting span for the cult theme.
  *
  * Returns the message passed in, with the cult span applied.
  *
  * message - the message being passed
  * bold - whether it should be bold
  * italics - whether it should be italicized
  * large - whether it should be largetext
  */
/datum/cult_theme/proc/our_cult_span(message, bold = FALSE, italics = FALSE, large = FALSE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement cult_span!")

/*
 * Called when a new cultist is made of this theme.
 *
 * cultist_datum - the antag datum of the cultist created
 * cultist - the mob of the cultist created
 */
/datum/cult_theme/proc/on_cultist_made(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	SHOULD_CALL_PARENT(TRUE)

	if(faction)
		cultist.faction |= faction

	if(language)
		cultist.grant_language(language, TRUE, TRUE, LANGUAGE_CULTIST)

	if(cultist_hud_name)
		cultist_datum.antag_hud_name = cultist_hud_name
		cultist_datum.hud_icon = cultist_hud_icon
		cultist_datum.add_team_hud(cultist, /datum/antagonist/advanced_cult)

	cultist.playsound_local(get_turf(cultist), on_gain_sound, 80, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	give_spells(cultist_datum, cultist)

/*
 * Called when a new cult team is made by a cultist of this theme.
 *
 * cult_team - the team that was created
 * lead_cultist - the mind of the cultist who leads the new team
 */
/datum/cult_theme/proc/on_cultist_team_made(datum/team/advanced_cult/cult_team, datum/mind/lead_cultist)
	SHOULD_CALL_PARENT(TRUE)

	var/datum/antagonist/advanced_cult/master/lead_antag_datum = lead_cultist.has_antag_datum(/datum/antagonist/advanced_cult/master)
	lead_antag_datum?.antag_hud_name = cultist_lead_hud_name

	equip_cultist(lead_cultist.current)

/*
 *  Called when a cultist of this theme is deconverted.
 *
 * cultist_datum - the antag datum of the cultist being deconverted. Deleted after this proc (but not by this proc)
 * cultist - the mob of the cultist deconverted
 */
/datum/cult_theme/proc/on_cultist_lost(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	SHOULD_CALL_PARENT(TRUE)

	if(faction)
		cultist.faction -= faction
	if(language)
		cultist.remove_language(language, TRUE, TRUE, LANGUAGE_CULTIST)

/*
 * Equips a cultist with a set of ritual items.
 * Called whenever a new cult team is made, giving the leader their initial tools.
 *
 * cultist - the team leader, being equipped with ritual items
 */
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
		to_chat(cultist, our_cult_span("You were given a [new_ritual_item.name] and some [new_ritual_mats.name] to grow your cult. They are in your backpack - use them wisely."))

/*
 * Gives a cultist of this theme their corresponding spell creator action and initalizes it.
 * Sets the allowed spell list and such here.
 * Called when a cultist is made.
 *
 * cultist_datum - the antag datum of the cultist getting the magic
 * cultist - the mob of the cultist getting the magic
 */
/datum/cult_theme/proc/give_spells(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	var/datum/action/innate/cult/blood_magic/advanced/new_magic = new magic_type()
	var/list/possible_spell_types = list()
	for(var/type in magic_subtypes)
		for(var/subtype in subtypesof(type))
			possible_spell_types |= subtype

	for(var/datum/action/innate/cult/magic as anything in possible_spell_types)
		if(initial(magic.blacklisted_by_default))
			continue
		LAZYSET(new_magic.all_allowed_spell_types, initial(magic.name), magic)
	cultist_datum.our_magic = new_magic
	cultist_datum.our_magic.Grant(cultist)

/*
 * Get a list of all runes a cultist of this theme can make.
 * Called when a cultist scribes a rune.
 *
 * Returns a new instance of a list.
 *
 * cultist_datum - the antag datum of the cultist making the rune
 */
/datum/cult_theme/proc/get_allowed_runes(datum/antagonist/advanced_cult/cultist_datum)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	return LAZYCOPY(allowed_runes)

/*
 * Get the text displayed when a [cultist] of this theme starts to make a rune.
 */
/datum/cult_theme/proc/get_start_making_rune_text(mob/living/cultist)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_start_making_rune_text!")

/*
 * Get the text displayed when a [cultist] of this theme finishes making a rune.
 */
/datum/cult_theme/proc/get_end_making_rune_text(mob/living/cultist)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_end_making_rune_text!")

/*
 * Get the text displayed when a [cultist] of this theme starts invoking magic.
 */
/datum/cult_theme/proc/get_start_invoking_magic_text(added_magic, atom/target)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_start_invoking_magic_text!")

/*
 * Get the text displayed when a [cultist] of this theme finishes invoking magic.
 */
/datum/cult_theme/proc/get_end_invoking_magic_text(added_magic, atom/target)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement get_end_invoking_magic_text!")

/*
 * Get the text displayed to a [cultist] of this theme is being deconverted.
 */
/datum/cult_theme/proc/pick_deconversion_line()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement pick_deconversion_line!")

/*
 * Get the text displayed to a [cultist] of this theme is being deconverted, and is shamed by their god.
 */
/datum/cult_theme/proc/pick_god_shame_line()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Cult theme [type] did not implement pick_god_shame_line!")
