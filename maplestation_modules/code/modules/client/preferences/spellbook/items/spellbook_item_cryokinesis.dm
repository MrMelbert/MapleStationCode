GLOBAL_LIST_INIT(spellbook_cryokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_CRYOKINESIS))

/datum/spellbook_item/spell/ice_blast
	name = "Ice Blast"
	description = "An incantation to summon a condensed energy proejctile made out of ice. On contact with anything, it'll cover the nearby surfaces with a thin layer of ice."
	lore = "The favored tool of Frost Mages, Clowns, and Frost Clowns, Ice Blasts are quick and easy ways of inconveniencing an area for slip and slides alike."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/projectile/ice_blast

/datum/spellbook_item/spell/ice_knife
	name = "Ice Knife"
	description = "Conjures an ice knife at will in your hands."
	lore = "A spell not commonly practiced by followers of Cryokinesis for the fact that the knife's durability is much less desirable than a real one, some still sought to learn it for the sake of self defense. \
	Even then, the knife does not hold well on it's own and will eventually dissapear as to preserve mana."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS
	has_params = TRUE

	our_action_typepath = /datum/action/cooldown/spell/conjure_item/ice_knife

/datum/spellbook_item/spell/ice_knife/generate_customization_params()
	. = list()
	.["ice_blade"] = new /datum/spellbook_customization_entry/boolean("ice_blade", "Ice Armblade Variant", "Construct a blade around your arm, in exchange of harming you in the process.")


/datum/spellbook_item/spell/freeze_person
	name = "Freeze Person"
	description = "A well known and effective spell that encases your victim in a block of enchanted ice."
	lore = "Iconic and infamous, Freeze Person has been used to great effect to solidify opponents, victims, and other targets of mages for centuries.\
	Though it is quite useful to stop someone in their tracks, the ice around them is resistant enough to protect them from incoming attacks.\
	Just be careful you know exactly what this spell is before casting it."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/freeze_person
