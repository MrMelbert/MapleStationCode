#define MUTANT_ORGANS "mutant"
#define BODY_MARKINGS "body_markings"

// flags for animids
#define HAS_SCALES (1<<0)

#define GENERATE_HEAD_ICON(feature_list_key, feature_list_all) \
	generate_icon_with_head_accessory( \
		SSaccessories.hairstyles_list[/datum/sprite_accessory/hair/bedheadv4::name], \
		feature_list_all[feature_list_key], \
		relevant_external_organ::bodypart_overlay::feature_key, \
	)

#define GENERATE_TAIL_ICON(feature_list_key, feature_list_all) \
	generate_tail_icon( \
		feature_list_all[feature_list_key], \
		relevant_external_organ::bodypart_overlay::feature_key, \
	)

#define GENERATE_COLORED_TAIL_ICON(feature_list_key, feature_list_all, given_color) \
	generate_tail_icon( \
		feature_list_all[feature_list_key], \
		relevant_external_organ::bodypart_overlay::feature_key, \
		given_color, \
	)

#define SCALED_LIMBS_LIST list( \
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/scaled, \
		BODY_ZONE_HEAD  = /obj/item/bodypart/head/scaled, \
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/scaled, \
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/scaled, \
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/scaled, \
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/scaled )
