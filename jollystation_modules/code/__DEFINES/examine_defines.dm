/// -- Defines for the unique-examine element. --
/// Displays the special_desc regardless if it's set.
#define EXAMINE_CHECK_NONE "none"
/// For displaying descriptors for those with a certain antag datum. Pass a list of type "datum/antagonist/"
#define EXAMINE_CHECK_ANTAG "antag"
/// For displaying descriptors for those with a mindshield implant.
#define EXAMINE_CHECK_MINDSHIELD "mindshield"
/// For displaying description information based on a specific ROLE, e.g. traitor. Pass a list of string "Role"
#define EXAMINE_CHECK_ROLE "role"
/// For displaying descriptors for specific jobs, e.g scientist. Pass a list of string "Job"
#define EXAMINE_CHECK_JOB "job"
/// For displaying descriptors for specific departments, like "service". Pass a bitflag of departments
#define EXAMINE_CHECK_DEPARTMENT "department"
/// For displaying descriptors for mob factions, e.g. a zombie, or... turrets. Or syndicate. Pass a list of type "faction"
// NOTE: factions aren't often set very consistently, so this might not work as anticipated. You should try to use other checks before faction if possible.
#define EXAMINE_CHECK_FACTION "faction"
/// For displaying descriptors for people with certain skill-chips. Pass a list of type "/obj/item/skillchip"
#define EXAMINE_CHECK_SKILLCHIP "skillchip"
/// For displayind descriptors for people with certain traits. Pass a list of string "trait"
#define EXAMINE_CHECK_TRAIT "trait"
/// For displayind descriptors for people of certain species. Pass it a list of types "/datum/species"
#define EXAMINE_CHECK_SPECIES "species"

/// Defines for the message to display when finding more info.
#define ADDITIONAL_INFO_RECORDS (1<<0)
#define ADDITIONAL_INFO_EXPLOITABLE (1<<1)
#define ADDITIONAL_INFO_FLAVOR (1<<2)
