// In this document: Revolvers, Needlers, Weird revolvers
// See gun.dm for keywords and the system used for gun balance

/obj/item/gun/ballistic/revolver
	name = "revolver template"
	desc = "should not exist."
	icon_state = "revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	casing_ejector = FALSE
	spawnwithmagazine = TRUE

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	init_recoil = HANDGUN_RECOIL(1)
	init_firemodes = list(
		SEMI_AUTO_NODELAY
	)


	var/select = 0
	equipsound = 'sound/f13weapons/equipsounds/pistolequip.ogg'

/obj/item/gun/ballistic/revolver/Initialize()
	. = ..()
	if(!istype(magazine, /obj/item/ammo_box/magazine/internal/cylinder))
		verbs += /obj/item/gun/ballistic/revolver/verb/spin

/obj/item/gun/ballistic/revolver/generate_guntags()
	..()
	gun_tags |= GUN_REVOLVER

/obj/item/gun/ballistic/revolver/chamber_round(spin = 1)
	if(spin)
		chambered = magazine.get_round(1)
	else
		chambered = magazine.stored_ammo[1]

/obj/item/gun/ballistic/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round(1)

/obj/item/gun/ballistic/revolver/attack_self(mob/living/user)
	var/num_unloaded = 0
	chambered = null
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		if(CB)
			CB.forceMove(drop_location())
			CB.bounce_away(FALSE, NONE)
			num_unloaded++
	if (num_unloaded)
		to_chat(user, span_notice("You unload [num_unloaded] shell\s from [src]."))
	else
		to_chat(user, span_warning("[src] is empty!"))

/obj/item/gun/ballistic/revolver/verb/spin()
	set name = "Spin Chamber"
	set category = "Object"
	set desc = "Click to spin your revolver's chamber."

	var/mob/M = usr

	if(M.stat || !in_range(M,src))
		return

	if(do_spin())
		usr.visible_message("[usr] spins [src]'s chamber.", span_notice("You spin [src]'s chamber."))
		playsound(src, 'sound/f13weapons/revolverspin.ogg', 30, 1)
	else
		verbs -= /obj/item/gun/ballistic/revolver/verb/spin

/obj/item/gun/ballistic/revolver/proc/do_spin()
	var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
	. = istype(C)
	if(.)
		C.spin()
		chamber_round(0)

/obj/item/gun/ballistic/revolver/can_shoot()
	return get_ammo(0,0)

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = 0, countempties = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/revolver/examine(mob/user)
	. = ..()
	. += "[get_ammo(0,0)] of those are live rounds."

/obj/item/gun/ballistic/revolver/detective/Initialize()
	. = ..()
	safe_calibers = magazine.caliber

/obj/item/gun/ballistic/revolver/detective/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if("38" in magazine.caliber)
		to_chat(user, span_notice("You begin to reinforce the barrel of [src]..."))
		if(magazine.ammo_count())
			afterattack(user, user)	//you know the drill
			user.visible_message(span_danger("[src] goes off!"), span_userdanger("[src] goes off in your face!"))
			return TRUE
		if(I.use_tool(src, user, 30))
			if(magazine.ammo_count())
				to_chat(user, span_warning("You can't modify it!"))
				return TRUE
			magazine.caliber = "357"
			desc = "The barrel and chamber assembly seems to have been modified."
			to_chat(user, span_notice("You reinforce the barrel of [src]. Now it will fire .357 rounds."))
	else
		to_chat(user, span_notice("You begin to revert the modifications to [src]..."))
		if(magazine.ammo_count())
			afterattack(user, user)	//and again
			user.visible_message(span_danger("[src] goes off!"), span_userdanger("[src] goes off in your face!"))
			return TRUE
		if(I.use_tool(src, user, 30))
			if(magazine.ammo_count())
				to_chat(user, span_warning("You can't modify it!"))
				return
			magazine.caliber = "38"
			desc = initial(desc)
			to_chat(user, span_notice("You remove the modifications on [src]. Now it will fire .38 rounds."))
	return TRUE



/* * * * * * * * * *
 * LIGHT REVOLVERS *
 * * * * * * * * * */

/* * * * * * * * * * *
 * .38 detective
 * Extra light revolver
 * .38 Special
 * Tiny
 * Fits in a boot
 * Renamable?
 * Common
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/detective
	name = ".38 Detective Special"
	desc = "A small revolver thats easily concealable."
	icon_state = "detective"
	w_class = WEIGHT_CLASS_TINY
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	init_recoil = HANDGUN_RECOIL(0.8)

	obj_flags = UNIQUE_RENAME
	var/list/safe_calibers

/* * * * * * * * * * *
 * .45 ACP Revolver
 * Light revolver
 * .45 ACP
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/revolver45
	name = "S&W .45 ACP revolver"
	desc = "Smith and Wesson revolver firing .45 ACP from a seven round cylinder."
	item_state = "45revolver"
	icon_state = "45revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev45

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0

	fire_sound = 'sound/f13weapons/45revolver.ogg'

/* * * * * * * * * *
 * HEAVY REVOLVERS *
 * * * * * * * * * */

/* * * * * * * * * * *
 * .357 revolver
 * Baseline heavy revolver
 * .357 magnum
 * Common
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/colt357
	name = "\improper .357 magnum revolver"
	desc = "A no-nonsense revolver, more than likely made in some crude workshop in one of the more prosperous frontier towns."
	icon_state = "357colt"
	item_state = "357colt"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev357

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_NORMAL
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0

	fire_sound = 'sound/f13weapons/357magnum.ogg'

/* * * * * * * * * * *
 * Mateba revolver
 * Cool? heavy revolver
 * .357 magnum
 * Unique
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/colt357/mateba //this is a skin that rigbe wanted
	name = "\improper Unica 6 auto-revolver"
	desc = "A pre-war high-power autorevolver commonly used by people who think they look cool."
	icon_state = "mateba"
	item_state = "mateba"

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_NORMAL
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	init_recoil = HANDGUN_RECOIL(1.2)

	fire_sound = 'sound/f13weapons/magnum_fire.ogg'

/* * * * * * * * * * *
 * Lucky revolver
 * Blocking heavy revolver
 * .357 magnum
 * Unique
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/colt357/lucky
	name = "Lucky"
	desc = "Just holding this gun makes you feel like an ace. This revolver was handmade from pieces of other guns in some workshop after the war. A one-of-a-kind gun, it was someone's lucky gun for many a year, it's in good condition and hasn't changed hands often."
	icon_state = "lucky37"
	item_state = "lucky"

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_NORMAL
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0

	block_chance = 20

/* * * * * * * * * * *
 * Police revolver
 * Smol heavy revolver
 * .357 magnum
 * Less accurate
 * Lighter
 * Less Melee
 * More recoil
 * Less damage
 * Faster shot
 * Small
 * Common
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/police
	name = "police revolver"
	desc = "Pre-war double action police revolver chambered in .357 magnum."
	icon_state = "police"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev357
	w_class = WEIGHT_CLASS_SMALL

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_LESS_DAMAGE_T1
	init_recoil = HANDGUN_RECOIL(1)

	fire_sound = 'sound/f13weapons/policepistol.ogg'
	gun_accuracy_zone_type = ZONE_WEIGHT_AUTOMATIC // limbfucker2000

/* * * * * * * * * * *
 * .44 magnum revolver
 * Heavier revolver
 * .44 magnum
 * Scope!
 * Common
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/m29
	name = ".44 magnum revolver"
	desc = "Powerful handgun for those who want to travel the wasteland safely in style. Has a bit of a kick."
	item_state = "model29"
	icon_state = "m29"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev44

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_NORMAL
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	gun_tags = list(GUN_SCOPE)
	can_scope = TRUE
	scope_state = "revolver_scope"
	scope_x_offset = 6
	scope_y_offset = 24
	fire_sound = 'sound/f13weapons/44mag.ogg'

/* * * * * * * * * * *
 * Pearly .44 magnum revolver
 * Cute heavier revolver
 * .44 magnum
 * Scope!
 * Unique
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/m29/alt
	desc = "Powerful handgun with a bit of a kick. This one has nickled finish and pearly grip, and has been kept in good condition by its owner."
	item_state = "44magnum"
	icon_state = "mysterious_m29"

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_NORMAL
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	gun_tags = list(GUN_SCOPE)
	can_scope = TRUE


/* * * * * * * * * * *
 * Peacekeeper revolver
 * Quickfire heavier revolver
 * .44 magnum
 * Scope!
 * Quick fire
 * Heavy recoil
 * Unique
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/m29/peacekeeper
	name = "Peacekeeper"
	desc = "When you don't just need excessive force, but crave it. This .44 has a special hammer mechanism, allowing for measured powerful shots, or fanning for a flurry of inaccurate shots."
	item_state = "m29peace"
	icon_state = "m29peace"

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_NORMAL
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0

	automatic = 0
	autofire_shot_delay = 0
	actions_types = list(/datum/action/item_action/toggle_firemode)
	can_scope = FALSE

/* * * * * * * * * * *
 * Snubnose .44 revolver
 * Smol heavier revolver
 * .44 magnum
 * Less accurate
 * Lighter
 * Less Melee
 * More recoil
 * Less damage
 * Faster shot
 * Small
 * Common
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/m29/snub
	name = "snubnose .44 magnum revolver"
	desc = "A snubnose variant of the commonplace .44 magnum. An excellent holdout weapon for self defense."
	icon_state = "m29_snub"
	w_class = WEIGHT_CLASS_SMALL

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_LESS_DAMAGE_T1
	init_recoil = HANDGUN_RECOIL(1.2)
	gun_accuracy_zone_type = ZONE_WEIGHT_AUTOMATIC

/* * * * * * * * * * *
 * .44 single-action revolver
 * Slow heavier revolver
 * .44 magnum
 * Scope!
 * Accurate
 * Slow to fire
 * More damage
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/revolver44
	name = "\improper .44 magnum single-action revolver"
	desc = "I hadn't noticed, but there on his hip, was a moderately sized iron..."
	item_state = "44colt"
	icon_state = "44colt"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev44

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_SLOWER
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_T1
	init_recoil = HANDGUN_RECOIL(0.8)
	gun_accuracy_zone_type = ZONE_WEIGHT_PRECISION
	gun_tags = list(GUN_SCOPE)
	can_scope = TRUE

	fire_sound = 'sound/f13weapons/44revolver.ogg'

/* * * * * * * * * * *
 * Desert ranger revolver
 * Cool heavier revolver
 * .44 magnum
 * Scope!
 * Accurate
 * Slow to fire
 * More damage
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/revolver44/desert_ranger
	name = "desert ranger revolver"
	desc = "I hadn't noticed, but there on his hip, was a really spiffy looking iron..."

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_SLOWER
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_T1
	gun_accuracy_zone_type = ZONE_WEIGHT_PRECISION
	gun_tags = list(GUN_SCOPE)
	can_scope = TRUE

/* * * * * * * * * * *
 * M2045 Magnum Revolver Rifle
 * Heavy revolver rifle
 * Scoped
 * .308
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/m2405
	name = "M2045 Magnum Revolver Rifle"
	desc = "A relic from before the Great War returns to the wasteland. This rifle uses .308 ammunition and has considerable recoil."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev308
	icon = 'icons/fallout/objects/guns/longguns.dmi'
	item_state = "m2405"
	icon_state = "m2405"

	slowdown = GUN_SLOWDOWN_RIFLE_BOLT
	force = GUN_MELEE_FORCE_RIFLE_HEAVY
	weapon_weight = GUN_TWO_HAND_ONLY
	draw_time = GUN_DRAW_LONG
	fire_delay = GUN_FIRE_DELAY_SLOW
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_SLOW
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_T1
	init_recoil = RIFLE_RECOIL(2.2)

	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13

/* * * * * * * * * * *
 * Hunting revolver
 * Super heavy revolver
 * .45-70
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/hunting
	name = "hunting revolver"
	desc = "A scoped double action revolver chambered in 45-70."
	icon_state = "hunting_revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev4570

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_SLOWER
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_LESS_DAMAGE_T1
	init_recoil = HANDGUN_RECOIL(1.2)
	gun_accuracy_zone_type = ZONE_WEIGHT_PRECISION
	gun_tags = list(GUN_SCOPE)
	can_scope = TRUE
	scope_state = "revolver_scope"
	scope_x_offset = 9
	scope_y_offset = 20
	fire_sound = 'sound/f13weapons/sequoia.ogg'

/* * * * * * * * * * *
 * Degraded hunting revolver
 * Really heavy revolver
 * .45-70
 * Even less damage
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/hunting/klatue
	name = "degraded hunting revolver"
	desc = "A scoped double action revolver chambered in 45-70. This one is very worn."

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_SLOWER
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_LESS_DAMAGE_T2

/* * * * * * * * * * *
 * Sequoia revolvers
 * Super heavy revolver
 * .45-70
 * Accurate
 * Slow to fire
 * More damage
 * They're all the same gun really
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/sequoia
	name = "ranger sequoia"
	desc = "This large, double-action revolver is a trademark weapon of the New California Republic Rangers. It features a dark finish with intricate engravings etched all around the weapon. Engraved along the barrel are the words 'For Honorable Service,' and 'Against All Tyrants.' The hand grip bears the symbol of the NCR Rangers, a bear, and a brass plate attached to the bottom that reads '20 Years.' "
	icon_state = "sequoia"
	item_state = "sequoia"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev4570

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_SLOW
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_T1
	init_recoil = HANDGUN_RECOIL(1.2)
	gun_accuracy_zone_type = ZONE_WEIGHT_PRECISION

	fire_sound = 'sound/f13weapons/sequoia.ogg'

/obj/item/gun/ballistic/revolver/sequoia/bayonet
	name = "bladed ranger sequoia"
	desc = "This heavy revolver is a trademark weapon of the New California Republic Rangers. This one has a blade attached to the handle for a painful pistolwhip."
	icon_state = "sequoia_b"
	item_state = "sequoia"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev4570

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_SLOW
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_T1

	fire_sound = 'sound/f13weapons/sequoia.ogg'

/obj/item/gun/ballistic/revolver/sequoia/death
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev4570/death
	fire_sound = 'sound/f13weapons/sequoia.ogg'

	slowdown = GUN_SLOWDOWN_REVOLVER_HEAVY
	force = GUN_MELEE_FORCE_PISTOL_HEAVY
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_SLOW
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_T1

/* * * * * * * * * * *
 * Single Action Army revolvers
 * Bouncy revolver
 * .45LC
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/revolver45/gunslinger
	name = "\improper Colt Single Action Army"
	desc = "A Colt Single Action Army, chambered in the archaic .45 long colt cartridge."
	item_state = "coltwalker"
	icon_state = "peacemaker"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev45/gunslinger

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_QUICK
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	init_recoil = HANDGUN_RECOIL(0.8)
	gun_accuracy_zone_type = ZONE_WEIGHT_PRECISION

	fire_sound = 'sound/f13weapons/45revolver.ogg'

/* * * * * * * * * * *
 * .223 revolver
 * Quirky revolver
 * .223 / 5.56mm
 * Light
 * Two-Gun
 * Awful accuracy
 * Longer recoil recovery
 * Slower draw
 * Common
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/thatgun
	name = ".223 pistol"
	desc = "A strange pistol firing rifle ammunition, possibly damaging the users wrist and with poor accuracy."
	icon_state = "thatgun"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/thatgun

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_NORMAL
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	gun_accuracy_zone_type = ZONE_WEIGHT_AUTOMATIC

	fire_sound = 'sound/f13weapons/magnum_fire.ogg'

/* * * * * * * * * * *
 * Needler 'revolver'
 * Wounding revolver
 * Needles
 * Uncommon
 * * * * * * * * * * */

/obj/item/gun/ballistic/revolver/needler
	name = "Needler pistol"
	desc = "You suspect this Bringham needler pistol was once used in scientific field studies. It uses small hard-plastic hypodermic darts as ammo. "
	icon_state = "needler"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/revneedler

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_NORMAL
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0
	init_recoil = HANDGUN_RECOIL(0.8)
	gun_accuracy_zone_type = ZONE_WEIGHT_PRECISION

	fire_sound = 'sound/weapons/gunshot_silenced.ogg'

/obj/item/gun/ballistic/revolver/needler/ultra
	name = "Ultracite needler"
	desc = "An ultracite enhanced needler pistol." //Sounds like lame bethesda stuff to me
	icon_state = "ultraneedler"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/revneedler

	slowdown = GUN_SLOWDOWN_REVOLVER_LIGHT
	force = GUN_MELEE_FORCE_PISTOL_LIGHT
	weapon_weight = GUN_ONE_HAND_AKIMBO
	draw_time = GUN_DRAW_NORMAL
	fire_delay = GUN_FIRE_DELAY_FAST
	autofire_shot_delay = GUN_AUTOFIRE_DELAY_NORMAL
	burst_shot_delay = GUN_BURSTFIRE_DELAY_NORMAL
	burst_size = 1
	damage_multiplier = GUN_EXTRA_DAMAGE_0

	fire_sound = 'sound/weapons/gunshot_silenced.ogg'

// LEGACY STUFF

// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/gun/ballistic/revolver/russian
	name = "deer hunting revolver"
	desc = "A revolver for drinking games. Uses .357 ammo, and has a mechanism requiring you to spin the chamber before each trigger pull."
	icon_state = "russianrevolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rus357
	var/spun = FALSE

/obj/item/gun/ballistic/revolver/russian/do_spin()
	. = ..()
	spun = TRUE

/obj/item/gun/ballistic/revolver/russian/Initialize()
	. = ..()
	do_spin()
	spun = TRUE
	update_icon()

/obj/item/gun/ballistic/revolver/russian/attackby(obj/item/A, mob/user, params)
	..()
	if(get_ammo() > 0)
		spin()
		spun = TRUE
	update_icon()
	A.update_icon()
	return

/obj/item/gun/ballistic/revolver/russian/attack_self(mob/user)
	if(!spun)
		spin()
		spun = TRUE
		return
	..()

/obj/item/gun/ballistic/revolver/russian/afterattack(atom/target, mob/living/user, flag, params)
	. = ..(null, user, flag, params)

	if(flag)
		if(!(target in user.contents) && ismob(target))
			if(user.a_intent == INTENT_HARM) // Flogging action
				return

	if(isliving(user))
		if(!can_trigger_gun(user))
			return
	if(target != user)
		if(ismob(target))
			to_chat(user, span_warning("A mechanism prevents you from shooting anyone but yourself!"))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!spun)
			to_chat(user, span_warning("You need to spin \the [src]'s chamber first!"))
			return

		spun = FALSE

		if(chambered)
			var/obj/item/ammo_casing/AC = chambered
			if(AC.fire_casing(user, user))
				playsound(user, fire_sound, 50, 1)
				var/zone = check_zone(user.zone_selected)
				var/obj/item/bodypart/affecting = H.get_bodypart(zone)
				if(zone == BODY_ZONE_HEAD || zone == BODY_ZONE_PRECISE_EYES || zone == BODY_ZONE_PRECISE_MOUTH)
					shoot_self(user, affecting)
				else
					user.visible_message(span_danger("[user.name] cowardly fires [src] at [user.p_their()] [affecting.name]!"), span_userdanger("You cowardly fire [src] at your [affecting.name]!"), span_italic("You hear a gunshot!"))
				chambered = null
				return

		user.visible_message(span_danger("*click*"))
		playsound(src, "gun_dry_fire", 30, 1)

/obj/item/gun/ballistic/revolver/russian/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	add_fingerprint(user)
	playsound(src, "gun_dry_fire", 30, TRUE)
	user.visible_message(span_danger("[user.name] tries to fire \the [src] at the same time, but only succeeds at looking like an idiot."), span_danger("\The [src]'s anti-combat mechanism prevents you from firing it at the same time!"))

/obj/item/gun/ballistic/revolver/russian/proc/shoot_self(mob/living/carbon/human/user, affecting = BODY_ZONE_HEAD)
	user.apply_damage(300, BRUTE, affecting)
	user.visible_message(span_danger("[user.name] fires [src] at [user.p_their()] head!"), span_userdanger("You fire [src] at your head!"), span_italic("You hear a gunshot!"))

/obj/item/gun/ballistic/revolver/russian/soul
	name = "cursed Russian revolver"
	desc = "To play with this revolver requires wagering your very soul."

/obj/item/gun/ballistic/revolver/russian/soul/shoot_self(mob/living/user)
	..()
	var/obj/item/soulstone/anybody/SS = new /obj/item/soulstone/anybody(get_turf(src))
	if(!SS.transfer_soul("FORCE", user)) //Something went wrong
		qdel(SS)
		return
	user.visible_message(span_danger("[user.name]'s soul is captured by \the [src]!"), span_userdanger("You've lost the gamble! Your soul is forfeit!"))


//////////////////
// CODE ARCHIVE //
//////////////////

/*SLING CODE
/obj/item/gun/ballistic/revolver/doublebarrel/improvised/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/stack/cable_coil) && !sawn_off)
		if(A.use_tool(src, user, 0, 10, skill_gain_mult = EASY_USE_TOOL_MULT))
			slot_flags = ITEM_SLOT_BACK
			to_chat(user, span_notice("You tie the lengths of cable to the shotgun, making a sling."))
			slung = TRUE
			update_icon()
		else
			to_chat(user, span_warning("You need at least ten lengths of cable if you want to make a sling!"))

/obj/item/gun/ballistic/revolver/doublebarrel/improvised/update_overlays()
	. = ..()
	if(slung)
		. += "[icon_state]sling"

/obj/item/gun/ballistic/revolver/doublebarrel/improvised/sawoff(mob/user)
	. = ..()
	if(. && slung) //sawing off the gun removes the sling
		new /obj/item/stack/cable_coil(get_turf(src), 10)
		slung = 0
		update_icon()

//BREAK ACTION CODE
/obj/item/gun/ballistic/revolver/doublebarrel/attack_self(mob/living/user)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.forceMove(drop_location())
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		to_chat(user, span_notice("You break open \the [src] and unload [num_unloaded] shell\s."))
	else
		to_chat(user, span_warning("[src] is empty!"))

//DODGE CODE
/obj/item/gun/ballistic/revolver/colt357/lucky/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		if(prob(block_chance))
			owner.visible_message(span_danger("[owner] seems to dodge [attack_text] entirely thanks to [src]!"))
			playsound(src, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, 1)
			return 1
	return 0


// -------------- HoS Modular Weapon System -------------
// ---------- Code originally from VoreStation ----------
/obj/item/gun/ballistic/revolver/mws
	name = "MWS-01 'Big Iron'"
	desc = "Modular Weapons System"

	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "mws"

	fire_sound = 'sound/weapons/Taser.ogg'

	mag_type = /obj/item/ammo_box/magazine/mws_mag
	spawnwithmagazine = FALSE

	recoil = 0

	var/charge_sections = 6

/obj/item/gun/ballistic/revolver/mws/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click to remove the magazine.")

/obj/item/gun/ballistic/revolver/mws/shoot_with_empty_chamber(mob/living/user as mob|obj)
	process_chamber(user)
	if(!chambered || !chambered.BB)
		to_chat(user, span_danger("*click*"))
		playsound(src, "gun_dry_fire", 30, 1)


/obj/item/gun/ballistic/revolver/mws/process_chamber(mob/living/user)
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/mws_batt/shot = chambered
		if(shot.cell.charge >= shot.e_cost)
			shot.chargeshot()
		else
			for(var/B in magazine.stored_ammo)
				var/obj/item/ammo_casing/mws_batt/other_batt = B
				if(istype(other_batt,shot) && other_batt.cell.charge >= other_batt.e_cost)
					switch_to(other_batt, user)
					break
	update_icon()

/obj/item/gun/ballistic/revolver/mws/proc/switch_to(obj/item/ammo_casing/mws_batt/new_batt, mob/living/user)
	if(ishuman(user))
		if(chambered && new_batt.type == chambered.type)
			to_chat(user,span_warning("[src] is now using the next [new_batt.type_name] power cell."))
		else
			to_chat(user,span_warning("[src] is now firing [new_batt.type_name]."))

	chambered = new_batt
	update_icon()

/obj/item/gun/ballistic/revolver/mws/attack_self(mob/living/user)
	if(!chambered)
		return

	var/list/stored_ammo = magazine.stored_ammo

	if(stored_ammo.len == 1)
		return //silly you.

	//Find an ammotype that ISN'T the same, or exhaust the list and don't change.
	var/our_slot = stored_ammo.Find(chambered)

	for(var/index in 1 to stored_ammo.len)
		var/true_index = ((our_slot + index - 1) % stored_ammo.len) + 1 // Stupid ONE BASED lists!
		var/obj/item/ammo_casing/mws_batt/next_batt = stored_ammo[true_index]
		if(chambered != next_batt && !istype(next_batt, chambered.type) && next_batt.cell.charge >= next_batt.e_cost)
			switch_to(next_batt, user)
			break

/obj/item/gun/ballistic/revolver/mws/AltClick(mob/living/user)
	.=..()
	if(magazine)
		user.put_in_hands(magazine)
		magazine.update_icon()
		if(magazine.ammo_count())
			playsound(src, 'sound/weapons/gun_magazine_remove_full.ogg', 70, 1)
		else
			playsound(src, "gun_remove_empty_magazine", 70, 1)
		magazine = null
		to_chat(user, span_notice("You pull the magazine out of [src]."))
		if(chambered)
			chambered = null
		update_icon()

/obj/item/gun/ballistic/revolver/mws/update_overlays()
	.=..()
	if(!chambered)
		return

	var/obj/item/ammo_casing/mws_batt/batt = chambered
	var/batt_color = batt.type_color //Used many times

	//Mode bar
	var/image/mode_bar = image(icon, icon_state = "[initial(icon_state)]_type")
	mode_bar.color = batt_color
	. += mode_bar

	//Barrel color
	var/mutable_appearance/barrel_color = mutable_appearance(icon, "[initial(icon_state)]_barrel", color = batt_color)
	barrel_color.alpha = 150
	. += barrel_color

	//Charge bar
	var/ratio = can_shoot() ? CEILING(clamp(batt.cell.charge / batt.cell.maxcharge, 0, 1) * charge_sections, 1) : 0
	for(var/i = 0, i < ratio, i++)
		var/mutable_appearance/charge_bar = mutable_appearance(icon,  "[initial(icon_state)]_charge", color = batt_color)
		charge_bar.pixel_x = i
		. += charge_bar


//ACCIDENTALLY SHOOT YOURSELF IN THE FACE CODE
/obj/item/gun/ballistic/revolver/reverse/can_trigger_gun(mob/living/user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) || (user.mind && HAS_TRAIT(user.mind, TRAIT_CLOWN_MENTALITY)))
		return ..()
	if(process_fire(user, user, FALSE, null, BODY_ZONE_HEAD))
		user.visible_message(span_warning("[user] somehow manages to shoot [user.p_them()]self in the face!"), span_userdanger("You somehow shoot yourself in the face! How the hell?!"))
		user.emote("scream")
		user.drop_all_held_items()
		user.DefaultCombatKnockdown(80)
*/
