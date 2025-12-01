// living_flags
/// Simple mob trait, indicating it may follow continuous move actions controlled by code instead of by user input.
#define MOVES_ON_ITS_OWN (1<<0)
/// Always does *deathgasp when they die
/// If unset mobs will only deathgasp if supplied a death sound or custom death message
#define ALWAYS_DEATHGASP (1<<1)
/// Nutrition changed last life tick, so we should bulk update this tick
#define QUEUE_NUTRITION_UPDATE (1<<3)

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
#define COMSIG_LIVING_BODY_TEMPERATURE_CHANGE "living_body_temperature_change"

#define COMSIG_LIVING_HOMEOSTASIS "living_homeostasis"
	/// Return to do no homeostasis at all
	#define HOMEOSTASIS_HANDLED (1<<0)
	/// Return to not reduce hunger at all
	#define HOMEOSTASIS_NO_HUNGER (1<<1)

//from base of living/set_pull_offset(): (mob/living/pull_target, grab_state)
#define COMSIG_LIVING_SET_PULL_OFFSET "living_set_pull_offset"
//from base of living/reset_pull_offsets(): (mob/living/pull_target, override)
#define COMSIG_LIVING_RESET_PULL_OFFSETS "living_reset_pull_offsets"
//from base of living/CanAllowThrough(): (atom/movable/mover, border_dir)
#define COMSIG_LIVING_CAN_ALLOW_THROUGH "living_can_allow_through"
	#define COMPONENT_LIVING_PASSABLE (1<<0)

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

// Defines for pain (and shock) gained by surgery
#define SURGERY_PAIN_TRIVIAL 6
#define SURGERY_PAIN_LOW 12
#define SURGERY_PAIN_MEDIUM 18
#define SURGERY_PAIN_HIGH 24
#define SURGERY_PAIN_SEVERE 36
#define SURGERY_PAIN_CRITICAL 48

/// Cap on shock level
#define MAX_TRAUMATIC_SHOCK 200
/// Hard cap on pain level
#define MAX_LIMB_PAIN 300

/// Checks if a mob can feel pain.
#define CAN_FEEL_PAIN(mob) (mob?.stat <= SOFT_CRIT && mob?.pain_controller?.pain_modifier > 0.33)

// Keys for pain modifiers
#define PAIN_MOD_CHEMS "chems"
#define PAIN_MOD_NEAR_DEATH "near-death"
#define PAIN_MOD_KOD "ko-d"
#define PAIN_MOD_RECENT_SHOCK "recently-shocked"
#define PAIN_MOD_QUIRK "quirk"
#define PAIN_MOD_SPECIES "species"
#define PAIN_MOD_OFF_STATION "off-station-pain-resistance"
#define PAIN_MOD_STATUS_EFFECT "status_effect"

// ID for traits and modifiers gained by pain
#define PAIN_LIMB_PARALYSIS "pain_paralysis"
#define MOVESPEED_ID_PAIN "pain_movespeed"
#define ACTIONSPEED_ID_PAIN "pain_actionspeed"

/// If the mob enters shock, they will have +1 cure condition (helps cure it faster)
#define TRAIT_ABATES_SHOCK "shock_abated"
/// All this trait does is change your stat to soft crit, which itself doesn't do much,
/// but as your stat is changed many stat checks will block you (such as using the radio)
#define TRAIT_SOFT_CRIT "soft_crit"
/// Skip a breath once in every x breaths (where x is ticks between breaths)
#define TRAIT_LABOURED_BREATHING "laboured_breathing"
/// Blocks losebreath from accumulating from things such as heart attacks or choking
#define TRAIT_ASSISTED_BREATHING "assisted_breathing"
/// Stops organs from decaying while dead
#define TRAIT_NO_ORGAN_DECAY "no_organ_decay"
/// Don't get slowed down by aggro grabbing (or above)
#define TRAIT_NO_GRAB_SPEED_PENALTY "no_grab_speed_penalty"
/// Doesn't let a mob shift this atom around with move_pulled
#define TRAIT_NO_MOVE_PULL "no_move_pull"

/// Boosts the heart rate of the mob
#define TRAIT_HEART_RATE_BOOST "heart_rate_boost"
/// Slows the heart rate of the mob
#define TRAIT_HEART_RATE_SLOW "heart_rate_slow"

/// The trait that determines if someone has the robotic limb reattachment quirk.
#define TRAIT_ROBOTIC_LIMBATTACHMENT "trait_robotic_limbattachment"

/// Mob can walk despite having two disabled/missing legs so long as they have two of this trait.
/// Kind of jank, refactor at a later day when I can think of a better solution.
/// Just be sure to call update_limbless_locomotion() after applying / removal
#define TRAIT_NO_LEG_AID "no_leg_aid"

#define COLOR_BLOOD "#c90000"

/// Checks if the value is "left"
/// Used primarily for hand or foot indexes
#define IS_RIGHT(value) (value % 2 == 0)
/// Checks if the value is "right"
/// Used primarily for hand or foot indexes
#define IS_LEFT(value) (value % 2 != 0)
/// Helper for picking between left or right when given a value
/// Used primarily for hand or foot indexes
#define SELECT_LEFT_OR_RIGHT(value, left, right) (IS_LEFT(value) ? left : right)

// Used in ready menu anominity
/// Hide ckey
#define CKEY_ANON (1<<0)
/// Hide character name
#define NAME_ANON (1<<1)
/// Hide top job preference
#define JOB_ANON (1<<2)

/// Calculates oxyloss cap
#define MAX_OXYLOSS(maxHealth) (maxHealth * 2)

// Some source defines for pain and consciousness
// Consciousness ones are human readable because of laziness (they are shown in cause of death)
#define PAINSHOCK "traumatic shock"
#define PAINCRIT "paincrit"
#define PAIN "pain"
#define HUNGER "starvation"
#define BRAIN_DAMAGE "brain damage"
#define BLOOD_LOSS "blood loss"
#define BLUNT_DAMAGE "blunt force trauma"
#define BURN_DAMAGE "severe burns"
#define OXY_DAMAGE "suffocation"
#define TOX_DAMAGE "toxic poisoning"

// For SShealth_updates
/// Call update_damage_hud()
#define UPDATE_SELF_DAMAGE (1 << 0)
/// Call update_health_hud()
#define UPDATE_SELF_HEALTH (1 << 1)
/// Call med_hud_set_health()
#define UPDATE_MEDHUD_HEALTH (1 << 2)
/// Call med_hud_set_status()
#define UPDATE_MEDHUD_STATUS (1 << 3)
/// Call update_conscisouness()
#define UPDATE_CON (1 << 4)

/// Updates the entire medhud
#define UPDATE_MEDHUD (UPDATE_MEDHUD_HEALTH | UPDATE_MEDHUD_STATUS)
/// Updates associated self-huds on the mob
#define UPDATE_SELF (UPDATE_SELF_DAMAGE | UPDATE_SELF_HEALTH)

/// Threshold that heart beat becomes "slow"
#define SLOW_HEARTBEAT_THRESHOLD 6
/// Threshold that heart beat becomes "fast"
#define FAST_HEARTBEAT_THRESHOLD 11

// Used in living mob offset list for determining pixel offsets
#define PIXEL_W_OFFSET "w"
#define PIXEL_X_OFFSET "x"
#define PIXEL_Y_OFFSET "y"
#define PIXEL_Z_OFFSET "z"

/// Disables headset use, but not internal radio / intercom use
#define TRAIT_BLOCK_HEADSET_USE "block_headset_use"

/// Dwarf but without some side effects
#define TRAIT_SMALL "small_size_trait"
/// Giant but without some side effects
#define TRAIT_HUGE "huge_size_trait"

/// Formats text for an object for a mob that they are examining
/// - The mob is holding it: "your [thing.name]"
/// - Another mob is holding it: "[mob]'s [thing.name]"
/// - Then object is on the ground: "the [thing.name]"
#define EXAMINING_WHAT(examiner, thing) (thing.loc == examiner ? "your [thing.name]" : (ismob(thing.loc) ? "[thing.loc]'s [thing.name]" : thing ))

/// Formats text for an object for a mob witnessing another mob examining it
/// - The mob is holding it: "their [thing.name]"
/// - Another mob is holding it: "[other]'s [thing.name]"
/// - Viewer is holding it: "your [thing.name]"
/// - The object is on the ground: "the [thing.name]"
#define WITNESSING_EXAMINE_WHAT(examiner, thing, viewer) (thing.loc == examiner ? "[examiner.p_their()] [thing.name]" : EXAMINING_WHAT(viewer, thing))

/// For consistent examine span formatting (normal size)
#define examining_span_normal(msg) span_infoplain(span_italics(msg))
/// For consistent examine span formatting (small size)
#define examining_span_small(msg) span_small(span_infoplain(span_italics(msg)))
