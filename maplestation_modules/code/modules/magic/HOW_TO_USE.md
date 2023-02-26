## Adding a new spell/mana user
Adding a mana user is very simple. All you have to do is subtype /datum/component/uses_mana, then add this subtype to the item thats now a mana user.

### Extending uses_mana
There are a few crucial steps to extending uses_mana.
Firstly, you must override get_mana_required() and have it return the exact numerical value in EFFECTIVE mana (we will get to this later)
it requires for the action to be cast. The action in this case can be quite literally anything - anything that requires a signal to determine
if it will execute. MAKE SURE TO MULTIPLY IT AGAINST THE USER'S CASTING COST MULT: spell.owner.get_casting_cost_mult()

If you wish your action to be fail if not enough mana is acquired (common behavior), register a signal to a signal handler from some sort of pre-usage check
(story_spell_component uses COMSIG_SPELL_BEFORE_CAST, attached to handle_precast, so for spells this is already handled). Most things have a signal for this, you just
have to look.

If you wish the action to use mana, you must register a signal that fires when the action is successful to a signal handler, and then call drain_mana(), which will get
the available mana and drain the required mana from all mana pools it finds.

The next crucial step is overriding get_attunement_dispositions() to return the actual attunements of the spell/action. The proc itself returns a copy of the default
attunement list, a list of every attunement in the game with an attunement value of 0. You must modify your selected attunements by the values you desire.
Ex. firebolt should do . = ..(), then .[MAGIC_ELEMENT_FIRE] += (Value), then return .

Congratulations. You have now made a spell that uses mana. If youre making a spell, you can extend /datum/component/uses_mana/story_spell - it already has 3 signal handlers for precast, cast, and postcast, meaning you dont have to worry about finding the signals yourself.
