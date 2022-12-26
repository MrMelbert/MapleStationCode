<!-- Hi! Thanks for contributing to our code! Please make sure to check the check list below. -->
<!-- Please make sure that modularity is in order to prevent headaches later. For more information, check the README.md in /maplestation_modules/ -->

## CHECK LIST

1. **If you're adding new code**... Make sure it compiles and is tested. Any changes made to /tg/station files should either be modularized out if possible, or otherwise have `// NON-MODULE CHANGE` appended.
2. **If you're adding sounds or sprites**... Including a picture of the new sprites or clips of new sounds is more than appreciated. If you've modified /tg/station DMI icons, either move them to our modules subfolder or accept they will be overridden next update.
3. **If you're mapping**... Including screenshots of changes is preferred. Avoid editing /tg/station map files unless you are okay with them being overridden next update.
4. Make sure that any changes to /tg/station files are appended with `// NON-MODULE CHANGE`!
5. If you have any other questions on how to modularize certain aspects, ask. Some things are impossible to split out, like **GAGS configs**, **string files**, and **TGUI interfaces**, so just ensure it's easy to tell modular files apart.
6. Optionally, providing a **unit test** with your feature is an excellent way to ensure it is not broken come next merge.

## MODULARITY
It's important to ALWAYS MAKE SURE to modularize your content! If you need to touch the main game files, ALWAYS use "NON-MODULE" in the comment.
Multi line changes should have "NON-MODULE START / END" to denote the multi line changes, if applicable in succession.
Images added to master .dmi files will be rejected and you will be asked to modularize them, even if you need to copy the master file.
