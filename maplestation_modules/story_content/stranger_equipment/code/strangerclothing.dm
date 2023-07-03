// funny lore man, overpowered so lavaland enemies/the crew dont kill him, won't attack crewmates so no worry about that. not meant to be worn by crewmembers
/obj/item/clothing/suit/armor/strangerarmor
	name = "stranger's armor"
	desc = "A massive, bulky suit of armor. Resembles some sort of death knight."
	icon = 'maplestation_modules/story_content/stranger_equipment/icons/stranger_icons.dmi'
	worn_icon = 'maplestation_modules/story_content/stranger_equipment/icons/stranger_worn.dmi'
	icon_state = "strangerarmor"
	w_class = WEIGHT_CLASS_BULKY
	body_parts_covered = FULL_BODY
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEHEADGEAR|HIDEJUMPSUIT|HIDEMASK|HIDENECK|HIDESHOES
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	resistance_flags = INDESTRUCTIBLE
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	strip_delay = 10 MINUTES //so people don't steal it. it can probably be made unable to take off but its so much funnier to have it take absurdly long
	slowdown = 2
	armor_type = /datum/armor/unobtanium_armor

/datum/armor/unobtanium_armor
	melee = 100
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90
