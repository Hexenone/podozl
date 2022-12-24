/* Glass stack types
 * Contains:
 * Glass sheets
 * Reinforced glass sheets
 * Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
GLOBAL_LIST_INIT(glass_recipes, list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("glass shard", /obj/item/shard, time = 0, on_floor = TRUE) \
))

/obj/item/stack/sheet/glass
	name = "glass"
	desc = "HOLY SHEET! That is a lot of glass."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	inhand_icon_state = "sheet-glass"
	mats_per_unit = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/glass
	grind_results = list(/datum/reagent/silicon = 20)
	material_type = /datum/material/glass
	point_value = 1
	tableVariant = /obj/structure/table/glass
	matter_amount = 4
	cost = 500
	source = /datum/robot_energy_storage/glass

/obj/item/stack/sheet/glass/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to slice [user.p_their()] neck with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/stack/sheet/glass/fifty
	amount = 50

/obj/item/stack/sheet/glass/get_main_recipes()
	. = ..()
	. += GLOB.glass_recipes

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if (get_amount() < 1 || CC.get_amount() < 5)
			to_chat(user, "<span class='warning>You need five lengths of coil and one sheet of glass to make wired glass!</span>")
			return
		CC.use(5)
		use(1)
		to_chat(user, span_notice("You attach wire to the [name]."))
		var/obj/item/stack/light_w/new_tile = new(user.loc)
		if (!QDELETED(new_tile))
			new_tile.add_fingerprint(user)
		return
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/rglass/RG = new (get_turf(user))
			if(!QDELETED(RG))
				RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item()==src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace && !QDELETED(RG))
				user.put_in_hands(RG)
		else
			to_chat(user, span_warning("You need one rod and one sheet of glass to make reinforced glass!"))
		return
	return ..()

GLOBAL_LIST_INIT(pglass_recipes, list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/plasma/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/plasma/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("plasma glass shard", /obj/item/shard/plasma, time = 0, on_floor = TRUE) \
))

/obj/item/stack/sheet/plasmaglass
	name = "plasma glass"
	desc = "A glass sheet made out of a plasma-silicate alloy. It looks extremely tough and heavily fire resistant."
	singular_name = "plasma glass sheet"
	icon_state = "sheet-pglass"
	inhand_icon_state = "sheet-pglass"
	mats_per_unit = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plasmaglass
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 75, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plasmaglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/toxin/plasma = 10)
	material_flags = NONE
	tableVariant = /obj/structure/table/glass/plasmaglass

/obj/item/stack/sheet/plasmaglass/fifty
	amount = 50

/obj/item/stack/sheet/plasmaglass/get_main_recipes()
	. = ..()
	. += GLOB.pglass_recipes

/obj/item/stack/sheet/plasmaglass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)

	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/plasmarglass/RG = new (get_turf(user))
			if (!QDELETED(RG))
				RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item()==src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace)
				user.put_in_hands(RG)
		else
			to_chat(user, span_warning("You need one rod and one sheet of plasma glass to make reinforced plasma glass!"))
			return
	else
		return ..()

/*
 * Reinforced glass sheets
 */
GLOBAL_LIST_INIT(reinforced_glass_recipes, list ( \
	new/datum/stack_recipe("windoor frame", /obj/structure/windoor_assembly, 5, time = 0, on_floor = TRUE, window_checks = TRUE), \
	null, \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/reinforced/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/reinforced/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("glass shard", /obj/item/shard, time = 0, on_floor = TRUE) \
))


/obj/item/stack/sheet/rglass
	name = "reinforced glass"
	desc = "Glass which seems to have rods or something stuck in them."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	inhand_icon_state = "sheet-rglass"
	mats_per_unit = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 70, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/rglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/iron = 10)
	point_value = 4
	matter_amount = 6
	tableVariant = /obj/structure/table/reinforced/rglass

/obj/item/stack/sheet/rglass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	..()

/obj/item/stack/sheet/rglass/cyborg
	mats_per_unit = null
	cost = 250
	source = /datum/robot_energy_storage/iron

	/// What energy storage this draws glass from as a robot module.
	var/datum/robot_energy_storage/glasource = /datum/robot_energy_storage/glass
	/// The amount of energy this draws from the glass source per stack unit.
	var/glacost = 500

/obj/item/stack/sheet/rglass/cyborg/get_amount()
	return min(round(source.energy / cost), round(glasource.energy / glacost))

/obj/item/stack/sheet/rglass/cyborg/use(used, transfer = FALSE, check = TRUE) // Requires special checks, because it uses two storages
	if(get_amount(used)) //ensure we still have enough energy if called in a do_after chain
		source.use_charge(used * cost)
		glasource.use_charge(used * glacost)
		return TRUE

/obj/item/stack/sheet/rglass/cyborg/add(amount)
	source.add_charge(amount * cost)
	glasource.add_charge(amount * glacost)

/obj/item/stack/sheet/rglass/get_main_recipes()
	. = ..()
	. += GLOB.reinforced_glass_recipes

GLOBAL_LIST_INIT(prglass_recipes, list ( \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/reinforced/plasma/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/reinforced/plasma/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("plasma glass shard", /obj/item/shard/plasma, time = 0, on_floor = TRUE) \
))

/obj/item/stack/sheet/plasmarglass
	name = "reinforced plasma glass"
	desc = "A glass sheet made out of a plasma-silicate alloy and a rod matrix. It looks hopelessly tough and nearly fire-proof!"
	singular_name = "reinforced plasma glass sheet"
	icon_state = "sheet-prglass"
	inhand_icon_state = "sheet-prglass"
	mats_per_unit = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT, /datum/material/iron = MINERAL_MATERIAL_AMOUNT * 0.5)
	armor = list(MELEE = 20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 80, ACID = 100)
	resistance_flags = ACID_PROOF
	material_flags = NONE
	merge_type = /obj/item/stack/sheet/plasmarglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/toxin/plasma = 10, /datum/reagent/iron = 10)
	point_value = 23
	matter_amount = 8
	tableVariant = /obj/structure/table/reinforced/plasmarglass

/obj/item/stack/sheet/plasmarglass/get_main_recipes()
	. = ..()
	. += GLOB.prglass_recipes

GLOBAL_LIST_INIT(titaniumglass_recipes, list(
	new/datum/stack_recipe("shuttle window", /obj/structure/window/reinforced/shuttle/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("glass shard", /obj/item/shard, time = 0, on_floor = TRUE) \
	))

/obj/item/stack/sheet/titaniumglass
	name = "titanium glass"
	desc = "A glass sheet made out of a titanium-silicate alloy."
	singular_name = "titanium glass sheet"
	icon_state = "sheet-titaniumglass"
	inhand_icon_state = "sheet-titaniumglass"
	mats_per_unit = list(/datum/material/alloy/titaniumglass=MINERAL_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/titaniumglass
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 80, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/titaniumglass
	tableVariant = /obj/structure/table/reinforced/titaniumglass

/obj/item/stack/sheet/titaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.titaniumglass_recipes

GLOBAL_LIST_INIT(plastitaniumglass_recipes, list(
	new/datum/stack_recipe("plastitanium window", /obj/structure/window/reinforced/plasma/plastitanium/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("plasma glass shard", /obj/item/shard/plasma, time = 0, on_floor = TRUE) \
	))

/obj/item/stack/sheet/plastitaniumglass
	name = "plastitanium glass"
	desc = "A glass sheet made out of a plasma-titanium-silicate alloy."
	singular_name = "plastitanium glass sheet"
	icon_state = "sheet-plastitaniumglass"
	inhand_icon_state = "sheet-plastitaniumglass"
	mats_per_unit = list(/datum/material/alloy/plastitaniumglass=MINERAL_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plastitaniumglass
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 80, ACID = 100)
	material_flags = NONE
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plastitaniumglass
	tableVariant = /obj/structure/table/reinforced/plastitaniumglass

/obj/item/stack/sheet/plastitaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.plastitaniumglass_recipes

/obj/item/shard
	name = "shard"
	desc = "A nasty looking shard of glass."
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	w_class = WEIGHT_CLASS_TINY
	force = 5
	throwforce = 10
	inhand_icon_state = "shard-glass"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	custom_materials = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	attack_verb_continuous = list("stabs", "slashes", "slices", "cuts")
	attack_verb_simple = list("stab", "slash", "slice", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	resistance_flags = ACID_PROOF
	armor = list(MELEE = 100, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 0, FIRE = 50, ACID = 100)
	max_integrity = 40
	sharpness = SHARP_EDGED
	var/icon_prefix
	var/obj/item/stack/sheet/weld_material = /obj/item/stack/sheet/glass
	embedding = list("embed_chance" = 65)


/obj/item/shard/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is slitting [user.p_their()] [pick("wrists", "throat")] with the shard of glass! It looks like [user.p_theyre()] trying to commit suicide."))
	return (BRUTELOSS)


/obj/item/shard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = force)
	AddComponent(/datum/component/butchering, 150, 65)
	icon_state = pick("large", "medium", "small")
	switch(icon_state)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)
	if (icon_prefix)
		icon_state = "[icon_prefix][icon_state]"

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/shard/Destroy()
	. = ..()

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)
/*
/obj/item/shard/afterattack(atom/A as mob|obj, mob/user, proximity)
	. = ..()
	if(!proximity || !(src in user))
		return
	if(isturf(A))
		return
	if(istype(A, /obj/item/storage))
		return
	var/hit_hand = ((user.active_hand_index % 2 == 0) ? "r_" : "l_") + "arm"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.gloves && !HAS_TRAIT(H, TRAIT_PIERCEIMMUNE)) // golems, etc
			to_chat(H, span_warning("[src] cuts into your hand!"))
			H.apply_damage(force*0.5, BRUTE, hit_hand)
*/
/obj/item/shard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/lightreplacer))
		var/obj/item/lightreplacer/L = I
		L.attackby(src, user)
	else if(istype(I, /obj/item/stack/sheet/cloth))
		var/obj/item/stack/sheet/cloth/C = I
		to_chat(user, span_notice("You begin to wrap the [C] around the [src]..."))
		if(do_after(user, 35, target = src))
			var/obj/item/knife/shiv/S = new /obj/item/knife/shiv
			C.use(1)
			to_chat(user, span_notice("You wrap the [C] around the [src] forming a makeshift weapon."))
			remove_item_from_storage(src)
			qdel(src)
			user.put_in_hands(S)

	else
		return ..()

/obj/item/shard/welder_act(mob/living/user, obj/item/I)
	..()
	if(I.use_tool(src, user, 0, volume=50))
		var/obj/item/stack/sheet/NG = new weld_material(user.loc)
		for(var/obj/item/stack/sheet/G in user.loc)
			if(G == NG)
				continue
			if(G.amount >= G.max_amount)
				continue
			G.attackby(NG, user)
		to_chat(user, span_notice("You add the newly-formed [NG.name] to the stack. It now contains [NG.amount] sheet\s."))
		qdel(src)
	return TRUE

/obj/item/shard/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(isliving(AM))
		var/mob/living/L = AM
		if(!(L.movement_type & (FLYING|FLOATING)) || L.buckled)
			playsound(src, 'sound/effects/glass_step.ogg', HAS_TRAIT(L, TRAIT_LIGHT_STEP) ? 30 : 50, TRUE)

/obj/item/shard/plasma
	name = "purple shard"
	desc = "A nasty looking shard of plasma glass."
	force = 6
	throwforce = 11
	icon_state = "plasmalarge"
	custom_materials = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "plasma"
	weld_material = /obj/item/stack/sheet/plasmaglass

///obj/item/shard
//	name = "a fucked up retarded weapon"
//	desc = "report thgis to a retard dev if you see it"
//	var/slash_hitsound = list('modular_septic/sound/weapons/melee/kukri1.wav', 'modular_septic/sound/weapons/melee/kukri2.wav', 'modular_septic/sound/weapons/melee/kukri3.wav')
//	var/stab_hitsound = list('modular_septic/sound/weapons/melee/sharp_stab1.ogg', 'modular_septic/sound/weapons/melee/sharp_stab2.ogg')
//	var/bash_hitsound = list('modular_septic/sound/weapons/melee/baton1.wav', 'modular_septic/sound/weapons/melee/baton2.wav', 'modular_septic/sound/weapons/melee/baton3.wav')
//	var/current_atk_mode = null

#define slashh 1
#define stabb 2

/obj/item/shard/crystal
	var/current_atk_mode = slashh
	worn_icon_state = "shard"
//	worn_icon = 'icons/mob/clothing/belt.dmi'
	havedurability = 1
	durability = 50
	force = 8
	wound_bonus = 3
	bare_wound_bonus = 15
	min_force_strength = 1
	force_strength = 1.5
	min_throwforce = 9
	min_throwforce_strength = 8
	throwforce_strength = 1.1
	throwforce = 12
	tetris_width = 32
	tetris_height = 32
	skill_melee = SKILL_KNIFE
	sharpness = SHARP_EDGED
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS
	var/slashh_hitsound = list('modular_septic/sound/weapons/melee/sharpy1.ogg')
	var/stabb_hitsound = list('modular_septic/sound/weapons/melee/stabber1.ogg', 'modular_septic/sound/weapons/melee/stabber2.ogg')

/obj/item/shard/crystal/examine(mob/user)
	. = ..()
	if(current_atk_mode)
		var/attack_text = current_atk_mode == slashh ? "slash" : "stab"
		. += span_info("It's currently ready to [attack_text]")

/obj/item/shard/crystal/attack_self(mob/user, modifiers)
	. = ..()
	swap_intents(user)

/obj/item/shard/crystal/dropped(mob/user, silent)
	. = ..()
	current_atk_mode = initial(current_atk_mode)

/obj/item/shard/crystal/proc/swap_intents(mob/user)
	if(isnull(current_atk_mode))
		to_chat(user, span_warning("There's no other ways to attack with this weapon."))
		return
	user.playsound_local(get_turf(src), 'modular_septic/sound/weapons/melee/swap_intent.ogg', 5, FALSE)

/obj/item/shard/crystal/Initialize(mapload)
	. = ..()
	if(current_atk_mode == slashh)
		hitsound = slashh_hitsound
	if(current_atk_mode == stabb)
		hitsound = stabb_hitsound

/obj/item/shard/crystal/swap_intents(mob/user)
	. = ..()
	switch(current_atk_mode)
		if(slashh)
			to_chat(user, span_notice("I'm now stabbing them with the pointy end of the [src]."))
			hitsound = stabb_hitsound
			current_atk_mode = stabb
			sharpness = SHARP_POINTY
			embedding = list("pain_mult" = 4, "rip_time" = 3, "embed_chance" = 45, "jostle_chance" = 3.5, "pain_stam_pct" = 0.5, "pain_jostle_mult" = 6, "fall_chance" = 0.3)
		if(stabb)
			to_chat(user, span_notice("I'm now slicing them with the harshed side of the [src]."))
			hitsound = slashh_hitsound
			current_atk_mode = slashh
			sharpness = SHARP_EDGED
			embedding = list("pain_mult" = 4, "rip_time" = 3, "embed_chance" = 30, "jostle_chance" = 3, "pain_stam_pct" = 0.5, "pain_jostle_mult" = 8, "fall_chance" = 0.4)

/obj/item/shard/crystal/green
	name = "Green Crystal Shard"
	desc = "A nasty looking shard of green crystal."
	icon_state = "green"
//	custom_materials = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "green"
	light_range = 2
	light_power = 2
	light_color = "#00dd78"
	light_system = MOVABLE_LIGHT
//	weld_material = /obj/item/stack/sheet/plasmaglass

/obj/item/shard/crystal/red
	name = "Red Crystal Shard"
	desc = "A nasty looking shard of red crystal."
	icon_state = "red"
//	custom_materials = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "red"
	light_range = 2
	light_power = 2
	light_color = "#ff460e"
	light_system = MOVABLE_LIGHT
//	weld_material = /obj/item/stack/sheet/plasmaglass

/obj/item/shard/crystal/blue
	name = "Blue Crystal Shard"
	desc = "A nasty looking shard of blue crystal."
	icon_state = "blue"
//	custom_materials = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "blue"
	light_range = 2
	light_power = 2
	light_color = "#008eff"
	light_system = MOVABLE_LIGHT
//	weld_material = /obj/item/stack/sheet/plasmaglass

/obj/item/shard/crystal/purple
	name = "Pink Crystal Shard"
	desc = "A nasty looking shard of pink crystal."
	icon_state = "purple"
//	custom_materials = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "purple"
	light_range = 2
	light_power = 2
	light_color = "#e252ea"
	light_system = MOVABLE_LIGHT
//	weld_material = /obj/item/stack/sheet/plasmaglass


