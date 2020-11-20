

--##
--##	CONSTANTS, LOCALIZED FUNCTIONS
--##

	local abs   = math.abs
	local max   = math.max
	local min   = math.min
	local floor = math.floor
	
	
	--local mg_golden_ratio = ((1 + (5^0.5)) * 0.5)				-- is 1.61803398875
	--local euler_mascheroni_const = 0.5772156649
	--local euler_number = 2.7182818284
	
	--##		local mg_golden_ratio = ((1 + (5^0.5)) * 0.5)				-- is 1.61803398875
	--##		local mg_golden_ratio_double = mg_golden_ratio * 2			-- is 3.2360679775
	--##		local mg_golden_ratio_half = mg_golden_ratio * 0.5			-- is 0.809016994375
	--##		local mg_golden_ratio_tenth = mg_golden_ratio * 0.1			-- is 0.161803398875
	--##		local mg_golden_ratio_fivetenths = mg_golden_ratio * 0.05		-- is 0.0809016994375
	--##		
	--##		local euler_mascheroni_const = 0.5772156649
	--##		local euler_number = 2.7182818284
	--##		
	--##		euler_mascheroni_const = 0.5772156649-0153286060-6512090082-4024310421-5933593992
	--##		euler_number = 2.7182818284-5904523536-0287471352-6624977572-4709369995
	--##		
	--##		sqrt(2)		=	1.41421356237
	--##		sqrt(3)		=	1.73205080757
	--##		sqrt(5)		=	2.2360679775
	--##		sqrt(6)		=	2.44948974278
	--##		sqrt(7)		=	2.64575131106
	--##		sqrt(8)		=	2.82842712475
	--##		sqrt(10)	=	3.16227766017
	--##		sqrt(11)	=	3.31662479036
	--##		sqrt(12)	=	3.46410161514
	--##		sqrt(13)	=	3.60555127546
	--##		sqrt(14)	=	3.74165738677
	--##		sqrt(15)	=	3.87298334621
	--##		sqrt(17)	=	4.12310562562
	--##		sqrt(18)	=	4.24264068712
	--##		sqrt(19)	=	4.35889894354
	--##		sqrt()		= 
	--##		pi		=	3.14159265359
	--##		pi/2		=	1.5707963268
	--##		
	--##		
	


--##
--##	MIDPOINT, TRIANGULATION FUNCTIONS
--##

	function lib_mg_voronoi.get_midpoint(a,b)						--get_midpoint(a,b)
		return ((a.x+b.x) * 0.5), ((a.z+b.z) * 0.5)					--returns the midpoint between two points
	end
	
	function lib_mg_voronoi.get_triangulation_2d(a,b,c)					--get_2d_triangulation(a,b,c)
		return ((a.x+b.x+c.x)/3), ((a.z+b.z+c.z)/3)				--returns the triangulated point between three points (average pos)
	end
	
	function lib_mg_voronoi.get_triangulation_3d(a,b,c)					--get_3d_triangulation(a,b,c)
		return ((a.x+b.x+c.x)/3), ((a.y+b.y+c.y)/3), ((a.z+b.z+c.z)/3)		--returns the 3D triangulated point between three points (average pos)
	end


--##
--##	DIRECTION, SLOPE FUNCTIONS
--##

	function lib_mg_voronoi.get_direction_to_pos(a,b)
		local t_compass
		local t_dir = {x = 0, z = 0}
	
		if a.z < b.z then
			t_dir.z = 1
			t_compass = "N"
		elseif a.z > b.z then
			t_dir.z = -1
			t_compass = "S"
		else
			t_dir.z = 0
			t_compass = ""
		end
		if a.x < b.x then
			t_dir.x = 1
			t_compass = t_compass .. "E"
		elseif a.x > b.x then
			t_dir.x = -1
			t_compass = t_compass .. "W"
		else
			t_dir.x = 0
			t_compass = t_compass .. ""
		end
		return t_dir, t_compass
	end
	
	function lib_mg_voronoi.get_slope(a,b)
		local run = a.x-b.x
		local rise = a.z-b.z
		return (rise/run), rise, run
	end
	
	function lib_mg_voronoi.get_slope_inverse(a,b)
		local run = a.x-b.x
		local rise = a.z-b.z
		return (run/rise), run, rise
	end
	
	function lib_mg_voronoi.get_line_inverse(a,b)
		local run = a.x-b.x
		local rise = a.z-b.z
		local inverse = (run - rise) / 2
		local c = {
			x = a.x + inverse,
			y = b.z + inverse
		}
		local d = {
			x = b.x - inverse,
			y = a.z - inverse
		}
		return c, d
	end




--##
--##	DISTANCE FUNCTIONS
--##
--[[
	function lib_mg_voronoi.get_dist(a,b,d_type)						--get_distance(a,b)
	
		local this_dist
		
		if d_type == "a" then
			this_dist = (abs(a) + abs(b)) * 0.5
		elseif d_type == "c" then
			this_dist = max(abs(a), abs(b))
		elseif d_type == "e" then
			this_dist = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		elseif d_type == "l" then
			this_dist = min(abs(a), abs(b))
		elseif d_type == "m" then
			this_dist = abs(a) + abs(b)
		elseif d_type == "x" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_c + d_e + d_m) * 0.25
		elseif d_type == "r" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = d_a + d_c + d_e + d_m
		elseif d_type == "ac" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			this_dist = (d_a + d_c) * 0.5
		elseif d_type == "ae" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			this_dist = (d_a + d_e) * 0.5
		elseif d_type == "al" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_l = min(abs(a), abs(b))
			this_dist = (d_a + d_l) * 0.5
		elseif d_type == "am" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_m) * 0.5
		elseif d_type == "ce" then
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			this_dist = (d_c + d_e) * 0.5
		elseif d_type == "cl" then
			local d_c = max(abs(a), abs(b))
			local d_l = min(abs(a), abs(b))
			this_dist = (d_c + d_e) * 0.5
		elseif d_type == "cm" then
			local d_c = max(abs(a), abs(b))
			local d_m = abs(a) + abs(b)
			this_dist = (d_c + d_m) * 0.5
			--this_dist = (d_c + d_m)
		elseif d_type == "em" then
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_e + d_m) * 0.5
		elseif d_type == "ace" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			this_dist = (d_a + d_c + d_e) * 0.35
		elseif d_type == "acm" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_c + d_m) * 0.35
		elseif d_type == "aem" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_e + d_m) * 0.35
		elseif d_type == "cem" then
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_c + d_e + d_m) * 0.35
		else
			this_dist = 0
		end
	
		return this_dist
	
	end
--]]

	local function get_dist_a(a,b)						--get_distance(a,b)
		return (abs(a) + abs(b)) * 0.5
	end

	local function get_dist_c(a,b)						--get_distance(a,b)
		return max(abs(a), abs(b))
	end

	local function get_dist_e(a,b)						--get_distance(a,b)
		return ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
	end

	local function get_dist_l(a,b)						--get_distance(a,b)
		return min(abs(a), abs(b))
	end

	local function get_dist_m(a,b)						--get_distance(a,b)
		return abs(a) + abs(b)
	end

	local function get_dist_r(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_c = max(abs(a), abs(b))
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		local d_m = abs(a) + abs(b)
		return d_a + d_c + d_e + d_m
	end

	local function get_dist_x(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_c = max(abs(a), abs(b))
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		local d_m = abs(a) + abs(b)
		return (d_a + d_c + d_e + d_m) * 0.25
	end

	local function get_dist_ac(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_c = max(abs(a), abs(b))
		return (d_a + d_c) * 0.5
	end

	local function get_dist_ae(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		return (d_a + d_e) * 0.5
	end

	local function get_dist_al(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_l = min(abs(a), abs(b))
		return (d_a + d_l) * 0.5
	end

	local function get_dist_am(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_m = abs(a) + abs(b)
		return (d_a + d_m) * 0.5
	end

	local function get_dist_ce(a,b)						--get_distance(a,b)
		local d_c = max(abs(a), abs(b))
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		return (d_c + d_e) * 0.5
	end

	local function get_dist_cl(a,b)						--get_distance(a,b)
		local d_c = max(abs(a), abs(b))
		local d_l = min(abs(a), abs(b))
		return (d_c + d_e) * 0.5
	end

	local function get_dist_cm(a,b)						--get_distance(a,b)
		local d_c = max(abs(a), abs(b))
		local d_m = abs(a) + abs(b)
		return (d_c + d_m) * 0.5
	end

	local function get_dist_em(a,b)						--get_distance(a,b)
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		local d_m = abs(a) + abs(b)
		return (d_e + d_m) * 0.5
	end

	local function get_dist_ace(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_c = max(abs(a), abs(b))
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		return (d_a + d_c + d_e) * 0.35
	end

	local function get_dist_acm(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_c = max(abs(a), abs(b))
		local d_m = abs(a) + abs(b)
		return (d_a + d_c + d_m) * 0.35
	end

	local function get_dist_aem(a,b)						--get_distance(a,b)
		local d_a = (abs(a) + abs(b)) * 0.5
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		local d_m = abs(a) + abs(b)
		return (d_a + d_e + d_m) * 0.35
	end

	local function get_dist_cem(a,b)						--get_distance(a,b)
		local d_c = max(abs(a), abs(b))
		local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		local d_m = abs(a) + abs(b)
		return (d_c + d_e + d_m) * 0.35
	end

	function lib_mg_voronoi.set_dist_func(d_type)

		if d_type == "a" then
			lib_mg_voronoi.get_dist = get_dist_a
		elseif d_type == "c" then
			lib_mg_voronoi.get_dist = get_dist_c
		elseif d_type == "e" then
			lib_mg_voronoi.get_dist = get_dist_e
		elseif d_type == "l" then
			lib_mg_voronoi.get_dist = get_dist_l
		elseif d_type == "m" then
			lib_mg_voronoi.get_dist = get_dist_m
		elseif d_type == "r" then
			lib_mg_voronoi.get_dist = get_dist_r
		elseif d_type == "x" then
			lib_mg_voronoi.get_dist = get_dist_x
		elseif d_type == "ac" then
			lib_mg_voronoi.get_dist = get_dist_ac
		elseif d_type == "ae" then
			lib_mg_voronoi.get_dist = get_dist_ae
		elseif d_type == "al" then
			lib_mg_voronoi.get_dist = get_dist_al
		elseif d_type == "am" then
			lib_mg_voronoi.get_dist = get_dist_am
		elseif d_type == "ce" then
			lib_mg_voronoi.get_dist = get_dist_ce
		elseif d_type == "cl" then
			lib_mg_voronoi.get_dist = get_dist_cl
		elseif d_type == "cm" then
			lib_mg_voronoi.get_dist = get_dist_cm
		elseif d_type == "em" then
			lib_mg_voronoi.get_dist = get_dist_em
		elseif d_type == "ace" then
			lib_mg_voronoi.get_dist = get_dist_ace
		elseif d_type == "acm" then
			lib_mg_voronoi.get_dist = get_dist_acm
		elseif d_type == "aem" then
			lib_mg_voronoi.get_dist = get_dist_aem
		elseif d_type == "cem" then
			lib_mg_voronoi.get_dist = get_dist_cem
		else
			lib_mg_voronoi.get_dist = get_dist_a
		end
	end
--[[
	function lib_mg_voronoi.get_distance(a,b,d_type)						--get_distance(a,b)
	
		local this_dist
		
		if d_type == "a" then
			this_dist = (abs(a) + abs(b)) * 0.5
		elseif d_type == "c" then
			this_dist = max(abs(a), abs(b))
		elseif d_type == "e" then
			this_dist = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
		elseif d_type == "l" then
			this_dist = min(abs(a), abs(b))
		elseif d_type == "m" then
			this_dist = abs(a) + abs(b)
		elseif d_type == "x" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_c + d_e + d_m) * 0.25
		elseif d_type == "r" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = d_a + d_c + d_e + d_m
		elseif d_type == "ac" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			this_dist = (d_a + d_c) * 0.5
		elseif d_type == "ae" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			this_dist = (d_a + d_e) * 0.5
		elseif d_type == "al" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_l = min(abs(a), abs(b))
			this_dist = (d_a + d_l) * 0.5
		elseif d_type == "am" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_m) * 0.5
		elseif d_type == "ce" then
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			this_dist = (d_c + d_e) * 0.5
		elseif d_type == "cl" then
			local d_c = max(abs(a), abs(b))
			local d_l = min(abs(a), abs(b))
			this_dist = (d_c + d_e) * 0.5
		elseif d_type == "cm" then
			local d_c = max(abs(a), abs(b))
			local d_m = abs(a) + abs(b)
			this_dist = (d_c + d_m) * 0.5
			--this_dist = (d_c + d_m)
		elseif d_type == "em" then
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_e + d_m) * 0.5
		elseif d_type == "ace" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			this_dist = (d_a + d_c + d_e) * 0.35
		elseif d_type == "acm" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_c = max(abs(a), abs(b))
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_c + d_m) * 0.35
		elseif d_type == "aem" then
			local d_a = (abs(a) + abs(b)) * 0.5
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_a + d_e + d_m) * 0.35
		elseif d_type == "cem" then
			local d_c = max(abs(a), abs(b))
			local d_e = ((abs(a) * abs(a)) + (abs(b) * abs(b)))^0.5
			local d_m = abs(a) + abs(b)
			this_dist = (d_c + d_e + d_m) * 0.35
		else
			this_dist = 0
		end
	
		return this_dist
	
	end
--]]

--##
--##	NOISE FUNCTIONS
--##

	function lib_mg_voronoi.max_height(noiseprm)
		local height = 0					--	30		18
		local scale = noiseprm.scale				--	18		10.8
		for i=1,noiseprm.octaves do				--	10.8		6.48
			height=height + scale				--	6.48		3.88
			scale = scale * noiseprm.persist		--	3.88		2.328
		end							--	-----		------
		return height+noiseprm.offset				--			41.496 + (-4)
	end								--			37.496
	
	function lib_mg_voronoi.min_height(noiseprm)
		local height = 0
		local scale = noiseprm.scale
		for i=1,noiseprm.octaves do
			height=height - scale
			scale = scale * noiseprm.persist
		end	
		return height+noiseprm.offset
	end
	
	function lib_mg_voronoi.rangelim(a, min, max)
		if a < 0 then
			return min
		end
		if a > 1 then
			return max
		end
		return a
	end



--##
--##	NOISE DATA FUNCTIONS
--##
--[[
	local mult = lib_mg_voronoi.mg_world_scale
	local noise_scale = lib_mg_voronoi.mg_noise_scale

	local np_terrain = lib_mg_voronoi.P["np_terrain"]

	--lib_mg_voronoi.mountain_altitude = np_terrain.scale * 0.75
	--lib_mg_voronoi.mountain_altitude = 240

	local hills_thresh = floor((np_terrain.scale) * 0.5)
	local shelf_thresh = floor((np_terrain.scale) * 0.5) 
	local cliffs_thresh = floor((np_terrain.scale) * 0.5)

	lib_mg_voronoi.mg_hills_thresh = hills_thresh
	lib_mg_voronoi.mg_shelf_thresh = shelf_thresh
	lib_mg_voronoi.mg_cliffs_thresh = cliffs_thresh

	local base_min = lib_mg_voronoi.min_height(np_terrain)
	local base_max = lib_mg_voronoi.max_height(np_terrain)
	local base_rng = base_max-base_min
	local easing_factor = 1/(base_max*base_max*4)

	lib_mg_voronoi.mg_base_min = base_min
	lib_mg_voronoi.mg_base_max = base_max
	lib_mg_voronoi.mg_base_rng = base_rng
	lib_mg_voronoi.mg_easing_factor = easing_factor
--]]



--##
--##	ISLANDS TERRAIN SHAPING FUNCTIONS:	get_terrain_height, _shelf, _hills, _cliffs, _adjustable variants.
--##
--
	function lib_mg_voronoi.get_terrain_height(theight,hheight,cheight)
			-- parabolic gradient
		if theight > 0 and theight < shelf_thresh then
			theight = theight * (theight * theight / (shelf_thresh * shelf_thresh) * 0.5 + 0.5)
		end	
			-- hills
		local t_cliff = 0
		if theight > hills_thresh then
			theight = theight + max((theight - hills_thresh) * hheight,0)
			-- cliffs
		elseif theight > 1 and theight < hills_thresh then 
			local clifh = max(min(cheight,1),0) 
			if clifh > 0 then
				clifh = -1 * (clifh - 1) * (clifh - 1) + 1
				t_cliff = clifh
				theight = theight + (hills_thresh - theight) * clifh * ((theight < 2) and theight - 1 or 1)
			end
		end
		return theight, t_cliff
	end
	function lib_mg_voronoi.get_terrain_height_shelf(theight)
			-- parabolic gradient
		if theight > 0 and theight < shelf_thresh then
			theight = theight * (theight * theight / (shelf_thresh * shelf_thresh) * 0.5 + 0.5)
		end
	
		return theight
	end
	function lib_mg_voronoi.get_terrain_height_cliffs(theight,cheight)
			-- cliffs
		local t_cliff = 0
		if theight > 1 and theight < hills_thresh then 
			local clifh = max(min(cheight,1),0) 
			if clifh > 0 then
				clifh = -1 * (clifh - 1) * (clifh - 1) + 1
				t_cliff = clifh
				theight = theight + (hills_thresh - theight) * clifh * ((theight < 2) and theight - 1 or 1)
				--theight = theight + (cliffs_thresh - theight) * clifh * ((theight < 2) and theight - 1 or 1)
			end
		end
		return theight, t_cliff
	end








