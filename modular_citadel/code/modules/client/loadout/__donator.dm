//This is the file that handles donator loadout items.

/datum/gear/donator
	name = "IF YOU SEE THIS, PING A CODER RIGHT NOW!"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/storage/belt/shoulderholster/ranger45
	category = LOADOUT_CATEGORY_DONATOR
	ckeywhitelist = list("This entry should never appear with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard
	cost = 0

/datum/gear/donator/donortestingbikehorn
	name = "Donor item testing"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/storage/belt/shoulderholster/ranger45
	geargroupID = list("DONORTEST") //This is a list mainly for the sake of testing, but geargroupID works just fine with ordinary strings

/datum/gear/donator/monke1818
	name = "CIA Badge"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/clothing/accessory/cia_badge
	ckeywhitelist = list("monke1818")

// SUNSET FLUFF ITEMS

/datum/gear/donator/mrsanderp
	name = "Happy Sharky Company Cuisine Book"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/book/granter/crafting_recipe/happysharky
	category = LOADOUT_CATEGORY_BACKPACK
	ckeywhitelist = list("mr.sanderp")
	cost = 0

/* /// Fluff for fuzzy
/datum/gear/donator/fuz_card
	name = "Fuzzy License Card"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/card/fuzzy_license
	ckeywhitelist = list("fuzlet", "superlagg")
	cost = 0

/// Also fluff for fuzzy
/datum/gear/donator/fuz_pen
	name = "Free Crayon Box"
	slot = SLOT_IN_BACKPACK
	path = /obj/item/storage/crayons
	ckeywhitelist = list("fuzlet", "superlagg")
	cost = 0 */

/////////////////////
///Loadout Boxes///// See kits.dm, use this model for loadouts that have more than one item per character.
/////////////////////
/datum/gear/donator/kits
	slot = SLOT_IN_BACKPACK

/*example
/datum/gear/donator/kits/averyamadeus
	name = "Avery Amadeus' belongings"
	path = /obj/item/storage/box/large/custom_kit/averyamadeus
	ckeywhitelist = list("topbirb")
*/

/datum/gear/donator/kits/mrsanderp
	name = "Happy Sharky Co. Business Bundle"
	path = /obj/item/storage/box/large/custom_kit/exoticjazz
	ckeywhitelist = list("mr.sanderp")

/obj/item/storage/box/large/custom_kit/exoticjazz/PopulateContents()
	new /obj/item/book/granter/crafting_recipe/happysharky(src)

/datum/gear/donator/kits/fenny
	name = "Casey's 'Business' Bundle"
	path = /obj/item/storage/box/large/custom_kit/fenny
	ckeywhitelist = list("tk420634")

/obj/item/storage/box/large/custom_kit/fenny/PopulateContents()
	new /obj/item/clothing/head/beret/sec/navyofficer(src)
	new /obj/item/clothing/suit/armor/light/leather(src)
	new /obj/item/melee/onehanded/knife/trench(src)
	new /obj/item/gun/ballistic/automatic/smg/mini_uzi(src)
	new /obj/item/ammo_box/magazine/uzim9mm(src)
	new /obj/item/ammo_box/magazine/uzim9mm(src)
	new /obj/item/reagent_containers/food/snacks/grown/poppy/lily(src)
	new /obj/item/gun_upgrade/trigger/dangerzone(src)
	new /obj/item/gun_upgrade/barrel/forged(src)
	new /obj/item/tool_upgrade/refinement/stabilized_grip(src)

/datum/gear/donator/kits/brimcon
	name = "Gift from Claws"
	path = /obj/item/storage/box/large/custom_kit/brimcon
	ckeywhitelist = list("brimcon")

/obj/item/storage/box/large/custom_kit/brimcon/PopulateContents()
	new /obj/item/clothing/suit/armor/light/tribal/cloak(src)

/datum/gear/donator/kits/ferisramsay
	name = "Feris' Box"
	path = /obj/item/storage/box/large/custom_kit/ferisramsay
	ckeywhitelist = list("ferisramsay")

/obj/item/storage/box/large/custom_kit/ferisramsay/PopulateContents()
	new /obj/item/gun/energy/laser/wattz(src)
	new /obj/item/stock_parts/cell/ammo/ec(src)

/datum/gear/donator/kits/bladeburstninja
	name = "Split-Noggin's Box"
	path = /obj/item/storage/box/large/custom_kit/bladeburstninja
	ckeywhitelist = list("bladeburstninja")

/obj/item/storage/box/large/custom_kit/bladeburstninja/PopulateContents()
	new /obj/item/gun/ballistic/bow/silver(src)
	new /obj/item/clothing/head/helmet/f13/metalmask(src)
	new /obj/item/clothing/suit/armor/light/leather(src)
	new /obj/item/clothing/accessory/talisman(src)
	new /obj/item/stack/sheet/sinew(src)
	new /obj/item/stack/sheet/sinew(src)

/datum/gear/donator/kits/sloaff
	name = "Leo's Kit"
	path = /obj/item/storage/box/large/custom_kit/sloaff
	ckeywhitelist = list("sloaff")

/obj/item/storage/box/large/custom_kit/sloaff/PopulateContents()
	new /obj/item/binoculars(src)
	new /obj/item/gun/ballistic/revolver/thatgun(src)
	new /obj/item/ammo_box/magazine/m556/rifle/small(src)
	new /obj/item/ammo_box/magazine/m556/rifle/small(src)
	new /obj/item/melee/onehanded/knife/bowie(src)
	new /obj/item/clothing/head/helmet/f13/marlowhat(src)

/datum/gear/donator/kits/lucine
	name = "Earlong Travel Supplies"
	path = /obj/item/storage/box/large/custom_kit/lucine
	ckeywhitelist = list("lucine")

/obj/item/storage/box/large/custom_kit/lucine/PopulateContents()
	new /obj/item/gun/energy/laser/wattz/magneto(src)
	new /obj/item/gun/energy/laser/wattz(src)
	new /obj/item/stock_parts/cell/ammo/ec(src)
	new /obj/item/stock_parts/cell/ammo/ec(src)

/datum/gear/donator/kits/pappavol
	name = "Earlong Travel Supplies"
	path = /obj/item/storage/box/large/custom_kit/pappavol
	ckeywhitelist = list("pappavol")

/obj/item/storage/box/large/custom_kit/pappavol/PopulateContents()
	new /obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/tribal/junk(src)
	new /obj/item/twohanded/sledgehammer/simple(src)

/datum/gear/donator/kits/soulwinter446
	name = "Shocome's relic cross"
	path = /obj/item/nullrod/rosary/keep_as_is
	ckeywhitelist = list("soulwinter446")

/datum/gear/donator/kits/fuzz_rifle
	name = "fuzzy supply box"
	path = /obj/item/storage/box/large/custom_kit/fuzz_rifle
	ckeywhitelist = list("fuzlet", "superlagg")

/obj/item/storage/box/large/custom_kit/fuzz_rifle/PopulateContents()
	new /obj/item/gun/ballistic/automatic/sportcarbine/m1_22(src)
	new /obj/item/ammo_box/magazine/m22/extended(src)
	new /obj/item/card/fuzzy_license(src)
	new /obj/item/toy/crayon/orange(src)

/datum/gear/donator/kits/mathiel
	name = "Annastasia's Kit"
	path = /obj/item/storage/box/large/custom_kit/mathiel
	ckeywhitelist = list("mathiel")

/obj/item/storage/box/large/custom_kit/mathiel/PopulateContents()
	new /obj/item/gun/ballistic/revolver/m29/alt(src)

/datum/gear/donator/kits/dezuel
	name = "Lunas Stash"
	path = /obj/item/storage/box/large/custom_kit/dezuel
	ckeywhitelist = list("dezuel")

/obj/item/storage/box/large/custom_kit/dezuel/PopulateContents()
	new /obj/item/gun/ballistic/revolver/police(src)
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/a357(src)

/datum/gear/donator/kits/aldrictalvalin
	name = "Aldric's Supply Kit"
	path = /obj/item/storage/box/large/custom_kit/aldrictalvalin
	ckeywhitelist = list("aldrictalvalin")

/obj/item/storage/box/large/custom_kit/aldrictalvalin/PopulateContents()
	new /obj/item/clothing/head/beret/headband(src)
	new /obj/item/clothing/under/f13/detectivealt(src)
	new /obj/item/gun/energy/laser/pistol(src)
	new /obj/item/stock_parts/cell/ammo/ec(src)

/datum/gear/donator/kits/greed2323
	name = "Magnum Kit"
	path = /obj/item/storage/box/large/custom_kit/greed2323
	ckeywhitelist = list("greed2323")

/obj/item/storage/box/large/custom_kit/greed2323/PopulateContents()
	new /obj/item/gun/ballistic/revolver/m29/alt(src)
	new /obj/item/gun_upgrade/trigger/dangerzone(src)

/datum/gear/donator/kits/aerodynamique
	name = "Yee-Haw Sharpshooter Kit"
	path = /obj/item/storage/box/large/custom_kit/aerodynamique
	ckeywhitelist = list("aerodynamique")

/obj/item/storage/box/large/custom_kit/aerodynamique/PopulateContents()
	new /obj/item/gun/ballistic/rifle/repeater/trail(src)
	new /obj/item/gun_upgrade/scope/watchman(src)
