//BARRELS
//Damn copypastes

/obj/structure/reagent_dispensers/barrel
	name = "barrel"
	desc = "Metal barrel for large amount of liquid material."
	icon = 'icons/obj/barrels.dmi'
	icon_state = "barrel"

/obj/structure/reagent_dispensers/barrel/water_barrel
	name = "barrel"
	desc = "Metal barrel for large amount of liquid material."
	icon = 'icons/obj/barrels.dmi'
	icon_state = "barrel"
	var/on_pallet = 0 //barrel's index on a pallet. 0 - barrel is not on the pallet.
	var/obj/structure/pallet/P

	New()
		. = ..()
		reagents.add_reagent("water", 1000)

/*	MouseDrop(over_object, over_location)

		if(!istype(over_object, /obj/structure/pallet))
			if (P)
				src.loc = over_location
				switch(on_pallet)
					if(1)
						pixel_x +=7
						pixel_y -=6
					if(2)
						pixel_x -=8
						pixel_y -=6
					if(3)
						pixel_x +=6
						pixel_y -=2
					if(4)
						pixel_x -=8
						pixel_y -=2

				on_pallet = 0
				P.barrels.Remove(src)
				P.barrel_n--
				P = null

			return

		P = over_object
		src.on_pallet = P.barrel_n++
		src.loc = over_location

		switch(on_pallet)
			if(1)
				pixel_x -=7
				pixel_y +=6
			if(2)
				pixel_x +=8
				pixel_y +=6
			if(3)
				pixel_x -=6
				pixel_y +=2
			if(4)
				pixel_x +=8
				pixel_y +=2
		P.barrels.Add(src)
*/

/obj/structure/reagent_dispensers/barrel/fuel_barrel
	name = "fuel barrel"
	desc = "Metal barrel for large amount of liquid flameable material."
	icon = 'icons/obj/barrels.dmi'
	icon_state = "dangerous_barrel"
	var/on_pallet = 0
	New()
		. = ..()
		reagents.add_reagent("fuel", 1000)

/obj/structure/reagent_dispensers/barrel/barrel_random
	name = "barrel"
	desc = "A misterious old rusty barrel."
	icon = 'icons/obj/barrels.dmi'
	icon_state = "rusty_barrel"
	var/on_pallet = 0

	New()
		. = ..()
		var/reagent = pick(list("stoxin","ketchup","psilocybin",
								"moonrocks","holywater","inaprovaline",
								"toxin","anti_toxin","capsaicin",
								"creatine", "cornoil","cherryjelly",
								"discount","toxicwaste","peptobismol",
								"orangejuice","tomatojuice","limejuice",
								"carrotjuice","berryjuice","poisonberryjuice",
								"watermelonjuice","soymilk","icecoffee",
								"tonic","nuka_cola","brownstar",
								"ethanol","moonshine","sacid",))
		reagents.add_reagent(reagent, rand(1000))

	examine()
		return

/obj/structure/pallet
	name = "pallet"
	desc = "Old wooden pallet."
	icon = 'icons/obj/barrels.dmi'
	icon_state = "pallet"
	anchored = 0
	density = 0
	var/list/barrels
	var/barrel_n = 0

	Move(NewLoc,Dir,step_x,step_y)
		.=..()
		for(var/barrel as obj in barrels)
			step(barrel,Dir)

		return