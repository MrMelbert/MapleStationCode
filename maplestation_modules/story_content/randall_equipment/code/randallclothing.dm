//this charlatan gucci'd down to the socks but need $4!?

/obj/item/clothing/under/jumpsuit/randallsuit
	name = "expensive suit"
	desc = "A well fitted suit. The shirt is tailored with a cold shoulder style and the neck is tied with a jewel that sparkles with an otherworldly glow."
	icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_worn.dmi'
	icon_state = "randallsuit"
	can_be_bloody = FALSE
	can_adjust = FALSE
	resistance_flags = INDESTRUCTIBLE
	clothing_traits = list(TRAIT_PACIFISM, TRAIT_VIRUSIMMUNE, TRAIT_NOHUNGER, TRAIT_NOBLOOD, TRAIT_NOBREATH, TRAIT_NODEATH) //so my ass isnt spending 5 minutes roundstart loading these on but if someone steals his clothes itll be really funny

/obj/item/clothing/suit/randallcoat
	name = "dress coat"
	desc = "A dress coat worn loosely around the shoulders. It's adorned with gold and jewels."
	icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_worn.dmi'
	icon_state = "randallcoat"
	can_be_bloody = FALSE
	resistance_flags = INDESTRUCTIBLE


/obj/item/clothing/shoes/randallboots
	name = "strange leather boots"
	desc = "Thigh-high leather boots made from an unknown animal. The heels click on the ground."
	icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_worn.dmi'
	icon_state = "randallboots"
	can_be_bloody = FALSE
	can_be_tied = FALSE
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/gloves/randallgloves
	name = "clawed gloves"
	desc = "Solid black gloves with a single claw ring on each."
	icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/randall_equipment/icons/randall_worn.dmi'
	icon_state = "randallgloves"
	can_be_bloody = FALSE
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/gloves/randallgloves/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(.)
		return

	if(!isliving(A))
		return

	if(deprecise_zone(user.zone_selected) != BODY_ZONE_HEAD)
		return

	var/mob/living/slapped = A
	user.visible_message(span_warning("[user] slaps [slapped] with [src]!"), span_warning("You slap [slapped] with [src]!"), span_hear("You hear a slap."))
	playsound(slapped, 'sound/weapons/slap.ogg', get_clamped_volume(), TRUE)
	slapped.Knockdown(1 SECONDS)
	user.do_attack_animation(slapped, used_item = src)
	user.changeNext_move(CLICK_CD_MELEE)
	return TRUE

/datum/outfit/randall
	name = "The United Amateur"

	uniform = /obj/item/clothing/under/jumpsuit/randallsuit
	suit = /obj/item/clothing/suit/randallcoat
	shoes = /obj/item/clothing/shoes/randallboots
	gloves = /obj/item/clothing/gloves/randallgloves
	l_hand = /obj/item/cane
