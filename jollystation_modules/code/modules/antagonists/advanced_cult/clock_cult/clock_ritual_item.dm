
/obj/item/clockwork_slab
	name = "clockwork slab"
	desc = "A slab of brass covered in cogs and gizmos used by agents of Rat'var to invoke their spells."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "dread_ipad"
	worn_icon_state = "dread_ipad"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	throwforce = 6
	block_chance = 25 // The slab protects

/obj/item/clockwork_slab/Initialize(mapload)
	. = ..()
	var/examine_text = {"Allows the scribing of sigils and access to the powers of the cult of Rat'var.
Can be used on <b>cult structures</b> to move them around.
Can also be used on <b>sigils or runes</b> to clear them away.
Can block melee attacks for followers of Rat'var when held in hand."}

	AddComponent(/datum/component/cult_ritual_item/advanced, \
		span_brass(examine_text), \
		/datum/action/item_action/ritual_item/slab, \
		/turf/open/floor/bronze)

/obj/item/clockwork_slab/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	var/block_message = "[owner] blocks [attack_text] with [src]"
	if(owner.get_active_held_item() != src)
		block_message = "[owner] blocks [attack_text] with [src] in their offhand"

	var/datum/antagonist/advanced_cult/cultist = IS_CULTIST(owner)
	if(cultist && istype(cultist.cultist_style.ritual_item, type) && prob(final_block_chance) && attack_type != PROJECTILE_ATTACK)
		new /obj/effect/particle_effect/sparks(get_turf(owner))
		playsound(get_turf(owner), 'sound/weapons/resonator_blast.ogg', 100, TRUE)
		owner.visible_message(span_danger("[block_message]"))
		return TRUE

	return FALSE

/datum/action/item_action/ritual_item/slab
	name = "Draw Clockwork Sigil"
	desc = "Use the clockwork slab to create a powerful sigil."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"

/obj/item/stack/sheet/bronze/ten
	amount = 10
