
# MapleStation Modules Folder

## MODULES ARE YOU:

So you want to add content? Then you've come to the right place. I appreciate you for reading this first before jumping in and adding a buncha changes to /tg/ files.

We use module files to separate our added content from /tg/ content to prevent un-necessary and excessive merge conflicts when trying to merge from /tg/.

What does this mean to you? This means if you want to add something, you should add it in THIS FOLDER (maplestation_modules) and not in ANY OF THE OTHER FOLDERS unless absolutly necessary (it usually isn't).

# What if I want to add...

## ...icons to this fork:

ALWAYS add icons to a new .dmi in the `maplestation_modules/icons` folder. Icon are rather difficult for to resolve merge conflicts so we opt to completely override our files on merge. Adding icons can be complicated for things such as jumpsuits and IDs, so be sure to ask for help if it gets confusing.

## ...a one-off object, datum, etc. to this fork:

Create all new content in a new .dm file in the `maplestation_modules/code` folder. For the sake of organization, we attempt to mimic the folder path of the place we would normally add something to /tg/, but in our modules folder instead. For example, if you want to add a positive quirk, make the file path `maplestation_modules/code/datums/quirks/good.dm`. Sometimes it may make sense to put your change somewhere else rather than creating a million empty folders - just use logic and try to leave your changes in places that follow logic.

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

Don't edit /tg/station maps with sweeping changes! Like with icons, map merge conflicts are difficult to resolve, so we simply override the maps with the never versions on updates, so any changes made will be lost.

But what if I want to make a station?
- You will be expected to help maintain it. It's not guaranteed that it will be updated with future changes, which means after updates your map likely will not be playable until fixed.

## ...some other file:

If you made an edit to some other file, like a json or js file in some strange corner of the code base, it would be wise to leave a comment *somewhere* that you did this, otherwise it is very likely your change will be reset automatically.

A good place to leave this comment would be wherever the file is read in its corresponding DM file. If you can't find a good place to put it, just leave it in the readme below.
