// Directional behaviors

/// Can block/parry attacks from any direction
#define ACTIVE_COMBAT_OMNIDIRECTIONAL 0
/// Can block/parry attacks from the direction you're facing + diagonals. Default behavior
#define ACTIVE_COMBAT_FACING 1
/// Only can block/parry attacks from the directions you're facing - cardinals only
#define ACTIVE_COMBAT_CARDINAL_FACING 2

// Effects for successfull blocks
// Also used on self upon failing to parry/block
/// Click on the attacker upon blocking for a parry, list assoc should be TRUE or a damage multiplier
#define ACTIVE_COMBAT_PARRY "active_combat_parry"
/// Shoves the attacker, list assoc should be TRUE
#define ACTIVE_COMBAT_SHOVE "active_combat_shove"
/// Evades to the side, if sides are occupied evades back, list assoc should be TRUE
#define ACTIVE_COMBAT_EVADE "active_combat_evade"
/// Knocks the attacker down, list assoc is duration. Can be used in failed parries
#define ACTIVE_COMBAT_KNOCKDOWN "active_combat_knockdown"
/// Staggers the attacker, list assoc is duration. Can be used in failed parries
#define ACTIVE_COMBAT_STAGGER "active_combat_stagger"
/// Deals stamina to the attacker, list assoc is amount. Can be used in failed parries
#define ACTIVE_COMBAT_STAMINA "active_combat_stamina"
/// Make an emote, list assoc is emote itself. Can be used in failed parries
#define ACTIVE_COMBAT_EMOTE "active_combat_emote"
/// Reflect a projectile if hit by one at whatever the user is currently hovering their mouse over, list assoc is TRUE
#define ACTIVE_COMBAT_REFLECT_PROJECTILE "active_combat_reflect_projectile"
/// Makes the damage go through even if the parry was good enough, list assoc is TRUE
#define ACTIVE_COMBAT_FORCED_DAMAGE "active_combat_forced_damage"

// Parry states
#define ACTIVE_COMBAT_INACTIVE 0
#define ACTIVE_COMBAT_PREPARED 1
#define ACTIVE_COMBAT_RECOVERING 2

// Parry returns
#define PARRY_FAILURE NONE
#define PARRY_SUCCESS (1<<0)
#define PARRY_FULL_BLOCK (1<<1)
#define PARRY_RETALIATE (1<<2)
