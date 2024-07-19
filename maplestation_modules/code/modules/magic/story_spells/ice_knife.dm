/datum/component/uses_mana/story_spell/conjure_item/ice_knife
	var/ice_knife_attunement = 0.5

/datum/component/uses_mana/story_spell/conjure_item/ice_knife/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/ice] = ice_knife_attunement

/datum/component/uses_mana/story_spell/conjure_item/ice_knife/get_mana_required(atom/caster, atom/cast_on, ...)
	var/datum/action/cooldown/spell/conjure_item/ice_knife/ice_knife_spell = parent
	return ..() * ice_knife_spell.ice_knife_cost

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

	/// What the mana cost is, affected by Armblade variant.
	var/ice_knife_cost = 30

/obj/item/knife/combat/ice
	name = "ice knife"
	icon = 'maplestation_modules/icons/obj/weapons/stabby.dmi'
	icon_state = "ice_knife"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/ice_knife_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/ice_knife_righthand.dmi'
	inhand_icon_state = "ice_knife"
	embed_type = /datum/embed_data/ice_knife
	desc = "A knife made out of magical ice. Doesn't look like it'll be solid for too long."
	force = 12
	throwforce = 12
	var/expire_time = -1

/datum/embed_data/ice_knife
	pain_mult = 4
	embed_chance = 35
	fall_chance = 10

/obj/item/knife/combat/ice/Initialize(mapload)
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
		expire()

/obj/item/knife/combat/ice/proc/expire()
	playsound(src, 'sound/effects/glass_step.ogg', 70, TRUE, FALSE)
	qdel(src)

//Variant that conjures an armblade, in exchange for pain

/datum/spellbook_item/spell/ice_knife/apply_params(datum/action/cooldown/spell/conjure_item/ice_knife/our_spell, ice_blade)
	if (ice_blade)
		our_spell.item_type = /obj/item/melee/arm_blade/ice_armblade
		our_spell.ice_knife_cost = 45
		our_spell.name = "Ice Armblade"
		our_spell.desc = "Construct a blade around your arm, in exchange of harming it in the process."
	return

/obj/item/melee/arm_blade/ice_armblade
	name = "ice-blade"
	desc = "An armblade made out of ice magic. Sharper than a knife, but it pains you to keep it up."
	icon = 'maplestation_modules/icons/obj/weapons/stabby.dmi'
	icon_state = "ice_armblade"
	inhand_icon_state = "ice_armblade"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/ice_knife_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/ice_knife_righthand.dmi'
	item_flags = ABSTRACT
	w_class = WEIGHT_CLASS_HUGE
	force = 18
	hitsound = 'sound/weapons/bladeslice.ogg'
	wound_bonus = 5
	bare_wound_bonus = 5
	armour_penetration = 10
	block_chance = 15
	var/expire_time = -1

/obj/item/melee/arm_blade/ice_armblade/equipped()
	loc.visible_message(
			span_danger("[loc] conjures an ice-blade!"),
			span_danger("You conjure an ice-blade!"),
			span_hear("You hear someone conjuring something!"),
	)
	. = ..()
	self_damage(7)

/obj/item/melee/arm_blade/ice_armblade/Initialize(mapload)
	. = ..()
	expire_time = world.time + 10 SECONDS
	START_PROCESSING(SSobj, src)

/obj/item/melee/arm_blade/ice_armblade/process()
	if(world.time >= expire_time)
		expire()

/obj/item/melee/arm_blade/ice_armblade/attack()
	. = ..()
	self_damage(1)
	expire_time += 2 SECONDS

/obj/item/melee/arm_blade/ice_armblade/dropped()
	. = ..()
	loc.visible_message(
			span_danger("[loc]'s ice-blade shatters!"),
			span_danger("Your ice-blade shatters!"),
			span_hear("You hear something shatter!"),
	)

/obj/item/melee/arm_blade/ice_armblade/proc/expire()
	playsound(src, 'sound/effects/glass_step.ogg', 70, TRUE, FALSE)
	self_damage(7)
	qdel(src)

/obj/item/melee/arm_blade/ice_armblade/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/melee/arm_blade/ice_armblade/proc/self_damage(damage)
	var/mob/living/mymob = loc
	if(!istype(mymob))
		return
	var/spell_hand = (mymob.get_held_index_of_item(src) % 2) ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM
	mymob.apply_damage(damage, BRUTE, spell_hand)
