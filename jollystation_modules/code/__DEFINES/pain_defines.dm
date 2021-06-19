// -- Defines for the pain system. --

/// Pained Limp status effect
#define STATUS_EFFECT_LIMP_PAIN /datum/status_effect/limp/pain

/// Sent when a carbon gains pain. (obj/item/bodypart/affected_bodypart, amount)
#define COMSIG_CARBON_PAIN_GAINED "pain_gain"
/// Sent when a carbon loses pain. (obj/item/bodypart/affected_bodypart, amount)
#define COMSIG_CARBON_PAIN_LOST "pain_loss"
/// Add or subtract to a bodypart's pain. (def_zone, amount)
#define COMSIG_CARBON_ADJUST_BODYPART_PAIN "cause_pain"
/// Set bodypart's pain. (def_zone, amount)
#define COMSIG_CARBON_SET_BODYPART_PAIN "set_pain"
/// Add a pain modifier. (key, amount)
#define COMSIG_CARBON_ADD_PAIN_MODIFIER "add_pain_mod"
/// Remove a pain modifier. (key)
#define COMSIG_CARBON_REMOVE_PAIN_MODIFIER "remove_pain_mod"

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

/// ID for paralysis trait gained by pain
#define PAIN_LIMB_PARALYSIS "pain"

#define MIN_DELTA_PAIN -0.5
