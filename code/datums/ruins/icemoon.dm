// Hey! Listen! Update \config\iceruinblacklist.txt with your new ruins!

/datum/map_template/ruin/icemoon
	prefix = "_maps/RandomRuins/IceRuins/"
	allow_duplicates = FALSE
	cost = 5
	ruin_type = ZTRAIT_ICE_RUINS
	default_area = /area/icemoon/surface/outdoors/unexplored
	has_ceiling = TRUE
	ceiling_turf = /turf/closed/mineral/random/snow/do_not_chasm
	ceiling_baseturfs = list(/turf/open/misc/asteroid/snow/icemoon/do_not_chasm)

// above ground only

/datum/map_template/ruin/icemoon/gas
	name = "Ice-Ruin Lizard Gas Station"
	id = "lizgasruin"
	description = "A gas station. It appears to have been recently open and is in mint condition."
	suffix = "icemoon_surface_gas.dmm"

/datum/map_template/ruin/icemoon/lust
	name = "Ice-Ruin Ruin of Lust"
	id = "lust"
	description = "Not exactly what you expected."
	suffix = "icemoon_surface_lust.dmm"

/datum/map_template/ruin/icemoon/asteroid
	name = "Ice-Ruin Asteroid Site"
	id = "asteroidsite"
	description = "Surprised to see us here?"
	suffix = "icemoon_surface_asteroid.dmm"

/datum/map_template/ruin/icemoon/engioutpost
	name = "Ice-Ruin Engineer Outpost"
	id = "engioutpost"
	description = "Blown up by an unfortunate accident."
	suffix = "icemoon_surface_engioutpost.dmm"

/datum/map_template/ruin/icemoon/fountain
	name = "Ice-Ruin Fountain Hall"
	id = "ice_fountain"
	description = "The fountain has a warning on the side. DANGER: May have undeclared side effects that only become obvious when implemented."
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "fountain_hall.dmm"

/datum/map_template/ruin/icemoon/abandoned_homestead
	name = "Ice-Ruin Abandoned Homestead"
	id = "abandoned_homestead"
	description = "This homestead was once host to a happy homesteading family. It's now host to hungry bears."
	suffix = "icemoon_underground_abandoned_homestead.dmm"

/datum/map_template/ruin/icemoon/entemology
	name = "Ice-Ruin Insect Research Station"
	id = "bug_habitat"
	description = "An independently funded research outpost, long abandoned. Their mission, to boldly go where no insect life would ever live, ever, and look for bugs."
	suffix = "icemoon_surface_bughabitat.dmm"

/datum/map_template/ruin/icemoon/pizza
	name = "Ice-Ruin Moffuchi's Pizzeria"
	id = "pizzeria"
	description = "Moffuchi's Family Pizzeria chain has a reputation for providing affordable artisanal meals of questionable edibility. This particular pizzeria seems to have been abandoned for some time."
	suffix = "icemoon_surface_pizza.dmm"

/datum/map_template/ruin/icemoon/frozen_phonebooth
	name = "Ice-Ruin Frozen Phonebooth"
	id = "frozen_phonebooth"
	description = "A venture by nanotrasen to help popularize the use of holopads. This one was sent to a icemoon."
	suffix = "icemoon_surface_phonebooth.dmm"

/datum/map_template/ruin/icemoon/smoking_room
	name = "Ice-Ruin Smoking Room"
	id = "smoking_room"
	description = "Here lies Charles Morlbaro. He died the way he lived."
	suffix = "icemoon_surface_smoking_room.dmm"

// above and below ground together

/datum/map_template/ruin/icemoon/mining_site
	name = "Ice-Ruin Mining Site"
	id = "miningsite"
	description = "Ruins of a site where people once mined with primitive tools for ore."
	suffix = "icemoon_surface_mining_site.dmm"
	always_place = TRUE
	always_spawn_with = list(/datum/map_template/ruin/icemoon/underground/mining_site_below = PLACE_BELOW)

/datum/map_template/ruin/icemoon/underground/mining_site_below
	name = "Ice-Ruin Mining Site Underground"
	id = "miningsite-underground"
	description = "Who knew ladders could be so useful?"
	suffix = "icemoon_underground_mining_site.dmm"
	has_ceiling = FALSE
	unpickable = TRUE

// below ground only

/datum/map_template/ruin/icemoon/underground
	name = "Ice-Ruin underground ruin"
	ruin_type = ZTRAIT_ICE_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/icemoon/underground/abandonedvillage
	name = "Ice-Ruin Abandoned Village"
	id = "abandonedvillage"
	description = "Who knows what lies within?"
	suffix = "icemoon_underground_abandoned_village.dmm"

/datum/map_template/ruin/icemoon/underground/library
	name = "Ice-Ruin Buried Library"
	id = "buriedlibrary"
	description = "A once grand library, now lost to the confines of the Ice Moon."
	suffix = "icemoon_underground_library.dmm"

/datum/map_template/ruin/icemoon/underground/wrath
	name = "Ice-Ruin Ruin of Wrath"
	id = "wrath"
	description = "You'll fight and fight and just keep fighting."
	suffix = "icemoon_underground_wrath.dmm"

/datum/map_template/ruin/icemoon/underground/hermit
	name = "Ice-Ruin Frozen Shack"
	id = "hermitshack"
	description = "A place of shelter for a lone hermit, scraping by to live another day."
	suffix = "icemoon_underground_hermit.dmm"

/datum/map_template/ruin/icemoon/underground/lavaland
	name = "Ice-Ruin Lavaland Site"
	id = "lavalandsite"
	description = "I guess we never really left you huh?"
	suffix = "icemoon_underground_lavaland.dmm"

/datum/map_template/ruin/icemoon/underground/puzzle
	name = "Ice-Ruin Ancient Puzzle"
	id = "puzzle"
	description = "Mystery to be solved."
	suffix = "icemoon_underground_puzzle.dmm"

/datum/map_template/ruin/icemoon/underground/bathhouse
	name = "Ice-Ruin Bath House"
	id = "bathhouse"
	description = "A warm, safe place."
	suffix = "icemoon_underground_bathhouse.dmm"

/datum/map_template/ruin/icemoon/underground/wendigo_cave
	name = "Ice-Ruin Wendigo Cave"
	id = "wendigocave"
	description = "Into the jaws of the beast."
	suffix = "icemoon_underground_wendigo_cave.dmm"

/datum/map_template/ruin/icemoon/underground/free_golem
	name = "Ice-Ruin Free Golem Ship"
	id = "golem-ship"
	description = "Lumbering humanoids, made out of precious metals, move inside this ship. They frequently leave to mine more minerals, which they somehow turn into more of them. \
	Seem very intent on research and individual liberty, and also geology-based naming?"
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "golem_ship.dmm"

/datum/map_template/ruin/icemoon/underground/mailroom
	name = "Ice-Ruin Frozen-over Post Office"
	id = "mailroom"
	description = "This is where all of your paychecks went. Signed, the management."
	suffix = "icemoon_underground_mailroom.dmm"

/datum/map_template/ruin/icemoon/underground/frozen_comms
	name = "Ice-Ruin Frozen Communicatons Outpost"
	id = "frozen_comms"
	description = "3 Peaks Radio, where the 2000's live forever."
	suffix = "icemoon_underground_frozen_comms.dmm"

//TODO: Bottom-Level ONLY Spawns after Refactoring Related Code
/datum/map_template/ruin/icemoon/underground/plasma_facility
	name = "Ice-Ruin Abandoned Plasma Facility"
	id = "plasma_facility"
	description = "Rumors have developed over the many years of Freyja plasma mining. These rumors suggest that the ghosts of dead mistreated excavation staff have returned to \
	exact revenge on their (now former) employers. Coorperate reminds all staff that rumors are just that: Old Housewife tales meant to scare misbehaving kids to bed."
	suffix = "icemoon_underground_abandoned_plasma_facility.dmm"

/datum/map_template/ruin/icemoon/underground/hotsprings
	name = "Ice-Ruin Hot Springs"
	id = "hotsprings"
	description = "Just relax and take a dip, nothing will go wrong, I swear!"
	suffix = "icemoon_underground_hotsprings.dmm"

/datum/map_template/ruin/sandbox
	prefix = "_maps/RandomRuins/SandRuins/"
	allow_duplicates = FALSE
	cost = 5
	ruin_type = ZTRAIT_SAND_RUINS
	default_area = /area/icemoon/surface/outdoors/unexplored
	has_ceiling = TRUE
	ceiling_turf = /turf/closed/mineral/random/sand/do_not_chasm
	ceiling_baseturfs = list(/turf/open/misc/beach/sand/no_ruins)

/datum/map_template/ruin/sandbox/fountain_hall
	name = "Sand-Ruin Fountain Hall"
	id = "fountain_hall"
	description = "The fountain has a warning on the side. DANGER: May have undeclared side effects that only become obvious when implemented."
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "fountain_hall.dmm"

/datum/map_template/ruin/sandbox/casbah
	name = "Sand-Ruin Casbah"
	id = "casbah"
	description = "A sandy fortification, built to withstand the harsh desert environment. \
		It has seen better days, but still stands as a testament to the resilience of its builders."
	suffix = "sandbox_surface_kasbah.dmm"
	cost = 15

/datum/map_template/ruin/sandbox/oasis
	name = "Sand-Ruin Oasis"
	id = "oasis"
	description = "A rare and precious oasis, providing a haven of life and water in the midst of the unforgiving desert."
	suffix = "sandbox_surface_oasis.dmm"
	cost = 5
	// allow_duplicates = TRUE

/datum/map_template/ruin/sandbox/beach
	name = "Sand-Ruin Beach"
	id = "beach"
	description = "A sandy beach, once a popular destination for travelers and adventurers. \
		The beach is now desolate and windswept, but still holds a sense of nostalgia and beauty for those who visit it."
	suffix = "sandbox_surface_beach.dmm"
	cost = 10

/datum/map_template/ruin/sandbox/ufo_crash
	name = "Sand-Ruin UFO Crash Site"
	id = "ufo_crash"
	description = "The remains of a UFO crash, long since abandoned and buried by the sands. The crash site is rumored to hold advanced alien technology."
	suffix = "sandbox_surface_ufo_crash.dmm"
	cost = 5

/datum/map_template/ruin/sandbox/minecraft
	name = "Sand-Ruin Minecraft Temple"
	id = "minecraft"
	description = "A mysterious temple, found in strange locations across the desert. \
		Said to hold ancient treasure within."
	suffix = "sandbox_surface_minecraft.dmm"
	cost = 15
	always_place = TRUE
	always_spawn_with = list(/datum/map_template/ruin/sandbox/minecraft/below = PLACE_BELOW)

/datum/map_template/ruin/sandbox/minecraft/below
	name = "Sand-Ruin Minecraft Temple Underground"
	id = "minecraft-underground"
	description = "The underground portion of the mysterious temple."
	suffix = "sandbox_underground_minecraft.dmm"
	has_ceiling = FALSE
	unpickable = TRUE

/datum/map_template/ruin/sandbox/ruins
	name = "Sand-Ruin Generic Ruins"
	id = "generic_ruins"
	description = "Generic ruins. Who knows what they used to be?"
	suffix = "sandbox_surface_ruins.dmm"
	cost = 5

/datum/map_template/ruin/sandbox/mummies
	name = "Sand-Ruin Mummy Tomb"
	id = "mummies"
	description = "A tomb filled with mummies, preserved by the dry desert air."
	suffix = "sandbox_underground_mummies.dmm"
	cost = 15
	ruin_type = ZTRAIT_SAND_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/sandbox/ark
	name = "Sand-Ruin Ark of the Covenant"
	id = "ark"
	description = "The legendary Ark of the Covenant, said to hold immense power and secrets, but guarded by ancient crusaders."
	suffix = "sandbox_underground_ark.dmm"
	cost = 15
	ruin_type = ZTRAIT_SAND_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/sandbox/grail
	name = "Sand-Ruin Holy Grail Site"
	id = "grail"
	description = "The rumored location of the legendary Holy Grail, said to grant life and healing, but guarded by ancient crusaders."
	suffix = "sandbox_underground_grail.dmm"
	cost = 15
	ruin_type = ZTRAIT_SAND_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/sandbox/library
	name = "Sand-Ruin Library"
	id = "library"
	description = "A once grand library, now lost to the confines of the desert. \
		The library's shelves are filled with ancient tomes and scrolls, many of which have been damaged by the harsh desert conditions."
	suffix = "sandbox_underground_library.dmm"
	cost = 15
	ruin_type = ZTRAIT_SAND_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/sandbox/tomb
	name = "Sand-Ruin Tomb"
	id = "tomb"
	description = "A mysterious tomb, buried deep beneath the sands. \
		The tomb is said to hold the remains of a powerful and ancient ruler, and is rumored to be filled with treasures and secrets."
	suffix = "sandbox_underground_tomb.dmm"
	cost = 15
	ruin_type = ZTRAIT_SAND_RUINS_UNDERGROUND
	always_place = TRUE
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/sandbox/railway
	name = "Sand-Ruin Abandoned Mine Rail"
	id = "railway"
	description = "An abandoned minecart railway, once used to transport valuable minerals from the depths of the desert. \
		The railway is now rusted and overgrown, but still holds a sense of adventure and mystery for those who dare to explore it."
	suffix = "sandbox_surface_railway.dmm"
	cost = 10
	ruin_type = ZTRAIT_SAND_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/sandbox/lava
	name = "Sand-Ruin Underground Lava"
	id = "lava"
	description = "A subterranean lava flow with an item in the middle."
	suffix = "sandbox_underground_lava.dmm"
	cost = 5
	ruin_type = ZTRAIT_SAND_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/obj/item/reagent_containers/cup/glass/trophy/grail
	name = "holy grail"
	desc = "The legendary Holy Grail, said to grant life and healing to those who drink from it."
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "golden_cup"
	w_class = WEIGHT_CLASS_SMALL
	volume = 30

/obj/item/reagent_containers/cup/glass/trophy/grail/real
	icon_state = "bronze_cup"

/obj/item/reagent_containers/cup/glass/trophy/grail/real/Initialize(mapload, vol)
	. = ..()
	reagents.add_reagent(/datum/reagent/water/holywater/grail_water, reagents.maximum_volume)

/obj/item/reagent_containers/cup/glass/trophy/grail/fake
	icon_state = "silver_cup"

/obj/item/reagent_containers/cup/glass/trophy/grail/fake/Initialize(mapload, vol)
	. = ..()
	reagents.add_reagent(/datum/reagent/fuel/unholywater/grail_water, reagents.maximum_volume)

/obj/item/reagent_containers/cup/glass/trophy/grail/fake/b
	icon_state = "golden_cup"

/datum/reagent/fuel/unholywater/grail_water
	name = "Grail Water"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_UNAFFECTED_BY_METABOLISM
	color = "#E0E8EF"

/datum/reagent/fuel/unholywater/grail_water/on_mob_life(mob/living/carbon/human/user, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(user, span_warning("You feel older."))
	user.age += 1 * seconds_per_tick
	switch(user.age)
		if(90 to INFINITY)
			to_chat(user, span_userdanger("You feel your life fading away!"))
			user.death(null, "old age")
		if(70 to 90)
			user.cause_pain(BODY_ZONES_ALL, 1.5 * seconds_per_tick)
			user.adjust_traumatic_shock(0.5 * seconds_per_tick)
		if(50 to 70)
			user.cause_pain(BODY_ZONES_ALL, 1 * seconds_per_tick)
		if(20 to 50)
			user.cause_pain(BODY_ZONES_ALL, 0.5 * seconds_per_tick)

/datum/reagent/water/holywater/grail_water
	name = "Grail Water"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_UNAFFECTED_BY_METABOLISM
	color = "#E0E8EF"

/datum/reagent/water/holywater/grail_water/on_mob_life(mob/living/carbon/human/user, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(user, span_green("You feel a warm sensation wash over you."))
	user.age = max(20, user.age - 0.5 * seconds_per_tick)
	user.adjustBruteLoss(-1.5 * seconds_per_tick)
	user.adjustFireLoss(-1.5 * seconds_per_tick)
	user.heal_pain(1 * seconds_per_tick)
	user.adjust_traumatic_shock(-3 * seconds_per_tick)

/obj/item/nullrod/egyptian/cursed
	chaplain_spawnable = FALSE
	var/has_cursed = FALSE

/obj/item/nullrod/egyptian/cursed/Initialize(mapload)
	. = ..()
	add_filter("cursefilter", 1, outline_filter(size = 2, color = COLOR_DARK_PURPLE))

/obj/item/nullrod/egyptian/cursed/equipped(mob/living/carbon/user, slot, initial)
	. = ..()
	if(has_cursed || !iscarbon(user) || isskeleton(user))
		return
	if(!(slot & ITEM_SLOT_HANDS))
		return

	var/datum/disease/curse_of_ra/curse = new()
	curse.antimagic_bypass = TRUE
	curse.cure_chance *= 0.5
	if(user.ForceContractDisease(curse, FALSE, TRUE))
		to_chat(user, span_hypnophrase("As you pick up [src], you feel a dark presence enter your mind... \
			Strange symbols fill your vision, and you think for a moment you hear... 'curso fra'...?"))
		has_cursed = TRUE
		transition_filter("cursefilter", outline_filter(size = 0), 1 SECONDS)

/datum/disease/curse_of_ra
	name = "Curse of Ra"
	max_stages = 5
	cures = list(/datum/reagent/water/holywater)
	spread_flags = DISEASE_SPREAD_AIRBORNE | DISEASE_SPREAD_CONTACT_SKIN
	agent = "Dark Magic"
	spread_text = "Airbourne"
	cure_text = "Holy Water"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "A powerful curse."
	infectivity = 33
	severity = DISEASE_SEVERITY_HARMFUL
	bypasses_immunity = TRUE
	disease_flags = CURABLE|INCREMENTAL_CURE
	var/antimagic_bypass = FALSE

/datum/disease/curse_of_ra/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.emote("cough")
				if(affected_mob.CanSpreadAirborneDisease())
					spread()

		if(2)
			if(SPT_PROB(3, seconds_per_tick))
				affected_mob.emote("cough")
				affected_mob.apply_damage(1, OXY)
				if(affected_mob.CanSpreadAirborneDisease())
					spread()
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.emote("pale")

		if(3)
			if(SPT_PROB(3, seconds_per_tick))
				affected_mob.emote("cough")
				to_chat(affected_mob, span_warning("You cough up sand!"))
				new /obj/item/stack/ore/glass(affected_mob.loc)
				affected_mob.apply_damage(5, OXY)
				if(affected_mob.CanSpreadAirborneDisease())
					spread()

			if(SPT_PROB(2, seconds_per_tick))
				affected_mob.emote("pale")

/datum/disease/curse_of_ra/try_infect(mob/living/infectee, make_copy)
	if(!antimagic_bypass && infectee.can_block_magic(MAGIC_RESISTANCE_HOLY, 1))
		return FALSE

	return ..()

/obj/structure/closet/crate/necropolis/ark
	name = "ark of the covenant"
	var/desouled = FALSE
	COOLDOWN_DECLARE(ghost_sound)

/obj/structure/closet/crate/necropolis/ark/PopulateContents()
	var/obj/item/nullrod/staff/blue/staff = new(src)
	staff.name = "staff of spirits"
	staff.force = 16
	staff.obj_flags &= ~UNIQUE_RENAME
	staff.AddElement(/datum/element/bane, mob_biotypes = MOB_SPIRIT|MOB_UNDEAD, damage_multiplier = 1.5)

/obj/structure/closet/crate/necropolis/ark/before_open(mob/living/user, force)
	if(force || desouled)
		return ..()

	if(COOLDOWN_FINISHED(src, ghost_sound))
		playsound(src, 'sound/effects/ghost.ogg', 50, TRUE)
		COOLDOWN_START(src, ghost_sound, 10 SECONDS)

	user.visible_message(
		span_notice("[user] attempts to pry open [src]..."),
		span_notice("You attempt to pry open [src]... \
			Though you really feel like you should be prepared - and [src] should be somewhere safe - before you do this..."),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	if(!do_after(user, 10 SECONDS, src))
		return FALSE
	user.visible_message(
		span_notice("[user] pries open [src]!"),
		span_notice("You pry open [src]!"),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	return ..()


/obj/structure/closet/crate/necropolis/ark/after_open(mob/living/user, force)
	. = ..()
	if(force || desouled)
		return

	for(var/i in 1 to rand(8, 12))
		new /mob/living/basic/ghost/hostile(loc)

	desouled = TRUE
	visible_message(
		span_warning("Souls begin to pour out of [src] and into the world!"),
	)
	playsound(src, 'sound/effects/ghost2.ogg', 50, TRUE)
