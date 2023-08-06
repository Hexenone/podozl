/mob/living/death(gibbed)
	. = ..()
	if(!QDELETED(src))
		update_shock()
	if(.)
		if(client)
			if(deathsound_local)
				SEND_SOUND(client, deathsound_local)
			SSdroning.kill_droning(client)
	if(HAS_TRAIT(src, TRAIT_FRAGGOT))
		for(var/mob/living/carbon/human/M in range(7, src))
			if(M != src && (src in view(M)))
				to_chat(M, span_achievementrare("I have seen a fatal death! So good!"))
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[src.real_name]", /datum/mood_event/fraggot/killed)

/mob/living/revive(full_heal, admin_revive, excess_healing)
	. = ..()
	update_shock()
