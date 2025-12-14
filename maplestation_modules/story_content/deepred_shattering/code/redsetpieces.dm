/obj/structure/redtech_indestructable
	name = "redtech setpiece"
	desc = "Report this to a coder."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/setpieces.dmi'
	icon_state = "server_off"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/redtech_indestructable/server_off
	name = "redtech server"
	desc = "A large quantum computing server machine, which seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "server_off"

/obj/structure/redtech_indestructable/heatsink_off
	name = "redtech heatsink"
	desc = "An excessively large heatsink, which thankfully seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "heatsink_off"

/obj/structure/redtech_indestructable/inert_AV
	name = "inert Anti Void"
	desc = "Something has gone terribly wrong."
	icon_state = "inert_AV"

/obj/structure/redtech_indestructable/inert_AV/worse
	icon_state = "inert_AV_worse"

/obj/structure/redtech_indestructable/esoteric_off
	name = "esoteric redtech machinery"
	desc = "An odd piece of machinery which doesn't have a clear purpose, but is deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "esoteric_off"

/obj/structure/redtech_indestructable/dimensional_off
	name = "redtech dimensional lathe"
	desc = "A highly advanced dimensional manipulation device, which seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "dimensional_off"

/obj/structure/redtech_indestructable/singularity_off
	name = "redtech singularity link"
	desc = "A contained multipurpose compression device, which seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "singularity_off"

/obj/effect/step_trigger/linker
	var/targetlink

/obj/effect/step_trigger/linker/Trigger(mob/M)
	if(M.client && targetlink)
		M.client << link(targetlink)
		qdel(src)

/obj/effect/step_trigger/windowlinker
	var/windowlink
	var/windowID

/obj/effect/step_trigger/windowlinker/Trigger(atom/movable/A)
	if(!A || !ismob(A))
		return

	var/mob/M = A
	if(M.client && windowlink && windowID)
		var/windowout = {"
		<html>
			<head>
				<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
				<style>
					body { margin: 0; padding: 0; background: #000; }
					img { display: block; max-width: 100%; max-height: 100vh; margin: auto; }
				</style>
			</head>
			<body>
				<img src='[windowlink]' alt='image'>
			</body>
		</html>
		"}

		M.client << browse(windowout, "window=[windowID];size=1000x1000")
		qdel(src)
