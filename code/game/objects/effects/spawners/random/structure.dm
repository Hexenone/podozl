/obj/effect/spawner/random/structure
	name = "structure spawner"
	desc = "Now you see me, now you don't..."

/obj/effect/spawner/random/structure/crate
	name = "crate spawner"
	icon_state = "crate"
	loot = list(
		/obj/effect/spawner/random/structure/crate_loot = 745,
		/obj/structure/closet/crate/trashcart/filled = 75,
		/obj/effect/spawner/random/trash/moisture_trap = 50,
		/obj/effect/spawner/random/trash/hobo_squat = 30,
		/obj/structure/closet/mini_fridge = 35,
		/obj/effect/spawner/random/trash/mess = 30,
		/obj/item/kirbyplants/fern = 20,
		/obj/structure/closet/crate/decorations = 15,
	)

/obj/effect/spawner/random/structure/crate_abandoned
	name = "locked crate spawner"
	icon_state = "crate_secure"
	spawn_loot_chance = 20
	loot = list(/obj/structure/closet/crate/secure/loot)

/obj/effect/spawner/random/structure/girder
	name = "girder spawner"
	icon_state = "girder"
	loot = list(
		/obj/structure/girder = 4,
		/obj/structure/girder/displaced = 1,
	)

/obj/effect/spawner/random/structure/grille
	name = "grille spawner"
	icon_state = "grille"
	loot = list(
		/obj/structure/grille = 4,
		/obj/structure/grille/broken = 1,
	)

/obj/effect/spawner/random/structure/furniture_parts
	name = "furniture parts spawner"
	icon_state = "table_parts"
	loot = list(
		/obj/structure/table_frame,
		/obj/structure/table_frame/wood,
		/obj/item/rack_parts,
	)

/obj/effect/spawner/random/structure/table_or_rack
	name = "table or rack spawner"
	icon_state = "rack_parts"
	loot = list(
		/obj/effect/spawner/random/structure/table,
		/obj/structure/rack,
	)

/obj/effect/spawner/random/structure/table
	name = "table spawner"
	icon_state = "table"
	loot = list(
		/obj/structure/table = 40,
		/obj/structure/table/wood = 30,
		/obj/structure/table/glass = 20,
		/obj/structure/table/reinforced = 5,
		/obj/structure/table/wood/poker = 5,
	)

/obj/effect/spawner/random/structure/table_fancy
	name = "table spawner"
	icon_state = "table_fancy"
	loot_type_path = /obj/structure/table/wood/fancy
	loot = list()

/obj/effect/spawner/random/structure/tank_holder
	name = "tank holder spawner"
	icon_state = "tank_holder"
	loot = list(
		/obj/structure/tank_holder/oxygen = 40,
		/obj/structure/tank_holder/extinguisher = 40,
		/obj/structure/tank_holder = 20,
		/obj/structure/tank_holder/extinguisher/advanced = 1,
	)

/obj/effect/spawner/random/structure/crate_empty
	name = "empty crate spawner"
	icon_state = "crate"
	loot = list(
		/obj/structure/closet/crate = 20,
		/obj/structure/closet/crate/wooden = 1,
		/obj/structure/closet/crate/internals = 1,
		/obj/structure/closet/crate/medical = 1,
		/obj/structure/closet/crate/freezer = 1,
		/obj/structure/closet/crate/radiation = 1,
		/obj/structure/closet/crate/hydroponics = 1,
		/obj/structure/closet/crate/engineering = 1,
		/obj/structure/closet/crate/engineering/electrical = 1,
		/obj/structure/closet/crate/science = 1,
	)

/obj/effect/spawner/random/structure/crate_loot
	name = "lootcrate spawner"
	icon_state = "crate"
	loot = list(
		/obj/structure/closet/crate/maint = 15,
		/obj/effect/spawner/random/structure/crate_empty = 4,
		/obj/structure/closet/crate/secure/loot = 1,
	)

/obj/effect/spawner/random/structure/closet_private
	name = "private closet spawner"
	icon_state = "cabinet"
	loot = list(
		/obj/structure/closet/secure_closet/personal,
		/obj/structure/closet/secure_closet/personal/cabinet,
	)

/obj/effect/spawner/random/structure/closet_empty
	name = "empty closet spawner"
	icon_state = "locker"
	loot = list(
		/obj/structure/closet = 850,
		/obj/structure/closet/cabinet = 150,
		/obj/structure/closet/acloset = 1,
	)

/obj/effect/spawner/random/structure/closet_maintenance
	name = "maintenance closet spawner"
	icon_state = "locker"
	loot = list( // use these for maintenance areas
		/obj/effect/spawner/random/structure/closet_empty = 10,
		/obj/structure/closet/emcloset = 2,
		/obj/structure/closet/firecloset = 2,
		/obj/structure/closet/toolcloset = 2,
		/obj/structure/closet/l3closet = 1,
		/obj/structure/closet/radiation = 1,
		/obj/structure/closet/bombcloset = 1,
		/obj/structure/closet/mini_fridge = 1,
	)

/obj/effect/spawner/random/structure/chair_flipped
	name = "flipped chair spawner"
	icon_state = "chair"
	loot = list(
		/obj/item/chair/wood,
		/obj/item/chair/stool/bar,
		/obj/item/chair/stool,
		/obj/item/chair,
	)

/obj/effect/spawner/random/structure/chair_comfy
	name = "comfy chair spawner"
	icon_state = "chair"
	loot_type_path = /obj/structure/chair/comfy
	loot = list()

/obj/effect/spawner/random/structure/chair_maintenance
	name = "maintenance chair spawner"
	icon_state = "chair"
	loot = list(
		/obj/structure/chair = 200,
		/obj/structure/chair/stool = 200,
		/obj/structure/chair/stool/bar = 200,
		/obj/effect/spawner/random/structure/chair_flipped = 150,
		/obj/structure/chair/wood = 100,
		/obj/effect/spawner/random/structure/chair_comfy = 50,
		/obj/structure/chair/office/light = 50,
		/obj/structure/chair/office = 50,
		/obj/structure/chair/wood/wings = 1,
		/obj/structure/chair/old = 1,
	)

/obj/effect/spawner/random/structure/barricade
	name = "barricade spawner"
	icon_state = "barricade"
	loot = list(
		/obj/structure/barricade/wooden,
		/obj/structure/barricade/wooden/crude,
	)

/obj/effect/spawner/random/structure/maphelp/cursedtree/eight
	name = "cursed tree spawner 80"
	icon_state = "cursedtree"
	spawn_loot_chance = 80
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/flora/tree/evil,
	)

/obj/effect/spawner/random/structure/maphelp/cursedtree/five
	name = "cursed tree spawner 50"
	icon_state = "cursedtree"
	spawn_loot_chance = 50
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/flora/tree/evil,
	)

/obj/effect/spawner/random/structure/maphelp/lynx/one
	name = "lynx spawner 10"
	icon_state = "lynx"
	spawn_loot_chance = 10
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/trap/lynx,
	)

/obj/effect/spawner/random/structure/maphelp/lynx/five
	name = "lynx spawner 50"
	icon_state = "lynx"
	spawn_loot_chance = 50
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/trap/lynx,
	)

/obj/effect/spawner/random/structure/maphelp/lynx/eight
	name = "lynx spawner 80"
	icon_state = "lynx"
	spawn_loot_chance = 80
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/trap/lynx,
	)

/obj/effect/spawner/random/structure/maphelp/beertrap/one
	name = "beer trap spawner 10"
	icon_state = "beertrap"
	spawn_loot_chance = 10
	spawn_random_offset = FALSE
	loot = list(
		/obj/item/restraints/legcuffs/beartrap,
	)

/obj/effect/spawner/random/structure/maphelp/beertrap/five
	name = "beer trap spawner 50"
	icon_state = "beertrap"
	spawn_loot_chance = 50
	spawn_random_offset = FALSE
	loot = list(
		/obj/item/restraints/legcuffs/beartrap,
	)

/obj/effect/spawner/random/structure/maphelp/beertrap/eight
	name = "beer trap spawner 80"
	icon_state = "beertrap"
	spawn_loot_chance = 80
	spawn_random_offset = FALSE
	loot = list(
		/obj/item/restraints/legcuffs/beartrap,
	)

/obj/effect/spawner/random/structure/maphelp/rock/one
	name = "rock spawner 10"
	icon_state = "rock"
	spawn_loot_chance = 10
	spawn_random_offset = FALSE
	loot = list(
		/obj/item/stone,
	)

/obj/effect/spawner/random/structure/maphelp/rock/five
	name = "rock spawner 50"
	icon_state = "rock"
	spawn_loot_chance = 50
	spawn_random_offset = FALSE
	loot = list(
		/obj/item/stone,
	)

/obj/effect/spawner/random/structure/maphelp/rock/eight
	name = "rock spawner 80"
	icon_state = "rock"
	spawn_loot_chance = 80
	spawn_random_offset = FALSE
	loot = list(
		/obj/item/stone,
	)

/obj/effect/spawner/random/structure/maphelp/flametrap/one/chaot
	name = "flame chaot spawner 10"
	icon_state = "flametrap"
	spawn_loot_chance = 10
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/trap/fire/chaot,
	)

/obj/effect/spawner/random/structure/maphelp/flame/five/chaot
	name = "flame chaot spawner 50"
	icon_state = "flametrap"
	spawn_loot_chance = 50
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/trap/fire/chaot,
	)

/obj/effect/spawner/random/structure/maphelp/flame/eight/chaot
	name = "flame chaot spawner 80"
	icon_state = "flametrap"
	spawn_loot_chance = 80
	spawn_random_offset = FALSE
	loot = list(
		/obj/structure/trap/fire/chaot,
	)

/obj/effect/spawner/random/structure/maphelp/shallowater/waist/ten
	name = "shallow water spawner 100"
	icon_state = "shallowwater"
	spawn_loot_chance = 100
	spawn_random_offset = FALSE
	loot = list(
		/atom/movable/liquid/immutable/ocean/shallow = 100,
	)

/obj/effect/spawner/random/structure/maphelp/fire/inferno/ten/magic
	name = "inferno fire magic spawner 100"
	icon_state = "inferno"
	spawn_loot_chance = 100
	spawn_random_offset = FALSE
	loot = list(
		/atom/movable/fire/inferno/magical,
	)

/obj/effect/spawner/random/structure/maphelp/fire/inferno/one/magic
	name = "inferno fire magic spawner 10"
	icon_state = "inferno"
	spawn_loot_chance = 10
	spawn_random_offset = FALSE
	loot = list(
		/atom/movable/fire/inferno/magical,
	)

/obj/effect/spawner/random/structure/maphelp/fire/inferno/eight/magic
	name = "inferno fire magic spawner 80"
	icon_state = "inferno"
	spawn_loot_chance = 80
	spawn_random_offset = FALSE
	loot = list(
		/atom/movable/fire/inferno/magical,
	)

/obj/effect/spawner/random/structure/maphelp/fire/inferno/five/magic
	name = "inferno fire magic spawner 50"
	icon_state = "inferno"
	spawn_loot_chance = 50
	spawn_random_offset = FALSE
	loot = list(
		/atom/movable/fire/inferno/magical,
	)

/obj/effect/spawner/random/structure/maphelp/mob/hydra/one
	name = "hydra spawner 10"
	icon_state = "hydra"
	spawn_loot_chance = 10
	spawn_random_offset = FALSE
	loot = list(
		/mob/living/simple_animal/hostile/podozl/hydra,
	)

/obj/effect/spawner/random/structure/maphelp/mob/hydra/eight
	name = "hydra spawner 80"
	icon_state = "hydra"
	spawn_loot_chance = 80
	spawn_random_offset = FALSE
	loot = list(
		/mob/living/simple_animal/hostile/podozl/hydra,
	)

/obj/effect/spawner/random/structure/maphelp/mob/hydra/five
	name = "hydra spawner 50"
	icon_state = "hydra"
	spawn_loot_chance = 50
	spawn_random_offset = FALSE
	loot = list(
		/mob/living/simple_animal/hostile/podozl/hydra,
	)