/obj/item/clothing/glasses/red
	desc = "These might ruin your dreams of becoming a pastry chef."
	icon = 'maplestation_modules/icons/obj/clothing/glasses.dmi'
	icon_state = "red_justice"
	worn_icon = 'maplestation_modules/icons/mob/clothing/eyes.dmi'
	unique_reskin = list(
			"Justice" = "red_justice",
			"Senpai" = "red_senpai",
	)

/obj/item/clothing/glasses/red/reskin_obj(mob/user)
	. = ..()
	user.update_worn_glasses()
	if(icon_state == "red_senpai")
		desc = "Hey, you're looking good, senpai!"
	else
		desc = initial(desc)
