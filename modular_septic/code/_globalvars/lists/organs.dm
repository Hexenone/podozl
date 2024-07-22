/// Organ slot processing order for life proc
GLOBAL_LIST_INIT(organ_process_order, list(
	ORGAN_SLOT_BRAIN,
	ORGAN_SLOT_APPENDIX,
	ORGAN_SLOT_RIGHT_ARM_AUG,
	ORGAN_SLOT_LEFT_ARM_AUG,
	ORGAN_SLOT_STOMACH,
	ORGAN_SLOT_STOMACH_AID,
	ORGAN_SLOT_BREATHING_TUBE,
	ORGAN_SLOT_EARS,
	ORGAN_SLOT_EYES,
	ORGAN_SLOT_LUNGS,
	ORGAN_SLOT_HEART,
	ORGAN_SLOT_ZOMBIE,
	ORGAN_SLOT_THRUSTERS,
	ORGAN_SLOT_HUD,
	ORGAN_SLOT_KIDNEYS,
	ORGAN_SLOT_LIVER,
	ORGAN_SLOT_SPLEEN,
	ORGAN_SLOT_TONGUE,
	ORGAN_SLOT_VOICE,
	ORGAN_SLOT_ARTERY,
	ORGAN_SLOT_TENDON,
	ORGAN_SLOT_BONE,
	ORGAN_SLOT_ADAMANTINE_RESONATOR,
	ORGAN_SLOT_HEART_AID,
	ORGAN_SLOT_BRAIN_ANTIDROP,
	ORGAN_SLOT_BRAIN_ANTISTUN,
	ORGAN_SLOT_TAIL,
	ORGAN_SLOT_EXTERNAL_WINGS,
	ORGAN_SLOT_PENIS,
	ORGAN_SLOT_TESTICLES,
	ORGAN_SLOT_VAGINA,
	ORGAN_SLOT_WOMB,
	ORGAN_SLOT_BREASTS,
	ORGAN_SLOT_ANUS,
	ORGAN_SLOT_PARASITE_EGG,
	ORGAN_SLOT_REGENERATIVE_CORE,
	ORGAN_SLOT_XENO_PLASMAVESSEL,
	ORGAN_SLOT_XENO_HIVENODE,
	ORGAN_SLOT_XENO_RESINSPINNER,
	ORGAN_SLOT_XENO_ACIDGLAND,
	ORGAN_SLOT_XENO_NEUROTOXINGLAND,
	ORGAN_SLOT_XENO_EGGSAC,
	))

GLOBAL_LIST_INIT(organ_process_datum_order, list(
	ORGAN_SLOT_BRAIN,
	ORGAN_SLOT_HEART,
	ORGAN_SLOT_LUNGS,
	ORGAN_SLOT_KIDNEYS,
	ORGAN_SLOT_LIVER,
	ORGAN_SLOT_STOMACH,
	ORGAN_SLOT_SPLEEN,
	ORGAN_SLOT_EARS,
	ORGAN_SLOT_INTESTINES,
	ORGAN_SLOT_NERVESYSTEM,
	ORGAN_SLOT_BLADDER,
	ORGAN_SLOT_PENIS,
	))

GLOBAL_LIST_INIT_TYPED(bones_by_path, /obj/item/organ/bone, setup_bones())
GLOBAL_LIST_INIT_TYPED(tendons_by_path, /obj/item/organ/tendon, setup_tendons())
GLOBAL_LIST_INIT_TYPED(arteries_by_path, /obj/item/organ/artery, setup_arteries())
