/datum/mutation/werewolf
    var/list/old_parts = list()

/datum/mutation/werewolf/proc/transform(mob/living/carbon/dude)
    old_parts = dude.bodyparts.Copy()

    var/list/new_parts = list(
        new /obj/item/bodypart/werewolf_r_leg,
        new /obj/item/bodypart/werewolf_l_arm,
        new /obj/item/bodypart/werewolf_l_leg,
        new /obj/item/bodypart/werewolf_r_arm,
        new /obj/item/bodypart/werewolf_chest,
        new /obj/item/bodypart/werewolf_head,
        new /obj/item/organ/internal/ears/werewolf,
        new /obj/item/organ/internal/eyes/werewolf,
        new /obj/item/organ/internal/tongue/werewolf,
    )
    
    for(var/obj/item/bodypart/new_part as anything in new_parts)
        new_part.replace_limb(dude, TRUE)

/datum/mutation/werewolf/proc/detransform(mob/living/carbon/dude)
    var/list/werewolf_parts = dude.bodyparts.Copy()
    for(var/obj/item/old_part as anything in old_parts)
        old_part.replace_limb(dude, TRUE)
    if(length(old_parts))
        // handle parts which failed to re-attach
    old_parts.Cut()
    for(var/obj/item/werewolf_part as anything in werewolf_parts)
        if(werewolf_part.owner != dude)
            qdel(werewolf_part)
