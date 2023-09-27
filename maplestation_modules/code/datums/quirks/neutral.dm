// --Adds the neutral quirk to start with TDATET cards and a binder to quickly play a game and store said cards.
/datum/quirk/item_quirk/cardcollector
	name = "Card Collector"
	desc = "You carry your personal card binder and fresh packs of unopened cards, it's time to duel!"
	icon = FA_ICON_DIAMOND
	value = 0
	mob_trait = TRAIT_CARDCOLLECTOR //The only instance of this being used is for an examine more of the TdateT packs for a single line of text, I may use this to show rarity rates or other silly things someone that likes cards would notice.
	gain_text = "<span class='notice'>You trust in the heart of the cards.</span>"
	lose_text = "<span class='danger'>You forget what these funny bookmarks used to be.</span>"
	medical_record_text = "Patient mentions their card collection as a stress-relieving hobby."
	//A chance to get a cardpack for tdatet in the mail.
	mail_goodies = list(
		/obj/item/cardpack/tdatet,
		/obj/item/cardpack/tdatet/green,
		/obj/item/cardpack/tdatet/blue,
		/obj/item/cardpack/tdatet/mixed,
		/obj/item/cardpack/tdatet_box,
	)

/datum/quirk/item_quirk/cardcollector/add_unique()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/storage/card_binder/personal/card_binder = new(get_turf(human_holder))
	/*Will be commented out until someone figures out persistence, which is unlikely but this will stay here just incase!
	card_binder.persistence_id = "personal_[human_holder.last_mind?.key]" // this is a persistent binder, the ID is tied to the account's key to avoid tampering, just like the Photo album.
	card_binder.persistence_load() */
	card_binder.name = "[human_holder.real_name]'s card binder"
	//Will add named cardbinder, starting base 2 cards, packbox of 28 Red cards, 4 counters, and a paper with rules. Now in a handy box!
	give_item_to_holder(card_binder, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(/obj/item/storage/box/tdatet_starter, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/stowaway
	name = "Stowaway"
	desc = "You're a stowaway - You spawn randomly in maintenance without a PDA, ID or bank account, and with no records to or of your name. \
		This quirk only works for roundstart assistants!"
	icon = FA_ICON_PERSON_THROUGH_WINDOW
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY
	/// List of random starting things dumped in their backpack to help
	var/static/list/starting_items = list(
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/stack/spacecash/c100,
	)
	/// Message sent when they gain the quirk first
	var/add_message

/datum/quirk/stowaway/add_unique(client/client_source)
	if(SSticker.current_state != GAME_STATE_SETTING_UP)
		return
	if(!istype(quirk_holder.mind?.assigned_role, /datum/job/assistant))
		add_message = examine_block("\
			[span_warning("You are not an assistant, so you did not stowaway.")]\
		")
		return

	var/mob/living/carbon/human/stowaway = quirk_holder
	var/obj/item/card/id/old_id = stowaway.wear_id?.GetID()
	// set them to unassigned, so they don't appear on the manifest
	stowaway.mind.set_assigned_role(SSjob.GetJobType(/datum/job/stowaway))

	// get rid of their bank account
	QDEL_NULL(old_id?.registered_account)
	// get rid of any memory that their bank account existed
	var/datum/memory/account_memory = quirk_holder.mind.memories[/datum/memory/key/account]
	quirk_holder.mind.memories -= /datum/memory/key/account
	qdel(account_memory)
	// get rid of their old ID
	qdel(old_id)

	// get rid of their PDA, too advanced
	var/obj/item/modular_computer/pda/pda = locate() in stowaway
	qdel(pda)
	// get rid of that headset too
	var/obj/item/radio/headset/radio = locate() in stowaway
	qdel(radio)

	// give them a replacement maintenance tech ID, with just maint access
	var/obj/item/card/id/maint_tech/replacement = new(stowaway)
	replacement.registered_age = rand(25, 65)
	stowaway.equip_to_slot(replacement, ITEM_SLOT_ID, TRUE)

	// starting items
	for(var/thing in starting_items)
		stowaway.equip_to_slot(new thing(stowaway), ITEM_SLOT_BACKPACK, TRUE)

	// give them some tools, just incase they get stuck somewhere
	var/obj/item/storage/toolbox/mechanical/old/toolbox = new(stowaway)
	new /obj/item/multitool(toolbox)
	stowaway.put_in_inactive_hand(toolbox)

	// finally: dump them in maint
	var/turf/spawn_loc = find_maintenance_spawn(atmos_sensitive = TRUE)
	if(isnull(spawn_loc))
		add_message = examine_block("\
			[span_warning("You could not find a suitable place to stowaway in maintenance.")]\
		")
	else
		stowaway.forceMove(spawn_loc)
		add_message = examine_block("\
			[span_boldnotice("You find yourself stown away somewhere in [get_area_name(spawn_loc, TRUE)] on board [station_name()].")]\n\
			[span_notice("The station has no record of your existence.")]\n\
			[span_notice("All you have to your name is the clothes on your back, an old maintenance technician's ID card, tools, and some pocket change.")]\
		")

/datum/quirk/stowaway/post_add()
	if(!add_message)
		return

	to_chat(quirk_holder, add_message)
	add_message = null

/obj/item/card/id/maint_tech
	name = "Maintenance Technician ID"
	desc = "An old ID card once given to poorly paid technicians."
	trim = /datum/id_trim/maintenance_technician
	icon_state = "retro"

/datum/id_trim/maintenance_technician
	access = list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MAINT_TUNNELS)
	assignment = "Maintenance Technician"
	trim_state = "trim_stationengineer"
	department_color = COLOR_ASSISTANT_GRAY

/datum/job/stowaway
	title = "Stowaway"
	rpg_title = "Stowaway" // TES4: Oblivion
	paycheck = PAYCHECK_ZERO
