# Magic system

## Premise
The magic system was derived from wolly's lore, see the doc in lore-documents for more info on that.
https://hackmd.io/iOeSmeysS-KNJ8KHn8mkbw
The design doc. This readme will not cover its contents, instead it will cover how the magic system works.

If you just want to see how to extend it, see HOW_TO_USE.md.

## How it works
When a datum calls /datum/proc/get_available_mana(), it will search for any mana pools available to the entity. The contents that return can vary based on the type of entity its called on, as the idea is that the proc can be overrided to, say, have it search for transmutation spells in a /living. By default, leylines are available to everyone, and are on the datum level.

This proc is primarily called when an instance of the uses_mana component, the component used to add the behavior of requiring mana to a given entity, has it's pre-use signal handler called. Typically, it will compare the effective mana received with the absolute amount of mana it requires - we will get into effective vs raw mana later. Use will be cancelled if mana is insufficient - continue if its not. 
This proc is also called on USE, where it gathers all the available mana (Potentially, in order of priority of use, unimplemented), gets the mana required, converts the mana required to effective mana, then subtracts the effective mana from the mana source.

"Effective" mana comes from the attunement system. Mana pools and mana users both have attunement values - a associative list of /datum/attunement instances/typepaths to attunement value. Pools can have only positive values - users can hvae positive and negative. When a user requests mana from mana pools, it doesn't draw the actual amount of mana - it gets the attuned value. The attuned value of mana is the value of mana after attunement values have been applied. 
The more a pool's attunements correspond to the values of a user, the lower the casting cost will be, and vice versa. Correspondance is determined by multiplying the attunement to a specific value with the attunement value of the other. Ex. 3\*1 = value of 3, 3\*-2 = value of -6. These attunement values are added together, then converted to a multiplier by proc/get_total_attunement_mult(), and then applied to the raw amount to determine the "effective" amount of mana if it would be applied to the mana user.

This same effective amount is also what is actually used. If something has 50 mana but an attunement mult of 0.25, the effective mana is 200, and thus this 50 mana can be applied to a mana user with a requirement of 200.
It's also possible that, in the future, attunements/element will have inherent multipliers attached ot them, in the form of, say, lizards having 80% casting cost for fire magic.
Mobs also have a inherent "castng cost" multiplier, accessable through get_casting_cost_mult(). All instances of mana usage that require or anticipate a mob casting it should take this into account, and multiply the cost by this.

mana_users are instances of the mana_user component, which is, again, the component that designates having to use mana somewhere. All instaces of behavior that require mana should implement this component, as they are the only way to actually interact with the mana system and consume/request mana.
mana_holders are datums that hold a mana_pool instance. They are primarily irrelevant at the moment - but will become required when mana is refactored into lists of gas_mixture-like datums.

mana_users and mana_holders are the demand and supply of this system, and together, form it.
