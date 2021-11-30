/client
	var/list/parallax_layers_k = list()
	var/static/list/parallax_whitespace// = /atom/movable/screen/parallax/whitespace //Doesn't move, it's 'static' get it?




/client/proc/create_parallax()
	var/client/C = src
	//var add parallax object layers
	if(isnull(C.parallax_layers_k))
		C.parallax_layers_k = list()
	if (isnull(parallax_whitespace))
		parallax_whitespace += new /atom/movable/screen/parallax/whitespace()

	C.parallax_layers_k += new /atom/movable/screen/parallax/layer/plasma_giant(C)
	C.parallax_layers_k += new /atom/movable/screen/parallax/layer/starfield(C)
	// C.parallax_layers_k += new /atom/movable/screen/parallax/layer/nebula(C)
	C.parallax_layers_k += new /atom/movable/screen/parallax/layer/binary_stars(C)


	// C.screen |= (C.parallax_layers_k + C.parallax_static_layers_tail)
	C.screen += C.parallax_layers_k
	C.screen += parallax_whitespace

/client/proc/update_parallax()

/atom/movable/screen/parallax/layer
	icon = 'icons/turf/parallax/starfield.dmi'
	icon_state = ""
	blend_mode = BLEND_ADD
	mouse_opacity = 0
	plane = PLANE_PARALLAX
	layer = PARALLAX_LAYER
	appearance_flags = TILE_BOUND
	screen_loc = "1,1"
	var/pan_s = 1				//for pan_speed
	var/width
	var/height
	var/static/midx 	//middle x value of map, should be 150 most of the time
	var/static/midy 	//middle y value of map, should be 150 most of the time
	var/view_x = 21
	var/view_y = 15
	var/x_offset
	var/y_offset

	New(var/client/C)
		..()
		// screen_loc = "CENTER-[C.view], CENTER-[C.view]"
		var/icon/I = new(icon, icon_state)
		width = I.Width()
		height = I.Height()
		message_admins("[src]. width:[width] height:[height]")
		midx = round(world.maxx/2)
		midy = round(world.maxy/2)
		var/list/items = splittext(C.view, "x")
		if (items.len)
			view_x = text2num(items[1])
			view_y = text2num(items[2])

	proc/update_pos(var/x as num, var/y as num)
		// src.transform = matrix(1, 0, x*width, 0, 1, y*height)
		// src.transform = matrix(midx-(x*pan_s),midy-(y*pan_s), MATRIX_TRANSLATE)

		//defaults
		if (!view_x)
			view_x = 21
		if (!view_y)
			view_y = 15
		// animate(src, transform = matrix(midx-(x*pan_s),midy-(y*pan_s), MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)
		// var/change_x = ((x * pan_s) % (view_x*world.icon_size))
		// var/change_y = ((y * pan_s) % (view_y*world.icon_size))
		// message_admins("[x],[pan_s]%%[world.maxx]//[width] --[src]")



		// var/thing_x = midx-(x*pan_s)
		// var/thing_y = midy-(y*pan_s)

		// var/bounds_x = 5*world.icon_size
		// var/bounds_y = 5*world.icon_size



		// animate(src, transform = matrix(thing_x,thing_y, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)
		// scrollX = calculateScroll(playerX, 00000, playfieldWidth, screenWidth - layerWidth + 1);

 	//  calculateScroll( int scroll, int minScroll, int maxScroll, int screenWidth - layerWidth + 1) {
  // 		return (minScroll / 2 - scroll) * (screenWidth - layerWidth + 1 - viewportSize) / (maxScroll - minScroll);


		var/Itestx = (pan_s*x) * ((view_x*world.icon_size)-width-(7*world.icon_size))/(world.maxx*world.icon_size)
		var/Itesty = (pan_s*y) * ((view_y*world.icon_size)-height-(5*world.icon_size))/(world.maxy*world.icon_size)
		// var/Itesty = (0/2-x) * (world.maxy-(height) - (5*world.icon_size)/*viewportSize*/)/(300-0)

		// var/kyltestx = (x)(width-7*world.icon_size)/(world.maxx-(x*pan_s)

		animate(src, transform = matrix(Itestx,Itesty, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)

		// var/zewaka_testx = (world.maxx*width)%(x*pan_s)
		// var/zewaka_testy = (world.maxy*height)%(y*pan_s)
		// animate(src, transform = matrix(zewaka_testx,zewaka_testy, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)

		// var/change_x = ((x * pan_s) % (world.maxx/width))
		// var/change_y = ((y * pan_s) % (world.maxy/height))

		// animate(src, transform = matrix(change_x,change_y, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)



		// var/xxx = (x * pan_s)/( src.view_x*world.icon_size)
		// var/yyy = (x * pan_s)/( src.view_y*world.icon_size)
		// message_admins("[midx]|[x]*[pan_s] = [x*pan_s]|[x_offset]")


		// var/x = world.icon_size
		// animate(src, transform = matrix(midx(x*pan_s)-x_offset,(y*pan_s)-y_offset, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)

		//test
		// animate(src, transform = matrix((midx-x)*pan_s-x_offset,(midy-y)*pan_s-y_offset, MATRIX_TRANSLATE), time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)

	plasma_giant
		icon = 'icons/turf/parallax/plasma_giant.dmi'
		icon_state = "plasma_giant"
		layer = PARALLAX_LAYER+0.004
		pan_s = 1.4
		blend_mode = BLEND_OVERLAY

		New()
			..()
			x_offset = width*midx/world.maxx
			// y_offset = height*midy/world.maxy

	starfield
		icon_state = "starfield"
		layer = PARALLAX_LAYER+0.001
		pan_s = 0.6
		New()
			..()
			// var/matrix/M = matrix()
			// M.Scale(1.375, 1)
			// transform = M

	nebula
		icon_state = "nebula"
		layer = PARALLAX_LAYER+0.002
		pan_s = 0.8
		New()
			..()
			// var/matrix/M = matrix()
			// M.Scale(1.375, 1)
			// transform = M

	binary_stars
		icon_state = "binary_stars"
		layer = PARALLAX_LAYER+0.003
		pan_s = 1.0

/mob/Move(NewLoc)
	var/tmp/old_loc = loc
	..()
	if (NewLoc == old_loc || src.client)
		message_admins("THINGYSDFD")
		return
	// var/midx = round(world.maxx/2)
	// var/midy = round(world.maxy/2)
	// boutput(src, "[old_loc]|[NewLoc] |[midx],[midy]")
	boutput(src, "x:[x] y:[y]")
	for (var/atom/movable/screen/parallax/layer/P in src?.client.parallax_layers_k)
		P.update_pos(x,y)

//Kinda stole this idea. Make all of spess blank for this client, then put parallax shit over it.
/atom/movable/screen/parallax/whitespace
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	appearance_flags = PLANE_MASTER
	plane = PLANE_SPACE
	// blend_mode = BLEND_INSET_OVERLAY	//This one worked
	blend_mode = BLEND_MULTIPLY
	override = 1
	color = list(
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1
		)
	screen_loc = "CENTER,CENTER"

	// New()	//Does nothing... maybe...
	// 	..()
	// 	var/icon/I = new/icon('icons/effects/nothing.dmi',"nothing")
	// 	filters += filter(type="alpha",icon = I, flags = MASK_INVERSE)

/turf/space
	blend_mode = BLEND_MULTIPLY
	// alpha = 0

