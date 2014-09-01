./sound/turntable/test
	file = 'sound/turntable/TestLoop1.ogg'
	falloff = 2
	repeat = 1

/mob/var/music = 0

/obj/machinery/party/turntable
	name = "Jukebox"
	desc = "A jukebox is a partially automated music-playing device, usually a coin-operated machine, that will play a patron's selection from self-contained media."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "Jukeboxalt"
	var/playing = 0
	anchored = 1
	density = 1
	var/obj/item/party/music_disc/m_disc
	var/list/songs
	var/list/default_songs = list ("Jawa Bar"='sound/turntable/Cantina.ogg',
							"Lonely Assistant Blues"='sound/turntable/AGrainOfSandInSandwich.ogg',
							"Chinatown"='sound/turntable/chinatown.ogg',
							"Wade In The Water"='sound/turntable/WadeInTheWater.ogg',
							"Blue Theme"='sound/turntable/BlueTheme.ogg',
							"Beyond The Sea"='sound/turntable/BeyondTheSea.ogg',
							"The Assassination of Jesse James"='sound/turntable/TheAssassinationOfJesseJames.ogg',
							"Everyone Has Their Vices"='sound/turntable/EveryoneHasTheirVices.ogg',
							"The Way You Look Tonight"='sound/turntable/TheWayYouLookTonight.ogg',
							"They Were All Dead"='sound/turntable/TheyWereAllDead.ogg',
							"Onizukas Blues"='sound/turntable/OnizukasBlues.ogg',
							"Ragtime Piano"='sound/turntable/TheEntertainer.ogg',
							"It Had To Be You"='sound/turntable/ItHadToBeYou.ogg',
							"Janitorial Blues"='sound/turntable/KyouWaYuuhiYarou.ogg',
							"Lujon"='sound/turntable/Lujon.ogg',
							"Mute Beat"='sound/turntable/MuteBeat.ogg',
							"Groovy Times"='sound/turntable/GroovyTime.ogg',
							"Under My Skin"='sound/turntable/IveGotYouUnderMySkin.ogg',
							"That`s All"='sound/turntable/ThatsAll.ogg',
							"The Folks On The Hill"='sound/turntable/TheFolksWhoLiveOnTheHill.ogg')



/obj/machinery/party/turntable/mixer
	name = "mixer"
	desc = "A mixing board for mixing music"
	icon_state = "mixer"
	density = 0
	anchored = 1
	default_songs = list ("Alien"='sound/turntable/club_music/Alien_vs_Predator.ogg',
					"Below The Asteroids"='sound/turntable/club_music/BelowTheAsteroids.ogg',
					"Crystals"='sound/turntable/club_music/Crystals.ogg',
					"Deus Ex Machina"='sound/turntable/club_music/DE_NYClub.ogg',
					"Gabbag"='sound/turntable/club_music/gabbag.ogg',
					"Isolated"='sound/turntable/club_music/Isolated.ogg',
					"Jank"='sound/turntable/club_music/jank.ogg',
					"Last Day Alive"='sound/turntable/club_music/LastDayAlive.ogg',
					"Nocture City"='sound/turntable/club_music/NoctureCity.ogg',
					"Monsterbreaks"='sound/turntable/club_music/Monsterbreaks.ogg',
					"Pjanoo"='sound/turntable/club_music/Pjanoo.ogg',
					"Positive Vibes"='sound/turntable/club_music/PositiveVibe.ogg',
					"Techno Commie"='sound/turntable/club_music/SovietAnthem.ogg',
					"Space Migrator"='sound/turntable/club_music/SpaceMigrator.ogg',
					"Medbeat"='sound/turntable/club_music/Staggered_Injection.ogg',
					"Party In Positronic Brain"='sound/turntable/club_music/StillAlive.ogg',
					"Stronger Better Faster"='sound/turntable/club_music/stronger_better_faster.ogg',
					"Twilight"='sound/turntable/club_music/Twilight.ogg',
					"U. N."='sound/turntable/club_music/UNWasHer.ogg',
					"We Monsters"='sound/turntable/club_music/WeeMonsters.ogg')


/obj/machinery/party/turntable/New()
	..()
	sleep(2)
	new /sound/turntable/test(src)
	songs = default_songs
	return

/obj/machinery/party/turntable/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/party/turntable/attack_hand(mob/living/user as mob)
	if (..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/t = "<body background=turntable.png ><br><br><br><br><br><br><br><br><br><br><br><br><div align='center'>"
	t += "<A href='?src=\ref[src];off=1'><font color='maroon'>T</font><font color='geen'>urn</font> <font color='red'>Off</font></A>"
	if(m_disc)
		t += "<br><A href='?src=\ref[src];eject=1'><font color='maroon'>E</font><font color='geen'>ject <font color='red'>Disc</font></A>"
	t += "<table border='0' height='25' width='300'><tr>"

	for (var/i = 1, i<=(songs.len), i++)
		var/check = i%2
		t += "<td><A href='?src=\ref[src];on=[i]'><font color='maroon'>[copytext(songs[i],1,2)]</font><font color='purple'>[copytext(songs[i],2)]</font></A></td>"
		if(!check) t += "</tr><tr>"

	t += "</tr></table></div></body>"
	user << browse(t, "window=turntable;size=500x636;can_resize=1")
	onclose(user, "turntable")
	return

/obj/machinery/party/turntable/attackby(var/obj/item/I, var/mob/user)
	if (istype(I, /obj/item/party/music_disc))
		if (!m_disc)
			usr.drop_item()
			I.loc = src
			m_disc = I
		else user << "<font color='red'>Thre is another disc in this machine!</font>"
		read_disc()
	else
		..()
	src.updateUsrDialog()
	return

/obj/machinery/party/turntable/proc/read_disc()
	songs = m_disc.playlist
	updateDialog()
	return

/obj/machinery/party/turntable/Topic(href, href_list)
	..()
	if( href_list["on"])
		if(src.playing == 0)
			//world << "Should be working..."
			var/sound/S
			S = sound(songs[songs[text2num(href_list["on"])]])
			S.repeat = 1
			S.channel = 10
			S.falloff = 2
			S.wait = 1
			S.environment = 0

			var/area/A = src.loc.loc:master

			for(var/area/RA in A.related)
				for(var/obj/machinery/party/lasermachine/L in RA)
					L.turnon()
			playing = 1
			while(playing == 1)
				for(var/mob/M in world)
					var/area/location = get_area(M)
					if((location in A.related) && M.music == 0)
						//world << "Found the song..."
						M << S
						M.music = 1
					else if(!(location in A.related) && M.music == 1)
						var/sound/Soff = sound(null)
						Soff.channel = 10
						M << Soff
						M.music = 0
				sleep(10)
			return

	if( href_list["off"] )
		if(src.playing == 1)
			var/sound/S = sound(null)
			S.channel = 10
			S.wait = 1
			for(var/mob/M in world)
				M << S
				M.music = 0
			playing = 0
			var/area/A = src.loc.loc:master
			for(var/area/RA in A.related)
				for(var/obj/machinery/party/lasermachine/L in RA)
					L.turnoff()

	if( href_list["eject"] )
		m_disc.loc = src.loc
		m_disc.verb_pickup()
		m_disc = null
		songs = default_songs
		src.updateUsrDialog()
		return


/obj/machinery/party/lasermachine
	name = "laser machine"
	desc = "A laser machine that shoots lasers."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "lasermachine"
	anchored = 1
	var/mirrored = 0

/obj/effects/laser
	name = "laser"
	desc = "A laser..."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "laserred1"
	anchored = 1
	layer = 4

/obj/item/lasermachine/New()
	..()

/obj/machinery/party/lasermachine/proc/turnon()
	var/wall = 0
	var/cycle = 1
	var/area/A = get_area(src)
	var/X = 1
	var/Y = 0
	if(mirrored == 0)
		while(wall == 0)
			if(cycle == 1)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred1"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++

			if(cycle == 2)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred2"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++

			if(cycle == 3)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred3"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					del(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++

			if(mirrored == 1)
				while(wall == 0)
					if(cycle == 1)
						var/obj/effects/laser/F = new/obj/effects/laser(src)
						F.x = src.x+X
						F.y = src.y-Y
						F.z = src.z
						F.icon_state = "laserred1m"
						var/area/AA = get_area(F)
						var/turf/T = get_turf(F)
						if(T.density == 1 || AA.name != A.name)
							del(F)
							return
						cycle++
						if(cycle > 3)
							cycle = 1
						Y++

					if(cycle == 2)
						var/obj/effects/laser/F = new/obj/effects/laser(src)
						F.x = src.x+X
						F.y = src.y-Y
						F.z = src.z
						F.icon_state = "laserred2m"
						var/area/AA = get_area(F)
						var/turf/T = get_turf(F)
						if(T.density == 1 || AA.name != A.name)
							del(F)
							return
						cycle++
						if(cycle > 3)
							cycle = 1
						X++

					if(cycle == 3)
						var/obj/effects/laser/F = new/obj/effects/laser(src)
						F.x = src.x+X
						F.y = src.y-Y
						F.z = src.z
						F.icon_state = "laserred3m"
						var/area/AA = get_area(F)
						var/turf/T = get_turf(F)
						if(T.density == 1 || AA.name != A.name)
							del(F)
							return
						cycle++
						if(cycle > 3)
							cycle = 1
						X++


/obj/machinery/party/lasermachine/proc/turnoff()
	var/area/A = src.loc.loc
	for(var/area/RA in A.related)
		for(var/obj/effects/laser/F in RA)
			del(F)

/obj/item/party/music_disc
	name = "Music album"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "music_disc"
	var/list/playlist = list("Glorious Morning" = 'gloriousmorning2.ogg',
								"Absolute Zero" = 'AbsoluteZero.ogg',
								"Rave Vader" = 'RaveVader.ogg')


	New()
		..()
		desc="This album is labled [name]. on a backside following songs are listed:"
		for (var/i = 1, i<=(playlist.len), i++)
			desc+="<br>[i]. [copytext(playlist[i],1)]"
		return

/obj/machinery/party/gramophone
	name = "Gramophone"
	desc = "Old-time styley."
	icon = 'icons/obj/musician.dmi'
	icon_state = "gramophone"
	var/playing = 0
	anchored = 1
	density = 1

/obj/machinery/party/gramophone/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/party/gramophone/attack_hand(mob/living/user as mob)

	if (src.playing == 0)

		var/sound/S
		S = sound(pick('Taintedlove.ogg','Soviet.ogg'))
		S.repeat = 1
		S.channel = 10
		S.falloff = 2
		S.wait = 1
		S.environment = 0
		var/area/A = src.loc.loc:master

		for(var/area/RA in A.related)
			playing = 1
			while(playing == 1)
				for(var/mob/M in world)
					if((M.loc.loc in A.related) && M.music == 0)
						M << S
						M.music = 1
					else if(!(M.loc.loc in A.related) && M.music == 1)
						var/sound/Soff = sound(null)
						Soff.channel = 10
						M << Soff
						M.music = 0
				sleep(10)
			return

	else
		(src.playing) = 0
		var/sound/S = sound(null)
		S.channel = 10
		S.wait = 1
		for(var/mob/M in world)
			M << S
			M.music = 0
		playing = 0
		var/area/A = src.loc.loc:master
		for(var/area/RA in A.related)