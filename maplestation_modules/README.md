
# The JollyStation Module Folder

## MODULES ARE YOU:

So you want to add content? Then you've come to the right place. I appreciate you for reading this first before jumping in and adding a buncha changes to /tg/ files.

We use module files to separate our added content from /tg/ content to prevent un-necessary and excessive merge conflicts when trying to merge from /tg/.

What does this mean to you? This means if you want to add something, you should add it in THIS FOLDER (maplestation_modules) and not in ANY OF THE OTHER FOLDERS unless absolutly necessary (it usually isn't).

# What if I want to add...

## ...icons to this fork:

ALWAYS add icons to a new .dmi in the `maplestation_modules/icons` folder. Icons are notorious for causing awful terrible impossible-to-resolve-easy merge conflicts so never ever add them to normal codebase .dmi files. Adding icons can be complicated for things
such as jumpsuits and IDs, so be sure to ask for help if it gets confusing.

## ...a one-off object, datum, etc. to this fork:

Create all new content in a new .dm file in the `maplestation_modules/code` folder. For the sake of organization, we mimic the folder path of the place we would normally add something to /tg/, but in our modules folder instead. For example, if you want to add a positive quirk, make the file path `maplestation_modules/code/datums/quirks/good.dm`. If the folder doesn't exist: Make it, and follow this formatting, even if it involves you making a bunch of empty folders.

If you're adding a new file, please add a comment (example below) with a short explanation of what the file is extending or adding.

`// --This file contains mob/living/carbon/human proc extensions.`

VERY IMPORTANT:

After you make your new folder with your new .dm file, you need to add it to OUR dme. DO NOT ADD IT TO TGSTATION.DME. You need to add it to maplestation.dme in alphabetical order - VSCODE will do this automatically if you tick the file.

## ...a minor change to a pre-existing object, datum, etc.:

If you want to add a behavior to an existing item or object, you should hook onto it in a new file, instead of adding it to the pre-existing one.

For example, if I have an object `foo_bar` and want to make it do a flip when it's picked up, create a NEW FILE named `foo_bar.dm` in our module folder and add the `cool_flip` proc definition and code in that file. Then, you can call the proc `cool_flip` from `foo_bar/attack` proc in the main file if it already has one defined, or add a `foo_bar/attack` to your new file if it doesn't. Keep as much code as possible in the module files and out of /tg/ files for our sanity.

## ...big balance/code changes to /tg/ files:

Oh boy. This is where it gets annoying.
You CAN override existing object variable and definitions easily, but adding sweeping changes to multiple procs is more difficult.
Modules exist to minimize merge conflicts with the upstream, but if you want to change the main files then we can't just use modules in most cases.

First: I recommend trying to make the change to the upstream first to save everyone's headaches.
If your idea doesn't have a chance in hell of getting merged to the upstream, or you really don't want to deal with the upstream git, then feel free to PR it here instead, but take a few precautions:

- Keep your changes to an absolute minimum. Touch as few lines and as few files as possible.

- Add a comment before and after your changed code so the spot is known in the future that something was changed.
Something like so:
```
var/epic_variable = 3 // NON-MODULE CHANGE
```

```
// NON-MODULE CHANGE START
/obj/foo/bar/proc/do_thing()
	to_chat(world, "I added a proc to something")
	qdel(src)
// NON-MODULE CHANGE END
```

- What DOES matter: The formatting of the first part of the comment! The comment MUST start with `// NON-MODULE`, space included, exact number of forward slashes, capitalized.
- What doesnt matter: what follows above. `// NON-MODULE CHANGE`, `// NON-MODULE CHANGE START`, `// NON-MODULE CHANGES`, `// NON-MODULE CHANGE: I did stuff`
## ...custom things to vendors:

Go to `maplestation_modules/code/modules/vending/_vending.dm` and use the template provided to add or remove items from vendors. Follow the provided template there.

## ...defines:

Defines can only be seen by files if it's been compiled beforehand.
- Add any defines you need to use across multiple files to `maplestation_modules/code/__DEFINES/_module_defines`
- Add any defines you need just in that file to the top of the file - make sure to undef it at the end.
- Add any defines you need to use in core files to their respective core define files, but be sure to comment it.

## ...maps:

Editing the main maps is STRICTLY PROHIBITED! Any PRs that touch Delta, Meta, Ice Box, Tram or Kilo will be closed.
Do not copy maps either to circumvent this.
Reguardless of what map you make, you are REQUIRED TO ADD [MDB IGNORE] to your PR title.

But what if I..

Want to make a station?
- You WILL be required to maintain it, and will be added to codeowners as the owner of the map. Failure to do so will result in the soft removal until its completely removed from the code.
- Do not make a PR with a giant commit that is the staton. Please for your sanity and ours, splice it up.
- If you need a guide, follow one of TGs main maps, or one of ours for our modular differences.

Want to make a ruin?
- Any changes per the upstream you will be required to update.
- Unlike stations, which will recieve the most and heavy hitting changes, maintaining a small ruin will be more lax in comparission. However, you will still be held accountable for updaating and maintaing your map.
- Ruins related maps are extempt from being added as a codeowner.

# Important other notes:

This module system edits the launch.json and the build.bat files so VSCODE can compile with this codebase. This might cause problems in the future if either are edited to any extent. Luckily the vscode edits are not necessary for compiling the project and and reasy to redo, so just overrite the changes if it causes conflicts.

# Upstream merge:

The time has come for doom. Pull from upstream and pray. Before you make your PR, you are REQUIRED to add [MDB IGNORE] and [IDB IGNORE] in your PRs title, this stops the Map Diff bot from rendering.

- Run ./_merge_driver.bash from gitbash (or any bash terminal, I guess) This will do a few things:
	- A list of all unticked files in the code directory will be printed.
		- Either delete the unticked files, or leave them if you desire.
	- All files with merge conflict markers will be parsed through.
		- All JSON files with merge conflicts will need to be resolved manually.
		- All JS and DM files that don't have a modular comment will have its merge conflicts automatically resolved.
		- All JS and DM files with a modular comment will need to be resolved manually.
	- maplestation.dme will be updated to tgstation.dme automatically.
	- build.js, if it was changed, will attempt to update automatically. Merge conflicts may persist in the file.
- After the merge driver is ran, minor maintenance and resolving merge conflicts will be expected. Then, it's done.

Everything should be set to try to compile. If there are errors, try to solve them. If it compiles and the game itself seems wonky, then call your local coder and cry.

- Make sure that (to maintainers and Jolly) the commit message is not the garbled mess that it is. Change it. Please.

# Files that have 'non-module' comments in the main code:

To prevent me from accidentally accept incoming on files with module changes, I'm doing this for the future.

- code\__DEFINES\chat.dm
- code\__DEFINES\DNA.dm
- code\__DEFINES\is_helpers.dm
- code\__DEFINES\reagents.dm
- code\__DEFINES\say.dm
- code\__HELPERS\global_lists.dm
- code\__HELPERS\icons.dm
- code\__HELPERS\mobs.dm
- code\controllers\subsystem\id_access.dm
- code\controllers\subsystems\job.dm
- code\controllers\subsystem\mapping.dm
- code\controllers\subsystem\vote.dm
- code\datums\chatmessage.dm
- code\datums\datacore.dm
- code\datums\dna.dm
- code\datums\id_trim\jobs.dm
- code\datums\mapgen\Cavegens\LavalandGenerator.dm
- code\datums\greyscale\json_configs\plushie_lizard.json
- code\game\world.dm
- code\game\gamemodes\objective_items.dm
- code\game\machinery\computer\crew.dm
- code\game\machinery\computer\medical.dm
- code\game\machinery\computer\security.dm
- code\game\objects\items\devices\PDA\PDA.dm
- code\game\objects\items\plushes.dm
- code\game\objects\items\scanners.dm
- code\modules\admin\create_mob.dm
- code\modules\antagonists\eldritch_cult\eldritch_effects.dm
- code\modules\antagonists\eldritch_cult\eldritch_knowledge.dm
- code\modules\antagonists\traitor\datum_traitor.dm
- code\modules\client\client_procs.dm
- code\modules\client\preferences_savefile.dm
- code\modules\client\preferences_toggles.dm
- code\modules\client\preferences.dm
- code\modules\clothing\under\_under.dm
- code\modules\food_and_drinks\drinks\drinks.dm
- code\modules\food_and_drinks\drinks\drinks\bottle.dm
- code\modules\food_and_drinks\recipes\drinks_recipes.dm
- code\modules\jobs\jobs.dm
- code\modules\jobs\job_types\_job.dm
- code\modules\jobs\job_types\cargo_technician.dm
- code\modules\jobs\job_types\head_of_personnel.dm
- code\modules\jobs\job_types\lawyer.dm
- code\modules\jobs\job_types\research_director.dm
- code\modules\jobs\job_types\scientist.dm
- code\modules\jobs\job_types\shaft_miner.dm
- code\modules\jobs\job_types\quartermaster.dm
- code\modules\language\language_holder.dm
- code\modules\mob\dead\new_player\new_player.dm
- code\modules\mob\living\damage_procs.dm
- code\modules\mob\living\living_defense.dm
- code\modules\mob\living\carbon\human\human.dm
- code\modules\mob\living\carbon\human\human_update_icons.dm
- code\modules\mob\living\carbon\human\species.dm
- code\modules\mob\living\carbon\human\species_types\golems.dm
- code\modules\modular_computers\file_system\programs\jobmanagement.dm
- code\modules\reagents\chemistry\reagents\other_reagents.dm
- code\modules\surgery\bodyparts\_bodyparts.dm
- code\modules\surgery\bodyparts\dismemberment.dm
- code\modules\surgery\bodyparts\helpers.dm
- code\modules\surgery\organs\lungs.dm
- code\modules\surgery\organs\tongue.dm
- code\modules\unit_tests\heretic_knowledge.dm

# Interface files with non-module comments
- interface\interface.dm
- interface\skin.dmf

# Tools with non-module comments
- tgui\packages\tgui\index.js
- tgui\packages\tgui-panel\chat\constants.js
