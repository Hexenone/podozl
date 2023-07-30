//this is to ensure gibbing drops the chest, which i think is cool
/mob/living/carbon/spread_bodyparts()
	for(var/zone in ALL_BODYPARTS_ORDERED)
		var/obj/item/bodypart/bodypart = get_bodypart(zone)
		if(bodypart?.drop_limb())
			bodypart.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)
	var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
	if(chest)
		chest.drop_limb(TRUE)
		chest.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)

/mob/living/carbon/spill_organs(no_brain, no_organs, no_bodyparts)
	for(var/obj/item/organ/organ as anything in internal_organs)
		organ.plane = initial(organ.plane)
		organ.layer = initial(organ.layer)
		organ.mouse_opacity = initial(organ.mouse_opacity)
		if(organ.maptext)
			organ.maptext = ""
	return ..()

/mob/living/carbon/death(gibbed)
	. = ..()
	// We're dead - We can't have a pulse!
	pulse = PULSE_NONE
	for(var/thing in getorganslotlist(ORGAN_SLOT_HEART))
		var/obj/item/organ/heart/heart = thing
		heart.Stop()
	SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "died", /datum/mood_event/died)
	if(!HAS_TRAIT(src, TRAIT_FRAGGOT))
		if(!iswillet(src))
			for(var/mob/living/carbon/human/H in range(src))
				if(H != src && (src in view(H)))
					if(GET_MOB_SKILL_VALUE(H, SKILL_MEDICINE) > ATTRIBUTE_MIDDLING)
						SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "saw_dead", /datum/mood_event/saw_dead)
					else
						SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "saw_dead", /datum/mood_event/saw_dead/lesser)
	// Shit yourself
	if(!QDELETED(src))
		if(prob(80))
			shit(FALSE)
		if(prob(80))
			piss(FALSE)

/mob/living/carbon/revive(full_heal, admin_revive, excess_healing)
	. = ..()
	// We are alive - We need our pulse back!
	set_heartattack(FALSE)
