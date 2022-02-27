
/obj/item/melee/cultblade/advanced_dagger
	name = "ritual dagger"
	desc = "A special and strange dagger said to be used by cultists to prepare rituals, scribe runes, and combat heretics alike."
	icon = 'icons/obj/cult/items_and_weapons.dmi'
	icon_state = "render"
	inhand_icon_state = "cultdagger"
	worn_icon_state = "render"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	w_class = WEIGHT_CLASS_SMALL
	force = 15
	throwforce = 25
	block_chance = 25
	wound_bonus = -10
	bare_wound_bonus = 20
	armour_penetration = 35

/obj/item/melee/cultblade/advanced_dagger/Initialize(mapload)
	. = ..()
	var/image/silicon_image = image(icon = 'icons/effects/blood.dmi' , icon_state = null, loc = src)
	silicon_image.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "cult_dagger", silicon_image)

	var/examine_text = {"Allows the scribing of blood runes of the cult of Nar'Sie.
Hitting a cult structure will unanchor or reanchor it. Cult Girders will be destroyed in a single blow.
Can be used to scrape blood runes away, removing any trace of them.
Striking another cultist with it will purge all holy water from them and transform it into unholy water.
Striking a noncultist, however, will tear their flesh."}

	AddComponent(/datum/component/cult_ritual_item/advanced, \
		span_cult(examine_text), \
		/datum/action/item_action/ritual_item/dagger)

/obj/item/melee/cultblade/advanced_dagger/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	var/block_message = "[owner] parries [attack_text] with [src]!"
	if(owner.get_active_held_item() != src)
		block_message = "[owner] parries [attack_text] with [src] in their offhand!"

	var/datum/antagonist/advanced_cult/cultist = IS_CULTIST(owner)
	if(cultist && istype(src, cultist.cultist_style.ritual_item) && prob(final_block_chance) && attack_type != PROJECTILE_ATTACK)
		new /obj/effect/temp_visual/cult/sparks(get_turf(owner))
		playsound(src, 'sound/weapons/parry.ogg', 100, TRUE)
		owner.visible_message(span_danger("[block_message]"))
		return TRUE

	return FALSE

/datum/action/item_action/ritual_item/dagger
	name = "Draw Blood Rune"
	desc = "Use the ritual dagger to create a blood rune."
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"
