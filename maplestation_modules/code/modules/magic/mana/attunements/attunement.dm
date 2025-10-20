GLOBAL_LIST_INIT(magic_attunements, create_attunement_list())
/// List of typepaths - to access the singletons, access magic attunements
GLOBAL_LIST_INIT(default_attunements, create_default_attunement_list())

/proc/create_attunement_list()
	. = list()

	var/list/typecache = typecacheof(/datum/attunement, ignore_root_path = TRUE)
	for (var/datum/attunement/typepath as anything in typecache)
		.[typepath] = new typepath

/proc/create_default_attunement_list()
	. = list()
	for (var/datum/attunement/iterated_attunement as anything in GLOB.magic_attunements)
		.[iterated_attunement] = 0 // make it an assoc list

// Not touching subtypes right now or compound attunements

/// The "attunement" a certain spell or piece of mana may have. When mana is consumed, it's attunements will be compared to the attunements of
/// what consumed it, and then the result will be used to generate how much mana will be actually consumed. Matching attunements decreases cost,
/// vice versa.
/datum/attunement
	var/name = "Base attunement"
	var/desc = "Some coder forgot to set desc"

	var/list/alignments = list() // no alignments by default

/datum/attunement/Destroy(force, ...)
	stack_trace("Destroy called on [src], [src.type], a singleton attunement instance!")
	if (!force)
		return QDEL_HINT_LETMELIVE //should not be deleted, ever
	// forced
	. = ..()

	GLOB.magic_attunements[src.type] = new src.type // recover

/// Should return how much we want the cost multiplier on a cast to be incremented by.
/// Inverse - Higher positive increments = lower cost, higher negative increments = higher cost
/datum/attunement/proc/get_bias_mult_increment(atom/caster)
	return 0

/datum/attunement/fire
	name = "Fire"
	desc = "Perhaps the most well-known, and often many a mage's first study of the elements, the Fire element covers any heat or other flame related magic."

	alignments = list(MAGIC_ALIGNMENT_CHAOS = 0.1)

/datum/attunement/fire/get_bias_mult_increment(atom/caster)
	. = ..()

	if (ishuman(caster))
		var/mob/living/carbon/human/human_caster = caster
		if (islizard(human_caster))
			. += MAGIC_ELEMENT_FIRE_LIZARD_MULT_INCREMENT

/datum/attunement/ice
	name = "Ice"
	desc = "Sibling and eternal rival of Fire, Ice centers on the manipulation of the cold, far beyond just water.  Many mages study ice shortly before or after studying fire, and is often used in demonstrations of interactions of the elements."

	alignments = list(MAGIC_ALIGNMENT_LAW = 0.1)

/datum/attunement/ice/get_bias_mult_increment(atom/caster)
	. = ..()

	if (ishuman(caster))
		var/mob/living/carbon/human/human_caster = caster
		if (ismoth(human_caster))
			. += MAGIC_ELEMENT_ICE_MOTH_MULT_INCREMENT

/datum/attunement/electric
	name = "Electric"
	desc = "An element typically associated with weather, sometimes with divinity, and often technology, electricity is another of the “Classical” elements, albeit not as well known as its siblings."

/datum/attunement/electric/get_bias_mult_increment(atom/caster)
	. = ..()

	if (isliving(caster))
		var/mob/living/living_caster = caster
		if (living_caster.mob_biotypes & MOB_ROBOTIC)
			. += MAGIC_ELEMENT_ELECTRIC_ROBOTIC_MULT_INCREMENT

/datum/attunement/water
	name = "Water"
	desc = "The lifeblood of all organics, water is ubiquitous with any planet or area with any biological life, and is a core aspect of any civilization."

	alignments = list(MAGIC_ALIGNMENT_GOOD = 0.1)

/datum/attunement/life
	name = "Life"
	desc = "The driving force of, and most effectively seen in, all living matter. Life is the most far-reaching of all elements, with its effects seen across the galaxy. Most famously, life is known for the Healing sub element, which directly assists a targeted organism. Critically, the force of life does not discriminate, and still affects parasites & bacteria, harmful or not."

	alignments = list(MAGIC_ALIGNMENT_NONE = 0)

/datum/attunement/life/get_bias_mult_increment(atom/caster)
	. = ..()

	if (isliving(caster))
		var/mob/living/living_caster = caster
		if (living_caster.mob_biotypes & MOB_ORGANIC)
			. += MAGIC_ELEMENT_LIFE_ORGANIC_MULT_INCREMENT

/datum/attunement/wind
	name = "Wind"
	desc = "Air, breathing, motion, and atmosphere. These are all products of the wind element. Much like Water, many biological life forms depend on this to live."

	alignments = list(MAGIC_ALIGNMENT_CHAOS = 0.1)

/datum/attunement/earth
	name = "Earth"
	desc = "The very ground you stand on, a raging earthquake, or an asteroid. Earth is all encompassing of any solid non-living matter."

	alignments = list(MAGIC_ALIGNMENT_LAW = 0.15)

/datum/attunement/earth/get_bias_mult_increment(atom/caster)
	. = ..()

	if (ishumanbasic(caster))
		. += MAGIC_ELEMENT_EARTH_HUMAN_MULT_INCREMENT

/datum/attunement/light
	name = "Light"
	desc = "Self explanatory: Light is the natural enemy of dark, and is often a part of many religions. In addition, Light, alongside Dark, holds some of the most complex sub-types."

	alignments = list(MAGIC_ALIGNMENT_GOOD = 0.15)

/datum/attunement/dark
	name = "Dark"
	desc = "While in physics, darkness is simply the absence of light, in magic Darkness is its own element, being able to subtract Light, combine with other elements, and manifest on its own."

	alignments = list(MAGIC_ALIGNMENT_EVIL = 0.15)

/datum/attunement/blood
	name = "Blood"
	desc = "The most feared and hated element in the universe, Blood magic is inexorably tied with Nar-Sie and her Cult of Blood. Blood magic stands as a perversion of Life, a grand temptation of the feeble minded, and a dark power used to corrupt even the greatest of works."

	alignments = list(
		MAGIC_ALIGNMENT_EVIL = 1.2,
		MAGIC_ALIGNMENT_CHAOS = 1
	)

/datum/attunement/time
	name = "Time"
	desc = "A unique and nigh-impossible element to master by all but those with either endless lifespans, or non-euclidian existence. Measured by all civilizations, and the defining aspect of countless realms and systems. You know exactly what this is, and shouldn't need any further description."

	alignments = list(MAGIC_ALIGNMENT_LAW = 2)
