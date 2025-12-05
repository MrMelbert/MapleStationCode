
#define NO_MANA_POOL (1<<0)
#define MANA_POOL_FULL (1<<1)

#define MANA_POOL_TRANSFER_START (1<<2)
#define MANA_POOL_TRANSFER_STOP (1<<3)

#define MANA_POOL_ALREADY_TRANSFERRING (1<<4)
#define MANA_POOL_CANNOT_TRANSFER (1<<5)

#define MANA_POOL_TRANSFER_SKIP_ACTIVE (1<<6)

/// used to dictate what rules a mana transfer abide by
// No rules, default. Doesn't do anything, actually.
#define MANA_TRANSFER_ANARCHY (1<<0)
// Stops or skips transfer when the transfer hits or passes the target pool's softcap
#define MANA_TRANSFER_SOFTCAP (1<<1)
// Same as the above, but with added behavior to prevent a transfer that would put someone above the softcap
#define MANA_TRANSFER_SOFTCAP_NO_PASS (1<<2)
// None of the above, just adds manual rules to transfer.
#define MANA_TRANSFER_MANUAL_RULES (1<<3)
