/// Handles all of the new modular variables that changelings need for their transformations

/datum/changeling_profile
	/// Reference to the profile source's flavor_text if it has any
	var/datum/flavor_text/flavor_text
	/// the size of the profile source
	var/size = 1
	/// The height of the profile source
	var/height = HUMAN_HEIGHT_MEDIUM

/datum/changeling_profile/copy_profile(datum/changeling_profile/new_profile)
	. = ..()
	new_profile.flavor_text = flavor_text
	new_profile.size = size
	new_profile.height = height

/datum/antagonist/changeling/create_profile(mob/living/carbon/human/target, protect = 0)
	var/datum/changeling_profile/new_profile = ..()

	new_profile.flavor_text = target.linked_flavor
	if(target.dna.features["size"])
		new_profile.size = target.dna.features["size"]
	new_profile.height = target.base_mob_height

	return new_profile

/datum/antagonist/changeling/transform(mob/living/carbon/human/user, datum/changeling_profile/chosen_profile)
	user.linked_flavor = chosen_profile.flavor_text
	if(user.dna.features["size"])
		user.update_transform(RESIZE_DEFAULT_SIZE/user.dna.features["size"])
	user.update_transform(chosen_profile.size)
	user.set_mob_height(chosen_profile.height)

	. = ..()
