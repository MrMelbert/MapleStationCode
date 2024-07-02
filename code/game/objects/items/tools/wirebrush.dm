/**
 * The wirebrush is a tool whose sole purpose is to remove rust from anything that is rusty.
 * Because of the inherent nature of hard countering rust heretics it does it very slowly.
 */
/obj/item/wirebrush
	name = "wirebrush"
	desc = "A tool that is used to scrub the rust thoroughly off walls. Not for hair!"
	icon = 'icons/obj/tools.dmi'
	icon_state = "wirebrush"
	tool_behaviour = TOOL_RUSTSCRAPER
	toolspeed = 1
	drop_sound = 'maplestation_modules/sound/items/drop/metal_drop.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/metalweapon.ogg'
