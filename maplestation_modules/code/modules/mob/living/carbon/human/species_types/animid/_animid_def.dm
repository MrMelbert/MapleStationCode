#define MUTANT_ORGANS "mutant"
#define BODY_MARKINGS "body_markings"

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
