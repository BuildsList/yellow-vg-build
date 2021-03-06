/obj/machinery/door_control
	name = "remote door-control"
	desc = "It controls doors, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	desc = "A remote control-switch for a door."
	power_channel = ENVIRON
	var/id_tag = null
	var/range = 10
	var/normaldoorcontrol = 0
	var/desiredstate = 0 // Zero is closed, 1 is open.
	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties

	*/

	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

	ghost_read=0
	ghost_write=0

/obj/machinery/door_control/attack_ai(mob/user as mob)
	src.add_hiddenprint(user)
	if(wires & 2)
		return src.attack_hand(user)
	else
		user << "Error, no route to host."

/obj/machinery/door_control/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door_control/attackby(obj/item/weapon/W, mob/user as mob)
	/* For later implementation
	if (istype(W, /obj/item/weapon/screwdriver))
	{
		if(wiresexposed)
			icon_state = "doorctrl0"
			wiresexposed = 0

		else
			icon_state = "doorctrl-open"
			wiresexposed = 1

		return
	}
	*/
	if(istype(W, /obj/item/device/detective_scanner))
		return
	if(istype(W, /obj/item/weapon/card/emag))
		req_access = list()
		req_one_access = list()
		playsound(get_turf(src), "sparks", 100, 1)
	return src.attack_hand(user)

/obj/machinery/door_control/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!allowed(user) && (wires & 1))
		user << "\red Access Denied"
		flick("doorctrl-denied",src)
		return

	use_power(5)
	icon_state = "doorctrl1"
	add_fingerprint(user)

	if(normaldoorcontrol)
		for(var/obj/machinery/door/airlock/D in range(range))
			if(D.id_tag == src.id_tag)
				if(desiredstate == 1)
					if(specialfunctions & OPEN)
						if (D.density)
							spawn( 0 )
								D.open()
								return
					if(specialfunctions & IDSCAN)
						D.aiDisabledIdScanner = 1
					if(specialfunctions & BOLTS)
						D.locked = 1
						D.update_icon()
					if(specialfunctions & SHOCK)
						D.secondsElectrified = -1
					if(specialfunctions & SAFE)
						D.safe = 0

				else
					if(specialfunctions & OPEN)
						if (!D.density)
							spawn( 0 )
								D.close()
								return
					if(specialfunctions & IDSCAN)
						D.aiDisabledIdScanner = 0
					if(specialfunctions & BOLTS)
						if(!D.isWireCut(4) && D.arePowerSystemsOn())
							D.locked = 0
							D.update_icon()
					if(specialfunctions & SHOCK)
						D.secondsElectrified = 0
					if(specialfunctions & SAFE)
						D.safe = 1

	else
		for(var/obj/machinery/door/poddoor/M in world)
			if (M.id_tag == src.id_tag)
				if (M.density)
					spawn( 0 )
						M.open()
						return
				else
					spawn( 0 )
						M.close()
						return

	desiredstate = !desiredstate
	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = "doorctrl0"

/obj/machinery/door_control/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/obj/machinery/driver_button/attack_ai(mob/user as mob)
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/driver_button/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/driver_button/attackby(obj/item/weapon/W, mob/user as mob)

	if(istype(W, /obj/item/device/detective_scanner))
		return
	return src.attack_hand(user)

/obj/machinery/driver_button/attack_hand(mob/user as mob)

	src.add_fingerprint(usr)
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		return
	add_fingerprint(user)

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/machinery/door/poddoor/M in world)
		if (M.id_tag == src.id_tag)
			spawn( 0 )
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in world)
		if(M.id_tag == src.id_tag)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/poddoor/M in world)
		if (M.id_tag == src.id_tag)
			spawn( 0 )
				M.close()
				return

	icon_state = "launcherbtt"
	active = 0

	return

//PAID ACCESS

/obj/machinery/door_control/paid
	name = "Paid access button"
	desc = "A door control button equipped with coin reciever and a golden frame."
	icon_state = "doorctrllux0"

	var/obj/item/weapon/coin/coin
	var/list/safe

	attack_hand(mob/user as mob)
		src.add_fingerprint(usr)
		if(stat & (NOPOWER|BROKEN))
			return

		if((coin) && (wires & 1))
			user << "\red Access Denied"
			return


		use_power(5)
		flick("doorctrllux2",src)
		icon_state = "doorctrllux0"
		safe.Add(coin)

	attackby(obj/item/weapon/W, mob/user as mob)
		..()
		if(istype(W, /obj/item/weapon/coin))
			user.drop_item()
			W.loc = src
			coin = W
			user << "<span class='notice'>You insert [W] into [src].</span>"
			icon_state = "doorctrllux1"

		if(istype(W, /obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/card = W
			if(access_bar in card.access)
				for(var/obj/item/weapon/coin/cash as obj in safe)
					sleep(2)
					cash = new(src)
					cash.pixel_x = rand(-8,8)
					cash.pixel_y = rand(-8,8)
		return