<<<<<<< HEAD
<!-- Hi! Thanks for contributing to our code! Please make sure to check the check list below. -->
<!-- Please make sure that modulairty is in order to prevent headaches later. For more information, check the README.md in /jollystation_modules/ -->

## CHECK LIST

1. If you're adding sounds/sprites.. Are they visible in the PR? Are they modular?
2. Did you apply "NON-MODULE" comments to line(s) of code that require it? Did you update the README.md to reflect this too?
3. Pulling from the upstream? Did you make sure to resolve the map, .dmi, modular and any other conflicts? Does it compile? Did you run the merge driver? (Don't forget to accept incoming to tgstation.dme first!)
4. Uploading a map? If its complete.. Did you include images of each department, and a general overview of the map? Uploading it in bits? Include an image per each commit.
5. Confused? Lost? Don't know what you're doing? Ask for help!
6. If you uploaded a map, or are preforming an upstream merge, did you add [MDB IGNORE] to your PR title?

## MODULARITY
It's important to ALWAYS MAKE SURE to modularize your content! If you need to touch the main game files, ALWAYS use "NON-MODULE" in the comment.
Multi line changes should have "NON-MODULE START / END" to deonate the multi line changes, if applicable in succession.
Images added to master .dmi files will be rejected and you will be asked to modularize them, even if you need to copy the master file.
=======
<!-- Write **BELOW** The Headers and **ABOVE** The comments else it may not be viewable. -->
<!-- You can view Contributing.MD for a detailed description of the pull request process. -->

## About The Pull Request

<!-- Describe The Pull Request. Please be sure every change is documented or this can delay review and even discourage maintainers from merging your PR! -->

## Why It's Good For The Game

<!-- Please add a short description of why you think these changes would benefit the game. If you can't justify it in words, it might not be worth adding. -->

## Changelog

<!-- If your PR modifies aspects of the game that can be concretely observed by players or admins you should add a changelog. If your change does NOT meet this description, remove this section. -->

:cl:
add: Added new mechanics or gameplay changes
add: Added more things
expansion: Expands content of an existing feature
del: Removed old things
qol: made something easier to use
balance: rebalanced something
fix: fixed a few things
soundadd: added a new sound thingy
sounddel: removed an old sound thingy
imageadd: added some icons and images
imagedel: deleted some icons and images
spellcheck: fixed a few typos
code: changed some code
refactor: refactored some code
config: changed some config setting
admin: messed with admin stuff
server: something server ops should know
/:cl:

<!-- Both :cl:'s are required for the changelog to work! You can put your name to the right of the first :cl: if you want to overwrite your GitHub username as author ingame. -->
<!-- You can use multiple of the same prefix (they're only used for the icon ingame) and delete the unneeded ones. Despite some of the tags, changelogs should generally represent how a player might be affected by the changes rather than a summary of the PR's contents. -->
>>>>>>> remotes/tg/master
