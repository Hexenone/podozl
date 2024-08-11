/datum/diceroll_modifier/nondominant_hand
	modification = -4
	applicable_contexts = list(
		DICE_CONTEXT_PHYSICAL = TRUE,
	)

/datum/diceroll_modifier/poorly_ambidextrous
	modification = -2
	applicable_contexts = list(
		DICE_CONTEXT_PHYSICAL = TRUE,
	)

/datum/diceroll_modifier/verybadmood
	modification = -4
	applicable_contexts = list(
		DICE_CONTEXT_PHYSICAL = TRUE,
		DICE_CONTEXT_MENTAL = TRUE,
	)

/datum/diceroll_modifier/verybadmood/applies_to(datum/attribute_holder/holder, context)
	return TRUE
