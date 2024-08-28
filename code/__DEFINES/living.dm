// living_flags
/// Simple mob trait, indicating it may follow continuous move actions controlled by code instead of by user input.
#define MOVES_ON_ITS_OWN (1<<0)

// NON-MODULE CHANGE
// Sticking these here for now because i'm dumb

/// Updating a mob's movespeed when lacking limbs. (list/modifiers)
#define COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE "living_get_movespeed_modifiers"

// -- Defines for the pain system. --

/// Sent when a carbon gains pain. (source = mob/living/carbon/human, obj/item/bodypart/affected_bodypart, amount, type)
#define COMSIG_CARBON_PAIN_GAINED "pain_gain"
/// Sent when a carbon loses pain. (source = mob/living/carbon/human, obj/item/bodypart/affected_bodypart, amount, type)
#define COMSIG_CARBON_PAIN_LOST "pain_loss"
/// Sent when a temperature pack runs out of juice. (source = obj/item/temperature_pack)
#define COMSIG_TEMPERATURE_PACK_EXPIRED "temp_pack_expired"

#define COMSIG_HUMAN_ON_HANDLE_BLOOD "human_on_handle_blood"
	#define HANDLE_BLOOD_HANDLED (1<<0)
	#define HANDLE_BLOOD_NO_NUTRITION_DRAIN (1<<1)
	#define HANDLE_BLOOD_NO_EFFECTS (1<<2)

/// Various lists of body zones affected by pain.
#define BODY_ZONES_ALL list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
#define BODY_ZONES_MINUS_HEAD list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
#define BODY_ZONES_LIMBS list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
#define BODY_ZONES_MINUS_CHEST list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

/// List of some emotes that convey pain.
#define PAIN_EMOTES list("wince", "gasp", "grimace", "shiver", "sway", "twitch_s", "whimper", "inhale_s", "exhale_s", "groan")

/// Amount of pain gained (to chest) from dismembered limb
#define PAIN_LIMB_DISMEMBERED 90
/// Amount of pain gained (to chest) from surgically removed limb
#define PAIN_LIMB_REMOVED 30

/// Soft max pains for bodyparts, adds up to 500
#define PAIN_LIMB_MAX 70
#define PAIN_CHEST_MAX 120
#define PAIN_HEAD_MAX 100

// Keys for pain modifiers
#define PAIN_MOD_CHEMS "chems"
#define PAIN_MOD_LYING "lying"
#define PAIN_MOD_NEAR_DEATH "near-death"
#define PAIN_MOD_KOD "ko-d"
#define PAIN_MOD_RECENT_SHOCK "recently-shocked"
#define PAIN_MOD_QUIRK "quirk"
#define PAIN_MOD_SPECIES "species"
#define PAIN_MOD_OFF_STATION "off-station-pain-resistance"

// ID for traits and modifiers gained by pain
#define PAIN_LIMB_PARALYSIS "pain_paralysis"
#define MOVESPEED_ID_PAIN "pain_movespeed"
#define ACTIONSPEED_ID_PAIN "pain_actionspeed"

/// If the mob enters shock, they will have +1 cure condition (helps cure it faster)
#define TRAIT_ABATES_SHOCK "shock_abated"
/// Pain effects, such as stuttering or feedback messages ("Everything hurts") are disabled.
#define TRAIT_NO_PAIN_EFFECTS "no_pain_effects"
/// Shock buildup does not increase, only decrease. No effect if already in shock (unlike abates_shock)
#define TRAIT_NO_SHOCK_BUILDUP "no_shock_buildup"
/// Don't get slowed down by aggro grabbing (or above)
#define TRAIT_NO_GRAB_SPEED_PENALTY "no_grab_speed_penalty"
/// Doesn't let a mob shift this atom around with move_pulled
#define TRAIT_NO_MOVE_PULL "no_move_pull"
/// Mob does not homeostasize body temperature
#define TRAIT_COLD_BLOODED "cold_blooded"

/// The trait that determines if someone has the robotic limb reattachment quirk.
#define TRAIT_ROBOTIC_LIMBATTACHMENT "trait_robotic_limbattachment"

/// Mob can walk despite having two disabled/missing legs so long as they have two of this trait.
/// Kind of jank, refactor at a later day when I can think of a better solution.
/// Just be sure to call update_limbless_locomotion() after applying / removal
#define TRAIT_NO_LEG_AID "no_leg_aid"

#define COLOR_BLOOD "#c90000"

// Used in ready menu anominity
/// Hide ckey
#define CKEY_ANON (1<<0)
/// Hide character name
#define NAME_ANON (1<<1)
/// Hide top job preference
#define JOB_ANON (1<<2)
