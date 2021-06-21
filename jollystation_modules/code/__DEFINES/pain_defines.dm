// -- Defines for the pain system. --

/// Pained Limp status effect
#define STATUS_EFFECT_LIMP_PAIN /datum/status_effect/limp/pain

/// Sent when a carbon gains pain. (obj/item/bodypart/affected_bodypart, amount)
#define COMSIG_CARBON_PAIN_GAINED "pain_gain"
/// Sent when a carbon loses pain. (obj/item/bodypart/affected_bodypart, amount)
#define COMSIG_CARBON_PAIN_LOST "pain_loss"

/// List of all body zones affected by pain. (Which is all body zones...)
#define BODY_ZONES_ALL list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

/// List of some emotes that convey pain.
#define PAIN_EMOTES list("wince", "gasp", "grimace", "shiver", "sway", "twitch_s", "whimper")

/// Amount of pain gained from dismembered limb
#define PAIN_LIMB_DISMEMBERED 45
/// Amount of pain gained from surgically removed limb
#define PAIN_LIMB_REMOVED 10

/// Keys for pain modifiers
#define PAIN_MOD_CHEMS "chems"
#define PAIN_MOD_DRUNK "drunk"
#define PAIN_MOD_SLEEP "asleep"
#define PAIN_MOD_STASIS "stasis"
#define PAIN_MOD_DROWSY "drowsy"
#define PAIN_MOD_NEAR_DEATH "near-death"

/// ID for traits and modifiers gained by pain
#define PAIN_LIMB_PARALYSIS "pain_paralysis"
#define MOVESPEED_ID_PAIN "pain_movespeed"
#define ACTIONSPEED_ID_PAIN "pain_actionspeed"
