/mob/dead/new_player/LateChoices()
	var/list/dat = list()
	if(SSlag_switch.measures[DISABLE_NON_OBSJOBS])
		dat += "<div class='notice red' style='font-size: 125%'>Only Observers may join at this time.</div><br>"
	dat += "<div class='notice'>Идёт раунд: [DisplayTimeText(world.time - SSticker.round_start_time)]</div>"
	if(SSshuttle.emergency)
		switch(SSshuttle.emergency.mode)
			if(SHUTTLE_ESCAPE)
				dat += "<div class='notice red'>The village has been evacuated.</div><br>"
			if(SHUTTLE_CALL)
				if(!SSshuttle.canRecall())
					dat += "<div class='notice red'>The village is currently undergoing evacuation procedures.</div><br>"
	for(var/datum/job/prioritized_job in SSjob.prioritized_jobs)
		if(prioritized_job.current_positions >= prioritized_job.total_positions)
			SSjob.prioritized_jobs -= prioritized_job
	dat += "<table><tr><td valign='top'>"
	var/column_counter = 0
	for(var/datum/job_department/department as anything in SSjob.joinable_departments)
		var/department_color = department.latejoin_color
		dat += "<fieldset style='width: 185px; border: 2px solid [department_color]; display: inline'>"
		dat += "<legend align='center' style='color: [department_color]'>[department.department_name]</legend>"
		var/list/dept_data = list()
		for(var/datum/job/job_datum as anything in department.department_jobs)
			if(IsJobUnavailable(job_datum.title, TRUE) != JOB_AVAILABLE)
				continue

			var/command_bold = ""
			if(job_datum.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND)
				command_bold = " command"

			if(job_datum in SSjob.prioritized_jobs)
				dept_data += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'><span class='priority'>[job_datum.title] ([job_datum.current_positions])</span></a>"
			else
				dept_data += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'>[job_datum.title] ([job_datum.current_positions])</a>"
		if(!length(dept_data))
			dept_data += "<span class='nopositions'>No positions open.</span>"
		dat += dept_data.Join()
		dat += "</fieldset><br>"
		column_counter++
		if(column_counter > 0 && !(column_counter % 3))
			dat += "</td><td valign='top'>"
	dat += "</td></tr></table></center>"
	dat += "</div></div>"
	var/datum/browser/popup = new(src, "latechoices", "Выбираю роль", 680, 580)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/dead/new_player/verb/playthis()
	set name = "Play"
	set category = "OOC"

	if(!isnewplayer(src))
		return
	if(!client)
		return
	if(client.ready_char)
		return
	if(client.should_not_play)
		alert("Oh, what a pity... I can't continue my way.")
		return
	if(SSticker.current_state < GAME_STATE_PLAYING)
		alert("The game hasn't started yet.")
		return
	client.name_ch = name_generate()
	if(prob(70))
		client.age_ch = rand(18, 40)
	else
		client.age_ch = rand(18, 100)
	client.ready_char = TRUE
	alert("I remembered who I am!")
	chooseRole()

/mob/dead/new_player/proc/name_generate()
	var/special_name
	var/second_thing = null
	var/third_thing = null
	var/first_thing = pick("Hark", "Sideless", "Mor", "Nok", "Nox", "Garrett", "Haramec", "Enclave", "Vial", "Torner", "Web", "Hvax", "Coiler", "Boyd", "Hex", "Sacrec", "Rave")
	special_name = "[first_thing]"
	if(prob(40))
		second_thing = pick("Moon", "Stone", "Black", "Block")
		special_name = "[first_thing] [second_thing]"
	if(prob(10))
		third_thing = pick("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X")
		if(second_thing)
			special_name = "[first_thing] [second_thing] [third_thing]"
		else
			special_name = "[first_thing] [third_thing]"
	return special_name

/mob/dead/new_player/proc/chooseRole()
	if(!isnewplayer(src))
		return
	if(!client)
		return
	var/rolevich = input("Wait, what role?", "") as text
	switch(rolevich)
		if("Kapnobatai")
			client.role_ch = "kapnobatai"
		if("Asshole")
			client.role_ch = "asshole"
		if("God SMO")
			var/smo = "[global.config.directory]/smo.txt"
			if(ckey in world.file2list(smo))
				client.role_ch = "god smo"
			else
				alert("Donate for this role.")
				client.ready_char = FALSE
				return
			if(GLOB.world_deaths_crazy < 20)
				alert("Not enough deaths in the world.")
				client.ready_char = FALSE
				return
		if("Halbermensch")
			var/number = GLOB.world_deaths_crazy_next
			var/second = GLOB.player_list.len * 2
			if(length(second) > number)
				var/hal = "[global.config.directory]/hal.txt"
				if(ckey in world.file2list(hal))
					client.role_ch = "halbermensch"
				else
					alert("Donate for this role.")
					client.ready_char = FALSE
					return
			else
				alert("Deaths are not balanced.")
				client.ready_char = FALSE
				return
//			if(GLOB.world_deaths_crazy < 20)
//				alert("Not enough deaths in the world.")
//				client.ready_char = FALSE
//				return
		else
			alert("Unclear. The role of the common Kapnobatai.")
			client.role_ch = "kapnobatai"
	dolboEbism()

/mob/dead/new_player/proc/dolboEbism()
	var/crazyalert = alert("Or maybe there was another role?",,"Let's continue!","Yes, it seems like a different role...")
	switch(crazyalert)
		if("Let's continue!")
			for(var/obj/effect/landing/spawn_point as anything in GLOB.jobber_list)
				if(client)
					if(spawn_point.name == client.role_ch)
						if(spawn_point.spending > 0)
							if(client.role_ch != "halbermensch")
								spawn_point.spending--
								var/mob/living/carbon/human/character = new(pick(spawn_point.loc))
								important(character)
								things(character)
								things_two(character)
								qdel(src)
								updateshit(character)
							else
								spawn_point.spending--
								var/mob/living/carbon/human/species/halbermensch/character = new(pick(spawn_point.loc))
								important(character)
								things(character)
								things_two(character)
								qdel(src)
								updateshit(character)
						else
							alert("No more slots.")
							client.ready_char = FALSE
							return FALSE
		if("Yes, it seems like a different role...")
			client.ready_char = FALSE
			return FALSE

/mob/dead/new_player/proc/important(mob/living/carbon/human/our)
	our.gender = MALE
	our.genitals = GENITALS_MALE
	our.body_type = MALE
	our.chat_color = ""
	our.real_name = client.name_ch
	our.name = our.real_name
	our.age = client.age_ch
	our.handed_flags = DEFAULT_HANDEDNESS
	our.fully_heal(TRUE)

/mob/dead/new_player/proc/things(mob/living/carbon/human/our)
	switch(client.role_ch)
		if("kapnobatai")
			our.truerole = "Kapnobatai"
			our.pod_faction = "kapnobatai"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
		if("asshole")
			our.truerole = "Asshole"
			our.pod_faction = "asshole"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
		if("halbermensch")
			our.real_name = "Halbermensch"
			our.pod_faction = null
			our.truerole = "Halbermensch"
			our.pod_faction = null
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
			our.kaotiks_body = 100
		if("god smo")
			our.truerole = "God SMO"
			our.pod_faction = "god smo"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#ff0aff")
			our.kaotiks_body = 100
			our.real_name = "God SMO"
			our.name = our.real_name
			our.height = HUMAN_HEIGHT_TALLEST
	switch(our.truerole)
		if("Kapnobatai")
			var/mutable_appearance/appearance = mutable_appearance('modular_septic/icons/mob/human/overlays/signs.dmi', "kapno", ROLES_LAYER)
			our.add_overlay(appearance)
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/kapno)
			if(prob(10))
				our.equipOutfit(/datum/outfit/kapnofather)
				our.special_zvanie = "Kapnobataes Father"
			else
				our.equipOutfit(/datum/outfit/kapno)
		if("Asshole")
			var/mutable_appearance/appearance = mutable_appearance('modular_septic/icons/mob/human/overlays/signs.dmi', "konch", ROLES_LAYER)
			our.add_overlay(appearance)
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/konch)
			if(prob(10))
				our.equipOutfit(/datum/outfit/mostkonch)
				our.special_zvanie = "The Most Asshole"
			else
				our.equipOutfit(/datum/outfit/konch)
		if("God SMO")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/svogod)
			our.equipOutfit(/datum/outfit/svogod)

/mob/dead/new_player/proc/updateshit(mob/living/carbon/human/our)
	var/datum/component/babble/babble = our.GetComponent(/datum/component/babble)
	if(!babble)
		switch(our.truerole)
			if("Kapnobatai")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/plimpus.ogg')
			if("Asshole")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_male.ogg')
			if("Halbermensch")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/mobs_yes/babble/halber.ogg')
			else
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_agender.ogg')
	else
		switch(our.truerole)
			if("Kapnobatai")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/plimpus.ogg'
			if("Asshole")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_male.ogg'
			if("Halbermensch")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/mobs_yes/babble/halber.ogg')
			else
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_agender.ogg'
		babble.volume = BABBLE_DEFAULT_VOLUME
		babble.duration = BABBLE_DEFAULT_DURATION

	our.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	var/area/joined_area = get_area(our.loc)
	if(joined_area)
		joined_area.on_joining_game(our)
	for(var/obj/item/organ/genital/genital in our.internal_organs)
		genital.build_from_dna(our.dna, genital.mutantpart_key)
	for(var/obj/item/organ/plushp in our.internal_organs)
		plushp.maxHealth += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	for(var/obj/item/bodypart/plusbodyhp as anything in our.bodyparts)
		plusbodyhp.max_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
		plusbodyhp.max_stamina_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	our.gain_extra_effort(1, TRUE)
	to_chat(our, span_dead("I keep looking for my right way."))
	our.playsound_local(our, 'modular_pod/sound/eff/podpol_hello.ogg', 90, FALSE)
	our.cursings()
	if(our.special_zvanie)
		switch(our.special_zvanie)
			if("Kapnobataes Father")
				to_chat(our, span_yellowteamradio("I'm Kapnobataes Father!"))
			if("The Most Asshole")
				to_chat(our, span_yellowteamradio("I'm The Most Asshole!"))
	our.dna.features["body_size"] = BODY_SIZE_NORMAL
	our.dna.update_body_size()
	our.dna.update_dna_identity()
	our.attributes?.update_attributes()
	our.regenerate_icons()

/mob/dead/new_player/proc/things_two(mob/living/carbon/human/our)
	var/eye_coloring = pick("#000000", "#1f120f")
	switch(client.role_ch)
		if("asshole")
			eye_coloring = "#c30000"
	for(var/obj/item/organ/eyes/organ_eyes in our.internal_organs)
		if(organ_eyes.current_zone == BODY_ZONE_PRECISE_L_EYE)
			our.left_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_LEFT_EYE_COLOR_BLOCK)
		else
			our.right_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_RIGHT_EYE_COLOR_BLOCK)
	mind.active = FALSE
	mind.transfer_to(our)
	mind.set_original_character(our)
	our.key = key

/datum/outfit/kapno
	name = "Kapno Uniform"

	l_pocket = /obj/item/key/podpol/woody/kapnodvorkey
	uniform = /obj/item/clothing/under/codec/purp
	pants = /obj/item/clothing/pants/codec/purp
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/roba

/datum/outfit/kapnofather
	name = "Kapnofather Uniform"

	uniform = null
	r_pocket = /obj/item/key/podpol/woody/kapnokey
	l_pocket = /obj/item/key/podpol/woody/kapnodvorkey
	belt = /obj/item/podpol_weapon/sword/steel
	suit = /obj/item/clothing/suit/armor/roba
	oversuit = /obj/item/clothing/suit/armor/vest/bulletproofer
	pants = /obj/item/clothing/pants/codec/purp/red
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/helmet/codec/def_yel

/datum/outfit/konch
	name = "Konch Uniform"

	l_pocket = /obj/item/key/podpol/woody/konchkey
	r_pocket = /obj/item/reagent_containers/pill/carbonylmethamphetamine
	uniform = /obj/item/clothing/under/codec/purp/black
	pants = /obj/item/clothing/pants/codec/purp/black
	shoes = /obj/item/clothing/shoes/jackboots

/datum/outfit/mostkonch
	name = "Mostkonch Uniform"

	mask = /obj/item/clothing/mask/gas/ballisticarmor
	l_pocket = /obj/item/key/podpol/woody/konchkey
	uniform = /obj/item/clothing/under/codec/purp/black
	pants = /obj/item/clothing/pants/codec/purp/black
	shoes = /obj/item/clothing/shoes/jackboots
//	belt = /obj/item/melee/bita/cep/iron
	r_hand = /obj/item/melee/bita/hammer/sledge
	suit = /obj/item/clothing/suit/armor/vest/chainmail/steel
	back = /obj/item/melee/shieldo/buckler/wooden

/datum/outfit/svogod
	name = "Svogod Uniform"

	r_hand = /obj/item/podpol_weapon/axe/big
	l_hand = /obj/item/melee/hehe/pickaxe/iron
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/bulletproofer
	back = /obj/item/storage/belt/military/itobe/svo
	suit_store = /obj/item/gun/ballistic/automatic/remis/svd
