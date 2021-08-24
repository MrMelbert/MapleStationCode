//Modular accessories file
/obj/item/clothing/accessory
	/// What file we use for our on mob overlays when applied to uniforms
	var/overlay_file = 'icons/mob/clothing/accessories.dmi'

//Service armband
/obj/item/clothing/accessory/armband/service
	name = "service guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is green, and you're \
		filling in for the bartender who got bludgeoned to death by the bar monkey."
	icon = 'jollystation_modules/icons/obj/clothing/accessories.dmi'
	overlay_file = 'jollystation_modules/icons/mob/clothing/accessories.dmi'
	icon_state = "servband"
