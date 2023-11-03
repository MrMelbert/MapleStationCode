/datum/design/auto_cpr_device
	name = "CPR Autopulser"
	desc = "A device to automatically perform chest compressions on a patient. \
		Requires a cell to power it."
	id = "auto_cpr_device"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/auto_cpr
	category = list(RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/techweb_node/adv_biotech
	id_additions = list("auto_cpr_device")

/obj/item/auto_cpr
	name = "autopulser"
	desc = "A device with straps that can be worn around the chest. \
		It will automatically perform chest compressions on the wearer, \
		which can be useful for patients in cardiac arrest."

	icon = 'maplestation_modules/icons/obj/autopulser.dmi'
	worn_icon = 'maplestation_modules/icons/mob/autopulser.dmi'
	lefthand_file = 'maplestation_modules/icons/mob/inhands/autopulser_lhand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/autopulser_rhand.dmi'
	icon_state = "autopulser"

	drop_sound = 'sound/items/handling/component_drop.ogg'
	pickup_sound = 'sound/items/handling/component_pickup.ogg'

	slot_flags = ITEM_SLOT_OCLOTHING
	body_parts_covered = CHEST
	resistance_flags = FIRE_PROOF

	equip_delay_self = 3 SECONDS
	equip_delay_other = 2 SECONDS
	slowdown = 1
	throw_speed = 1
	throw_range = 2
	custom_price = PAYCHECK_COMMAND * 10

	/// Tracks how many pulses we've done on the current patient, to prevent message spam
	VAR_FINAL/pulse_count = 0
	/// The cell that powers this device
	VAR_FINAL/obj/item/stock_parts/cell/cell
	/// How much cell charge to use per pulse / compression
	var/charge_per_pulse = 50

/obj/item/auto_cpr/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/attack_equip)

/obj/item/auto_cpr/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/auto_cpr/deconstruct(disassembled)
	cell.forceMove(drop_location())
	return ..()

/obj/item/auto_cpr/examine(mob/user)
	. = ..()
	if(isnull(cell))
		. += span_notice("It has a slot for a power cell.")
	else
		. += span_notice("It has a power cell installed, secured by two <b>screws</b>.")

/obj/item/auto_cpr/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == cell)
		cell = null

/obj/item/auto_cpr/screwdriver_act(mob/living/user, obj/item/tool)
	if(isnull(cell))
		balloon_alert(user, "no cell!")
		return TOOL_ACT_SIGNAL_BLOCKING

	user.put_in_hands(cell)
	balloon_alert(user, "cell removed")
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	tool.play_tool_sound(src, 50)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/item/auto_cpr/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/stock_parts/cell))
		if(!isnull(cell))
			balloon_alert(user, "already has cell!")
			return TRUE
		if(!user.transferItemToLoc(attacking_item, src))
			balloon_alert(user, "can't put cell in!")
			return TRUE

		cell = attacking_item
		balloon_alert(user, "cell installed")
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		return TRUE

	return ..()

/obj/item/auto_cpr/equipped(mob/user, slot, initial)
	. = ..()
	if((slot & slot_flags) && ishuman(user))
		START_PROCESSING(SSobj, src)

/obj/item/auto_cpr/dropped(mob/user, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	pulse_count = 0

/obj/item/auto_cpr/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance, damage, attack_type, damage_type)
	. = ..()
	if(.)
		return
	if(damage > 0 && (damage_type == BRUTE || damage_type == BURN))
		do_sparks(2, FALSE, owner)

/obj/item/auto_cpr/process(seconds_per_tick)
	if(!ishuman(loc))
		return PROCESS_KILL

	if(!cell?.use(charge_per_pulse))
		return // Keep processing in case the cell is replaced

	var/mob/living/carbon/human/wearer = loc
	var/obj/item/bodypart/chest/chest = wearer.get_bodypart(BODY_ZONE_CHEST)
	if(IS_ORGANIC_LIMB(chest))
		var/kickstart_heart = prob(1) && wearer.undergoing_cardiac_arrest()
		chest.receive_damage(brute = (kickstart_heart ? 12 : 0.5), wound_bonus = CANT_WOUND, damage_source = "automatic chest compressions")
		wearer.cause_pain(BODY_ZONE_CHEST, (kickstart_heart ? 8 : 0.5))
		if(kickstart_heart)
			wearer.set_heartattack(FALSE)

	wearer.apply_status_effect(/datum/status_effect/cpr_applied)

	if(cell.charge < charge_per_pulse)
		playsound(src, 'sound/machines/defib_failed.ogg', 50, vary = TRUE, frequency = 0.75)
		wearer.audible_message(span_notice("[src] beeps, indicating that its power cell is empty."))

	else if(pulse_count % 5 == 0)
		playsound(src, 'sound/machines/defib_ready.ogg', 50, vary = TRUE, frequency = 0.75)
		if(IS_ORGANIC_LIMB(chest))
			wearer.visible_message(
				span_warning("[src] compresses down on [wearer]'s chest!"),
				span_warning("[src] compresses your chest painfully!"),
			)
		else
			wearer.visible_message(
				span_notice("[src] compresses down on [wearer]'s chest."),
				span_notice("[src] compresses your chest."),
			)

	pulse_count++


/obj/item/auto_cpr/loaded

/obj/item/auto_cpr/loaded/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/cell/upgraded(src)
