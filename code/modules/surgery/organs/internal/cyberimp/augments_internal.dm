
/obj/item/organ/cyberimp
	name = "cybernetic implant"
	desc = "A state-of-the-art implant that improves a baseline's functionality."

	organ_flags = ORGAN_ROBOTIC
	failing_desc = "seems to be broken."
	var/implant_color = COLOR_WHITE
	var/implant_overlay

/obj/item/organ/cyberimp/New(mob/implanted_mob = null)
	if(iscarbon(implanted_mob))
		src.Insert(implanted_mob)
	if(implant_overlay)
		var/mutable_appearance/overlay = mutable_appearance(icon, implant_overlay)
		overlay.color = implant_color
		add_overlay(overlay)
	return ..()

/obj/item/organ/cyberimp/feel_for_damage(self_aware)
	// No feeling in implants (yet?)
	return ""

//[[[[BRAIN]]]]

/obj/item/organ/cyberimp/brain
	name = "cybernetic brain implant"
	desc = "Injectors of extra sub-routines for the brain."
	zone = BODY_ZONE_HEAD
	w_class = WEIGHT_CLASS_TINY
	/// Duration of stun when hit with worst-case emp
	var/emp_stun_duration = 20 SECONDS
	/// Duration of immobilization when hit with worst-case emp
	var/emp_immobilize_duration = 0 SECONDS

/obj/item/organ/cyberimp/brain/emp_act(severity)
	. = ..()
	if(isnull(owner) || (. & EMP_PROTECT_SELF))
		return
	if(emp_immobilize_duration > 0)
		owner.Immobilize(emp_immobilize_duration / severity)
	if(emp_stun_duration > 0)
		owner.Stun(emp_stun_duration / severity)
		to_chat(owner, span_warning("Your body seizes up!"))

/obj/item/organ/cyberimp/brain/anti_drop
	name = "anti-drop implant"
	desc = "This cybernetic brain implant will allow you to force your hand muscles to contract, preventing item dropping. Twitch ear to toggle."
	icon_state = "brain_implant_antidrop"
	var/active = FALSE
	var/list/stored_items = list()
	slot = ORGAN_SLOT_BRAIN_CEREBELLUM
	actions_types = list(/datum/action/item_action/organ_action/toggle)

/obj/item/organ/cyberimp/brain/anti_drop/ui_action_click()
	active = !active
	if(active)
		var/list/hold_list = owner.get_empty_held_indexes()
		if(LAZYLEN(hold_list) == owner.held_items.len)
			to_chat(owner, span_notice("You are not holding any items, your hands relax..."))
			active = FALSE
			return
		for(var/obj/item/held_item as anything in owner.held_items)
			if(!held_item)
				continue
			stored_items += held_item
			to_chat(owner, span_notice("Your [owner.get_held_index_name(owner.get_held_index_of_item(held_item))]'s grip tightens."))
			ADD_TRAIT(held_item, TRAIT_NODROP, IMPLANT_TRAIT)
			RegisterSignal(held_item, COMSIG_ITEM_DROPPED, PROC_REF(on_held_item_dropped))
	else
		release_items()
		to_chat(owner, span_notice("Your hands relax..."))


/obj/item/organ/cyberimp/brain/anti_drop/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	var/range = severity ? 10 : 5
	var/atom/throw_target
	if(active)
		release_items()
	for(var/obj/item/stored_item as anything in stored_items)
		throw_target = pick(oview(range))
		stored_item.throw_at(throw_target, range, 2)
		to_chat(owner, span_warning("Your [owner.get_held_index_name(owner.get_held_index_of_item(stored_item))] spasms and throws the [stored_item.name]!"))
	stored_items = list()


/obj/item/organ/cyberimp/brain/anti_drop/proc/release_items()
	for(var/obj/item/stored_item as anything in stored_items)
		REMOVE_TRAIT(stored_item, TRAIT_NODROP, IMPLANT_TRAIT)
		UnregisterSignal(stored_item, COMSIG_ITEM_DROPPED)
	stored_items = list()


/obj/item/organ/cyberimp/brain/anti_drop/Remove(mob/living/carbon/implant_owner, special, movement_flags)
	if(active)
		ui_action_click()
	..()

/obj/item/organ/cyberimp/brain/anti_drop/proc/on_held_item_dropped(obj/item/source, mob/user)
	SIGNAL_HANDLER
	REMOVE_TRAIT(source, TRAIT_NODROP, IMPLANT_TRAIT)
	UnregisterSignal(source, COMSIG_ITEM_DROPPED)
	stored_items -= source

/obj/item/organ/cyberimp/brain/anti_stun
	name = "CNS rebooter implant"
	desc = "This implant will automatically give you back control over your central nervous system, reducing downtime when stunned."
	icon_state = "brain_implant_rebooter"
	slot = ORGAN_SLOT_BRAIN_CNS

	var/static/list/signalCache = list(
		COMSIG_LIVING_STATUS_STUN,
		COMSIG_LIVING_STATUS_KNOCKDOWN,
		COMSIG_LIVING_STATUS_IMMOBILIZE,
		COMSIG_LIVING_STATUS_PARALYZE,
	)

	var/stun_cap_amount = 40

/obj/item/organ/cyberimp/brain/anti_stun/on_mob_remove(mob/living/carbon/implant_owner)
	. = ..()
	UnregisterSignal(implant_owner, signalCache)

/obj/item/organ/cyberimp/brain/anti_stun/on_mob_insert(mob/living/carbon/receiver)
	. = ..()
	RegisterSignals(receiver, signalCache, PROC_REF(on_signal))

/obj/item/organ/cyberimp/brain/anti_stun/proc/on_signal(datum/source, amount)
	SIGNAL_HANDLER
	if(!(organ_flags & ORGAN_FAILING) && amount > 0)
		addtimer(CALLBACK(src, PROC_REF(clear_stuns)), stun_cap_amount, TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/item/organ/cyberimp/brain/anti_stun/proc/clear_stuns()
	if(owner || !(organ_flags & ORGAN_FAILING))
		owner.SetStun(0)
		owner.SetKnockdown(0)
		owner.SetImmobilized(0)
		owner.SetParalyzed(0)

/obj/item/organ/cyberimp/brain/anti_stun/emp_act(severity)
	. = ..()
	if((organ_flags & ORGAN_FAILING) || . & EMP_PROTECT_SELF)
		return
	organ_flags |= ORGAN_FAILING
	addtimer(CALLBACK(src, PROC_REF(reboot)), 90 / severity)

/obj/item/organ/cyberimp/brain/anti_stun/proc/reboot()
	organ_flags &= ~ORGAN_FAILING

/obj/item/organ/cyberimp/brain/surgical_processor
	name = "surgical processor implant"
	desc = "A cybernetic brain implant that allows you to perform advanced operations anywhere, anytime."
	icon_state = "brain_implant_antidrop"
	slot = ORGAN_SLOT_BRAIN_HIPPOCAMPUS
	emp_stun_duration = 0 SECONDS
	emp_immobilize_duration = 4 SECONDS
	/// Lazylist of surgeries this implant provides
	var/list/loaded_surgeries

/obj/item/organ/cyberimp/brain/surgical_processor/examine(mob/user)
	. = ..()
	if(length(loaded_surgeries))
		. += span_info("Load surgeries from an operating compuer or a disk containing surgery data. Loaded surgeries:")
		for(var/datum/surgery_operation/downloaded_surgery as anything in GLOB.operations.get_instances_from(loaded_surgeries))
			if(!(downloaded_surgery.operation_flags & OPERATION_LOCKED))
				continue
			// for simplicitly, filters out mechanical subtypes of normal surgeries
			if((downloaded_surgery.operation_flags & OPERATION_MECHANIC) && (downloaded_surgery.parent_type in loaded_surgeries))
				continue
			. += span_info("&bull; [capitalize(downloaded_surgery.rnd_name || downloaded_surgery.name)]")

	else
		. += span_info("Load surgeries from an operating compuer or a disk containing surgery data.")
		. += span_info("No surgeries loaded. Surgeries must be loaded <i>before</i> installation.")

/obj/item/organ/cyberimp/brain/surgical_processor/proc/load_surgeries(mob/living/user, obj/design_holder)
	balloon_alert(user, "copying designs...")
	playsound(src, 'sound/machines/terminal/terminal_processing.ogg', 25, TRUE)
	if(do_after(user, 1 SECONDS, target = design_holder))
		if(istype(design_holder, /obj/item/disk/surgery))
			var/obj/item/disk/surgery/surgery_disk = design_holder
			LAZYOR(loaded_surgeries, surgery_disk.surgeries)
		else
			var/obj/machinery/computer/operating/surgery_computer = design_holder
			LAZYOR(loaded_surgeries, surgery_computer.advanced_surgeries)
		playsound(src, 'sound/machines/terminal/terminal_success.ogg', 25, TRUE)
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/item/organ/cyberimp/brain/surgical_processor/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/item/disk/surgery) || istype(interacting_with, /obj/machinery/computer/operating))
		return load_surgeries(user, interacting_with)
	return NONE

/obj/item/organ/cyberimp/brain/surgical_processor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/disk/surgery))
		return load_surgeries(user, tool)
	return NONE

/obj/item/organ/cyberimp/brain/surgical_processor/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_LIVING_OPERATING_ON, PROC_REF(check_surgery))

/obj/item/organ/cyberimp/brain/surgical_processor/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_LIVING_OPERATING_ON)

/obj/item/organ/cyberimp/brain/surgical_processor/proc/check_surgery(datum/source, mob/living/patient, list/operations)
	SIGNAL_HANDLER

	if(organ_flags & (ORGAN_FAILING|ORGAN_EMP))
		return

	operations |= loaded_surgeries

/obj/item/organ/cyberimp/brain/surgical_processor/emp_act(severity)
	. = ..()
	if(isnull(owner) || (. & EMP_PROTECT_SELF))
		return

	var/obj/item/organ/surgeon_brain = owner.get_organ_by_type(/obj/item/organ/brain)
	surgeon_brain.apply_organ_damage(20 / severity, maximum = 120)


	var/duration = (30 SECONDS) / severity
	if(owner.mob_mood?.mood_modifier > 0)
		// forced insanity - reset to "only a little crazy" after
		owner.mob_mood.set_sanity(SANITY_INSANE)
		addtimer(CALLBACK(owner.mob_mood, TYPE_PROC_REF(/datum/mood, reset_sanity), SANITY_UNSTABLE + 10), duration, TIMER_DELETE_ME)
		// and some moodlets to sell the sanity loss
		owner.add_mood_event("surgery_emp", /datum/mood_event/surgery_emp_active)
		addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living, add_mood_event), "surgery_emp", /datum/mood_event/surgery_emp_expired), duration, TIMER_DELETE_ME)

	// causes the surgeon to go crazy and start stabbing people
	owner.apply_status_effect(/datum/status_effect/forced_combat, duration, (rand(8, 16) / severity))
	to_chat(owner, span_boldwarning("Your surgical processor malfunctions, giving you an overwhelming urge to incise, saw, and stitch!"))

/datum/mood_event/surgery_emp_active
	description = "THE PATIENT WILL NOT SURVIVE UNLESS THE OPERATION IS COMPLETE!"
	mood_change = -90
	timeout = 1 MINUTES
	special_screen_obj = "mood_despair"

/datum/mood_event/surgery_emp_expired
	description = "I lost control - Thankfully it's over now."
	timeout = 5 MINUTES

/obj/item/organ/cyberimp/brain/surgical_processor/pre_loaded
	loaded_surgeries = list(
		/datum/surgery_operation/basic/tend_wounds/combo/upgraded/master,
		/datum/surgery_operation/limb/bioware/cortex_folding,
		/datum/surgery_operation/limb/bioware/cortex_folding/mechanic,
		/datum/surgery_operation/limb/bioware/cortex_imprint,
		/datum/surgery_operation/limb/bioware/cortex_imprint/mechanic,
		/datum/surgery_operation/limb/bioware/ligament_hook,
		/datum/surgery_operation/limb/bioware/ligament_hook/mechanic,
		/datum/surgery_operation/limb/bioware/ligament_reinforcement,
		/datum/surgery_operation/limb/bioware/ligament_reinforcement/mechanic,
		/datum/surgery_operation/limb/bioware/muscled_veins,
		/datum/surgery_operation/limb/bioware/muscled_veins/mechanic,
		/datum/surgery_operation/limb/bioware/nerve_grounding,
		/datum/surgery_operation/limb/bioware/nerve_grounding/mechanic,
		/datum/surgery_operation/limb/bioware/nerve_splicing,
		/datum/surgery_operation/limb/bioware/nerve_splicing/mechanic,
		/datum/surgery_operation/limb/bioware/vein_threading,
		/datum/surgery_operation/limb/bioware/vein_threading/mechanic,
		/datum/surgery_operation/organ/brainwash,
		/datum/surgery_operation/organ/brainwash/mechanic,
		/datum/surgery_operation/organ/pacify,
		/datum/surgery_operation/organ/pacify/mechanic,
	)

//[[[[MOUTH]]]]
/obj/item/organ/cyberimp/mouth
	zone = BODY_ZONE_PRECISE_MOUTH

/obj/item/organ/cyberimp/mouth/breathing_tube
	name = "breathing tube implant"
	desc = "This simple implant adds an internals connector to your back, allowing you to use internals without a mask and protecting you from being choked."
	icon_state = "implant_mask"
	slot = ORGAN_SLOT_BREATHING_TUBE
	w_class = WEIGHT_CLASS_TINY
	organ_traits = list(TRAIT_ASSISTED_BREATHING)

/obj/item/organ/cyberimp/mouth/breathing_tube/emp_act(severity)
	. = ..()
	if(!owner || (. & EMP_PROTECT_SELF))
		return
	if(prob(60 / severity))
		to_chat(owner, span_warning("Your breathing tube suddenly closes!"))
		owner.losebreath += 2

//BOX O' IMPLANTS

/obj/item/storage/box/cyber_implants
	name = "boxed cybernetic implants"
	desc = "A sleek, sturdy box."
	icon_state = "cyber_implants"

/obj/item/storage/box/cyber_implants/PopulateContents()
	new /obj/item/autosurgeon/syndicate/xray_eyes(src)
	new /obj/item/autosurgeon/syndicate/anti_stun(src)
	new /obj/item/autosurgeon/syndicate/reviver(src)
