<!-- Hi! Thanks for contributing to our code! Please make sure to check the check list below. -->
<!-- Please make sure that modulairty is in order to prevent headaches later. For more information, check the README.md in /maplestation_modules/ -->

## CHECK LIST

1. If you're adding sounds/sprites.. Are they visible in the PR? Are they modular?
2. Did you apply "NON-MODULE" comments to line(s) of code that require it? Did you update the README.md to reflect this too?
3. Pulling from the upstream? Did you make sure to resolve the map, .dmi, modular and any other conflicts? Does it compile? Did you run the merge driver? (Don't forget to accept incoming to tgstation.dme first!)
4. Uploading a map? If its complete.. Did you include images of each department, and a general overview of the map? Uploading it in bits? Include an image per each commit.
5. Confused? Lost? Don't know what you're doing? Ask for help!
6. If you uploaded a map, or are preforming an upstream merge, did you add [MDB IGNORE] and [IDB IGNORE] to your PR title?

## MODULARITY
It's important to ALWAYS MAKE SURE to modularize your content! If you need to touch the main game files, ALWAYS use "NON-MODULE" in the comment.
Multi line changes should have "NON-MODULE START / END" to deonate the multi line changes, if applicable in succession.
Images added to master .dmi files will be rejected and you will be asked to modularize them, even if you need to copy the master file.
