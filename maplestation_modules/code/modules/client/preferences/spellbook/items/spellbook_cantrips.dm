GLOBAL_LIST_INIT(spellbook_cantrip_items, generate_spellbook_items(SPELLBOOK_CATEGORY_CANTRIPS))

/datum/spellbook_item/spell/acid_touch
	name = "Acid Touch"
	description = "Empowers your finger with a sticky acid, melting anything (or anyone) you touch."
	lore = "A very volatile spell which has resulted in many a wizard accidentily melting off their own hands. \
		The acid generated is comparable to that of sulfuric acid.\nThis has led to the spell gaining wide use \
		in the criminal underworld, as it is a very effective way to make entrances or exits, dispose of evidence, \
		or create a distraction."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/touch/acid_touch

/datum/spellbook_item/spell/airhike
	name = "Air hike"
	description = "Force wind beneath one's feet for a boost of movement where one is facing to jump over 2 tiles or to jump up a Zlevel and a tile ahead."
	lore = "A somewhat intermediate spell not from its complexity, but applying proper force that won't have the user spin out of control. \
	A spell that is often grown out of due to its unwieldly application, at least for aeromancers, it is known as a party trick or crude application in the magic community, but it is useful in a pinch.\n\
	A common experiment for early aeromancers after wondering if applying force to oneself is possible. Those that learn through experimentation require training to consistantly control it, eventually moving onto finer control or dropping it after one too many crashes.\n\
	Most scholars might prefer students not to spend too much time blasting themselves wildly due to injuries slowing down or stopping proper study.\n\
	If given a proper clear area, some might argue its a safe way to explain distance, the idea of self as a target, and points of force which can be applied to spells that require finesse.\n\
	The name was given due to mages that appeared to walk on air itself, and like climbing a mountain side, if caution is not taken would be fatigued and fall from their height."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/airhike

/datum/spellbook_item/spell/convect
	name = "Convect"
	description = "Manipulate the temperature of anything you can touch."
	lore = "Often considered the precursor to all thermal magic, convect is one of the most important fundumentals of thermokinesis. \
	An extremely common spell, at least for thermomancers, it is well known among the wider magic community and rather typical.\n\
	Latently available to some, with that latency being why it's so common. Those that learn through the latency typically require training to consistantly control it.\n\
	This latency, linked with it's relative simplicity of casting, causes stories of previous thaumic blanks suddenly bursting into flames/\
	freezing themselves (often due to intense emotion, though triggers can be diverse) to be common among the magic community.\n\
	While exceptions exist, most users can only manipulate temperature in the direction of their thermokinetic school/predisposition (fire/ice or both)."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/convect

/datum/spellbook_item/spell/finger_flame
	name = "Finger Flame"
	description = "With a snap, conjures a small flame at the tip of your fingers."
	lore = "More of a party trick than a real spell, Finger Flame is known far and wide as the showiest trick in a thermomancer's book. \
		While not particularly useful, it's a fantastic way to get attention, intimidate someone, demonstrate your powers, or light a cigarette.\n\
		Its low potency makes Finger Flame hardly expensive or tiresome to cast and maintain, \
		making it a good way to practice your control over fire (or rather, to practice avoiding burning yourself)."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/touch/finger_flame/mana

/datum/spellbook_item/spell/conjure_item/flare
	name = "Flare"
	description = "Conjure lumens into a glob to be held or thrown to light an area."
	lore = "A simple application of lumenomancy, although quite complex enough for those new to magic to have the resulting globule sustain itself for so long. \n\
	An extremely common spell, used to gauge a child's power if they are able to even emit a moment of light, it is well known among the wider magic community.\n\
	Effort is taken to understand lumens and conjuring it out of mana. Those that study might prefer to focus on another school of magic, causing them to skip proper flare casting.\n\
	A relatively safe spell that dissipates by itself under normal circumstances, the nebulous construct leaves no residue so clean up isn't needed.\n\
	Considered to be a helpful spell, its short lived life is mostly used to help locate more permanent lighting options.\n\
	Those interested in the lumenomancy school/predisposition use this spell to further their understanding of luminosity and their ability to warp its directions."

	category = SPELLBOOK_CATEGORY_CANTRIPS
	has_params = TRUE

	our_action_typepath = /datum/action/cooldown/spell/conjure_item/flare
// Customization to allow lesser flare
/datum/spellbook_item/spell/conjure_item/flare/generate_customization_params()
	. = list()
	.["lesser"] = new /datum/spellbook_customization_entry/boolean("lesser", "Lesser, weaker, somewhat cheaper version", "A cheap less lasting flare that fizzles out faster than normally, along with a considerable cooldown between casts, for those just learning magic or unable to grasp the full concept of luminosity.")


/datum/spellbook_item/spell/freeze_person
	name = "Freeze Person"
	description = "A well known and effective spell that encases your victim in a block of enchanted ice."
	lore = "Iconic and infamous, Freeze Person has been used to great effect to solidify opponents, victims, and other targets of mages for centuries.\
	Though it is quite useful to stop someone in their tracks, the ice around them is resistant enough to protect them from incoming attacks.\
	Just be careful you know exactly what this spell is before casting it."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/freeze_person

/datum/spellbook_item/spell/healing_touch
	name = "Healing Touch"
	description = "Lay your hands upon a target to heal their wounds."
	lore = "Often called for the action taken while invoking, \"Lay on Hands\", this spell is a staple of any healer's arsenal. \
		Healing Touch is often used by chaplains and priests to aid the ailing and wounded they encounter in their duties. \
		However, that's not to say that its use is exclusively for the holy, as some medical practitioners \
		(especially those who find themselves on the frontier, where supplies are scarce) \
		have been known to utilize it occasionally to expedite their work - \
		though many still find physical tools or chemicals to be more reliable, and thus, it's use is not as common as one might think."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/touch/healing_touch

/datum/spellbook_item/spell/ice_blast
	name = "Ice Blast"
	description = "An incantation to summon a condensed energy proejctile made out of ice. On contact with anything, it'll cover the nearby surfaces with a thin layer of ice."
	lore = "The favored tool of Frost Mages, Clowns, and Frost Clowns, Ice Blasts are quick and easy ways of inconveniencing an area for slip and slides alike."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/projectile/ice_blast

/datum/spellbook_item/spell/ice_knife
	name = "Ice Knife"
	description = "Conjures an ice knife at will in your hands."
	lore = "A spell not commonly practiced by followers of Cryokinesis for the fact that the knife's durability is much less desirable than a real one, some still sought to learn it for the sake of self defense. \
	Even then, the knife does not hold well on it's own and will eventually dissapear as to preserve mana."

	category = SPELLBOOK_CATEGORY_CANTRIPS
	has_params = TRUE

	our_action_typepath = /datum/action/cooldown/spell/conjure_item/ice_knife

/datum/spellbook_item/spell/ice_knife/generate_customization_params()
	. = list()
	.["ice_blade"] = new /datum/spellbook_customization_entry/boolean("ice_blade", "Ice Armblade Variant", "Construct a blade around your arm, in exchange of harming you in the process.")

/datum/spellbook_item/spell/illusion
	name = "Illusion"
	description = "Summon an illusionary clone of yourself at the target location. Looks identical to you, \
		but will not hold up to physical scrutiny. Has a long range, but lasts for only a short time, and is less effective in darker areas."
	lore = "Sometimes known as \"Mirror Image\" by more advanced pracitioners, Illusion is a well practiced spell which bends the light \
		in such a way to create an almost perfect copy of the caster. Of course, being effectively an advanced trick of the light, \
		the illusion is not capable of much besides being used to confuse and distract or otherwise look pretty."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/illusion

/datum/spellbook_item/spell/mage_hand
	name = "Mage Hand"
	description = "Magically manipulate an item from a distance."
	lore = "The favorite of lazy magicians and tricksters alike, \
		Mage Hand is a simple spell that allows the caster to manipulate an item from a distance. \
		The spell is often used to retrieve items that are out of reach, play pranks on unsuspecting victims, \
		press some buttons on a distant keyboard, or to simply avoid having to get up from a comfortable chair.\n\
		Due to its simplicity, the spell is often taught to the young as a first spell - and due to this commonality, \
		it is very easily recognized by most."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/apply_mutations/mage_hand


/datum/spellbook_item/spell/mana_sense
	name = "Mana Sense"
	description = "Sense other mana pools present"
	lore = "Using your magical attunement (or other aptitudes) \
	you can sense if a creature or object has a mana pool present; and what amount of mana the pool has. \
	Do note that this will require a reprieve between casts, and it will take a second to discern the amount of mana a pool has."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/mana_sense

/datum/spellbook_item/spell/meditate
	name = "Magic Meditation"
	description = "Use mental focus to draw mana within yourself"
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to draw mana from the ambient environment. \
	Do note that this will take a while between casts, and you should still find other methods of regeneration."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/meditate

/datum/spellbook_item/spell/shock_touch
	name = "Shocking Grasp"
	description = "Empower your hand to deliver a shock to your target. \
		While the zap is not powerful enough to stun or kill, it will cause them to drop their held items - or restart a stopped heart."
	lore = "A spell which has gained notoriety for its utility in the medical field. \
		Many wizards have found use in it, to jolt a patient out of a coma, or to restart a heart which has stopped beating. \
		However, it is also a favorite of clowns, who use it as a less-obvious joybuzzer.\n\n\
		Oddly, some Geneticists have found latent genes in their test subjects which allow them to use a similar ability, \
		without the need for learning any magic or using any mana. It has yet to be determined if humanoidkind has an innate, untapped ability \
		to manipulate electricity that this spell and the genetic ability are tapping into, or if it is simply a coincidence."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/touch/shock/magical

/datum/spellbook_item/spell/soothe
	name = "Soothe"
	description = "Attempt to soothe a target, stopping them from feeling rage, fear, doubt, or similar emotions for a short time. \
		This effect can be resisted by sentient targets, but also works on more simple-minded creatures."
	lore = "A spell that is often used by by clergical figures, psychologists, or nurses to calm down those who cannot be reasoned with \
		due to its ability to provide tranquility to those in a state of panic or fear. \n\
		Likewise, those who work with animals may use it to pacify a rampaging beast or settle a frightened pet.\n\
		However, its ability to be resisted by sentient creatures who are in extreme mental duress, especially anger, \
		means it is not always reliable - and thus - conventional methods are often preferred."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/soothe_target

/datum/spellbook_item/spell/soft_and_wet
	name = "Water Control"
	description = "Wet a dry spot, or dry a wet spot, from a distance. \
		Wetting a requires a water source - you can draw upon condensation in your surroundings, or supply your own."
	lore = "Quite a mundane spell, Water Control does just that - control water, in whatever form it may be in. Except ice. \
		It allows you to break apart water molecules into vapor or condense them into liquid. \
		Hydromancers are often seen using this spell to put out fires, much to the chagrin of thermomancers."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/soft_and_wet


/* /datum/spellbook_item/spell/leyline_charge
	name = "Leyline Charge"
	description = "Draw mana straight from the leylines themselves."
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to regain mana from the leylines themselves. \
	Do not that this is a finnicky way of regaining mana, and you risk overloading if done improperly."

	category = SPELLBOOK_CATEGORY_MISC

	our_action_typepath = /datum/action/cooldown/spell/leyline_charge */ // disabled because leylines are weirda

/datum/spellbook_item/spell/meditate
	name = "Magic Meditation"
	description = "Use mental focus to draw mana within yourself"
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to draw mana from the ambient environment. \
	Do note that this will take a while between casts, and you should still find other methods of regeneration."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/meditate

/datum/spellbook_item/spell/mana_sense
	name = "Mana Sense"
	description = "Sense other mana pools present"
	lore = "Using your magical attunement (or other aptitudes) \
	you can sense if a creature or object has a mana pool present; and what amount of mana the pool has. \
	Do note that this will require a reprieve between casts, and it will take a second to discern the amount of mana a pool has."

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/pointed/mana_sense

/datum/spellbook_item/spell/sending
	name = "Sending"
	description = "Its Telepathy, but with magic."
	lore = "Using your magical attunement (or other aptitudes) \
	you can send a message to another creature within a short radius. "

	category = SPELLBOOK_CATEGORY_CANTRIPS

	our_action_typepath = /datum/action/cooldown/spell/list_target/telepathy/mana

/datum/spellbook_item/spell/sense_equilibrium
	name = "Sense Equilibrium"
	description = "Divert pathways in a person's brain from one area to another, enhancing one at the cost of the other."
	lore = "Shape the power of the mind to your will." // I ain't writing all that.

	category = SPELLBOOK_CATEGORY_CANTRIPS
	has_params = TRUE

	our_action_typepath = /datum/action/cooldown/spell/list_target/sense_equilibrium

// Customization to allow greater sense equilibrium
/datum/spellbook_item/spell/sense_equilibrium/generate_customization_params()
	. = list()
	.["greater"] = new /datum/spellbook_customization_entry/boolean("greater", "Greater, stronger, shorter lasting version", "A more expensive and shorter lasting form of Sense Equilibrium which allows the user to pinpoint the exact effect they wish the spell to have.")
