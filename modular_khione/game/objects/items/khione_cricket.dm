/obj/item/khione_cricket
	name = "cricket"
	desc = "You found the cricket!"
	icon = 'icons/obj/weapons/guns/ammo.dmi'
	icon_state = "s-casing"
	worn_icon_state = "bullet"
	w_class = WEIGHT_CLASS_TINY
	color = "#996633"
	layer = 2

	/// Which noise loop is this cricket using? Used in Initialize().
	var/noise_type = 1
	/// Soundloop we use of a cricket chirping. Default type makes noise loop one.
	var/datum/looping_sound/cricket/soundloop

/obj/item/khione_cricket/Initialize(mapload)
	. = ..()
	switch(noise_type)
		if (1)
			soundloop = new /datum/looping_sound/cricket/one(src, TRUE)
		if (2)
			soundloop = new /datum/looping_sound/cricket/two(src, TRUE)
		if (3)
			soundloop = new /datum/looping_sound/cricket/three(src, TRUE)

/obj/item/khione_cricket/Destroy(force)
	soundloop.stop()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/khione_cricket/examine(mob/user)
	. = ..()
	. += span_info("It won't shut up!!")

/obj/item/khione_cricket/two
	noise_type = 2

/obj/item/khione_cricket/three
	noise_type = 3
