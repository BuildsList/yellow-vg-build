


/obj/effect/step_trigger/rail
	name = "rail"
	desc = "A huge metal bar."
	icon = 'icons/obj/rails.dmi'
	icon_state = "rail"
	density = 0
	anchored = 1
	invisibility = 0
	var/charge = 1

	Trigger(mob/mover as mob)
		if(!prob(50))
			return 0
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(1, 1, loc)
		s.start()
		electrocute_mob(mover, get_area(src), src, 0.7)
		sleep(300)
		charge = 1
		..()