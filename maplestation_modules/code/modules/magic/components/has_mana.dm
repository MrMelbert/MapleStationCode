/* Design notes:
* This component designates the parent datum as, through some mechanism, being a mana "source".
*
* When a request is put in to get available mana sources to a specific entity, datums with these componenets
* should be what is returned.
* HOW WE WILL GATHER DATUMS WITH THIS: As GetComponent is a crutch, this can likely be done through the use
* of firing a signal off the entity and having has_mana listen for it. (How? Have EVERY has_mana instance run a proc?
* THat can get out of hand fast. Need some way to only have things that might actually be available returned. Maybe
* we can, upon certain evenets occuring, such as an item being picked up, we can add it to a list associated with a
* specific entity?)
/** WHEN: It is likely the signal will be fired off by uses_mana components searching for available mana sources. When
* players desire to know their available mana, as well.
*
* has_mana instances should, at a minimum, have some way to generate mana. It doesn't necessarily have to store mana, just
* generate it.
* A possible use: Transmutation magic. A spell with the has_mana component. Upon a mana request being filed, a proc will be called that
* 1. will cast the spell, and 2. return a designated amount of mana.
* ANother use: Mana crystals. This one will have a variable holding mana, and apon mana request, will drain the designated amount from
* the crystal and provide it to the requestee.
*/

/// Designates the parent datum as, through some mechanism, being a mana "source".
/datum/component/has_mana

// I'm not sure
/datum/component/has_mana/Initialize(...)
	. = ..()

	RegisterSignal(???, putcomsighere, PROC_REF(mana_request_reaction))
*/
