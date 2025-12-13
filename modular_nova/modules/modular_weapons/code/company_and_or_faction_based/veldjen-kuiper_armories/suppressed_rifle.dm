// Suppressed rifles firing 12mm sub-sonics, funny

/obj/item/gun/ballistic/automatic/sol_suppressed
	name = "\improper Yari suppressed rifle"
	desc = "A special heavy rifle firing 12mm Chinmoku out of an integrally suppressed barrel. \
		Accepts Chinmoku magazines, which are modified SolFed rifle magazines."

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/veldjen-kuiper_armories/guns48x.dmi'
	icon_state = "yari"

	worn_icon = 'modular_nova/modules/modular_weapons/icons/mob/company_and_or_faction_based/veldjen-kuiper_armories/guns_worn.dmi'
	worn_icon_state = "quietevilgun"

	lefthand_file = 'modular_nova/modules/modular_weapons/icons/mob/company_and_or_faction_based/veldjen-kuiper_armories/guns_lefthand.dmi'
	righthand_file = 'modular_nova/modules/modular_weapons/icons/mob/company_and_or_faction_based/veldjen-kuiper_armories/guns_righthand.dmi'
	inhand_icon_state = "quietevilgun"

	SET_BASE_PIXEL(-8, 0)

	special_mags = TRUE

	bolt_type = BOLT_TYPE_LOCKING

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/c12chinmoku
	spawn_magazine_type = /obj/item/ammo_box/magazine/c12chinmoku/standard

	load_sound = 'modular_nova/modules/modular_weapons/sounds/yari/yari_magin.wav'
	rack_sound = 'modular_nova/modules/modular_weapons/sounds/yari/yari_rack.wav'
	fire_sound = 'modular_nova/modules/modular_weapons/sounds/yari/yari.wav'
	suppressed_sound = 'modular_nova/modules/modular_weapons/sounds/yari/yari.wav'
	suppressed = SUPPRESSED_QUIET
	can_suppress = FALSE
	can_unsuppress = FALSE

	pickup_sound = 'modular_nova/modules/modular_weapons/sounds/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_nova/modules/modular_weapons/sounds/pickup_sounds/drop_mediumgun.wav'

	burst_size = 1
	fire_delay = 0.3 SECONDS
	actions_types = list()
	spread = 7.5

	lore_blurb = "The Xhihao Kage series of battle rifles are aftermarket variants of the V-K Blokstaart \
		redesigned for the heavier, subsonic, cased 12mm Chinmoku cartridge, optimized for performance in tight confines.<br>\
		<br>\
		Designed with the needs of special forces who needed an effective, quiet rifle for dangerously close quarters in mind, \
		the Kage series, with its signature shadow-black coating, short barrel, and heavy-duty integrated suppressor, \
		was designed in tandem with and around the 12mm Chinmoku cartridge, which uses faster-burning powder \
		and a heavier projectile for high close-range performance in return for losses in longer-ranged effectiveness. \
		The dimensional similarities between .40 Sol Long and the newly-developed 12mm Chinmoku meant that, \
		with slight modifications to the magazine, standard .40 battle rifle magazines \
		could easily be reused for the new cartridge, causing only slight logistical headaches \
		for quartermasters who supplied both regular infantry and special forces.<br>\
		<br>\
		The specialist focus of the Kage series meant that they were never really meant for civilian sale. \
		The fact that you're seeing one now is perhaps some cause for concern."

	/// Lore specific to this type of gun.
	var/model_specific_lore = "This particular variant is the Yari model, built for general use by special forces operators. \
		The plain glow-sights aren't anything remarkable, but the stock is capable of folding, for very close-in wetwork. \
		The Yari serves its purpose as a stalwart spear for striking down your foes."

/obj/item/gun/ballistic/automatic/sol_suppressed/Initialize(mapload)
	. = ..()
	give_autofire()

/obj/item/gun/ballistic/automatic/sol_suppressed/get_lore_blurb()
	return lore_blurb + "<br><br>" + model_specific_lore

/// Separate proc for handling auto fire just because one of these subtypes isn't otomatica
/obj/item/gun/ballistic/automatic/sol_suppressed/proc/give_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/sol_suppressed/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/sol_suppressed/starts_empty
	spawnwithmagazine = FALSE

// The above rifle but with an underbarrel .980 grenade launcher

/obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher
	name = "\improper Gureibu-GL suppressed rifle"

	desc = "A special rifle firing 12mm Chinmoku out of an integrally suppressed barrel. Uses Chinmoku magazines. \
		This is a version of the Yari rifle that comes with an attached grenade launcher fit for .980 Tydhouer grenades."

	model_specific_lore = "This particular variant is the Gureibu-GL model, a modified version of the Yari \
		built for grenadiers in special forces units. \
		The plain glow-sights are unremarkable, and the stock remains capable of folding for concerningly close quarters, \
		but the underbarrel grenade launcher uses a smart targeting system to configure airburst settings as it's fired. \
		The Gureibu serves its purpose well as both a stalwart spear and a force multiplier, \
		both of which send their enemies to their graves."

	icon_state = "gureibu"

	/// The stored under-barrel grenade launcher for this weapon
	var/obj/item/gun/ballistic/revolver/grenadelauncher/tydhouer/underbarrel

/obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher/try_fire_gun(atom/target, mob/living/user, params)
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		return underbarrel.try_fire_gun(target, user, params)
	return ..()

/obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/ballistic/revolver/grenadelauncher/tydhouer(src)

/obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher/Destroy()
	QDEL_NULL(underbarrel)
	return ..()

/obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isammocasing(tool))
		if(istype(tool, underbarrel.magazine.ammo_type))
			underbarrel.attackby(tool, user, list2params(modifiers))
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isammocasing(tool))
		// is this a .980 grenade?
		if(istype(tool, underbarrel.magazine.ammo_type))
			underbarrel.item_interaction(user, tool, modifiers)
			return ITEM_INTERACT_BLOCKING
	else if(isammobox(tool))
		// is this a .980 grenade box/handful?
		var/obj/item/ammo_box/interacting_box = tool
		if(interacting_box.ammo_type == underbarrel.magazine.ammo_type)
			underbarrel.item_interaction(user, interacting_box, modifiers)
			return ITEM_INTERACT_BLOCKING
		// if not, attack as normal (because we're probably reloading the main gun)
		else
			return ..()
	else
		return ..()

/obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher/starts_empty
	spawnwithmagazine = FALSE

/obj/item/storage/toolbox/guncase/nova/launcher_sol_suppressed
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/sol_suppressed/grenade_launcher
	extra_to_spawn = /obj/item/ammo_box/magazine/c12chinmoku

// The actual grenade launcher for holding .980 grenades in for the rifle

/obj/item/gun/ballistic/revolver/grenadelauncher/tydhouer
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/grenadelauncher/c980grenade
	pin = /obj/item/firing_pin

/obj/item/ammo_box/magazine/internal/grenadelauncher/c980grenade
	name = "grenade launcher tube"
	ammo_type = /obj/item/ammo_casing/c980grenade
	caliber = CALIBER_980TYDHOUER
	start_empty = TRUE

// Variant of the suppressed rifle with a scope and perfect accuracy, also no automatic

/obj/item/gun/ballistic/automatic/sol_suppressed/marksman
	name = "\improper Ransu suppressed marksman rifle"
	desc = "A special heavy marksman rifle firing 12mm Chinmoku out of an integrally suppressed barrel, \
		sacrificing firerate for precision. \
		Uses Chinmoku magazines, which are modified Sol rifle magazines. \
		This one has an expensive scope and other furniture to support more long range action, along with \
		an enhanced rifling system to improve the ranged performance of its heavy, subsonic ammo."

	icon_state = "ransu"

	spawn_magazine_type = /obj/item/ammo_box/magazine/c12chinmoku

	rack_sound = 'modular_nova/modules/modular_weapons/sounds/ransu/ransu_rack.wav'
	fire_sound = 'modular_nova/modules/modular_weapons/sounds/ransu/ransu.wav'
	suppressed_sound = 'modular_nova/modules/modular_weapons/sounds/ransu/ransu.wav'
	can_suppress = TRUE
	can_unsuppress = FALSE

	fire_delay = 0.5 SECONDS
	spread = 0

	projectile_damage_multiplier = 1.5
	recoil = 0.5

	model_specific_lore = "This particular variant is the Ransu model, built for designated marksmen in SolFed's special forces branches. \
		The plain glow-sights are unremarkable, and the heavy stock, unlike other models, is incapable of folding. \
		The added bulk and large scope necessitate the addition of an underbarrel carrying handle, reminiscent of other sniper rifles. \
		The Ransu serves its purpose well as a far-reaching lance, capable of deterring or slaying foes who don't respect a capable marksman."

/obj/item/gun/ballistic/automatic/sol_suppressed/marksman/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

/obj/item/gun/ballistic/automatic/sol_suppressed/marksman/give_autofire()
	return

/obj/item/gun/ballistic/automatic/sol_suppressed/marksman/starts_empty
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/sol_suppressed/marksman/before_firing(atom/target, mob/user)
	// null the spread and damage falloff of fired projectiles
	. = ..()
	chambered.loaded_projectile?.damage_falloff_tile = 0
	chambered.loaded_projectile?.spread = 0

/datum/crafting_recipe/sol_rifle_short_to_chinmoku_short
	name = ".40 Sol Long Rifle Short Mag to 12mm Chinmoku Short Mag Conversion"
	desc = "If, for some reason, you've got a surplus of .40 Sol Long magazines and you have a 12mm Chinmoku firearm, they \
		come with the tools to modify the magazines as needed. \
		This works with any of the Infiltrant series, such as the Yari, Gureibu-GL, and Ransu."
	result = /obj/item/ammo_box/magazine/c12chinmoku/starts_empty
	tool_paths = list(
		/obj/item/gun/ballistic/automatic/sol_suppressed = 1,
	)
	reqs = list(
		/obj/item/ammo_box/magazine/c40sol_rifle = 1,
	)
	steps = list(
		"Empty the .40 Sol magazine",
	)
	time = 15 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/sol_rifle_short_to_chinmoku_short/New()
	..()
	blacklist |= typesof(/obj/item/ammo_box/magazine/c40sol_rifle/standard)

/datum/crafting_recipe/sol_rifle_short_to_chinmoku_short/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/ammo_box/magazine/c40sol_rifle/the_box = collected_requirements[/obj/item/ammo_box/magazine/c40sol_rifle][1]
	if(LAZYLEN(the_box.stored_ammo))
		return FALSE
	return ..()

/datum/crafting_recipe/sol_rifle_std_to_chinmoku_std
	name = ".40 Sol Long Rifle Mag to 12mm Chinmoku Mag Conversion"
	desc = /datum/crafting_recipe/sol_rifle_short_to_chinmoku_short::desc
	result = /obj/item/ammo_box/magazine/c12chinmoku/standard/starts_empty
	tool_paths = list(
		/obj/item/gun/ballistic/automatic/sol_suppressed = 1,
	)
	reqs = list(
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 1,
	)
	steps = list(
		"Empty the .40 Sol magazine",
	)
	time = 15 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/sol_rifle_std_to_chinmoku_std/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/ammo_box/magazine/c40sol_rifle/standard/the_box = collected_requirements[/obj/item/ammo_box/magazine/c40sol_rifle/standard][1]
	if(LAZYLEN(the_box.stored_ammo))
		return FALSE
	return ..()
