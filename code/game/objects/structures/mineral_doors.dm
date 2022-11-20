//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "iron door"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	layer = CLOSED_DOOR_LAYER
	var/locked = FALSE

	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "metal"
	max_integrity = 200
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 10, BIO = 100, FIRE = 50, ACID = 50)
	can_atmos_pass = ATMOS_PASS_DENSITY
	rad_insulation = RAD_MEDIUM_INSULATION

	var/door_opened = FALSE //if it's open or not.
	var/isSwitchingStates = FALSE //don't try to change stats if we're already opening

	var/close_delay = -1 //-1 if does not auto close.
	var/openSound = 'sound/effects/stonedoor_openclose.ogg'
	var/closeSound = 'sound/effects/stonedoor_openclose.ogg'

	var/sheetType = /obj/item/stack/sheet/iron //what we're made of
	var/sheetAmount = 7 //how much we drop when deconstructed

/obj/structure/mineral_door/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE, TRUE)

/obj/structure/mineral_door/Destroy()
	if(!door_opened)
		air_update_turf(TRUE, FALSE)
	. = ..()

/obj/structure/mineral_door/Move()
	var/turf/T = loc
	. = ..()
	if(!door_opened)
		move_update_air(T)

/obj/structure/mineral_door/Bumped(atom/movable/AM)
	..()
	if(!door_opened)
		return TryToSwitchState(AM)

/obj/structure/mineral_door/attack_ai(mob/user) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(iscyborg(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/mineral_door/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/mineral_door/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	return TryToSwitchState(user)

/obj/structure/mineral_door/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /obj/effect/beam))
		return !opacity

/obj/structure/mineral_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates || !anchored)
		return
	if(isliving(user))
		var/mob/living/M = user
		if(world.time - M.last_bumped <= 60)
			return //NOTE do we really need that?
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(ismecha(user))
		SwitchState()

/obj/structure/mineral_door/proc/SwitchState()
	if(door_opened)
		Close()
	else
		Open()

/obj/structure/mineral_door/proc/Open()
	isSwitchingStates = TRUE
	playsound(src, openSound, 100, TRUE)
	set_opacity(FALSE)
	flick("[initial(icon_state)]opening",src)
	sleep(10)
	set_density(FALSE)
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(TRUE, FALSE)
	update_appearance()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, .proc/Close), close_delay)

/obj/structure/mineral_door/proc/Close()
	if(isSwitchingStates || !door_opened)
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		return
	isSwitchingStates = TRUE
	playsound(src, closeSound, 100, TRUE)
	flick("[initial(icon_state)]closing",src)
	sleep(10)
	set_density(TRUE)
	set_opacity(TRUE)
	door_opened = FALSE
	layer = initial(layer)
	air_update_turf(TRUE, TRUE)
	update_appearance()
	isSwitchingStates = FALSE

/obj/structure/mineral_door/update_icon_state()
	icon_state = "[initial(icon_state)][door_opened ? "open":""]"
	return ..()

/obj/structure/mineral_door/attackby(obj/item/I, mob/living/user)
	if(pickaxe_door(user, I))
		return
	//else if(!user.combat_mode) //SEPTIC EDIT REMOVAL
	//SEPTIC EDIT BEGIN
	else if(IS_HELP_INTENT(user, null))
	//SEPTIC EDIT END
		return attack_hand(user)
	else
		return ..()

/obj/structure/mineral_door/set_anchored(anchorvalue) //called in default_unfasten_wrench() chain
	. = ..()
	set_opacity(anchored ? !door_opened : FALSE)
	air_update_turf(TRUE, anchorvalue)

/obj/structure/mineral_door/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 40)
	return TRUE


/////////////////////// TOOL OVERRIDES ///////////////////////


/obj/structure/mineral_door/proc/pickaxe_door(mob/living/user, obj/item/I) //override if the door isn't supposed to be a minable mineral.
	if(!istype(user))
		return
	if(I.tool_behaviour != TOOL_MINING)
		return
	. = TRUE
	to_chat(user, span_notice("You start digging [src]..."))
	if(I.use_tool(src, user, 40, volume=50))
		to_chat(user, span_notice("You finish digging."))
		deconstruct(TRUE)

/obj/structure/mineral_door/welder_act(mob/living/user, obj/item/I) //override if the door is supposed to be flammable.
	..()
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src] is still firmly secured to the ground!"))
		return

	user.visible_message(span_notice("[user] starts to weld apart [src]!"), span_notice("You start welding apart [src]."))
	if(!I.use_tool(src, user, 60, 5, 50))
		to_chat(user, span_warning("You failed to weld apart [src]!"))
		return

	user.visible_message(span_notice("[user] welded [src] into pieces!"), span_notice("You welded apart [src]!"))
	deconstruct(TRUE)

/obj/structure/mineral_door/proc/crowbar_door(mob/living/user, obj/item/I) //if the door is flammable, call this in crowbar_act() so we can still decon it
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src] is still firmly secured to the ground!"))
		return

	user.visible_message(span_notice("[user] starts to pry apart [src]!"), span_notice("You start prying apart [src]."))
	if(!I.use_tool(src, user, 60, volume = 50))
		to_chat(user, span_warning("You failed to pry apart [src]!"))
		return

	user.visible_message(span_notice("[user] pried [src] into pieces!"), span_notice("You pried apart [src]!"))
	deconstruct(TRUE)


/////////////////////// END TOOL OVERRIDES ///////////////////////


/obj/structure/mineral_door/deconstruct(disassembled = TRUE)
	var/turf/T = get_turf(src)
	if(disassembled)
		new sheetType(T, sheetAmount)
	else
		new sheetType(T, max(sheetAmount - 2, 1))
	qdel(src)


/obj/structure/mineral_door/iron
	name = "iron door"
	max_integrity = 300

/obj/structure/mineral_door/silver
	name = "silver door"
	icon_state = "silver"
	sheetType = /obj/item/stack/sheet/mineral/silver
	max_integrity = 300
	rad_insulation = RAD_HEAVY_INSULATION

/obj/structure/mineral_door/gold
	name = "gold door"
	icon_state = "gold"
	sheetType = /obj/item/stack/sheet/mineral/gold
	rad_insulation = RAD_HEAVY_INSULATION

/obj/structure/mineral_door/uranium
	name = "uranium door"
	icon_state = "uranium"
	sheetType = /obj/item/stack/sheet/mineral/uranium
	max_integrity = 300
	light_range = 2

/obj/structure/mineral_door/uranium/ComponentInitialize()
	return

/obj/structure/mineral_door/sandstone
	name = "sandstone door"
	icon_state = "sandstone"
	sheetType = /obj/item/stack/sheet/mineral/sandstone
	max_integrity = 100

/obj/structure/mineral_door/transparent
	opacity = FALSE
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/mineral_door/transparent/Close()
	..()
	set_opacity(FALSE)

/obj/structure/mineral_door/transparent/plasma
	name = "plasma door"
	icon_state = "plasma"
	sheetType = /obj/item/stack/sheet/mineral/plasma

/obj/structure/mineral_door/transparent/plasma/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)

/obj/structure/mineral_door/transparent/plasma/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/transparent/plasma/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature())
		var/turf/T = get_turf(src)
		message_admins("Plasma mineral door ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Plasma mineral door ignited by [key_name(user)] in [AREACOORD(T)]")
		TemperatureAct()
	else
		return ..()

/obj/structure/mineral_door/transparent/plasma/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 300

/obj/structure/mineral_door/transparent/plasma/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	TemperatureAct()

/obj/structure/mineral_door/transparent/plasma/proc/TemperatureAct()
	atmos_spawn_air("plasma=500;TEMP=1000")
	deconstruct(FALSE)

/obj/structure/mineral_door/transparent/diamond
	name = "diamond door"
	icon_state = "diamond"
	sheetType = /obj/item/stack/sheet/mineral/diamond
	max_integrity = 1000
	rad_insulation = RAD_EXTREME_INSULATION

/obj/structure/mineral_door/wood
	name = "wood door"
	icon_state = "wood"
	openSound = 'sound/effects/doorcreaky.ogg'
	closeSound = 'sound/effects/doorcreaky.ogg'
	sheetType = /obj/item/stack/sheet/mineral/wood
	resistance_flags = FLAMMABLE
	max_integrity = 200
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/mineral_door/wood/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/wood/attackby(obj/item/I, mob/living/user)
	if(I.get_temperature())
		fire_act(I.get_temperature())
		return

	return ..()

/obj/structure/mineral_door/paperframe
	name = "paper frame door"
	icon_state = "paperframe"
	openSound = 'sound/effects/doorcreaky.ogg'
	closeSound = 'sound/effects/doorcreaky.ogg'
	sheetType = /obj/item/stack/sheet/paperframes
	sheetAmount = 3
	resistance_flags = FLAMMABLE
	max_integrity = 20

/obj/structure/mineral_door/paperframe/Initialize(mapload)
	. = ..()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/mineral_door/paperframe/examine(mob/user)
	. = ..()
	if(atom_integrity < max_integrity)
		. += span_info("It looks a bit damaged, you may be able to fix it with some <b>paper</b>.")

/obj/structure/mineral_door/paperframe/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/paperframe/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/paperframe/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/paperframe/attackby(obj/item/I, mob/living/user)
	if(I.get_temperature()) //BURN IT ALL DOWN JIM
		fire_act(I.get_temperature())
		return
	/* SEPTIC EDIT REMOVAL
	if((!user.combat_mode) && istype(I, /obj/item/paper) && (atom_integrity < max_integrity))
	*/
	//SEPTIC EDIT BEGIN
	if(IS_HELP_INTENT(user, null) && istype(I, /obj/item/paper) && (atom_integrity < max_integrity))
	//SEPTIC EDIT END
		user.visible_message(span_notice("[user] starts to patch the holes in [src]."), span_notice("You start patching some of the holes in [src]!"))
		if(do_after(user, 2 SECONDS, src))
			atom_integrity = min(atom_integrity+4,max_integrity)
			qdel(I)
			user.visible_message(span_notice("[user] patches some of the holes in [src]."), span_notice("You patch some of the holes in [src]!"))
			return TRUE

	return ..()

/obj/structure/mineral_door/paperframe/ComponentInitialize()
	return

/obj/structure/mineral_door/paperframe/Destroy()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/machinery/door/unpowered/podpol
	name = "Wooden Door"
	icon_state = "wood"
//	sheetType = /obj/item/stack/sheet/mineral/wood
	resistance_flags = FLAMMABLE
	max_integrity = 200
	var/opensound = 'sound/machines/door_open.ogg'
	var/closesound = 'sound/machines/door_close.ogg'
	var/open = FALSE
	var/door_type = "wood"

/obj/machinery/door/unpowered/podpol/open()
	if(!density)
		return TRUE
	if(operating)
		return
	operating = TRUE
	set_opacity(0)
	set_density(FALSE)
	flags_1 &= ~PREVENT_CLICK_UNDER_1
	open = TRUE
	update_appearance()
	set_opacity(0)
	operating = FALSE
	update_freelook_sight()
	playsound(src, (opensound), 50, TRUE)
	return TRUE

/obj/machinery/door/unpowered/podpol/close()
	if(density)
		return TRUE
	if(operating)
		return
	if(safe)
		for(var/atom/movable/M in get_turf(src))
			if(M.density && M != src) //something is blocking the door
				return
	operating = TRUE
	set_density(TRUE)
	flags_1 |= PREVENT_CLICK_UNDER_1
	open = FALSE
	update_appearance()
	if(visible && !glass)
		set_opacity(1)
	operating = FALSE
	update_freelook_sight()
	playsound(src, (closesound), 50, TRUE)
	return TRUE

/obj/machinery/door/unpowered/podpol/update_appearance(updates)
	. = ..()
	if(density)
		icon_state = "[door_type]_closed"
	else
		icon_state = "[door_type]_open"

/obj/machinery/door/unpowered/podpol/try_to_activate_door(mob/living/M)
	add_fingerprint(M)
	if(density)
		open()
	else
		close()
	return TRUE

/obj/machinery/door/unpowered/podpol/attack_hand(mob/living/M)
	if(locked)
		to_chat(M, "<span class='warning'> The [name] is locked.</span>")
		playsound(src, 'mojave/sound/ms13effects/door_locked.ogg', 50, TRUE)
		return
	if(.)
		return
	if(flags_1 & LOCKABLE_1 && lock_locked)
		to_chat(M, span_warning("The [name] is locked."))
		playsound(src, 'mojave/sound/ms13effects/door_locked.ogg', 50, TRUE)
		return
	if(do_after(M, 0.5 SECONDS, interaction_key = DOAFTER_SOURCE_DOORS))
		try_to_activate_door(M)

/obj/machinery/door/unpowered/podpol/attackby(obj/item/I, mob/living/M, params)
	. = ..()
	if(locked && !(M.combat_mode))
		to_chat(M, "<span class='warning'> The [name] is locked.</span>")
		playsound(src, 'mojave/sound/ms13effects/door_locked.ogg', 50, TRUE)
		return
	if(!(I.item_flags & NOBLUDGEON || LOCKING_ITEM) && !(M.combat_mode) && do_after(M, 1.5 SECONDS, interaction_key = DOAFTER_SOURCE_DOORS))
		open = TRUE
		try_to_activate_door(M)
		return TRUE
	if(!open)
		update_overlays()
		return ((obj_flags & CAN_BE_HIT) && I.attack_atom(src, M, params))

/obj/machinery/door/unpowered/podpol/do_animate(animation)
	return

/obj/machinery/door/unpowered/podpol/Bumped(atom/movable/AM)
	return