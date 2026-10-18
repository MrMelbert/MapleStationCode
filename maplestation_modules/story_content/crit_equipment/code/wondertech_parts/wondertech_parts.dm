// Wondertech parts. Rating of 6 so that they're not disappointing to use in comparison to their rarity and excessive power cost
// Could be moved into regular modular content with admittedly minimal genericization

/obj/item/stock_parts/capacitor/wondertech
	name = "ancient starry capacitor"
	desc = "A thermoplast capacitor that holds an incredible amount of charge for it's size. There is a purple four-pointed star on the top."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/wondertech_parts.dmi'
	icon_state = "wondertech_capacitor"
	rating = 6
	energy_rating = 100
	custom_materials = null

/datum/stock_part/capacitor/wondertech
	tier = 6
	physical_object_type = /obj/item/stock_parts/capacitor/wondertech

/obj/item/stock_parts/scanning_module/wondertech
	name = "ancient lightweight scanning module"
	desc = "A very high-resolution scanning device that happens to be built so as to weigh less. It seems incredibly resistant to EMPs."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/wondertech_parts.dmi'
	icon_state = "wondertech_scan_module"
	rating = 6
	energy_rating = 100
	custom_materials = null

/datum/stock_part/scanning_module/wondertech
	tier = 6
	physical_object_type = /obj/item/stock_parts/scanning_module/wondertech

/obj/item/stock_parts/servo/wondertech
	name = "ancient reinforced atto-servo"
	desc = "A very small servo with an extra-reinforced tungsten carbide end. The motor takes in an enormous amount of power."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/wondertech_parts.dmi'
	icon_state = "wondertech_servo"
	rating = 6
	energy_rating = 100
	custom_materials = null

/datum/stock_part/servo/wondertech
	tier = 6
	physical_object_type = /obj/item/stock_parts/servo/wondertech

/obj/item/stock_parts/micro_laser/wondertech
	name = "ancient gamma micro-laser"
	desc = "A tiny laser that produces a gamma ray laser similar to the bursts seen in collapsing black holes. You probably do not want to shine this into your eyes."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/wondertech_parts.dmi'
	icon_state = "wondertech_laser"
	rating = 6
	energy_rating = 100
	custom_materials = null

/datum/stock_part/micro_laser/wondertech
	tier = 6
	physical_object_type = /obj/item/stock_parts/micro_laser/wondertech

/obj/item/stock_parts/matter_bin/wondertech
	name = "ancient digital matter bin"
	desc = "A material container that utilizes digital storage technology to contain many more materials in a compressed space. Each one of these likely costs more than the entire station."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/wondertech_parts.dmi'
	icon_state = "wondertech_matter_bin"
	rating = 6
	energy_rating = 100
	custom_materials = null

/datum/stock_part/matter_bin/wondertech
	tier = 6
	physical_object_type = /obj/item/stock_parts/matter_bin/wondertech

// cells

/obj/item/stock_parts/power_store/cell/wondertech
	name = "ancient supermatter power cell"
	desc = "A power cell that happens to contain a very small shard of supermatter inside of it. Has the ability to recharge by itself. Do not blend."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/wondertech_parts.dmi'
	icon_state = "wondertech_cell"
	maxcharge = STANDARD_CELL_CHARGE * 100
	custom_materials = null
	chargerate = STANDARD_CELL_RATE * 5
	/// How fast it recharges per second, ideally not spammable
	var/recharge_rate = STANDARD_CELL_CHARGE

/obj/item/stock_parts/power_store/cell/wondertech/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/stock_parts/power_store/cell/wondertech/Destroy(force)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/stock_parts/power_store/cell/wondertech/process(seconds_per_tick)
	if(charge < maxcharge)
		give(recharge_rate * seconds_per_tick)
		update_appearance()

/obj/item/stock_parts/power_store/cell/wondertech/atom_destruction(damage_flag)
	explode()

/obj/item/stock_parts/power_store/cell/wondertech/deconstruct(disassembled)
	explode()

/obj/item/stock_parts/power_store/cell/wondertech/grind(datum/reagents/target_holder, mob/user)
	explode()

//Hey so you know how these contain a mini-SM? yeah
/obj/item/stock_parts/power_store/cell/wondertech/explode()
	message_admins("A [name] has exploded at [AREACOORD(loc)].")

	radiation_pulse(src, max_range = 9, threshold = RAD_EXTREME_INSULATION, chance = 50)
	visible_hallucination_pulse(
		center = get_turf(src),
		radius = 12,
		hallucination_duration = 30 SECONDS,
		hallucination_max_duration = 150 SECONDS,
		optional_messages = span_boldannounce("You feel reality distort for a moment..."),
	)
	playsound(src, 'sound/magic/charge.ogg')
	explosion(src, devastation_range = 1, heavy_impact_range = 4, light_impact_range = 7, flash_range = 8)
	qdel(src)

/obj/item/stock_parts/power_store/cell/wondertech/empty // given the self-recharge im not entirely sure why you need this
	empty = TRUE

/obj/item/stock_parts/power_store/battery/wondertech
	name = "ancient supermatter megacell"
	desc = "A megacell that has an internal supermatter engine to recharge itself. Handle with care."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/wondertech_parts.dmi'
	icon_state = "wondertech_megacell"
	maxcharge = STANDARD_BATTERY_CHARGE * 100
	custom_materials = null
	chargerate = STANDARD_BATTERY_RATE * 5
	/// How fast it recharges per second
	var/recharge_rate = STANDARD_BATTERY_CHARGE * 2.5

/obj/item/stock_parts/power_store/battery/wondertech/empty // it recharges in 40 seconds
	empty = TRUE

/obj/item/stock_parts/power_store/battery/wondertech/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/stock_parts/power_store/battery/wondertech/Destroy(force)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/stock_parts/power_store/battery/wondertech/process(seconds_per_tick)
	if(charge < maxcharge)
		give(recharge_rate * seconds_per_tick)
		update_appearance()

/obj/item/stock_parts/power_store/battery/wondertech/atom_destruction(damage_flag)
	explode()

/obj/item/stock_parts/power_store/battery/wondertech/deconstruct(disassembled)
	explode()

/obj/item/stock_parts/power_store/battery/wondertech/grind(datum/reagents/target_holder, mob/user)
	explode()

//bigger SM means bigger boom
/obj/item/stock_parts/power_store/battery/wondertech/explode()
	message_admins("A [name] has exploded at [AREACOORD(loc)].")

	radiation_pulse(src, max_range = 15, threshold = RAD_EXTREME_INSULATION, chance = 50)
	visible_hallucination_pulse(
		center = get_turf(src),
		radius = 20,
		hallucination_duration = 30 SECONDS,
		hallucination_max_duration = 150 SECONDS,
		optional_messages = span_boldannounce("You feel reality distort for a moment..."),
	)
	playsound(src, 'sound/magic/charge.ogg')
	explosion(src, devastation_range = 2, heavy_impact_range = 7, light_impact_range = 13, flash_range = 15)
	qdel(src)

/obj/item/storage/part_replacer/bluespace/wondertech_parts
	name = "\improper Hale's Own bluespace rapid part exchange device"
	desc = "You hear cartoon noises coming from this thing."

/obj/item/storage/part_replacer/bluespace/wondertech_parts/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/stock_parts/capacitor/wondertech(src)
		new /obj/item/stock_parts/scanning_module/wondertech(src)
		new /obj/item/stock_parts/servo/wondertech(src)
		new /obj/item/stock_parts/micro_laser/wondertech(src)
		new /obj/item/stock_parts/matter_bin/wondertech(src)
		new /obj/item/stock_parts/power_store/cell/wondertech(src)
