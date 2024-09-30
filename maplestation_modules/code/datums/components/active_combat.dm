/*
 * Active Combat component
 * Allows weapons its attached to to perform active blocking/evading/parrying
 * Timing the parry perfectly can cause additional effects, such as shoving the opponent or retaliating in melee
 */

/datum/keybinding/living/active_combat
	hotkey_keys = list("N")
	name = "active_combat"
	full_name = "Active Parry"
	description = "Press to attempt to block/parry."
	keybind_signal = COMSIG_LIVING_ACTIVE_BLOCK_KEYBIND

/datum/component/active_combat
	/// Flags which this item (if parent is an item) needs to be in to be able to parry
	var/inventory_flags = ITEM_SLOT_HANDS

	/// Decides which directions you can block from
	var/block_directions = ACTIVE_COMBAT_FACING

	// These dictate the animation, kinda
	/// How long does it take for parry to become active
	var/windup_timer = 0.2 SECONDS
	/// Window during which you can parry. Includes perfect parrying window, after which the effects start to diminish
	var/parry_window = 0.75 SECONDS
	/// Window during the parry is "perfect"
	var/perfect_parry_window = 0.25 SECONDS

	/// Effects applied after parrying a hit
	var/list/parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE)
	/// Alternative list of effects for perfect parrying. If null, falls back to parry_effects
	var/list/perfect_parry_effects = null
	/// Effects used on self upon missing a parry
	var/list/parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 5)

	/// Multiplier for converting damage into stamina damage
	var/stamina_multiplier = 0.5
	/// Multiplier for stamina damage for a perfect parry
	var/perfect_stamina_multiplier = 0.33

	/// How much damage (in percentage) is blocked by a perfect parry
	/// If block_barrier or higher, hit is negated completely
	var/damage_blocked = 1
	/// How much damage block is lost by the end of the parry window
	var/damage_block_imperfect_loss = 0.5
	/// Maximum amount of damage to be blocked from a single hit
	var/maximum_damage_blocked = 25

	/// How efficient the block has to be to fully block an attack
	var/block_barrier = 1
	/// Overrides for block_barrier for different attack types
	var/list/block_barrier_overrides = list()

	/// For how long user's clicks are blocked after failing a parry
	var/parry_miss_cooldown = 0.4 SECONDS

	/// Icon used by VFX
	var/icon_state = "block"
	/// Color used by VFX
	var/effect_color = "#5EB4FF"

	/// Window multiplier for projectiles. Set to 0 to disable projectile blocking/parrying
	var/projectile_window_multiplier = 0

	/// Callback to determine valid parries
	var/datum/callback/parry_callback
	/// Callback that is called upon a successful parry
	var/datum/callback/success_callback

	// Internal variables
	/// Last time the user pressed the parry keybind
	var/last_keypress = 0
	/// Current state
	var/state = ACTIVE_COMBAT_INACTIVE
	/// Timer for failing the parry
	var/parry_fail_timer
	/// Tick during which we parried last time
	var/parry_tick = 0
	/// How much damage to negate off the next hit *this tick*
	var/damage_negation_mult = 1
	/// Current user
	var/mob/living/carbon/cur_user
	/// VFX
	var/obj/effect/temp_visual/active_combat/visual_effect

/datum/component/active_combat/Initialize(inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.2 SECONDS, \
		parry_window = 0.75 SECONDS, perfect_parry_window = 0.25 SECONDS, parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE), perfect_parry_effects = null, \
		parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
		stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1, damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 25, \
		block_barrier = 1, block_barrier_overrides = list(), parry_miss_cooldown = 0.4 SECONDS, icon_state = "block", effect_color = "#5EB4FF", \
		projectile_window_multiplier = 0, parry_callback, success_callback)

	if(!iscarbon(parent) && !isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.inventory_flags = inventory_flags
	src.block_directions = block_directions
	src.windup_timer = windup_timer
	src.parry_window = parry_window
	src.perfect_parry_window = perfect_parry_window
	src.parry_effects = parry_effects
	src.perfect_parry_effects = perfect_parry_effects
	src.parry_miss_effects = parry_miss_effects
	src.stamina_multiplier = stamina_multiplier
	src.perfect_stamina_multiplier = perfect_stamina_multiplier
	src.damage_blocked = damage_blocked
	src.damage_block_imperfect_loss = damage_block_imperfect_loss
	src.maximum_damage_blocked = maximum_damage_blocked
	src.block_barrier = block_barrier
	src.block_barrier_overrides = block_barrier_overrides
	src.parry_miss_cooldown = parry_miss_cooldown
	src.icon_state = icon_state
	src.effect_color = effect_color
	src.projectile_window_multiplier = projectile_window_multiplier
	src.parry_callback = parry_callback
	src.success_callback = success_callback

/datum/component/active_combat/RegisterWithParent()
	if (ismob(parent))
		register_to_mob(parent)
		RegisterSignal(parent, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))
		return

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_ITEM_HIT_REACT, PROC_REF(on_hit_react))

/datum/component/active_combat/UnregisterFromParent()
	if (ismob(parent))
		unregister_mob(parent)
		UnregisterSignal(parent, COMSIG_LIVING_CHECK_BLOCK)
		return

	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_ITEM_HIT_REACT))

/datum/component/active_combat/proc/on_equip(atom/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!(inventory_flags & slot))
		unregister_mob(equipper)
		return

	register_to_mob(equipper)

/datum/component/active_combat/proc/on_drop(atom/source, mob/user)
	SIGNAL_HANDLER
	unregister_mob(user)

/datum/component/active_combat/proc/register_to_mob(mob/living/carbon/user)
	last_keypress = 0
	state = ACTIVE_COMBAT_INACTIVE
	cur_user = user
	RegisterSignal(user, COMSIG_LIVING_ACTIVE_BLOCK_KEYBIND, PROC_REF(on_keybind))
	RegisterSignal(user, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(modify_damage))

/datum/component/active_combat/proc/unregister_mob(mob/living/carbon/user)
	UnregisterSignal(user, list(COMSIG_LIVING_ACTIVE_BLOCK_KEYBIND, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS))
	cur_user = null
	last_keypress = 0
	state = ACTIVE_COMBAT_INACTIVE
	user.remove_movespeed_modifier(/datum/movespeed_modifier/active_combat)
	if (!isnull(parry_fail_timer))
		deltimer(parry_fail_timer)
	STOP_PROCESSING(SSfastprocess, src)

/datum/component/active_combat/proc/on_keybind(mob/living/carbon/source)
	SIGNAL_HANDLER

	if (state != ACTIVE_COMBAT_INACTIVE)
		to_chat(source, span_warning("You cannot do this right now!"))
		return

	if(source.get_timed_status_effect_duration(/datum/status_effect/staggered))
		to_chat(source, span_warning("You're too off balance to parry!"))
		return

	last_keypress = world.time
	state = ACTIVE_COMBAT_PREPARED
	parry_fail_timer = addtimer(CALLBACK(src, PROC_REF(failed_parry)), parry_window, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	START_PROCESSING(SSfastprocess, src)
	source.changeNext_move(windup_timer + parry_window)
	playsound(source, 'maplestation_modules/sound/sfx-parry.ogg', 120, TRUE)
	visual_effect = new(source, icon_state, windup_timer + parry_window, windup_timer)
	source.add_movespeed_modifier(/datum/movespeed_modifier/active_combat)

	if (!isnull(source.client))
		source.face_atom(SSmouse_entered.sustained_hovers[source.client])

/datum/component/active_combat/process()
	if (!isnull(cur_user.client))
		cur_user.face_atom(SSmouse_entered.sustained_hovers[cur_user.client])

/datum/component/active_combat/proc/on_hit_react(obj/item/source, mob/living/carbon/owner, atom/movable/hitby, attack_text, final_block_chance, damage, attack_type, damage_type)
	SIGNAL_HANDLER

	if (last_keypress + windup_timer + parry_window * (isprojectile(hitby) ? projectile_window_multiplier : 1) < world.time || state != ACTIVE_COMBAT_PREPARED)
		return

	var/parry_return = run_parry(owner, source, hitby, damage, attack_type, damage_type)

	if (!parry_return)
		return

	if (!(parry_return & PARRY_RETALIATE))
		playsound(src, source.block_sound, BLOCK_SOUND_VOLUME, TRUE)

	if (parry_return & PARRY_FULL_BLOCK)
		owner.visible_message(span_danger("[owner] [(parry_return & PARRY_RETALIATE) ? "parries" : "blocks"] [attack_text] with [source]!"))
		return COMPONENT_HIT_REACTION_BLOCK

/datum/component/active_combat/proc/run_parry(mob/living/carbon/user, atom/source, atom/movable/hitby, damage, attack_type, damage_type)
	if (last_keypress + windup_timer > world.time)
		failed_parry(TRUE)
		return PARRY_FAILURE

	if (!isnull(user.client))
		user.face_atom(SSmouse_entered.sustained_hovers[user.client]) // In case SSfastprocess didn't tick yet and we moved last tick

	if (block_directions == ACTIVE_COMBAT_CARDINAL_FACING)
		if (user.dir != get_dir(user, hitby))
			failed_parry() // You eat shit if you get backstabbed while parrying
			return PARRY_FAILURE
	else if (block_directions == ACTIVE_COMBAT_FACING)
		if (!(user.dir & get_dir(user, hitby)))
			failed_parry()
			return PARRY_FAILURE

	if (!isnull(parry_callback) && !parry_callback.Invoke(hitby))
		failed_parry(TRUE)
		return PARRY_FAILURE

	var/window_mult = isprojectile(hitby) ? projectile_window_multiplier : 1
	var/is_perfect = last_keypress + windup_timer + perfect_parry_window * window_mult > world.time
	var/parry_loss = (world.time - (last_keypress + windup_timer + perfect_parry_window * window_mult)) / ((parry_window - perfect_parry_window) * window_mult)
	parry_tick = world.time
	last_keypress = 0
	state = ACTIVE_COMBAT_INACTIVE
	if (!isnull(parry_fail_timer))
		deltimer(parry_fail_timer)
	STOP_PROCESSING(SSfastprocess, src)
	user.changeNext_move(0)
	user.remove_movespeed_modifier(/datum/movespeed_modifier/active_combat)

	var/list/effects = is_perfect && !isnull(perfect_parry_effects) ? perfect_parry_effects : parry_effects
	var/damage_negation = is_perfect ? damage_blocked : (damage_blocked - parry_loss * damage_block_imperfect_loss)
	var/effect_mult = clamp(damage_negation, 0, 1)
	var/barrier = (attack_type in block_barrier_overrides) ? block_barrier_overrides[attack_type] : block_barrier
	var/turf/user_turf = get_turf(user)

	damage_negation_mult = (damage <= maximum_damage_blocked) ? clamp(1 - damage_negation, 0, 1) : (1 - (maximum_damage_blocked * clamp(damage_negation, 0, 1)) / damage)

	var/atom/movable/hitter = hitby
	var/parry_flags = PARRY_SUCCESS
	var/use_rush_effect = FALSE

	if (isprojectile(hitby))
		var/obj/projectile/hit_proj = hitby
		if (!isnull(hit_proj.firer))
			hitter = hit_proj.firer

		if (LAZYACCESS(effects, ACTIVE_COMBAT_REFLECT_PROJECTILE))
			hit_proj.firer = user
			hit_proj.set_angle(get_angle(user, hitter))
			damage_negation_mult = barrier

	if (LAZYACCESS(effects, ACTIVE_COMBAT_PARRY) && !isprojectile(hitter))
		playsound(user, 'sound/weapons/parry.ogg', BLOCK_SOUND_VOLUME, TRUE)
		parry_flags |= PARRY_RETALIATE
		INVOKE_ASYNC(src, PROC_REF(retaliate), user, source, hitter, effects)
		use_rush_effect = TRUE

	if (LAZYACCESS(effects, ACTIVE_COMBAT_EVADE))
		var/dir_attempts = prob(50) ? list(90, 270, 180) : list(270, 90, 180)
		for (var/dir_attempt in dir_attempts)
			if (user.Move(get_step(user, turn(user.dir, dir_attempt))))
				if (isprojectile(hitby))
					damage_negation_mult = barrier
				user.visible_message(span_warning("[user] weaves out of [hitby]'s way!"), span_notice("You weave out of [hitby]'s way!"))
				if (LAZYACCESS(effects, ACTIVE_COMBAT_EVADE) > 1)
					for (var/evade_count in 1 to (LAZYACCESS(effects, ACTIVE_COMBAT_EVADE) - 1))
						if (!user.Move(get_step(user, turn(user.dir, dir_attempt))))
							break
				break

	if (LAZYACCESS(effects, ACTIVE_COMBAT_EMOTE))
		INVOKE_ASYNC(user, TYPE_PROC_REF(/mob, emote), LAZYACCESS(effects, ACTIVE_COMBAT_EMOTE))

	if (isliving(hitter) && user.CanReach(hitter))
		var/mob/living/victim = hitter

		if (LAZYACCESS(effects, ACTIVE_COMBAT_SHOVE))
			user.disarm(victim, source)
			use_rush_effect = TRUE

		if (LAZYACCESS(effects, ACTIVE_COMBAT_KNOCKDOWN))
			victim.Knockdown(LAZYACCESS(effects, ACTIVE_COMBAT_KNOCKDOWN) * effect_mult)
			use_rush_effect = TRUE

		if (LAZYACCESS(effects, ACTIVE_COMBAT_STAGGER))
			victim.adjust_staggered_up_to(LAZYACCESS(effects, ACTIVE_COMBAT_STAGGER) * effect_mult, 10 SECONDS)
			use_rush_effect = TRUE

		if (LAZYACCESS(effects, ACTIVE_COMBAT_STAMINA))
			victim.apply_damage(LAZYACCESS(effects, ACTIVE_COMBAT_STAMINA) * effect_mult, STAMINA)
			use_rush_effect = TRUE

	if (is_perfect)
		visual_effect.add_filter("perfect_parry", 2, list("type" = "outline", "color" = "#ffffffAF", "size" = 2))
	if (use_rush_effect)
		visual_effect.rush_at(hitter)
	else
		visual_effect.fadeout()

	user.apply_damage(damage * (is_perfect ? perfect_stamina_multiplier : stamina_multiplier), STAMINA) // ngl itd be funny if you got stamcritted from parrying a meteor
	if (damage_negation >= barrier && !LAZYACCESS(effects, ACTIVE_COMBAT_FORCED_DAMAGE))
		parry_flags |= PARRY_FULL_BLOCK
	if (!isnull(success_callback))
		success_callback.Invoke(user, source, hitby, hitter, is_perfect, parry_loss, effect_mult, user_turf, parry_flags)
	return parry_flags

/datum/component/active_combat/proc/failed_parry(harmless = FALSE)
	last_keypress = 0
	state = ACTIVE_COMBAT_RECOVERING
	STOP_PROCESSING(SSfastprocess, src)
	cur_user.changeNext_move(parry_miss_cooldown)
	addtimer(CALLBACK(src, PROC_REF(recover_parry)), parry_miss_cooldown)
	cur_user.remove_movespeed_modifier(/datum/movespeed_modifier/active_combat)

	if (harmless)
		return

	if (LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_EMOTE))
		INVOKE_ASYNC(cur_user, TYPE_PROC_REF(/mob, emote), LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_EMOTE))

	if (LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_KNOCKDOWN))
		cur_user.Knockdown(LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_KNOCKDOWN))

	if (LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_STAGGER))
		cur_user.adjust_staggered_up_to(LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_STAGGER), 10 SECONDS)

	if (LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_STAMINA))
		cur_user.apply_damage(LAZYACCESS(parry_miss_effects, ACTIVE_COMBAT_STAMINA), STAMINA)

/datum/component/active_combat/proc/retaliate(mob/living/carbon/user, atom/source, atom/movable/hitter, list/effects)
	var/held_index = null
	var/old_force = null
	if (isitem(source))
		var/obj/item/source_item = source
		if (source != user.get_active_held_item())
			held_index = user.active_hand_index
			user.swap_hand(user.get_held_index_of_item(source))
		old_force = source_item.force
		source_item.force *= LAZYACCESS(effects, ACTIVE_COMBAT_PARRY)

	user.ClickOn(hitter)

	if (!isnull(held_index))
		user.swap_hand(held_index)

	if (!isnull(old_force))
		var/obj/item/source_item = source
		source_item.force = old_force

/datum/component/active_combat/proc/recover_parry()
	state = ACTIVE_COMBAT_INACTIVE

/datum/component/active_combat/proc/modify_damage(mob/living/carbon/human/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	if (parry_tick == world.time)
		damage_mods += damage_negation_mult
		parry_tick = 0

/datum/component/active_combat/proc/check_block(mob/living/carbon/source, atom/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, attack_flag)
	SIGNAL_HANDLER

	if (last_keypress + windup_timer + parry_window * (isprojectile(hitby) ? projectile_window_multiplier : 1) < world.time || state != ACTIVE_COMBAT_PREPARED)
		return

	var/parry_return = run_parry(source, null, hitby, damage, attack_type, damage_type)

	if (parry_return & PARRY_FULL_BLOCK)
		source.visible_message(span_danger("[source] [(parry_return & PARRY_RETALIATE) ? "parries" : "blocks"] [attack_text]!"))
		return COMPONENT_HIT_REACTION_BLOCK

/obj/effect/temp_visual/active_combat
	name = "blocking glow"
	icon = 'maplestation_modules/icons/effects/defense_indicators.dmi'
	icon_state = "block"
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/active_combat/Initialize(mapload, icon_state, max_duration, warmup)
	. = ..()
	var/atom/movable/owner = loc
	owner.vis_contents += src
	src.icon_state = icon_state
	pixel_y = -12
	update_appearance()
	var/matrix/nmatrix = matrix()
	nmatrix.Scale(0.2, 0.2)
	transform = nmatrix
	animate(src, transform = matrix(), pixel_y = 0, time = warmup, easing = SINE_EASING|EASE_IN)
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, PROC_REF(fadeout)), max_duration, TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/effect/temp_visual/active_combat/proc/fadeout()
	var/matrix/nmatrix = matrix()
	nmatrix.Scale(2, 2)
	animate(src, transform = nmatrix, alpha = 0, time = 0.3 SECONDS, easing = SINE_EASING|EASE_OUT)
	if (timerid)
		deltimer(timerid)
	timerid = QDEL_IN_STOPPABLE(src, 0.3 SECONDS)

/obj/effect/temp_visual/active_combat/proc/rush_at(atom/movable/target)
	var/atom/movable/owner = loc
	animate(src, pixel_x = sin(get_angle(owner, target)) * world.icon_size * get_dist(owner, target) * 1.5, pixel_y = cos(get_angle(owner, target)) * world.icon_size * get_dist(owner, target) * 1.5, alpha = 0, time = 0.5 SECONDS)
	if (timerid)
		deltimer(timerid)
	timerid = QDEL_IN_STOPPABLE(src, 0.5 SECONDS)

/datum/movespeed_modifier/active_combat
	multiplicative_slowdown = 0.5
