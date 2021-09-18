//Mutators
//Cold mutator
/obj/item/dnainjector/coldmut
	name = "\improper Cold Immunity injector"
	desc = "Take a stroll on the Ice planet."
	add_mutations = list(COLD_IMMUNITY)

//Hot mutator
/obj/item/dnainjector/hotmut
	name = "\improper Heat Immunity injector"
	desc = "Take a stroll on Lavaland."
	add_mutations = list(HOT_IMMUNITY)

//Vacuum mutator
/obj/item/dnainjector/spacemut
	name = "\improper Vacuum Immunity injector"
	desc = "Take a stroll through space. Lungs required."
	add_mutations = list(VACUUM_IMMUNITY)

//Anti-Mutators; Main code has these so why not?

//AntiCold mutator
/obj/item/dnainjector/anticoldmut
	name = "\improper Anti-Cold Immunity injector"
	desc = "Freeze to death."
	remove_mutations = list(COLD_IMMUNITY)

//AntiHot mutator
/obj/item/dnainjector/antihotmut
	name = "\improper Anti-Heat Immunity injector"
	desc = "Burn to Hell."
	remove_mutations = list(HOT_IMMUNITY)

//AntiVacuum mutator
/obj/item/dnainjector/antispacemut
	name = "\improper Anti-Vacuum Immunity injector"
	desc = "Crumble up like a used juice pouch."
	remove_mutations = list(VACUUM_IMMUNITY)
