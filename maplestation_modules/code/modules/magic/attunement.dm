GLOBAL_LIST_INIT(magic_attunements, typecacheof(/datum/attunement, ignore_root_path = TRUE))
GLOBAL_LIST_INIT(default_attunements, create_default_attunement_list())


/proc/create_default_attunement_list()
	. = list()
	for (var/iterated_attunement in GLOB.magic_attunements)
		.[iterated_attunement] = 0 // make it an assoc list

// Not touching subtypes right now or compound attunements

/datum/attunement
	var/name = "Base attunement"
	var/desc = "Some fucking dumbass forgot to set desc"

	var/list/alignments = list() // no alignments by default

/datum/attunement/fire
	name = "Fire"
	desc = "Perhaps the most well-known, and often many a mage's first study of the elements, the Fire element covers any heat or other flame related magic."

	alignments = list(MAGIC_ALIGNMENT_CHAOS = 0.1)

/datum/attunement/ice
	name = "Ice"
	desc = "Sibling and eternal rival of Fire, Ice centers on the manipulation of the cold, far beyond just water.  Many mages study ice shortly before or after studying fire, and is often used in demonstrations of interactions of the elements."

	alignments = list(MAGIC_ALIGNMENT_LAW = 0.1)

/datum/attunement/electric
	name = "Electric"
	desc = "An element typically associated with weather, sometimes with divinity, and often technology, electricity is another of the “Classical” elements, albeit not as well known as its siblings."

/datum/attunement/water
	name = "Water"
	desc = "The lifeblood of all organics, water is ubiquitous with any planet or area with any biological life, and is a core aspect of any civilization."

	alignments = list(MAGIC_ALIGNMENT_GOOD = 0.1)

/datum/attunement/life
	name = "Life"
	desc = "The driving force of, and most effectively seen in, all living matter. Life is the most far-reaching of all elements, with its effects seen across the galaxy. Most famously, life is known for the Healing sub element, which directly assists a targeted organism. Critically, the force of life does not discriminate, and still affects parasites & bacteria, harmful or not."

	alignments = list(MAGIC_ALIGNMENT_NONE = 0)

/datum/attunement/wind
	name = "Wind"
	desc = "Air, breathing, motion, and atmosphere. These are all products of the wind element. Much like Water, many biological life forms depend on this to live."

	alignments = list(MAGIC_ALIGNMENT_CHAOS = 0.1)

/datum/attunement/earth
	name = "Earth"
	desc = "The very ground you stand on, a raging earthquake, or an asteroid. Earth is all encompassing of any solid non-living matter."

	alignments = list(MAGIC_ALIGNMENT_LAW = 0.15)

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
