/atom/movable/screen/parallax_layer/planet/unbidden
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/unbidden_parallax.dmi'
	icon_state = "unbidden_empty"
	icon_state = "unbidden_far_ring"
	blend_mode = BLEND_OVERLAY
	absolute = TRUE
	speed = 5
	layer = 40

	var/distance = 0
	var/ringed = TRUE

/atom/movable/screen/parallax_layer/planet/unbidden/proc/get_random_look()
	return

/atom/movable/screen/parallax_layer/planet/unbidden/proc/change_distance(new_distance)
	switch(new_distance)
		if(0)
			icon_state = "unbidden_empty"
			distance = 0
		if(1)
			if(ringed)
				icon_state = "unbidden_far_ring"
			else
				icon_state = "unbidden_far"
			distance = 1
			speed = 4
		if(2)
			if(ringed)
				icon_state = "unbidden_ring"
			else
				icon_state = "unbidden"
			distance = 2
			speed = 5

/atom/movable/screen/parallax_layer/planet/unbidden/proc/switch_ring()
	if(ringed)
		ringed = FALSE
	else
		ringed = TRUE
	change_distance(distance)
