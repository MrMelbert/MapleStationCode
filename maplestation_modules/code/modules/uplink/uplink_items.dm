/datum/uplink_item/device_tools/announcement
	category = "Announcements"
	surplus = 0
	refundable = TRUE
	cant_discount = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/device_tools/announcement/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	. = ..()

	var/obj/item/item_announcer/spawned_device = .
	if(istype(spawned_device) && user)
		spawned_device.owner = user

/// -- Modular/additional uplink items --
/datum/uplink_item/device_tools/announcement/fake_ionstorm
	name = "Fake Ion Storm Announcement"
	desc = "Ai, state flaws. A beacon with one use that triggers a fake ion storm, \
		sending the crew clammering to investigate their nearest silicon."
	item = /obj/item/item_announcer/preset/ion
	cost = 4

/datum/uplink_item/device_tools/announcement/fake_radstorm
	name = "Fake Radiation Storm Announcement"
	desc = "Radiation storm! Turn on emergency maint! \
		A beacon with one use that triggers a fake radiation storm, \
		causing mild panic and a mad dash for maintenance. \
		Does not come with warm air."
	item = /obj/item/item_announcer/preset/rad
	cost = 5

/datum/uplink_item/device_tools/announcement/cc_announcement
	name = "\"Central Command\" Announcement"
	desc = "Need some diplomatic immunity to go along side your infiltration? \
		A beacon with one use that sends a fake report from \"Central Command\" \
		written by yours truly (you!). This report can be classified \
		or announced to everyone."
	item = /obj/item/item_announcer/input/centcom
	cost = 12

/datum/uplink_item/device_tools/announcement/syndicate_announcement
	name = "Syndicate Announcement"
	desc = "Forgoing any semblance of stealth and security? Need to make yourself known? \
		A beacon with two uses that sends reports directly from The Syndicate to the station, classified or announced."
	item = /obj/item/item_announcer/input/syndicate
	cost = 8

/datum/uplink_item/device_tools/doorhacker
	name = "Automatic Door Bypasser Card"
	desc = "An alternative to the Airlock Authentication Override Card, this device automatically hacks open \
		an airlock for a short time. Compared to the AAOC, this device does not destroy an airlock's electronics and \
		does not permanently bolt open an airlock. Instead, it takes a short time to hack open a door temporarily, increasing with rapid use. \
		Additionally, the Automatic Door Bypasser is not charge-based, you're only limited on how patient you are - hack the planet!"
	item = /obj/item/card/doorhacker
	cost = 3

/datum/uplink_item/badass/megaphone
	name = "Megaphone"
	desc = "LOUDER VOICE MEANS MORE EVIL!"
	item = /obj/item/megaphone/synd
	cost = 1
