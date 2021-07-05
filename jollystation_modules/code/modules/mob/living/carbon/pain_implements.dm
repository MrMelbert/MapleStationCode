// -- Implements and equipment to help reduce pain. --
/obj/item/reagent_containers/pill/asprin
	name = "asprin pill"
	desc = "Used to treat moderate pain and fever. Metabolizes slowly. Best at treating chest pain."
	icon_state = "pill7"
	list_reagents = list(/datum/reagent/medicine/painkiller/aspirin = 10) // Lasts ~4 minutes, heals ~20 pain in chest (lower in other parts)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/ibuprofen
	name = "ibuprofen pill"
	desc = "Used to treat mild pain, headaches, and fever. Metabolizes slowly. Best at treating head pain."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/medicine/painkiller/ibuprofen = 10) // Lasts ~4 minutes, heals ~20 pain in head (lower in other parts)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/paracetamol
	name = "paracetamol pill"
	desc = "Used to treat moderate pain and headaches. Metabolizes slowly. Good as a general painkiller."
	icon_state = "pill9"
	list_reagents = list(/datum/reagent/medicine/painkiller/paracetamol = 10) // Lasts ~4 minutes, heals ~15 pain per bodypart
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/morphine/diluted
	desc = "Used to treat major to severe pain. Causes moderate drowsyness. Mildly addictive."
	icon_state = "pill11"
	list_reagents = list(/datum/reagent/medicine/morphine = 5) // Lasts ~1 minute, heals ~10 pain per bodypart (~100 pain)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/oxycodone
	name = "oxycodon pill"
	desc = "Used to treat severe to extreme pain. Rapid acting, may cause delirium. Very addictive."
	icon_state = "pill12"
	list_reagents = list(/datum/reagent/medicine/oxycodone = 5) // Lasts ~1 minute, heals ~20 pain per bodypart (~200 pain)
	rename_with_volume = TRUE

/obj/item/storage/pill_bottle/painkillers
	name = "bottle of painkillers"
	desc = "Contains multiple pills used to treat anywhere from mild to extreme pain. CAUTION: Do not take in conjunction with alcohol."
	icon = 'jollystation_modules/icons/obj/chemical.dmi'
	custom_premium_price = PAYCHECK_HARD * 1.5

/obj/item/storage/pill_bottle/painkillers/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 14
	STR.max_combined_w_class = 28

/obj/item/storage/pill_bottle/painkillers/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/asprin(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/ibuprofen(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/paracetamol(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/morphine/diluted(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/pill/oxycodone(src)

/// Miner pen.
/obj/item/reagent_containers/hypospray/medipen/survival/painkiller
	name = "survival painkiller medipen"
	desc = "A medipen that contains a dosage of heavy duty painkillers. WARNING: Side effects or addiction may occur with rapid consecutive usage. Do not use in combination with alcohol."
	icon = 'jollystation_modules/icons/obj/syringe.dmi'
	icon_state = "painkiller_stimpen"
	base_icon_state = "painkiller_stimpen"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/oxycodone = 7.5, /datum/reagent/medicine/morphine = 5, /datum/reagent/medicine/modafinil = 2.5)

/// Medkit pen.
/obj/item/reagent_containers/hypospray/medipen/painkiller
	name = "emergency painkiller medipen"
	desc = "A medipen that contains a dosages of moderate painkilling chemicals. Can cause drowsyness. WARNING: Do not use in combination with alcohol."
	icon_state = "hypovolemic"
	base_icon_state = "hypovolemic"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/painkiller/paracetamol = 7.5, /datum/reagent/medicine/painkiller/aspirin_para_coffee = 5, /datum/reagent/medicine/morphine = 2.5)

#define DOAFTER_SOURCE_BLANKET "doafter_blanket"

/obj/item/shock_blanket
	name = "shock blanket"
	desc = "A metallic looking plastic blanket specifically designed to well insulate anyone seeking comfort underneath."
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	layer = MOB_LAYER
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_OCLOTHING
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	resistance_flags = FIRE_PROOF
	heat_protection = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 0, BULLET = 0, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 10, RAD = 20, FIRE = 100, ACID = 50)
	equip_delay_self = 2 SECONDS
	slowdown = 1.5
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	custom_price = PAYCHECK_MEDIUM

/obj/item/shock_blanket/Initialize(mapload)
	. = ..()
	if(prob(1))
		name = "safety blanket"
	AddElement(/datum/element/bed_tuckable, 0, 0, 0)

/obj/item/shock_blanket/examine(mob/user)
	. = ..()
	. += span_notice("To use: Apply to a patient experiencing shock or loss of body temperature. Keep patient still and lying down for maximum effect.")

/obj/item/shock_blanket/pre_attack(atom/target, mob/living/user, params)
	. = ..()

	if(ishuman(target))
		try_shelter_mob(target, user)
		return TRUE

	return

/*
 * Try to equip [target] with [src], done by [user].
 * Basically, the ability to equip someone just by hitting them with the blanket,
 * instead of needing to use the strip menu.
 *
 * target - the mob being hit with the blanket
 * user - the mob hitting the target
 */
/obj/item/shock_blanket/proc/try_shelter_mob(mob/living/carbon/human/target, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_BLANKET))
		return FALSE

	if(target.wear_suit)
		to_chat(user, span_warning("You need to take off [target == user ? "your" : "their"] [target.wear_suit] first!"))
		return FALSE

	to_chat(user, span_notice("You begin wrapping [target == user ? "yourself" : "[target]"] with [src]..."))
	visible_message(span_notice("[user] begins wrapping [target == user ? "[user.p_them()]self" : "[target]"] with [src]..."), ignored_mobs = list(user))
	if(!do_after(user, (target == user ? equip_delay_self : equip_delay_other), target, interaction_key = DOAFTER_SOURCE_BLANKET))
		return FALSE

	do_shelter_mob(target, user)
	return TRUE

/*
 * Actually equip [target] with [src], done by [user].
 *
 * target - the mob being equipped
 * user - the mob equipping the target
 */
/obj/item/shock_blanket/proc/do_shelter_mob(mob/living/carbon/human/target, mob/living/user)
	if(target.equip_to_slot_if_possible(src, ITEM_SLOT_OCLOTHING, disable_warning = TRUE, bypass_equip_delay_self = TRUE))
		to_chat(user, span_notice("You wrap [target == user ? "yourself" : "[target]"] with [src], helping prevent loss of body heat."))
	else
		to_chat(user, span_warning("You fumble and fail to wrap [target == user ? "yourself" : "[target]"] with [src]."))

/obj/item/shock_blanket/equipped(mob/user, slot)
	. = ..()
	if(slot_flags & slot)
		enable_protection(user)
		RegisterSignal(user, list(COMSIG_LIVING_SET_BODY_POSITION, COMSIG_LIVING_SET_BUCKLED), .proc/check_protection)
		RegisterSignal(user, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_PRE_MOVE), .proc/disable_protection)

/obj/item/shock_blanket/dropped(mob/user, silent)
	. = ..()
	disable_protection(user)
	UnregisterSignal(user, list(COMSIG_LIVING_SET_BODY_POSITION, COMSIG_LIVING_SET_BUCKLED, COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_PRE_MOVE))

/*
 * Check if we should be recieving temperature protection.
 * We only give protection if we're lying down or buckled - if we're moving, we don't get anything.
 */
/obj/item/shock_blanket/proc/check_protection(mob/living/source)
	SIGNAL_HANDLER

	if(source.body_position == LYING_DOWN)
		enable_protection(source)
		return
	if(source.buckled)
		enable_protection(source)
		return

	disable_protection(source)

/*
 * Enable the temperature protection.
 */
/obj/item/shock_blanket/proc/enable_protection(mob/living/source)
	SIGNAL_HANDLER

	if(istype(source) && !(datum_flags & DF_ISPROCESSING))
		var/temp_change = "warmer"
		if(source.bodytemperature > source.get_body_temp_normal(apply_change = FALSE))
			temp_change = "colder"

		to_chat(source, span_notice("You feel [temp_change] as [src] begins regulating your body temperature."))
		START_PROCESSING(SSobj, src)

/*
 * Disable the temperataure protection.
 */
/obj/item/shock_blanket/proc/disable_protection(mob/living/source)
	SIGNAL_HANDLER

	if(istype(source) && (datum_flags & DF_ISPROCESSING))
		var/temp_change = "freezing"
		if(source.bodytemperature > source.get_body_temp_normal(apply_change = FALSE))
			temp_change = "hotter"

		to_chat(source, span_notice("You feel [temp_change] again as [src] stops regulating your body temperature."))

	STOP_PROCESSING(SSobj, src)

/obj/item/shock_blanket/process(delta_time)
	var/mob/living/carbon/wearer = loc
	if(!istype(wearer))
		disable_protection()
		return

	var/target_temp = wearer.get_body_temp_normal(apply_change = FALSE)
	if(wearer.bodytemperature > target_temp)
		wearer.adjust_bodytemperature(-30 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
	else if(wearer.bodytemperature < (target_temp + 1))
		wearer.adjust_bodytemperature(30 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)
	if(ishuman(wearer))
		var/mob/living/carbon/human/human_wearer = wearer
		if(human_wearer.coretemperature > target_temp)
			human_wearer.adjust_coretemperature(-30 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, target_temp)
		else if(human_wearer.coretemperature < (target_temp + 1))
			human_wearer.adjust_coretemperature(30 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, 0, target_temp)

/obj/item/shock_blanket/emergency
	slowdown = 2.5
	equip_delay_self = 1.2 SECONDS
	equip_delay_other = 1.2 SECONDS

/obj/item/shock_blanket/emergency/Initialize()
	. = ..()
	name = "emergency [name]"

#undef DOAFTER_SOURCE_BLANKET

/obj/item/storage/firstaid/emergency/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 12
	STR.max_combined_w_class = 12

/obj/item/storage/firstaid/emergency/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/healthanalyzer/wound = 1,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/suture/emergency = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 2,
		/obj/item/reagent_containers/hypospray/medipen/painkiller = 2,
		/obj/item/storage/pill_bottle/iron = 1,
		/obj/item/shock_blanket/emergency = 1,
	)
	generate_items_inside(items_inside, src)


/obj/machinery/vending/drugs
	added_premium = list(/obj/item/storage/pill_bottle/painkillers = 2)

/obj/machinery/vending/medical
	added_products = list(/obj/item/shock_blanket = 3)

/obj/machinery/vending/wallmed
	added_products = list(/obj/item/shock_blanket/emergency = 2)
