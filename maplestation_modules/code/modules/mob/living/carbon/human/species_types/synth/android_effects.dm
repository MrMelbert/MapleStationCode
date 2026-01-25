/atom/movable/screen/alert/blood_leak
	name = "Leaking"
	desc = "You have too much fuel in your system, causing you to harmlessly shed the excess."

/datum/actionspeed_modifier/cold_android
	id = "cold_android"

/datum/actionspeed_modifier/cold_android/t1
	multiplicative_slowdown = 1.2

/datum/actionspeed_modifier/cold_android/t2
	multiplicative_slowdown = 1.5

/datum/actionspeed_modifier/cold_android/t3
	multiplicative_slowdown = 2.0

/datum/movespeed_modifier/cold_android
	id = "cold_android"

/datum/movespeed_modifier/cold_android/t1
	multiplicative_slowdown = 1.0

/datum/movespeed_modifier/cold_android/t2
	multiplicative_slowdown = 1.2

/datum/movespeed_modifier/cold_android/t3
	multiplicative_slowdown = 1.5

/datum/actionspeed_modifier/hot_android
	id = "hot_android"

/datum/actionspeed_modifier/hot_android/t1
	multiplicative_slowdown = 1.2

/datum/actionspeed_modifier/hot_android/t2
	multiplicative_slowdown = 1.5

/datum/actionspeed_modifier/hot_android/t3
	multiplicative_slowdown = 2.0

/datum/movespeed_modifier/hot_android
	id = "hot_android"

/datum/movespeed_modifier/hot_android/t1
	multiplicative_slowdown = 1.2

/datum/movespeed_modifier/hot_android/t2
	multiplicative_slowdown = 1.5

/datum/movespeed_modifier/hot_android/t3
	multiplicative_slowdown = 2.0

/datum/mood_event/android_minor_overheat
	description = "System operating above optimal temperature. I should cool down soon."
	mood_change = -4

/datum/mood_event/android_major_overheat
	description = "System significantly overheated! Performance degrading, integrity at risk - I must cool down!"
	mood_change = -8

/datum/mood_event/android_critical_overheat
	description = "Critical system overheat! I must cool down immediately to prevent damage!"
	mood_change = -12

/datum/mood_event/android_minor_overcool
	description = "System operating below optimal temperature. There is little risk, though I should warm up."
	mood_change = 0

/datum/mood_event/android_major_overcool
	description = "System far below optimal temperature. If I do not warm up soon, performance may degrade."
	mood_change = -3

/datum/mood_event/android_critical_overcool
	description = "System significantly below optimal temperature! To prevent chassis damage, I should warm up immediately!"
	mood_change = -6
