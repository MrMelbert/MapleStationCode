#define MOOD_CATEGORY_TRANSHUMANIST_PEOPLE "transhumanist_people"
#define MOOD_CATEGORY_TRANSHUMANIST_BODYPART "transhumanist_bodypart"
// The number of silicons minus the number of organics determines the level
#define TRANSHUMANIST_LEVEL_ECSTATIC 4
#define TRANSHUMANIST_LEVEL_HAPPY 1
#define TRANSHUMANIST_LEVEL_NEUTRAL 0
#define TRANSHUMANIST_LEVEL_UNHAPPY -2
#define TRANSHUMANIST_LEVEL_ANGRY -5

#define BODYPART_SCORE_ORGANIC 1
#define BODYPART_SCORE_SILICON 2
#define BODYPART_SCORE_OTHER_BODYTYPES 3
#define BODYPART_SCORE_OVERALL 4


/datum/quirk/transhumanist
	name = "Transhumanist"
	desc = "You see silicon life as the perfect lifeform and despise organic flesh. You are happier around silicons, but get frustrated when around organics. You seek to replace your fleshy limbs with their silicon counterparts. You start with a robotic limb."
	icon = FA_ICON_ROBOT
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES|QUIRK_MOODLET_BASED
	value = 0
	gain_text = span_notice("You have a desire to ditch your feeble organic flesh and surround yourself with robots.")
	lose_text = span_danger("Robots don't seem all that great anymore.")
	medical_record_text = "Patient reports hating pathetic creatures of meat and bone."
	mail_goodies = list(
		/obj/item/stock_parts/power_store/cell/potato,
		/obj/item/stack/cable_coil,
		/obj/item/toy/talking/ai,
		/obj/item/toy/figure/borg,
	)
	var/slot_string
	var/obj/item/bodypart/old_limb

/datum/quirk/transhumanist/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_CARBON_POST_ATTACH_LIMB, PROC_REF(calculate_bodypart_score))
	RegisterSignal(quirk_holder, COMSIG_CARBON_POST_REMOVE_LIMB, PROC_REF(calculate_bodypart_score))
	RegisterSignal(quirk_holder, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(calculate_bodypart_score))
	RegisterSignal(quirk_holder, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(calculate_bodypart_score))
	calculate_bodypart_score()

/datum/quirk/transhumanist/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_CARBON_REMOVE_LIMB, COMSIG_CARBON_ATTACH_LIMB))

/datum/quirk/transhumanist/proc/get_bodypart_score(mob/living/carbon/target, limbs_only = FALSE)
	var/organic_bodytypes = 0
	var/silicon_bodytypes = 0
	var/other_bodytypes = FALSE
	for(var/obj/item/bodypart/part as anything in target.bodyparts)
		if(part.bodytype & BODYTYPE_ROBOTIC)
			silicon_bodytypes += 1
		else if(part.bodytype & BODYTYPE_ORGANIC)
			organic_bodytypes += 0.1
		else
			other_bodytypes = TRUE

	if(!limbs_only)
		for(var/obj/item/organ/organ as anything in target.organs)
			if(organ.organ_flags & ORGAN_ROBOTIC)
				silicon_bodytypes += 0.25
			else if(organ.organ_flags & ORGAN_ORGANIC)
				organic_bodytypes += 0.02

	return list(
		BODYPART_SCORE_ORGANIC = organic_bodytypes,
		BODYPART_SCORE_SILICON = silicon_bodytypes,
		BODYPART_SCORE_OTHER_BODYTYPES = other_bodytypes,
		BODYPART_SCORE_OVERALL = silicon_bodytypes - organic_bodytypes
	)


/datum/quirk/transhumanist/proc/calculate_bodypart_score()
	SIGNAL_HANDLER
	var/list/score = get_bodypart_score(quirk_holder)
	var/organic_bodytypes = score[BODYPART_SCORE_ORGANIC]
	var/silicon_bodytypes = score[BODYPART_SCORE_SILICON]
	var/other_bodytypes = score[BODYPART_SCORE_OTHER_BODYTYPES]

	if(!other_bodytypes)
		if(organic_bodytypes <= 0.02)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_BODYPART, /datum/mood_event/completely_robotic)
			return
		else if(silicon_bodytypes == 0)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_BODYPART, /datum/mood_event/completely_organic)
			return
	else if(silicon_bodytypes == 0 && organic_bodytypes == 0)
		quirk_holder.clear_mood_event(MOOD_CATEGORY_TRANSHUMANIST_BODYPART)
		return

	var/bodypart_score = score[BODYPART_SCORE_OVERALL]
	switch(bodypart_score)
		if(3 to INFINITY)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_BODYPART, /datum/mood_event/very_robotic)
		if(0 to 3)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_BODYPART, /datum/mood_event/balanced_robotic)
		if(-INFINITY to 0)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_BODYPART, /datum/mood_event/very_organic)


/datum/quirk/transhumanist/add_unique(client/client_source)
	var/limb_type = GLOB.limb_choice_transhuman[client_source?.prefs?.read_preference(/datum/preference/choiced/prosthetic)]
	if(isnull(limb_type))  //Client gone or they chose a random prosthetic
		limb_type = GLOB.limb_choice_transhuman[pick(GLOB.limb_choice_transhuman)]

	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/bodypart/new_part = new limb_type()

	slot_string = "[new_part.plaintext_zone]"
	old_limb = human_holder.return_and_replace_bodypart(new_part, special = TRUE)

/datum/quirk/transhumanist/post_add()
	if(slot_string)
		to_chat(quirk_holder, span_boldannounce("Your [slot_string] has been replaced with a robot arm. You need to use a welding tool and cables to repair it, instead of sutures and regenerative meshes."))

/datum/quirk/transhumanist/remove()
	if(old_limb)
		var/mob/living/carbon/human/human_holder = quirk_holder
		human_holder.del_and_replace_bodypart(old_limb, special = TRUE)
		old_limb = null
	quirk_holder.clear_mood_event(MOOD_CATEGORY_TRANSHUMANIST_BODYPART)
	quirk_holder.clear_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE)

/datum/quirk/transhumanist/process(seconds_per_tick)
	var/organics_nearby = 0
	var/silicons_nearby = 0

	// Only cares about things that are nearby
	var/list/mobs = get_hearers_in_LOS(3, quirk_holder)

	for(var/mob/living/target in mobs)
		if(!isturf(target.loc) || target == quirk_holder || target.alpha <= 128 || target.invisibility > quirk_holder.see_invisible)
			continue

		if(iscarbon(target))
			var/list/score = get_bodypart_score(target, limbs_only = TRUE)
			// For an average human, they'll need 2 augmented limbs to not get counted as an organic nor a silicon.
			// If some monstrosity has 20-30 organic limbs, they'll likely need more.
			if(score[BODYPART_SCORE_OVERALL] < 1)
				organics_nearby += 1
			else if(score[BODYPART_SCORE_ORGANIC] == 0)
				silicons_nearby += 1
		else if(target.mob_biotypes & MOB_ORGANIC)
			organics_nearby += 1
		else if(target.mob_biotypes & MOB_ROBOTIC && target.stat != DEAD) // Dead silicons don't count, they're basically just machinery
			silicons_nearby += 1

	var/mood_result = silicons_nearby - organics_nearby

	switch(mood_result)
		if(TRANSHUMANIST_LEVEL_ECSTATIC to INFINITY)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE, /datum/mood_event/surrounded_by_silicon)
		if(TRANSHUMANIST_LEVEL_HAPPY to TRANSHUMANIST_LEVEL_ECSTATIC)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE, /datum/mood_event/around_many_silicon)
		if(TRANSHUMANIST_LEVEL_NEUTRAL + 0.01 to TRANSHUMANIST_LEVEL_HAPPY)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE, /datum/mood_event/around_silicon)
		if(TRANSHUMANIST_LEVEL_NEUTRAL)
			quirk_holder.clear_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE)
		if(TRANSHUMANIST_LEVEL_UNHAPPY to TRANSHUMANIST_LEVEL_NEUTRAL - 0.01)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE, /datum/mood_event/around_organic)
		if(TRANSHUMANIST_LEVEL_ANGRY to TRANSHUMANIST_LEVEL_UNHAPPY)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE, /datum/mood_event/around_many_organic)
		if(-INFINITY to TRANSHUMANIST_LEVEL_ANGRY)
			quirk_holder.add_mood_event(MOOD_CATEGORY_TRANSHUMANIST_PEOPLE, /datum/mood_event/surrounded_by_organic)

#undef MOOD_CATEGORY_TRANSHUMANIST_PEOPLE
#undef MOOD_CATEGORY_TRANSHUMANIST_BODYPART
#undef TRANSHUMANIST_LEVEL_ECSTATIC
#undef TRANSHUMANIST_LEVEL_HAPPY
#undef TRANSHUMANIST_LEVEL_NEUTRAL
#undef TRANSHUMANIST_LEVEL_UNHAPPY
#undef TRANSHUMANIST_LEVEL_ANGRY
#undef BODYPART_SCORE_ORGANIC
#undef BODYPART_SCORE_SILICON
#undef BODYPART_SCORE_OTHER_BODYTYPES
#undef BODYPART_SCORE_OVERALL
