/// -- Defines for the unique-examine element. --
/// Displays the special_desc regardless if it's set.
#define EXAMINE_CHECK_NONE "none"
/// For displaying descriptors for all varieties of syndiates (nuke ops, traitors, lavaland syndies, cybersun guys). Pass nothing
#define EXAMINE_CHECK_SYNDICATE "syndicate"
/// For displaying descriptors for those with a mindshield implant. Pass nothing
#define EXAMINE_CHECK_MINDSHIELD "mindshield"
/// For displaying descriptors for those with a certain antag datum. Pass a type "/datum/antagonist".
/// Can include an [affiliation] if you want to override the displayed antagonist name (IE, passing "Donk Co." so it shows that, instead of "Traitor")
#define EXAMINE_CHECK_ANTAG "antag"
/// For displaying descriptors for specific jobs, e.g scientist. Pass a string job title "Job"
#define EXAMINE_CHECK_JOB "job"
/// For displaying descriptors for specific departments, like "service". Pass a bitflag of departments.
#define EXAMINE_CHECK_DEPARTMENT "department"
/// For displaying descriptors for mob factions, e.g. a zombie, or... turrets. Or syndicate. Pass a string "faction"
// NOTE: factions aren't often set very consistently, so this might not work as anticipated. You should try to use other checks before faction if possible.
#define EXAMINE_CHECK_FACTION "faction"
/// For displaying descriptors for people with certain skill-chips. Pass a type "/obj/item/skillchip"
#define EXAMINE_CHECK_SKILLCHIP "skillchip"
/// For displayind descriptors for people with certain traits. Pass a string "trait"
#define EXAMINE_CHECK_TRAIT "trait"
/// For displayind descriptors for people of certain species. Pass a type "/datum/species"
#define EXAMINE_CHECK_SPECIES "species"
