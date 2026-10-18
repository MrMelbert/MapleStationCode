// overrides so we dont do goofy things like protolathes printing things out at 0x cost
// as well as new functionality if thought of

/obj/machinery/rnd/production/compute_efficiency()
	. = ..()

	return max(..(), 0.25)

// returns >100% reduced chance of malfunction with tier 5 parts. ignore how tier 3 parts already remove malfunctions
/obj/machinery/teleport/hub/RefreshParts()
	. = ..()

	if(accuracy > 5)
		accuracy = 5

// can do negative brain damage. funny, but probably bad
/obj/machinery/netpod/on_server_upgraded(obj/machinery/quantum_server/source)
	if (disconnect_damage < 0)
		disconnect_damage = 0

/obj/machinery/deepfryer
	/// If we're giga upgraded we generate oil instead of using it
	var/generates_oil = FALSE

// Okay so turns out deep fryers need an oil efficiency above 0 if they want to still put oil into foods and not become air fryers
/obj/machinery/deepfryer/RefreshParts()
	. = ..()
	if(oil_use < 0)
		oil_use = 0.005 // oil use is 0.006 on tier 4
		generates_oil = TRUE

/obj/machinery/deepfryer/examine(mob/user)
	. = ..()
	if(generates_oil && (in_range(user, src) || isobserver(user)))
		. += span_notice("Generates it's own cooking oil.")

/obj/machinery/deepfryer/process(seconds_per_tick)
	. = ..()

	if(!frying)
		return

	// technically means it doesnt do multiple types but SHHHH
	var/datum/reagent/consumable/nutriment/fat/frying_oil = reagents.has_reagent(/datum/reagent/consumable/nutriment/fat, check_subtypes = TRUE)

	reagents.add_reagent(frying_oil.type, oil_use * 2 * seconds_per_tick)

// Just wouldn't be fun if putting these in a mech didn't have special effects. btw this proc doesnt give what part changed so that SUCKS
/obj/vehicle/sealed/mecha/update_part_values()
	. = ..()
	if(servo?.rating >= 5)
		movedelay = initial(movedelay)
		movedelay /= (servo.rating - 4)
	else
		movedelay = initial(movedelay)
	if(capacitor?.rating >= 5)
		var/datum/armor/stock_armor = get_armor_by_type(armor_type)
		var/initial_laser = stock_armor.get_rating(LASER)
		set_armor_rating(LASER, initial_laser + (capacitor.rating * 5))
	else
		var/datum/armor/stock_armor = get_armor_by_type(armor_type)
		var/initial_laser = stock_armor.get_rating(LASER)
		set_armor_rating(LASER, initial_laser)
	if(scanmod?.rating >= 6)
		AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)
	else
		RemoveElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/vehicle/sealed/mecha/toggle_overclock(forced_state = null)
	. =..()
	if(overclock_mode && servo?.rating >= 5)
		movedelay = initial(movedelay)
		movedelay /= overclock_coeff * (servo.rating - 4)
	else if(servo?.rating >= 5)
		movedelay = initial(movedelay)
		movedelay /= (servo.rating - 4)

// the cell has a slight downside for the infinite recharge. it makes your mech go stackpole when destroyed
/obj/vehicle/sealed/mecha/atom_destruction()
	if(istype(cell, /obj/item/stock_parts/power_store/cell/wondertech))
		cell.atom_destruction(BOMB) // might aswell give it a damage flag

	. = ..()
