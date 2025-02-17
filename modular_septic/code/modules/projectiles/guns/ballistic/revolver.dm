/obj/item/gun/ballistic/revolver
	icon = 'modular_septic/icons/obj/items/guns/revolver.dmi'
	icon_state = "revolver"
	base_icon_state = "revolver"
	uncocked_icon_state = TRUE
	cylinder_shows_open = TRUE
	cylinder_shows_ammo_count = TRUE
	bolt_type = BOLT_TYPE_BREAK_ACTION
	bolt_wording = "drum"
	cylinder_wording = "cylinder"
	safety_flags = NONE
	initial_caliber = CALIBER_357
	alternative_caliber = CALIBER_38
	alternative_ammo_misfires = FALSE
	// close cylinder sound
	lock_back_sound = 'modular_septic/sound/weapons/guns/revolver/cylinder_in.ogg'
	// open cylinder sound
	bolt_drop_sound = 'modular_septic/sound/weapons/guns/revolver/cylinder_out.ogg'
	load_sound = 'modular_septic/sound/weapons/guns/revolver/load_bullet.ogg'
	eject_sound = 'modular_septic/sound/weapons/guns/revolver/revolver_eject.ogg'
	drop_sound = 'modular_septic/sound/weapons/guns/drop_lightgun.ogg'
	// hammer sound
	rack_sound = list(
		'modular_septic/sound/weapons/guns/revolver/hammer1.ogg', \
		'modular_septic/sound/weapons/guns/revolver/hammer2.ogg', \
	)
	fire_sound = 'modular_septic/sound/weapons/guns/revolver/revolver_fire.ogg'
	alternative_fire_sound = 'modular_septic/sound/weapons/guns/revolver/revolver_fire.ogg'
	equip_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_holster.ogg'
	pickup_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_draw.ogg'
	dry_fire_sound = 'modular_septic/sound/weapons/guns/revolver/empty_revolver.ogg'
	gunshot_animation_information = list(
		"pixel_x" = 12, \
		"pixel_y" = 5, \
	)
	recoil_animation_information = list(
		"recoil_angle_upper" = -15, \
		"recoil_angle_lower" = -30, \
	)
	client_recoil_animation_information = list(
		"strength" = 0.5,
		"duration" = 2.5,
	)
	w_class = WEIGHT_CLASS_NORMAL
	carry_weight = 1.5 KILOGRAMS
	skill_melee = SKILL_IMPACT_WEAPON
	skill_ranged = SKILL_PISTOL
	tetris_width = 64
	tetris_height = 64

/obj/item/gun/ballistic/revolver/chamber_examine(mob/user)
	. = ..()
	if(can_spin)
		. += "[cylinder_wording] can be spun."

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //mature var names for mature people //What If I'm a child?
	if(magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/revolver/remis

// CATTLE REVOLVER
/obj/item/gun/ballistic/revolver/remis/gado
	name = "\improper Revolver de Gado"
	desc = "An efficient revolver with multiple new systems in-place, if the hammer wasn't enough, there's now a safety exclusively for people who put the gun in their holster way too fast and shoot their own damn leg. \
			It has a unique system for the hammer and cylinder. It's used for slaughtering cattle."
	icon_state = "bladerunner"
	base_icon_state = "bladerunner"
	uncocked_icon_state = FALSE
	fire_sound = list('modular_septic/sound/weapons/guns/revolver/gado1.ogg', 'modular_septic/sound/weapons/guns/revolver/gado3.ogg', 'modular_septic/sound/weapons/guns/revolver/gado3.ogg')
	far_fire_sound = 'mojave/sound/ms13weapons/distant_shots/44_revolver.ogg'
	safety_on_sound = 'modular_septic/sound/weapons/guns/revolver/gado_safetyon.ogg'
	safety_off_sound = 'modular_septic/sound/weapons/guns/revolver/gado_safetyoff.ogg'
	lock_back_sound = 'modular_septic/sound/weapons/guns/revolver/gado_in.ogg'
	// open cylinder sound
	bolt_drop_sound = 'modular_septic/sound/weapons/guns/revolver/gado_out.ogg'
	// hammer sound
	rack_sound = 'modular_septic/sound/weapons/guns/revolver/gado_hammer.ogg'
	gunshot_animation_information = list(
		"pixel_x" = 13, \
		"pixel_y" = 3, \
	)
	recoil_animation_information = list(
		"recoil_angle_upper" = -15,
		"recoil_angle_lower" = -30, \
	)
	client_recoil_animation_information = list(
		"strength" = 0.5,
		"duration" = 2.5,
	)
	safety_flags = GUN_SAFETY_HAS_SAFETY | GUN_SAFETY_ENABLED | GUN_SAFETY_OVERLAY_ENABLED | GUN_SAFETY_OVERLAY_DISABLED
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/gado
	carry_weight = 2 KILOGRAMS

// NAMBU REVOLVER
/obj/item/gun/ballistic/revolver/remis/nova
	name = "Revolver Nova"
	desc = "Old and bizarre."
	icon_state = "newnambu"
	base_icon_state = "newnambu"
	lefthand_file = 'modular_septic/icons/obj/items/guns/inhands/pistol_lefthand.dmi'
	righthand_file = 'modular_septic/icons/obj/items/guns/inhands/pistol_righthand.dmi'
	inhand_icon_state = "newnambu"
	gunshot_animation_information = list(
		"pixel_x" = 13, \
		"pixel_y" = 3, \
	)
	recoil_animation_information = list(
		"recoil_angle_upper" = -10, \
		"recoil_angle_lower" = -25, \
	)
	fire_sound = 'modular_septic/sound/weapons/guns/revolver/nova.ogg'
	far_fire_sound = 'mojave/sound/ms13weapons/distant_shots/huntingrev.ogg'
	alternative_fire_sound = 'modular_septic/sound/weapons/guns/revolver/nova_alt.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/nova
	can_modify_ammo = TRUE
	initial_caliber = CALIBER_38
	carry_weight = 1.5 KILOGRAMS
	semi_auto = FALSE

/obj/item/gun/ballistic/revolver/remis/nova/pluspee
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/nova/pluspee

// Poppy
/obj/item/gun/ballistic/revolver/remis/poppy
	name = ".500 Poppy Revolver"
	desc = "A revolver used in a notorius game of random deathmatch."
	icon_state = "500"
	base_icon_state = "500"
	lefthand_file = 'modular_septic/icons/obj/items/guns/inhands/pistol_lefthand.dmi'
	righthand_file = 'modular_septic/icons/obj/items/guns/inhands/pistol_righthand.dmi'
	inhand_icon_state = "poppy"
	fire_sound = 'modular_septic/sound/weapons/guns/revolver/bigboy.ogg'
	far_fire_sound = 'mojave/sound/ms13weapons/distant_shots/that_gun.ogg'
	alternative_fire_sound = 'modular_septic/sound/weapons/guns/revolver/bigboy.ogg'
	lock_back_sound = 'modular_septic/sound/weapons/guns/revolver/bigboy_in.ogg'
	bolt_drop_sound = 'modular_septic/sound/weapons/guns/revolver/bigboy_out.ogg'
	rack_sound = 'modular_septic/sound/weapons/guns/revolver/bigboy_hammer.ogg'
	gunshot_animation_information = list(
		"pixel_x" = 13, \
		"pixel_y" = 3, \
	)
	recoil_animation_information = list(
		"recoil_angle_upper" = -25, \
		"recoil_angle_lower" = -30, \
	)
	client_recoil_animation_information = list(
		"strength" = 0.8,
		"duration" = 3,
	)
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/poppy
	carry_weight = 3 KILOGRAMS
	semi_auto = FALSE

// P A R A L Y Z E R
/obj/item/gun/ballistic/revolver/remis/paralyzer
	name = "\improper Paralyzer V350"
	desc = "Catch up with the bastard, or run away from him... The choice is yours."
	icon = 'modular_septic/icons/obj/items/guns/energy.dmi'
	icon_state = "paralyzer"
	lefthand_file = 'modular_septic/icons/obj/items/guns/inhands/pistol_lefthand.dmi'
	righthand_file = 'modular_septic/icons/obj/items/guns/inhands/pistol_righthand.dmi'
	inhand_icon_state = "one"
	base_icon_state = "paralyzer"
	uncocked_icon_state = FALSE
	cylinder_shows_open = FALSE
	cylinder_shows_ammo_count = FALSE
	fire_sound = list('modular_septic/sound/weapons/guns/revolver/paralyzer_fire (3).ogg', 'modular_septic/sound/weapons/guns/revolver/paralyzer_fire (2).ogg', 'modular_septic/sound/weapons/guns/revolver/paralyzer_fire (1).ogg')
	far_fire_sound = 'mojave/sound/ms13weapons/distant_shots/plasma_pistol.ogg'
	safety_on_sound = 'modular_septic/sound/weapons/guns/revolver/gado_safetyon.ogg'
	safety_off_sound = 'modular_septic/sound/weapons/guns/revolver/gado_safetyoff.ogg'
	lock_back_sound = 'modular_septic/sound/weapons/guns/revolver/gado_in.ogg'
	// open cylinder sound
	bolt_drop_sound = 'modular_septic/sound/weapons/guns/revolver/gado_out.ogg'
	// hammer sound
	rack_sound = 'modular_septic/sound/weapons/guns/revolver/gado_hammer.ogg'
	gunshot_animation_information = list(
		"pixel_x" = 13, \
		"pixel_y" = 3, \
	)
	recoil_animation_information = list(
		"recoil_angle_upper" = -15,
		"recoil_angle_lower" = -30, \
	)
	client_recoil_animation_information = list(
		"strength" = 0.3,
		"duration" = 2.5,
	)
	safety_flags = GUN_SAFETY_HAS_SAFETY | GUN_SAFETY_ENABLED
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/pulser
	carry_weight = 1 KILOGRAMS
	can_spin = FALSE

/obj/item/gun/ballistic/revolver/remis/paralyzer/empty
//	spawnwithmagazine = FALSE
