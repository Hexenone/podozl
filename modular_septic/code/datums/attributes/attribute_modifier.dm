/datum/attribute_modifier
	/// Whether or not this is a variable modifier. Variable modifiers can NOT be ever auto-cached. ONLY CHECKED VIA INITIAL(), EFFECTIVELY READ ONLY (and for very good reason)
	var/variable = FALSE

	/// Unique ID. You can never have different modifications with the same ID. By default, this SHOULD NOT be set. Only set it for cases where you're dynamically making modifiers/need to have two types overwrite each other. If unset, uses path (converted to text) as ID.
	var/id

	/// Higher ones override lower priorities. This is NOT used for ID, ID must be unique, if it isn't unique the newer one overwrites automatically if overriding.
	var/priority = 0
	var/flags = NONE

	/// Associative list, attribute path = modification
	var/list/attribute_list

	/// Other modification datums this conflicts with.
	var/conflicts_with

/datum/attribute_modifier/New()
	. = ..()
	if(!id)
		id = "[type]" //We turn the path into a string.

/// Grabs a STATIC MODIFIER datum from cache. YOU MUST NEVER EDIT THESE DATUMS, OR IT WILL AFFECT ANYTHING ELSE USING IT TOO!
/proc/get_cached_attribute_modifier(modtype)
	if(!ispath(modtype, /datum/attribute_modifier))
		CRASH("[modtype] is not a attribute modification typepath.")
	var/datum/attribute_modifier/attribute_mod = modtype
	if(initial(attribute_mod.variable))
		CRASH("[modtype] is a variable modifier, and can never be cached.")
	attribute_mod = GLOB.attribute_modification_cache[modtype]
	if(!attribute_mod)
		attribute_mod = GLOB.attribute_modification_cache[modtype] = new modtype
	return attribute_mod

///Add an attribute modifier to a holder. If a variable subtype is passed in as the first argument, it will make a new datum. If ID conflicts, it will overwrite the old ID.
/datum/attribute_holder/proc/add_attribute_modifier(datum/attribute_modifier/type_or_datum, update = TRUE)
	if(ispath(type_or_datum))
		if(!initial(type_or_datum.variable))
			type_or_datum = get_cached_attribute_modifier(type_or_datum)
		else
			type_or_datum = new type_or_datum
	var/datum/attribute_modifier/existing = LAZYACCESS(attribute_modification, type_or_datum.id)
	if(existing)
		if(existing == type_or_datum) //same thing don't need to touch
			return TRUE
		remove_attribute_modifier(existing, FALSE)
	if(length(attribute_modification))
		BINARY_INSERT(type_or_datum.id, attribute_modification, /datum/attribute_modifier, type_or_datum, priority, COMPARE_VALUE)
	LAZYSET(attribute_modification, type_or_datum.id, type_or_datum)
	if(update)
		update_attributes()
	return TRUE

/// Remove an attribute modifier from a holder, whether static or variable.
/datum/attribute_holder/proc/remove_attribute_modifier(datum/attribute_modifier/type_id_datum, update = TRUE)
	var/key
	if(ispath(type_id_datum))
		key = initial(type_id_datum.id) || "[type_id_datum]" //id if set, path set to string if not.
	else if(!istext(type_id_datum)) //if it isn't text it has to be a datum, as it isn't a type.
		key = type_id_datum.id
	else //assume it's an id
		key = type_id_datum
	if(!LAZYACCESS(attribute_modification, key))
		return FALSE
	LAZYREMOVE(attribute_modification, key)
	if(update)
		update_attributes()
	return TRUE

/*! Used for variable modification like hunger/health loss/etc, works somewhat like the old list-based modification adds. Returns the modifier datum if successful
	How this SHOULD work is:
	1. Ensures type_id_datum one way or another refers to a /variable datum. This makes sure it can't be cached. This includes if it's already in the modification list.
	2. Instantiate a new datum if type_id_datum isn't already instantiated + in the list, using the type. Obviously, wouldn't work for ID only.
	3. Add the datum if necessary using the regular add proc
	4. If any of the rest of the args are not null (see: multiplicative slowdown), modify the datum
	5. Update if necessary
*/
/datum/attribute_holder/proc/add_or_update_variable_attribute_modifier(datum/attribute_modifier/type_id_datum, update = TRUE, list/new_modification)
	var/modified = FALSE
	var/inject = FALSE
	var/datum/attribute_modifier/final
	if(istext(type_id_datum))
		final = LAZYACCESS(attribute_modification, type_id_datum)
		if(!final)
			CRASH("Couldn't find existing modification when provided a text ID.")
	else if(ispath(type_id_datum))
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = LAZYACCESS(attribute_modification, initial(type_id_datum.id) || "[type_id_datum]")
		if(!final)
			final = new type_id_datum
			inject = TRUE
			modified = TRUE
	else
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = type_id_datum
		if(!LAZYACCESS(attribute_modification, final.id))
			inject = TRUE
			modified = TRUE
	if(islist(new_modification))
		final.attribute_list = new_modification
		modified = TRUE
	if(inject)
		add_attribute_modifier(final, FALSE)
	if(update && modified)
		update_attributes()
	return final

/// Is there an attribute modifier of this type on this holder?
/datum/attribute_holder/proc/has_attribute_modifier(datum/attribute_modifier/datum_type_id)
	var/key
	if(ispath(datum_type_id))
		key = initial(datum_type_id.id) || "[datum_type_id]"
	else if(istext(datum_type_id))
		key = datum_type_id
	else
		key = datum_type_id.id
	return LAZYACCESS(attribute_modification, key)

/// Go through the list of actionspeed modifiers and calculate a final actionspeed. ANY ADD/REMOVE DONE IN UPDATE_actionspeed MUST HAVE THE UPDATE ARGUMENT SET AS FALSE!
/datum/attribute_holder/proc/update_attributes()
	. = raw_attribute_list.Copy()
	var/list/conflict_tracker = list()
	for(var/key in get_attribute_modification())
		var/datum/attribute_modifier/M = attribute_modification[key]
		var/conflict = M.conflicts_with
		if(conflict)
			// Conflicting modifiers prioritize the higher priority modifier
			if(conflict_tracker[conflict] < M.priority)
				conflict_tracker[conflict] = M.priority
			else
				continue
		for(var/attribute_path in .)
			// never turn nulls into zeroes, zero and null does not mean the same for skills
			if(isnull(M.attribute_list[attribute_path]))
				continue
			if(ispath(attribute_path, SKILL))
				.[attribute_path] = clamp(.[attribute_path] + M.attribute_list[attribute_path], nulltozero(skill_min), nulltozero(skill_max))
			else
				.[attribute_path] = clamp(.[attribute_path] + M.attribute_list[attribute_path], nulltozero(attribute_min), nulltozero(attribute_max))
	attribute_list = .
	parent?.hud_used?.stat_viewer?.update_stats()
	if(iscarbon(parent))
		var/mob/living/carbon/carbon_parent = parent
		carbon_parent.update_maximum_carry_weight()
		carbon_parent.update_basic_speed_modifier()
		carbon_parent.update_endurance_fatigue_modifier()

/// Get the attribute modifiers list of the holder
/datum/attribute_holder/proc/get_attribute_modification()
	. = LAZYCOPY(attribute_modification)
	for(var/id in attribute_mod_immunities)
		. -= id

/// Checks if an attribute modifier is valid and not missing any data
/proc/attribute_mod_data_null_check(datum/attribute_modifier/M) //Determines if a data list is not meaningful and should be discarded.
	. = LAZYLEN(M.attribute_list)

/// Ignores specific attribute mods - Accepts a list of attribute mods
/datum/attribute_holder/proc/add_attribute_mod_immunities(source, mod_type, update = TRUE)
	if(islist(mod_type))
		for(var/listed_type in mod_type)
			if(ispath(listed_type))
				listed_type = "[mod_type]" //Path2String
			LAZYADDASSOCLIST(attribute_mod_immunities, listed_type, source)
	else
		if(ispath(mod_type))
			mod_type = "[mod_type]" //Path2String
		LAZYADDASSOCLIST(attribute_mod_immunities, mod_type, source)
	if(update)
		update_attributes()

///Unignores specific attribute mods - Accepts a list of attribute mods
/datum/attribute_holder/proc/remove_attribute_mod_immunities(source, mod_type, update = TRUE)
	if(islist(mod_type))
		for(var/listed_type in mod_type)
			if(ispath(listed_type))
				listed_type = "[listed_type]" //Path2String
			LAZYREMOVEASSOC(attribute_mod_immunities, listed_type, source)
	else
		if(ispath(mod_type))
			mod_type = "[mod_type]" //Path2String
		LAZYREMOVEASSOC(attribute_mod_immunities, mod_type, source)
	if(update)
		update_attributes()
