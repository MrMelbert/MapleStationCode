/datum/component/uses_mana/story_spell/conjure_item/ice_knife
	var/ice_knife_attunement = 0.5
	var/ice_knife_cost = 30

/datum/component/uses_mana/story_spell/conjure_item/ice_knife/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/ice] = ice_knife_attunement

/datum/component/uses_mana/story_spell/conjure_item/ice_knife/get_mana_required(atom/caster, atom/cast_on, ...)
	return ..() * ice_knife_cost

/datum/action/cooldown/spell/conjure_item/ice_knife
	name = "Ice knife"
	desc = "Summon an ice knife made from the moisture in the air."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "ice_knife"

	item_type = /obj/item/knife/combat/ice
	delete_old = TRUE

	cooldown_time = 2 MINUTES
	invocation = "Ya shpion."
	invocation_type = INVOCATION_WHISPER
	school = SCHOOL_CONJURATION

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/obj/item/knife/combat/ice
	name = "ice knife"
	icon = 'maplestation_modules/icons/obj/weapons/stabby.dmi'
	icon_state = "ice_knife"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/knife_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/knife_righthand.dmi'
	inhand_icon_state = "ice_knife"
	embedding = list("pain_mult" = 4, "embed_chance" = 35, "fall_chance" = 10)
	desc = "A knife made out of magical ice. Doesn't look like it'll be solid for too long."
	force = 12
	throwforce = 12
	var/expire_time = -1

/obj/item/knife/combat/ice/Initialize()
	. = ..()
	expire_time = world.time + 20 SECONDS
	START_PROCESSING(SSobj, src)

/obj/item/knife/combat/ice/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/knife/combat/ice/attack()
	. = ..()
	expire_time += 3 SECONDS

/obj/item/knife/combat/ice/process()
	if(world.time >= expire_time)
		qdel(src)
