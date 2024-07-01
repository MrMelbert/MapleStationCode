// https://github.com/NovaSector/NovaSector/pull/497
/obj/structure/holosign/triage_zone_warning
	name = "triage zone indicator"
	desc = "A massive glowing holosign warning you, yes YOU, to keep out of it. \
		There's probably some important stuff happening in there!"
	icon = 'maplestation_modules/icons/effects/telegraph_96x96.dmi'
	icon_state = "treatment_zone"
	layer = BELOW_OBJ_LAYER
	pixel_x = -32
	pixel_y = 32
	pixel_z = -64
	use_vis_overlay = FALSE

/obj/item/holosign_creator/medical/triage_zone
	name = "emergency triage zone projector"
	desc = "A holographic projector that creates a large, \
		clearly marked triage zone hologram, which warns outsiders that they ought to stay out of it."
	holosign_type = /obj/structure/holosign/triage_zone_warning
	creation_time = 1 SECONDS
	max_signs = 1

/obj/item/holosign_creator/medical/create_holosign(atom/target, mob/user)
	. = ..()
	playsound(src, 'sound/machines/chime.ogg', 33, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, frequency = 0.5)

/datum/design/triage_zone_projector
	name = "Emergency Triage Zone Projector"
	desc = /obj/item/holosign_creator/medical/triage_zone::desc
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/holosign_creator/medical/triage_zone
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
	)
	id = "triage_zone_projector"
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/robot_model/medical/Initialize(mapload)
	basic_modules += /obj/item/holosign_creator/medical/triage_zone
	return ..()
