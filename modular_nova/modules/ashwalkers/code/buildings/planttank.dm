/obj/structure/plant_tank
	name = "plant tank"
	desc = "A small little glass tank that is used to grow plants; this tank promotes the nitrogen and oxygen cycle."
	icon = 'modular_nova/modules/ashwalkers/icons/structures.dmi'
	icon_state = "plant_tank_e"
	anchored = FALSE
	density = TRUE
	///the amount of times the tank can produce-- can be increased through feeding the tank
	var/operation_number = 0
	/// the farm component (if it was added)
	var/datum/component/simple_farm/connected_farm

/obj/structure/plant_tank/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/plant_tank/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/plant_tank/examine(mob/user)
	. = ..()
	. += span_notice("<br>Use food or worm fertilizer to allow nitrogen production and carbon dioxide processing!")
	. += span_notice("There are [operation_number] cycles left!")
	var/datum/component/simple_farm/find_farm = GetComponent(/datum/component/simple_farm)
	if(!find_farm)
		. += span_notice("<br>Use five sand to allow planting!")

/obj/structure/plant_tank/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/food) || istype(tool, /obj/item/stack/worm_fertilizer))
		if(istype(tool, /obj/item/food/tree_fruit))
			return ..()

		if(isstack(tool))
			if(!tool.use(1))
				return ITEM_INTERACT_BLOCKING

		else
			qdel(tool)

		balloon_alert(user, "[tool] placed inside")
		user.mind?.adjust_experience(/datum/skill/primitive, 2)
		operation_number += 2
		if(prob(user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
			operation_number += 2

		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/storage/bag/plants))
		balloon_alert(user, "placing food inside")
		for(var/obj/item/food/selected_food in tool.contents)
			qdel(selected_food)
			operation_number += 2
			if(prob(user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
				operation_number += 2

			user.mind?.adjust_experience(/datum/skill/primitive, 2)

		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/stack/ore/glass))
		if(connected_farm)
			balloon_alert(user, "no more [tool] required")
			return ITEM_INTERACT_BLOCKING

		if(!tool.use(5))
			balloon_alert(user, "farms require five sand")
			return ITEM_INTERACT_BLOCKING

		connected_farm = AddComponent(/datum/component/simple_farm, TRUE, TRUE, list(0, 12))
		icon_state = "plant_tank_f"
		return ITEM_INTERACT_BLOCKING

	return ..()

/obj/structure/plant_tank/process(seconds_per_tick)
	if(operation_number <= 0) //we require "fuel" to actually produce stuff
		return

	if(!locate(/obj/structure/simple_farm) in get_turf(src) && !locate(/obj/structure/simple_tree) in get_turf(src)) //we require a plant to process the "fuel"
		return

	operation_number--

	var/turf/open/src_turf = get_turf(src)
	if(!isopenturf(src_turf) || isspaceturf(src_turf) || src_turf.planetary_atmos) //must be open turf, can't be space turf, and can't be a turf that regenerates its atmos
		return

	var/datum/gas_mixture/src_mixture = src_turf.return_air()

	src_mixture.assert_gases(/datum/gas/carbon_dioxide, /datum/gas/oxygen, /datum/gas/nitrogen)

	var/proportion = src_mixture.gases[/datum/gas/carbon_dioxide][MOLES]
	if(proportion) //if there is carbon dioxide in the air, lets turn it into oxygen
		proportion = min(src_mixture.gases[/datum/gas/carbon_dioxide][MOLES], MOLES_CELLSTANDARD)
		src_mixture.gases[/datum/gas/carbon_dioxide][MOLES] -= proportion
		src_mixture.gases[/datum/gas/oxygen][MOLES] += proportion

	src_mixture.gases[/datum/gas/nitrogen][MOLES] += MOLES_CELLSTANDARD //the nitrogen cycle-- plants (and bacteria) participate in the nitrogen cycle

/obj/structure/plant_tank/wrench_act(mob/living/user, obj/item/tool)
	balloon_alert(user, "[anchored ? "un" : ""]bolting")
	tool.play_tool_sound(src, 50)
	if(!tool.use_tool(src, user, 2 SECONDS))
		return TRUE

	anchored = !anchored
	balloon_alert(user, "[anchored ? "" : "un"]bolted")
	return TRUE

/obj/structure/plant_tank/screwdriver_act(mob/living/user, obj/item/tool)
	balloon_alert(user, "deconstructing")
	tool.play_tool_sound(src, 50)
	if(!tool.use_tool(src, user, 2 SECONDS))
		return TRUE

	deconstruct()
	return TRUE

/obj/structure/plant_tank/atom_deconstruct(disassembled)
	var/target_turf = get_turf(src)
	for(var/loop in 1 to 4)
		new /obj/item/stack/sheet/glass(target_turf)
		new /obj/item/stack/rods(target_turf)
	new /obj/item/forging/complete/plate(target_turf)
	return ..()

/datum/crafting_recipe/plant_tank
	name = "Plant Tank"
	result = /obj/structure/plant_tank
	reqs = list(
		/obj/item/forging/complete/plate = 1,
		/obj/item/stack/sheet/glass = 4,
		/obj/item/stack/rods = 4,
	)
	category = CAT_STRUCTURE
