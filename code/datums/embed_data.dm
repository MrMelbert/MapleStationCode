/// Assosciative list of type -> embed data.
GLOBAL_LIST_INIT(embed_by_type, generate_embed_type_cache())

/proc/generate_embed_type_cache()
	var/list/embed_cache = list()
	for(var/datum/embed_data/embed_type as anything in subtypesof(/datum/embed_data))
		var/datum/embed_data/embed = new embed_type
		embed_cache[embed_type] = embed
	return embed_cache

/proc/get_embed_by_type(embed_type)
	var/datum/embed_data/embed = GLOB.embed_by_type[embed_type]
	if(embed)
		return embed
	CRASH("Attempted to get an embed type that did not exist! '[embed_type]'")

/datum/embed_data
	/// Chance for an object to embed into somebody when thrown
	var/embed_chance = 45
	/// Chance for embedded object to fall out (causing pain but removing the object)
	var/fall_chance = 5
	/// Chance for embedded objects to cause pain (damage user)
	var/pain_chance = 15
	/// Coefficient of multiplication for the damage the item does while embedded (this*item.w_class)
	var/pain_mult = 2
	/// Coefficient of multiplication for the damage the item does when it first embeds (this*item.w_class)
	var/impact_pain_mult = 4
	/// Coefficient of multiplication for the damage the item does when it falls out or is removed without a surgery (this*item.w_class)
	var/remove_pain_mult = 6
	/// If this should ignore throw speed threshold of 4
	var/ignore_throwspeed_threshold = FALSE
	/// Chance for embedded objects to cause pain every time they move (jostle)
	var/jostle_chance = 5
	/// Coefficient of multiplication for the damage the item does while
	var/jostle_pain_mult = 1
	/// This percentage of all pain will be dealt as stam damage rather than brute (0-1)
	var/pain_stam_pct = 0
	/// The embed doesn't show up on examine, only on health analyze
	/// (Note: This means you can't rip it out)
	var/stealthy_embed = FALSE
	/// How much blood is lost per life tick while embedded
	var/blood_loss = 0.25
	/// Max speed we can pull the embedded object out without causing damage
	var/max_pull_speed = 2

/datum/embed_data/proc/generate_with_values(
	embed_chance = src.embed_chance,
	fall_chance = src.fall_chance,
	pain_chance = src.pain_chance,
	pain_mult = src.pain_mult,
	impact_pain_mult = src.impact_pain_mult,
	remove_pain_mult = src.remove_pain_mult,
	max_pull_speed = src.max_pull_speed,
	ignore_throwspeed_threshold = src.ignore_throwspeed_threshold,
	jostle_chance = src.jostle_chance,
	jostle_pain_mult = src.jostle_pain_mult,
	pain_stam_pct = src.pain_stam_pct,
	stealthy_embed = src.stealthy_embed,
	force_new = FALSE,
)
	var/datum/embed_data/data = (isnull(GLOB.embed_by_type[type]) && !force_new) ? new() : src

	data.embed_chance = embed_chance
	data.fall_chance = fall_chance
	data.pain_chance = pain_chance
	data.pain_mult = pain_mult
	data.impact_pain_mult = impact_pain_mult
	data.remove_pain_mult = remove_pain_mult
	data.max_pull_speed = max_pull_speed
	data.ignore_throwspeed_threshold = ignore_throwspeed_threshold
	data.jostle_chance = jostle_chance
	data.jostle_pain_mult = jostle_pain_mult
	data.pain_stam_pct = pain_stam_pct
	data.stealthy_embed = stealthy_embed
	return data

/datum/embed_data/proc/on_embed(
	mob/living/carbon/victim,
	obj/item/bodypart/limb,
	obj/item/weapon,
	harmful = weapon?.is_embed_harmless(),
)
	victim.visible_message(
		span_danger("[weapon] [harmful ? "lodges" : "sticks"] itself [harmful ? "in" : "to"] [victim]'s [limb.plaintext_zone]!"),
		span_userdanger("[weapon] [harmful ? "lodges" : "sticks"] itself [harmful ? "in" : "to"] your [limb.plaintext_zone]!"),
	)
	if(harmful)
		playsound(victim, 'sound/weapons/bladeslice.ogg', 40)


/obj/item/bodypart
	/// The embed interface for this limb, shared between all users viewing it
	VAR_FINAL/atom/movable/screen/embed_interface/embed_interface

/obj/item/bodypart/proc/open_embed_interface(mob/living/user = usr)
	embed_interface ||= new(null, null, src)
	embed_interface.open(user)

/obj/effect/appearance_clone/embedded_item
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// Progress towards removal, or in other words y-pos
	var/remove_progress = 0
	/// Max speed we can pull this object out without causing damage
	var/max_speed = INFINITY

#define GET_REMOVAL_TOOL(whom, target) (whom.get_active_held_item()?.get_proxy_attacker_for(target, whom))

/atom/movable/screen/embed_interface
	icon = 'maplestation_modules/icons/hud/embed.dmi'
	icon_state = "base"
	screen_loc = "CENTER+2.1,CENTER-1.6"
	maptext_x = 2
	maptext_y = 160
	maptext_width = 120
	maptext_height = 200

	/// Limb that owns us
	VAR_PRIVATE/obj/item/bodypart/target_limb
	/// Assoc list of currently tracked embedded objects to the embed holder
	VAR_PRIVATE/list/tracked_embeds
	/// Assoc list of mob vieweing the interface to their data
	VAR_PRIVATE/list/viewers

/atom/movable/screen/embed_interface/Initialize(mapload, datum/hud/hud_owner, obj/item/bodypart/limb)
	. = ..()
	maptext += "<span style='text-align: center'>"
	maptext += MAPTEXT_TINY_UNICODE(\
		"Click on an object, then move your mouse to move it. \
		Once it enters the green area, it will be removed from the body.<br><br>\
		Be careful, moving too fast will cause damage and drop the object \
		if you are not using precision tools!"\
	)
	maptext += "</span>"

	target_limb = limb
	tracked_embeds = list()
	viewers = list()
	for (var/obj/item/embed as anything in target_limb.embedded_objects)
		register_embedded_object(embed)
	RegisterSignals(target_limb, list(COMSIG_QDELETING, COMSIG_BODYPART_REMOVED), PROC_REF(on_limb_deleted))
	RegisterSignal(target_limb, COMSIG_BODYPART_ON_EMBEDDED, PROC_REF(new_embed_registered))

	// var/mutable_appearance/limb_underlay = new(target_limb)
	// limb_underlay.appearance_flags |= PIXEL_SCALE
	// limb_underlay.transform = target_limb.transform.Scale(8, 8)
	// limb_underlay.plane = src.plane
	// limb_underlay.layer = src.layer - 1
	// limb_underlay.pixel_x = 45
	// limb_underlay.pixel_y = 55
	// limb_underlay.color = COLOR_MATRIX_GRAYSCALE
	// underlays += limb_underlay

/atom/movable/screen/embed_interface/Destroy()
	UnregisterSignal(target_limb, list(COMSIG_QDELETING, COMSIG_BODYPART_REMOVED, COMSIG_BODYPART_ON_EMBEDDED))
	target_limb.embed_interface = null
	target_limb = null
	for(var/mob/viewer as anything in viewers)
		close(viewer)
	for(var/obj/item/embed as anything in tracked_embeds)
		unregister_embedded_object(embed)
	return ..()

/atom/movable/screen/embed_interface/proc/on_limb_deleted(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/atom/movable/screen/embed_interface/proc/new_embed_registered(datum/source, obj/item/embedded_item)
	SIGNAL_HANDLER

	register_embedded_object(embedded_item)

/atom/movable/screen/embed_interface/proc/register_embedded_object(obj/item/embedded_item)

	var/obj/effect/appearance_clone/embedded_item/embed_holder = new(null, embedded_item)
	embed_holder.vis_flags |= VIS_INHERIT_ID
	embed_holder.appearance_flags |= PIXEL_SCALE
	embed_holder.transform = embedded_item.transform.Scale(2, 2)
	embed_holder.pixel_x = 6 + 36 * (length(tracked_embeds) % 3)
	embed_holder.pixel_y = 2 * rand(1, 4)
	embed_holder.layer = src.layer + 1
	embed_holder.plane = src.plane

	var/datum/embed_data/embed_data = embedded_item.get_embed()
	embed_holder.max_speed = embed_data.max_pull_speed

	tracked_embeds[embedded_item] = embed_holder
	RegisterSignal(embedded_item, COMSIG_ITEM_UNEMBEDDED, PROC_REF(embedded_object_removed))
	vis_contents += embed_holder

/atom/movable/screen/embed_interface/proc/embedded_object_removed(obj/item/source, mob/living/owner)
	SIGNAL_HANDLER
	unregister_embedded_object(source)
	if(!length(tracked_embeds))
		qdel(src)
		return

	for(var/mob/viewer as anything in viewers)
		if(viewers[viewer]["selected"] == source)
			set_currently_selected(null, viewer)

/atom/movable/screen/embed_interface/proc/unregister_embedded_object(obj/item/source)
	var/obj/effect/appearance_clone/embedded_item/embed_holder = tracked_embeds[source]
	vis_contents -= embed_holder
	qdel(embed_holder)

	tracked_embeds -= source
	UnregisterSignal(source, COMSIG_ITEM_UNEMBEDDED)

/atom/movable/screen/embed_interface/proc/open(mob/user)
	if(viewers[user])
		return // already open
	if(!isliving(user) || !check_state(user))
		return

	RegisterSignals(user, list(COMSIG_QDELETING, COMSIG_MOB_LOGOUT), PROC_REF(on_viewer_deleted))
	RegisterSignals(user, list(SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED), COMSIG_MOVABLE_MOVED), PROC_REF(on_viewer_state_update))
	RegisterSignals(user, list(COMSIG_MOB_DROPPING_ITEM, COMSIG_MOB_SWAP_HANDS), PROC_REF(on_viewer_hand_update))
	user.client.screen += src
	viewers[user] = list(
		"selected" = null,
		"last_move_world_time" = null,
		"last_move_x_num" = null,
		"last_move_y_num" = null,
		"last_fail" = null,
		"bypass_fail" = can_bypass_speed_check(user),
	)

/atom/movable/screen/embed_interface/proc/close(mob/user)
	UnregisterSignal(user, list(
		COMSIG_MOB_DROPPING_ITEM,
		COMSIG_MOB_LOGOUT,
		COMSIG_MOB_SWAP_HANDS,
		COMSIG_MOVABLE_MOVED,
		COMSIG_QDELETING,
		SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
	))
	user.client?.screen -= src
	viewers -= user

/atom/movable/screen/embed_interface/proc/check_state(mob/user)
	if(user.incapacitated(IGNORE_STASIS|IGNORE_GRAB))
		return FALSE
	if(user.CanReach(target_limb.owner, GET_REMOVAL_TOOL(user, target_limb) ))
		return TRUE
	if(!iscarbon(user))
		return FALSE
	var/mob/living/carbon/carbon_mob = user
	if(!carbon_mob.dna?.check_mutation(/datum/mutation/human/telekinesis))
		return FALSE
	if(!tkMaxRangeCheck(carbon_mob, target_limb.owner))
		return FALSE
	return TRUE

/atom/movable/screen/embed_interface/proc/on_viewer_state_update(mob/source, ...)
	SIGNAL_HANDLER

	if(!check_state(source))
		close(source)

/atom/movable/screen/embed_interface/proc/on_viewer_deleted(mob/source, ...)
	SIGNAL_HANDLER

	close(source)

/atom/movable/screen/embed_interface/proc/on_viewer_hand_update(mob/source, ...)
	SIGNAL_HANDLER

	viewers[source]["bypass_fail"] = can_bypass_speed_check(source)

/atom/movable/screen/embed_interface/proc/set_currently_selected(obj/item/embed, mob/user)
	if(!isnull(viewers[user]["selected"]))
		var/obj/effect/appearance_clone/embedded_item/embed_holder = tracked_embeds[viewers[user]["selected"]]
		embed_holder?.remove_filter("selected") // it's fine if this one is null

	viewers[user]["selected"] = embed
	if(!isnull(embed))
		var/obj/effect/appearance_clone/embedded_item/embed_holder = tracked_embeds[embed]
		if(isnull(embed_holder)) // but if this one is null we secrewed up
			stack_trace("Embed appearance for [embed] is null in embed interface!")
			viewers[user]["selected"] = null
		else
			embed_holder.add_filter("selected", 1, outline_filter(1, COLOR_YELLOW))

/atom/movable/screen/embed_interface/MouseMove(location, control, params)
	if(isnull(viewers?[usr]?["selected"]))
		return

	var/list/modifiers = params2list(params)
	var/cursor_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/cursor_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	update_effect(cursor_x, cursor_y)

/atom/movable/screen/embed_interface/Click(location, control, params)
	var/list/modifiers = params2list(params)
	var/cursor_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/cursor_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	if(cursor_x > 110 && cursor_y > 150)
		close(usr)
		return

	var/obj/item/clicked = find_clicked_embed(cursor_x, cursor_y)
	if(isnull(clicked))
		return
	if(clicked == viewers[usr]["selected"])
		// to_chat(usr, span_notice("You release [clicked]."))
		set_currently_selected(null, usr)
		return

	set_currently_selected(clicked, usr)
	// var/tool = can_bypass_speed_check(usr)
	// to_chat(usr, span_notice("You grab [clicked][tool ? " with [tool]" : ""]."))
	update_effect(cursor_x, cursor_y)

/atom/movable/screen/embed_interface/proc/damage_limb(obj/item/from_what, multiplier = 1)
	var/datum/embed_data/stats = from_what.get_embed()
	target_limb.owner.sharp_pain(
		target_zones = target_limb.body_zone,
		amount = multiplier * clamp(from_what.w_class * stats.pain_mult * 4, 24, 48) * max(0.5, stats.pain_stam_pct),
		dam_type = BRUTE,
		duration = 20 SECONDS,
		return_mod = 0.5,
	)
	target_limb.receive_damage(
		brute = multiplier * clamp(from_what.w_class * stats.pain_mult * 2, 12, 24) * max(0.5, 1 - stats.pain_stam_pct),
		wound_bonus = max(from_what.wound_bonus, 10),
		sharpness = from_what.get_sharpness(),
		damage_source = from_what,
	)

/atom/movable/screen/embed_interface/proc/update_effect(cursor_x, cursor_y)
	var/last_move_world_time = viewers[usr]["last_move_world_time"]
	var/last_move_x_num = viewers[usr]["last_move_x_num"]
	var/last_move_y_num = viewers[usr]["last_move_y_num"]

	if(!isnull(last_move_x_num) && !isnull(last_move_y_num))
		var/obj/item/currently_selected = viewers[usr]["selected"]
		var/dx = cursor_x - last_move_x_num
		var/dy = cursor_y - last_move_y_num

		var/obj/effect/appearance_clone/embedded_item/embed_holder = tracked_embeds[currently_selected]
		if(isnull(embed_holder))
			stack_trace("Embed appearance for [currently_selected] is null in embed interface!")
			set_currently_selected(null, usr)

		// if you move too fast, it causes damage and drops the embed
		var/time_diff = max(1, world.time - last_move_world_time)
		var/speed = sqrt((dx * dx) + (dy * dy)) / time_diff
		if (speed > embed_holder.max_speed && !viewers[usr]["bypass_fail"])
			// flick("[icon_state]_fast", src)
			icon_state = "[initial(icon_state)]_fast"
			addtimer(VARSET_CALLBACK(src, icon_state, initial(icon_state)), 1 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
			if(embed_holder.remove_progress > 36) // damage is not applied until out of the red zone
				embed_holder.remove_progress *= 0.9
				damage_limb(currently_selected, (COOLDOWN_FINISHED(src, viewers[usr]["last_fail"]) ? 1 : 0.2))
				log_combat(usr, target_limb.owner, "damaged limb by moving embedded object too quickly")
				COOLDOWN_START(src, viewers[usr]["last_fail"], 10 SECONDS)
			set_currently_selected(null, usr)

		else
			embed_holder.remove_progress += dy
			if(embed_holder.remove_progress > 120)
				var/obj/item/tool = GET_REMOVAL_TOOL(usr, target_limb)
				if(tool?.tool_behaviour == TOOL_WIRECUTTER || tool?.get_sharpness())
					damage_limb(currently_selected, 0.5) // you can bypass the speed limit but it still applies a bit of damage
					log_combat(usr, target_limb.owner, "damaged limb by removing embedded object with improvised tool", tool)
				target_limb.owner.remove_embedded_object(currently_selected, usr)
				return

		embed_holder?.pixel_x = clamp(cursor_x - 16, 8, 120)
		embed_holder?.pixel_y = clamp(embed_holder.remove_progress, 0, 180)

	viewers[usr]["last_move_world_time"] = world.time
	viewers[usr]["last_move_x_num"] = cursor_x
	viewers[usr]["last_move_y_num"] = cursor_y

/atom/movable/screen/embed_interface/proc/can_bypass_speed_check(mob/who)
	var/obj/item/holding = GET_REMOVAL_TOOL(who, target_limb)
	return holding?.tool_behaviour == TOOL_HEMOSTAT || holding?.tool_behaviour == TOOL_WIRECUTTER || holding?.get_sharpness()

/atom/movable/screen/embed_interface/proc/find_clicked_embed(x_num, y_num)
	for (var/u_embed_datum, u_embed_holder in tracked_embeds)
		var/obj/effect/appearance_clone/embedded_item/embed_holder = u_embed_holder
		if (x_num > embed_holder.pixel_x + 52 || x_num < embed_holder.pixel_x + 12)
			continue
		if (y_num > embed_holder.pixel_y + 52 || y_num < embed_holder.pixel_y + 12)
			continue
		return u_embed_datum
	return null

#undef GET_REMOVAL_TOOL
