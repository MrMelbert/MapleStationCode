/// -- Uplink items available to infiltrator uplinks. --
/datum/uplink_item/bundles_tc/cyber_implants/infiltrator
	cost = 24 // This is a veritable waste of money if it is not discounted.
	limited_stock = 1
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/bundles_tc/sniper
	limited_stock = 1
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_INFILTRATOR

/datum/uplink_item/bundles_tc/contract_kit // Sorry, but if you have nuke-ops gear in your uplink, you shouldn't be able to get more tc
	limited_stock = 1
	purchasable_from = UPLINK_TRAITORS

/datum/uplink_item/bundles_tc/bundle_a // Infiltrators should already have an idea/plan, not rely on a random bundle
	limited_stock = 1
	purchasable_from = UPLINK_TRAITORS

/datum/uplink_item/bundles_tc/bundle_b // Same as above
	limited_stock = 1
	purchasable_from = UPLINK_TRAITORS

/datum/uplink_item/bundles_tc/surplus // Same as above
	limited_stock = 1
	purchasable_from = UPLINK_TRAITORS

/datum/uplink_item/dangerous/guardian
	limited_stock = 1
	purchasable_from = UPLINK_TRAITORS

/datum/uplink_item/dangerous/sniper
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_INFILTRATOR

/datum/uplink_item/dangerous/aps/infiltrator
	cost = 12 // APS can be quite stronk so the price is bumped.
	cant_discount = TRUE
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/dangerous/surplus_smg/infiltrator
	cost = 4 // A gun is a gun
	cant_discount = TRUE
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/dangerous/foamsmg
	purchasable_from = ~UPLINK_TRAITORS

/datum/uplink_item/dangerous/foammachinegun
	purchasable_from = ~UPLINK_TRAITORS

/datum/uplink_item/stealthy_weapons/combatglovesplus
	purchasable_from = ~UPLINK_TRAITORS

/datum/uplink_item/stealthy_weapons/cqc/infiltrator // Do I really want to give out CQC for non-ops? Sure
	cost = 20
	cant_discount = TRUE
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/stealthy_weapons/crossbow
	purchasable_from = UPLINK_TRAITORS

/datum/uplink_item/stealthy_weapons/crossbow/infiltrator
	cost = 12
	purchasable_from = UPLINK_INFILTRATOR


/datum/uplink_item/stealthy_weapons/romerol_kit // No romerol, for the love of god
	purchasable_from = ~UPLINK_INFILTRATOR

/datum/uplink_item/ammo/pistolaps
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_INFILTRATOR

/datum/uplink_item/ammo/sniper
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_INFILTRATOR

/datum/uplink_item/ammo/bioterror
	purchasable_from = ~UPLINK_TRAITORS

/datum/uplink_item/ammo/surplus_smg
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_INFILTRATOR

/datum/uplink_item/stealthy_tools/mulligan // No mulligan, you're all in
	purchasable_from = UPLINK_TRAITORS


/datum/uplink_item/suits/hardsuit/elite/infiltrator
	cost = 12 // Elite hardsuit is well armored - costs a bit extra, for infiltrators focusing on combat
	cant_discount = TRUE
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/device_tools/magboots
	purchasable_from = ~UPLINK_TRAITORS


/datum/uplink_item/device_tools/syndie_jaws_of_life
	purchasable_from = ~UPLINK_TRAITORS

/datum/uplink_item/device_tools/failsafe
	purchasable_from = UPLINK_TRAITORS

/datum/uplink_item/device_tools/medkit/infiltrator
	cost = 6 // Combat Defib goes zap, price goes up
	cant_discount = TRUE
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/device_tools/suspiciousphone // Steal money the hard way, don't be lame
	purchasable_from = ~UPLINK_INFILTRATOR

/datum/uplink_item/device_tools/guerillagloves
	purchasable_from = ~UPLINK_TRAITORS

/datum/uplink_item/implants/antistun/infiltrator
	desc = "This implant will help you get back up on your feet faster after being stunned. Comes with an autosurgeon. \
		WARNING: Does not work again stamina crit and stun baton knockdowns."
	cost = 8 // CNS rebooter is baaaad
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/implants/microbomb/infiltrator
	cost = 3
	purchasable_from = UPLINK_INFILTRATOR

/datum/uplink_item/implants/reviver
	purchasable_from = ~UPLINK_TRAITORS

/datum/uplink_item/implants/uplink // Already have an uplink implant
	purchasable_from = ~UPLINK_INFILTRATOR

/datum/uplink_item/role_restricted
	purchasable_from = UPLINK_TRAITORS
