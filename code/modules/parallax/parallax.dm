/client
	var/list/parallax_layers_k = list()
	var/static/list/parallax_whitespace// = /obj/screen/parallax/whitespace //Doesn't move, it's 'static' get it?



// /datum/hud/proc/create_parallax()
// 	var/mob/M
// 	var/client/C
// 	if (islist(src.clients) && src.clients.len)
// 		C = src.clients[1]
// 		M = C.mob
// 	if (isnull(M))
// 		return

/client/proc/create_parallax()
	var/client/C = src
	//var add parallax object layers
	if(isnull(C.parallax_layers_k))
		C.parallax_layers_k = list()
	if (isnull(parallax_whitespace))
		parallax_whitespace += new /obj/screen/parallax/whitespace()

	C.parallax_layers_k += new /obj/screen/parallax/layer/plasma_giant(C)
	C.parallax_layers_k += new /obj/screen/parallax/layer/stars1(C)
	// C.parallax_layers_k += new /obj/screen/parallax/layer/stars2(C)


	// C.screen |= (C.parallax_layers_k + C.parallax_static_layers_tail)
	C.screen += C.parallax_layers_k
	C.screen += parallax_whitespace

/client/proc/update_parallax()

/obj/screen/parallax/layer
	icon = 'icons/turf/parallax/starfield.dmi'
	icon_state = ""
	blend_mode = BLEND_ADD
	mouse_opacity = FALSE
	plane = PLANE_PARALLAX
	layer = PARALLAX_LAYER
	var/pan_s = 1				//for pan_speed
	appearance_flags = TILE_BOUND
	screen_loc = "1,1"
	var/width
	var/height
	var/static/midx 	//middle x value of map, should be 150
	var/static/midy 	//middle y value of map, should be 150
	var/static/view_x
	var/static/view_y

	New(var/client/C)
		..()
		// screen_loc = "CENTER-[C.view], CENTER-[C.view]"
		var/icon/I = new(icon, icon_state)
		width = I.Width()
		height = I.Height()
		midx = round(world.maxx/2)
		midy = round(world.maxy/2)
		var/list/items = splittext(C.view, "x")
		if (items.len)
			view_x = text2num(items[1])
			view_y = text2num(items[2])

	proc/update_pos(var/x as num, var/y as num)
		// src.transform = matrix(1, 0, x*width, 0, 1, y*height)
		// src.transform = matrix(midx-(x*pan_s),midy-(y*pan_s), MATRIX_TRANSLATE)

		if (!view_x)
			view_x = 21
		if (!view_y)
			view_y = 15
		// animate(src, transform = matrix(midx-(x*pan_s),midy-(y*pan_s), MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)
		// var/change_x = ((x * pan_s) % (view_x*world.icon_size))
		// var/change_y = ((y * pan_s) % (view_y*world.icon_size))
		// message_admins("[x],[pan_s]%%[world.maxx]//[width] --[src]")
		// var/change_x = ((x * pan_s) % (world.maxx/width))
		// var/change_y = ((y * pan_s) % (world.maxy/height))

		// animate(src, transform = matrix(change_x,change_y, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)



		var/xxx = (x * pan_s)/( src.view_x*world.icon_size) 
		var/yyy = (x * pan_s)/( src.view_y*world.icon_size) 
		animate(src, transform = matrix(xxx,yyy, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)

	plasma_giant
		icon = 'icons/turf/parallax/plasma_giant.dmi'
		icon_state = "plasma_giant"
		layer = PARALLAX_LAYER+0.003
		pan_s = 2
		blend_mode = BLEND_OVERLAY
	stars1
		icon_state = "starfield1"
		layer = PARALLAX_LAYER+0.002
		pan_s = 1
		// New()
		// 	..()
			// var/matrix/M = matrix()
			// M.Scale(1.375, 1)
			// transform = M
			
	stars2
		icon_state = "stars2"
		layer = PARALLAX_LAYER+0.001
		pan_s = 1
		// New()
		// 	..()
		// 	var/matrix/M = matrix()
		// 	M.Scale(1.375, 1)
		// 	transform = M

/mob/Move(NewLoc)
	var/tmp/old_loc = loc
	..()
	// if (NewLoc != old_loc)
	// var/midx = round(world.maxx/2)
	// var/midy = round(world.maxy/2)
	// boutput(src, "[old_loc]|[NewLoc] |[midx],[midy]")

	if (src.client && src.client.parallax_layers_k)
		for (var/obj/screen/parallax/layer/P in src.client.parallax_layers_k)
			P.update_pos(x,y)
			// if (istype(P, /obj/screen/parallax/layer/plasma_giant))
			// 	P.transform = matrix(midx-(x*pan_s),midy-(y*pan_s), MATRIX_TRANSLATE)

			// else		//stars
			// 	P.transform = matrix(midx-(x*pan_s),midy-(y*pan_s), MATRIX_TRANSLATE)
		// for (var/obj/screen/parallax/layer/stars2/P in client.parallax_layers_k)
		// 	P.transform = matrix(-x,-y, MATRIX_TRANSLATE)

//Kinda stole this idea. Make all of spess blank for this client, then put parallax shit over it.
/obj/screen/parallax/whitespace
	appearance_flags = PLANE_MASTER
	plane = PLANE_SPACE
	color = list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		1, 1, 1, 1,
		0, 0, 0, 0
		)
	screen_loc = "CENTER,CENTER"
