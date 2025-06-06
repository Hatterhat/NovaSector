/obj/item/gun/ballistic/automatic/pistol/pepperball
	name = "\improper Bolt Pepperball AHG"
	desc = "An incredibly mediocre 'firearm' designed to fire soft pepper balls meant to easily subdue targets."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/pepperball/pepperball.dmi'
	icon_state = "peppergun"
	w_class = WEIGHT_CLASS_SMALL
	custom_premium_price = PAYCHECK_COMMAND * 4
	accepted_magazine_type = /obj/item/ammo_box/magazine/pepperball
	can_suppress = FALSE
	fire_sound = 'sound/effects/pop_expl.ogg'
	rack_sound = 'sound/items/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/pistol/slide_drop.ogg'
	fire_sound_volume = 50

/obj/item/gun/ballistic/automatic/pistol/pepperball/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_BOLT)

/obj/item/gun/ballistic/automatic/pistol/pepperball/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', light_overlay = "flight")

/obj/item/ammo_box/magazine/pepperball
	name = "pistol magazine (pepperball)"
	desc = "A gun magazine filled with balls, the kind that make your face itch. Holds eight rounds."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/pepperball/pepperball.dmi'
	icon_state = "pepperball"
	ammo_type = /obj/item/ammo_casing/pepperball
	caliber = CALIBER_PEPPERBALL
	custom_price = PAYCHECK_CREW * 2
	max_ammo = 8
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/pepperball
	name = "pepperball"
	desc = "A pepperball casing."
	caliber = CALIBER_PEPPERBALL
	projectile_type = /obj/projectile/bullet/pepperball
	harmful = FALSE
	ammo_categories = AMMO_CLASS_NONE

/obj/projectile/bullet/pepperball
	name = "pepperball orb"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/pepperball/projectiles.dmi'
	icon_state = "pepperball"
	damage = 0
	stamina = 5
	shrapnel_type = null
	sharpness = NONE
	embed_data = null
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	var/contained_reagent = /datum/reagent/consumable/condensedcapsaicin
	var/reagent_volume = 5

/obj/projectile/bullet/pepperball/on_hit(atom/target, blocked = 0, pierce_hit)
	if(isliving(target))
		var/mob/living/M = target
		if(M.can_inject())
			var/datum/reagent/R = new contained_reagent
			R.expose_mob(M, VAPOR, reagent_volume)
	. = ..()

/datum/design/pepperballs
	name = "Pepperball Ammo Box"
	id = "pepperballs"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/ammo_box/advanced/pepperballs
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/obj/item/ammo_box/advanced/pepperballs
	name = "pepperball ammo box"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/pepperball/ammoboxes.dmi'
	icon_state = "box10x24"
	desc = "A box of pepper ball rounds, holds eighteen rounds."
	custom_price = PAYCHECK_CREW * 2
	ammo_type = /obj/item/ammo_casing/pepperball
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
	)
	max_ammo = 18
