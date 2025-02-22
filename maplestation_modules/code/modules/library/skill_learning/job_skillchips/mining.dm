// -- Modular job skillchips. --
// Skillchip for miners that gives pain resistance when off the station's Z level.
/obj/item/skillchip/job/off_z_pain_resistance
	name = "D1GGY skillchip"
	skill_name = "Off Station Pain Resistance"
	skill_description = "For the adventurous in life, this skillchip provides \
		a reduction in pain (and boost to endurance) when off the station. \
		Additionally, includes an emergency injector which provides a temporary \
		boost of movement speed and pain resistance."
	skill_icon = "fist-raised"
	activate_message = span_notice("You feel like you can safely take on the unknown.")
	deactivate_message = span_notice("You feel more vulnerable to the unknown.")

	var/datum/action/cooldown/miner_skillchip/action
	var/refill_cd = 10 MINUTES

/obj/item/skillchip/job/off_z_pain_resistance/Initialize(mapload, is_removable)
	. = ..()
	create_reagents(25)
	action = new(src)

/obj/item/skillchip/job/off_z_pain_resistance/on_activate(mob/living/carbon/user, silent = FALSE)
	. = ..()
	RegisterSignal(user, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(check_z))
	check_z(user, null, user.loc)

/obj/item/skillchip/job/off_z_pain_resistance/on_deactivate(mob/living/carbon/user, silent = FALSE)
	UnregisterSignal(user, COMSIG_MOVABLE_Z_CHANGED)
	user.unset_pain_mod(PAIN_MOD_OFF_STATION)
	return ..()

/obj/item/skillchip/job/off_z_pain_resistance/proc/inject()
	var/mob/living/injectee = holding_brain?.owner
	if(isnull(injectee))
		return
	reagents.trans_to(injectee, amount = reagents.maximum_volume, transferred_by = injectee, methods = INJECT)
	addtimer(CALLBACK(src, PROC_REF(refill)), refill_cd)

/obj/item/skillchip/job/off_z_pain_resistance/proc/refill()
	reagents.add_reagent(/datum/reagent/medicine/painkiller/morphine, amount = 10, added_purity = 1)
	reagents.add_reagent(/datum/reagent/medicine/ephedrine, amount = 10, added_purity = 1)
	reagents.add_reagent(/datum/reagent/medicine/modafinil, amount = 5, added_purity = 1)

/**
 * Signal proc for [COMSIG_MOVABLE_Z_CHANGED].
 *
 * Checks if the new Z is valid for the skillchip.
 */
/obj/item/skillchip/job/off_z_pain_resistance/proc/check_z(datum/source, turf/old_turf, turf/new_turf)
	SIGNAL_HANDLER

	if(!ishuman(source) || !isturf(new_turf))
		return

	var/station_check = SSmapping.is_planetary() ? !SSmapping.level_trait(new_turf.z, ZTRAIT_UP) : is_station_level(new_turf.z)
	var/mob/living/carbon/human/human_source = source
	if(station_check)
		if(human_source.unset_pain_mod(PAIN_MOD_OFF_STATION))
			human_source.sprint_length_max /= 1.5
			human_source.sprint_regen_per_second /= 1.5
			action.Remove(human_source)
			to_chat(human_source, span_green("Returning to the station, you feel much more vulnerable to incoming pain."))
	else
		if(human_source.set_pain_mod(PAIN_MOD_OFF_STATION, 0.5))
			human_source.sprint_length_max *= 1.5
			human_source.sprint_regen_per_second *= 1.5
			action.Grant(human_source)
			to_chat(human_source, span_green("As you depart from the station, you feel more resilient to incoming pain."))

/datum/action/cooldown/miner_skillchip
	name = "Emergency Injection"
	desc = "Activates your skillchip's emergency injector, giving you a temporary boost of movement speed and pain resistance."
	button_icon = 'icons/hud/implants.dmi'
	button_icon_state = "adrenal"

/datum/action/cooldown/miner_skillchip/Activate()
	var/obj/item/skillchip/job/off_z_pain_resistance/chip = target
	chip.inject()
	StartCooldown(chip.refill_cd)
	owner.balloon_alert(owner, "you feel a surge of energy")

/datum/action/cooldown/miner_skillchip/update_button_name(atom/movable/screen/movable/action_button/button, force)
	. = ..()
	var/obj/item/skillchip/job/off_z_pain_resistance/chip = target
	button.desc += " Recharges in [DisplayTimeText(chip.refill_cd)]."

/datum/outfit/job/miner
	skillchips = list(/obj/item/skillchip/job/off_z_pain_resistance)

/obj/item/storage/box/skillchips/cargo
	name = "box of cargo skillchips"
	desc = "Contains spares of every cargo job skillchip."

/obj/item/storage/box/skillchips/cargo/PopulateContents()
	new /obj/item/skillchip/job/off_z_pain_resistance(src)
	new /obj/item/skillchip/job/off_z_pain_resistance(src)

/obj/structure/closet/secure_closet/quartermaster/PopulateContents()
	. = ..()
	new /obj/item/storage/box/skillchips/cargo(src)
