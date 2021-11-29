
/datum/team/advanced_cult
	name = "Advanced Cult"
	member_name = "Cultist"
	/// The original cultist / cult leader.
	var/datum/mind/original_cultist
	/// Whether people can be converted to join this team.
	var/no_conversion = TRUE
	/// A list of weakrefs to members who were deconverted from this cult.
	var/list/datum/weakref/lost_members
	/// Whether the cult is risen, enabled for some styles.
	var/cult_risen = FALSE
	/// Whether the cult is ascendent, enabled for some styles.
	var/cult_ascendent = FALSE
	/// List of bonus actions the leader only gets.
	var/list/datum/action/leader_actions

/datum/team/advanced_cult/New(starting_members)
	. = ..()
	if(starting_members && !islist(starting_members))
		original_cultist = starting_members
		name = "[original_cultist]'s cult"

	var/datum/antagonist/advanced_cult/our_cultist = original_cultist.has_antag_datum(/datum/antagonist/advanced_cult)
	our_cultist.cultist_style.on_cultist_team_made(src, original_cultist)

/datum/team/advanced_cult/Destroy(force, ...)
	original_cultist = null
	QDEL_LAZYLIST(leader_actions)
	return ..()

/datum/team/advanced_cult/remove_member(datum/mind/member)
	. = ..()
	lost_members += WEAKREF(member)

/datum/team/advanced_cult/proc/can_join_cult(mob/living/convertee)
	if(no_conversion)
		return CONVERSION_NOT_ALLOWED

	if(!isliving(convertee) || issilicon(convertee) || isbot(convertee) || isdrone(convertee))
		return CONVERSION_FAILED

	// if(convertee.client && convertee.mind)
	// 	if(ishuman(convertee) && (convertee.mind.holy_role))
	// 		return CONVERSION_FAILED
	// 	if(convertee.mind.unconvertable)
	// 		return CONVERSION_FAILED
	// else
	// 	return CONVERSION_FAILED

	if(HAS_TRAIT(convertee, TRAIT_MINDSHIELD))
		return CONVERSION_FAILED

	return CONVERSION_SUCCESS

/datum/team/advanced_cult/roundend_report()
	var/datum/antagonist/advanced_cult/cultist = original_cultist.has_antag_datum(/datum/antagonist/advanced_cult)
	if(no_conversion) //handled by the original cultist's roundend report
		return

	var/list/report = list()

	var/list/members_minus_head = LAZYCOPY(members) - original_cultist

	report += "<span class='header'>[name]:</span>"
	report += printplayer(original_cultist)
	report += "<b>[original_cultist]</b> was a/an <b>[cultist.linked_advanced_datum.name]</b>, a follower of <b>[cultist.linked_advanced_datum.employer || "no gods"]</b> and the leader of the cult!"
	if(LAZYLEN(members_minus_head))
		report += "<br>Followers of [name] at shift end:"
		report += printplayerlist(members_minus_head)
	if(LAZYLEN(lost_members))
		report += "<br>Followers of [name] who were deconverted:"
		var/list/lost_members_refs = list()
		for(var/datum/weakref/member as anything in lost_members)
			lost_members_refs += member.resolve()
		report += printplayerlist(lost_members_refs)

	var/total_members = LAZYLEN(lost_members) + LAZYLEN(members_minus_head)
	if(total_members <= 0)
		report += "<br>[original_cultist] did not convert anyone to their cult!<br>"
	else
		report += "<br>[total_members] crewmembers in total were converted to [name].<br>"

	if(LAZYLEN(cultist.linked_advanced_datum.our_goals))
		report += "[original_cultist] set the following objectives for their cult:"
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in cultist.linked_advanced_datum.our_goals)
			report += goal.get_roundend_text(count++)

	return "<div class='panel redborder'>[report.Join("<br>")]</div>"

/datum/team/advanced_cult/proc/arise_cultists()
	if(cult_risen)
		return

	cult_risen = TRUE
	for(var/datum/mind/cultist as anything in members)
		if(!ishuman(cultist.current))
			continue

		arise_given_cultist(cultist.current)

/datum/team/advanced_cult/proc/arise_given_cultist(mob/living/carbon/human/human_cultist, no_sound = FALSE)
	human_cultist.eye_color = BLOODCULT_EYE
	human_cultist.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
	ADD_TRAIT(human_cultist, TRAIT_UNNATURAL_RED_GLOWY_EYES, CULT_TRAIT)
	human_cultist.update_body()
	if(!no_sound)
		SEND_SOUND(human_cultist, pick('sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg'))

/datum/team/advanced_cult/proc/ascend_cultists()
	if(cult_ascendent)
		return

	cult_ascendent = TRUE
	for(var/datum/mind/cultist as anything in members)
		if(!ishuman(cultist.current))
			continue

		ascend_given_cultist(cultist.current)

/datum/team/advanced_cult/proc/ascend_given_cultist(mob/living/carbon/human/human_cultist, no_sound = FALSE)
	new /obj/effect/temp_visual/cult/sparks(get_turf(human_cultist), human_cultist.dir)
	var/istate = pick("halo1", "halo2", "halo3", "halo4", "halo5", "halo6")
	var/mutable_appearance/new_halo_overlay = mutable_appearance('icons/effects/32x64.dmi', istate, -HALO_LAYER)
	human_cultist.overlays_standing[HALO_LAYER] = new_halo_overlay
	human_cultist.apply_overlay(HALO_LAYER)
	if(!no_sound)
		SEND_SOUND(human_cultist, pick('sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg'))

/datum/action/innate/cult/arise_the_cult
	name = "Arise the Cult"
	desc = "Arise the cult, granting all members of the cult glowing red eyes."
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_cult.dmi'
	button_icon_state = "ascend_eyes"

/datum/action/innate/cult/arise_the_cult/IsAvailable()
	var/datum/antagonist/advanced_cult/cultist = owner.mind.has_antag_datum(/datum/antagonist/advanced_cult)
	var/datum/team/advanced_cult/cultist_team = cultist?.get_team()
	return !cultist_team?.cult_risen

/datum/action/innate/cult/arise_the_cult/Activate()
	var/datum/antagonist/advanced_cult/cultist = owner.mind.has_antag_datum(/datum/antagonist/advanced_cult)
	var/datum/team/advanced_cult/cultist_team = cultist?.get_team()
	if(!cultist_team)
		CRASH("[type] was activated without an associated advanced cult team!")

	cultist_team.arise_cultists()
	Remove(owner)

/datum/action/innate/cult/ascend_the_cult
	name = "Ascend the Cult"
	desc = "Ascend the cult, granting all members of the cult floating halos."
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_cult.dmi'
	button_icon_state = "ascend_halo"

/datum/action/innate/cult/ascend_the_cult/IsAvailable()
	var/datum/antagonist/advanced_cult/cultist = owner.mind.has_antag_datum(/datum/antagonist/advanced_cult)
	var/datum/team/advanced_cult/cultist_team = cultist?.get_team()
	return cultist_team?.cult_risen && !cultist_team?.cult_ascendent

/datum/action/innate/cult/ascend_the_cult/Activate()
	var/datum/antagonist/advanced_cult/cultist = owner.mind.has_antag_datum(/datum/antagonist/advanced_cult)
	var/datum/team/advanced_cult/cultist_team = cultist?.get_team()
	if(!cultist_team)
		CRASH("[type] was activated without an associated advanced cult team!")

	cultist_team.ascend_cultists()
	Remove(owner)
