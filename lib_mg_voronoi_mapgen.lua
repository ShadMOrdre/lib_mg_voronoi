

minetest.set_mapgen_setting('mg_name','singlenode',true)
minetest.set_mapgen_setting('flags','nolight',true)
--minetest.set_mapgen_params({mgname="singlenode"})

--local storage = minetest.get_mod_storage()

--local P = lib_mg_voronoi.P
--local C = lib_mg_voronoi.C

	local mg_type = lib_mg_voronoi.mg_type
	local mg_3d = lib_mg_voronoi.mg_3d

	local abs   = math.abs
	local max   = math.max
	local min   = math.min
	local floor = math.floor


	local c_air			= minetest.get_content_id("air")
	local c_ignore			= minetest.get_content_id("ignore")

	local c_mossy			= minetest.get_content_id("lib_materials:stone_cobble_mossy")
	local c_gravel			= minetest.get_content_id("lib_materials:stone_gravel")
	local c_lava			= minetest.get_content_id("lib_materials:liquid_lava_source")

	local c_desertsand		= minetest.get_content_id("lib_materials:sand_desert")
	local c_desertsandstone		= minetest.get_content_id("lib_materials:stone_sandstone_desert")
	local c_desertstone		= minetest.get_content_id("lib_materials:stone_desert")
	local c_sand			= minetest.get_content_id("lib_materials:sand")
	local c_sandstone		= minetest.get_content_id("lib_materials:stone_sandstone")
	local c_silversand		= minetest.get_content_id("lib_materials:sand_silver")
	local c_silversandstone		= minetest.get_content_id("lib_materials:stone_sandstone_silver")
	local c_stone			= minetest.get_content_id("lib_materials:stone")
	local c_brick			= minetest.get_content_id("lib_materials:stone_brick")
	local c_block			= minetest.get_content_id("lib_materials:stone_block")
	local c_desertstoneblock	= minetest.get_content_id("lib_materials:stone_desert_brick")
	local c_desertstonebrick	= minetest.get_content_id("lib_materials:stone_desert_block")
	local c_obsidian		= minetest.get_content_id("lib_materials:stone_obsidian")
	local c_dirt			= minetest.get_content_id("lib_materials:dirt")
	local c_dirtdry			= minetest.get_content_id("lib_materials:dirt_dry")
	local c_dirtgrass		= minetest.get_content_id("lib_materials:dirt_with_grass")
	local c_dirtdrygrass		= minetest.get_content_id("lib_materials:dirt_with_grass_dry")
	local c_dirtdrydrygrass		= minetest.get_content_id("lib_materials:dirt_dry_with_grass_dry")
	local c_dirtbrowngrass		= minetest.get_content_id("lib_materials:dirt_with_grass_brown")
	local c_dirtgreengrass		= minetest.get_content_id("lib_materials:dirt_with_grass_green")
	local c_dirtjunglegrass		= minetest.get_content_id("lib_materials:dirt_with_grass_jungle_01")
	local c_dirtperm		= minetest.get_content_id("lib_materials:dirt_permafrost")
	local c_top			= minetest.get_content_id("lib_materials:dirt_with_grass")
	local c_coniferous		= minetest.get_content_id("lib_materials:dirt_with_litter_coniferous")
	local c_rainforest		= minetest.get_content_id("lib_materials:dirt_with_litter_rainforest")
	local c_snow			= minetest.get_content_id("lib_materials:dirt_with_snow")
	local c_ice			= minetest.get_content_id("lib_materials:ice")
	local c_water			= minetest.get_content_id("lib_materials:liquid_water_source")
	local c_river			= minetest.get_content_id("lib_materials:liquid_water_river_source")
	local c_muddy			= minetest.get_content_id("lib_materials:liquid_water_river_muddy_source")
	local c_swamp			= minetest.get_content_id("lib_materials:liquid_water_swamp_source")


	local np_terrain = {
		offset = lib_mg_voronoi.mg_noise_offset,
		scale = lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale,
		seed = 5934,
		spread = {x = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), y = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), z = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale)},
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		--flags = "defaults"
	}
	local np_v7_alt = {
		offset = lib_mg_voronoi.mg_noise_offset,
		scale = lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale,
		seed = 5934,
		spread = {x = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), y = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), z = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale)},
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		--flags = "defaults"
	}
	local np_v7_base = {
		offset = lib_mg_voronoi.mg_noise_offset,
		scale = (lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale) * 2.8,
		seed = 82341,
		spread = {x = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), y = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), z = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale)},
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		flags = "defaults"
	}

	local np_v7_height = {
		flags = "defaults",
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		--offset = 0.25,
		offset = -4,
		scale = 1,
		spread = {x = (500 * lib_mg_voronoi.mg_world_scale), y = (500 * lib_mg_voronoi.mg_world_scale), z = (500 * lib_mg_voronoi.mg_world_scale)},
		seed = 4213,
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
	}
	local np_v7_persist = {
		flags = "defaults",
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		offset = 0.6,
		scale = 0.1,
		spread = {x = (2000 * lib_mg_voronoi.mg_world_scale), y = (2000 * lib_mg_voronoi.mg_world_scale), z = (2000 * lib_mg_voronoi.mg_world_scale)},
		seed = 539,
		octaves = 3,
		persist = 0.6,
	}

	np_v7_filler_depth = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.2,
		spread = {x = 150, y = 150, z = 150},
		seed = 261,
		octaves = 3,
		persistence = 0.7,
	}
	local np_v7_cliffs = {
		offset = 0,					
		scale = 0.72,
		spread = {x = 180, y = 180, z = 180},
		seed = 78901,
		octaves = 5,
		persist = 0.5,
		lacunarity = 2.19,
	}

	local np_heat = {
		flags = "defaults",
		lacunarity = 2,
		offset = 50,
		scale = 50,
		--spread = {x = 1000, y = 1000, z = 1000},
		spread = {x = (1000 * lib_mg_voronoi.mg_world_scale), y = (1000 * lib_mg_voronoi.mg_world_scale), z = (1000 * lib_mg_voronoi.mg_world_scale)},
		seed = 5349,
		octaves = 3,
		persist = 0.5,
	}
	local np_heat_blend = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.5,
		spread = {x = 8, y = 8, z = 8},
		seed = 13,
		octaves = 2,
		persist = 1,
	}
	local np_humid = {
		flags = "defaults",
		lacunarity = 2,
		offset = 50,
		scale = 50,
		--spread = {x = 1000, y = 1000, z = 1000},
		spread = {x = (1000 * lib_mg_voronoi.mg_world_scale), y = (1000 * lib_mg_voronoi.mg_world_scale), z = (1000 * lib_mg_voronoi.mg_world_scale)},
		seed = 842,
		octaves = 3,
		persist = 0.5,
	}
	local np_humid_blend = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.5,
		spread = {x = 8, y = 8, z = 8},
		seed = 90003,
		octaves = 2,
		persist = 1,
	}

	lib_mg_voronoi.mountain_altitude = np_v7_base.scale * 0.75
	local cliffs_thresh = floor((np_v7_alt.scale) * 0.5)

	local nobj_filler_depth = nil
	local nbuf_filler_depth = nil

	local nobj_cliffs = nil
	local nbuf_cliffs = nil

	local nobj_heatmap = nil
	local nbuf_heatmap = nil
	local nobj_heatblend = nil
	local nbuf_heatblend = nil
	local nobj_humiditymap = nil
	local nbuf_humiditymap = nil
	local nobj_humidityblend = nil
	local nbuf_humidityblend = nil

	local mg_world_scale = lib_mg_voronoi.mg_world_scale
	local b_mult = lib_mg_voronoi.mg_biome_scale
	local dist_metric = lib_mg_voronoi.mg_distance_metric
	local base_max = lib_mg_voronoi.mg_base_max
	local base_min = lib_mg_voronoi.mg_base_min
	local base_rng = lib_mg_voronoi.mg_base_rng

	local mg_base_height = lib_mg_voronoi.mg_base_height
	lib_mg_voronoi.mountain_altitude = mg_base_height

	local min_ocean = lib_materials.ocean_depth * mg_world_scale
	local min_beach = lib_materials.beach_depth * mg_world_scale
	local max_beach = lib_materials.maxheight_beach * mg_world_scale
	local max_highland = lib_materials.maxheight_highland * mg_world_scale
	local max_mountain = lib_materials.maxheight_mountain * mg_world_scale

	local v_cscale = 0.05
	local v_pscale = 0.1
	local v_mscale = 0.125
	local v_cmscale = 0.1
	local v_pmscale = 0.2
	local v_mmscale = 0.25
	local v_csscale = 0.2
	local v_psscale = 0.4
	local v_msscale = 0.5
	local p_cscale = 0.66
	local p_pscale = 1.33
	local p_mscale = 2.64575131106

	local mg_golden_ratio = 0.0161803398875

--##	
--##	Create a table of biome ids, so I can use the biomemap.
--##	

	lib_mg_voronoi.biome_info = {}

	for name, desc in pairs(minetest.registered_biomes) do

		if desc then

			lib_mg_voronoi.biome_info[desc.name] = {}

			lib_mg_voronoi.biome_info[desc.name].b_name = desc.name
			lib_mg_voronoi.biome_info[desc.name].b_cid = minetest.get_biome_id(name)

			lib_mg_voronoi.biome_info[desc.name].b_top = c_dirtgrass
			lib_mg_voronoi.biome_info[desc.name].b_top_depth = 1
			lib_mg_voronoi.biome_info[desc.name].b_filler = c_dirt
			lib_mg_voronoi.biome_info[desc.name].b_filler_depth = 4
			lib_mg_voronoi.biome_info[desc.name].b_stone = c_stone
			lib_mg_voronoi.biome_info[desc.name].b_water_top = c_water
			lib_mg_voronoi.biome_info[desc.name].b_water_top_depth = 1
			lib_mg_voronoi.biome_info[desc.name].b_water = c_water
			lib_mg_voronoi.biome_info[desc.name].b_river = c_river
			----local b_riverbed = c_gravel
			----local b_riverbed_depth = 2
			----local b_cave_liquid = c_lava
			----local b_dungeon = c_mossy
			----local b_dungeon_alt = c_brick
			----local b_dungeon_stair = c_block
			----local b_node_dust = c_air
			lib_mg_voronoi.biome_info[desc.name].vertical_blend = 0
			lib_mg_voronoi.biome_info[desc.name].min_pos = {x=-31000, y=-31000, z=-31000}
			lib_mg_voronoi.biome_info[desc.name].max_pos = {x=31000, y=31000, z=31000}
			lib_mg_voronoi.biome_info[desc.name].b_miny = -31000
			lib_mg_voronoi.biome_info[desc.name].b_maxy = 31000
			lib_mg_voronoi.biome_info[desc.name].b_heat = 50
			lib_mg_voronoi.biome_info[desc.name].b_humid = 50
		

			if desc.node_top and desc.node_top ~= "" then
				lib_mg_voronoi.biome_info[desc.name].b_top = minetest.get_content_id(desc.node_top) or c_dirtgrass
			end

			if desc.depth_top then
				lib_mg_voronoi.biome_info[desc.name].b_top_depth = desc.depth_top or 1
			end

			if desc.node_filler and desc.node_filler ~= "" then
				lib_mg_voronoi.biome_info[desc.name].b_filler = minetest.get_content_id(desc.node_filler) or c_dirt
			end

			if desc.depth_filler then
				lib_mg_voronoi.biome_info[desc.name].b_filler_depth = desc.depth_filler or 4
			end

			if desc.node_stone and desc.node_stone ~= "" then
				lib_mg_voronoi.biome_info[desc.name].b_stone = minetest.get_content_id(desc.node_stone) or c_stone
			end

			if desc.node_water_top and desc.node_water_top ~= "" then
				lib_mg_voronoi.biome_info[desc.name].b_water_top = minetest.get_content_id(desc.node_water_top) or c_water
			end

			if desc.depth_water_top then
				b_water_top_depth = desc.depth_water_top or 1
			end

			if desc.node_water and desc.node_water ~= "" then
				lib_mg_voronoi.biome_info[desc.name].b_water = minetest.get_content_id(desc.node_water) or c_water
			end
			if desc.node_river_water and desc.node_river_water ~= "" then
				lib_mg_voronoi.biome_info[desc.name].b_river = minetest.get_content_id(desc.node_river_water) or c_water
			end

--[[
			if desc.node_riverbed and desc.node_riverbed ~= "" then
				b_riverbed = minetest.get_content_id(desc.node_riverbed)
			end

			if desc.depth_riverbed and desc.depth_riverbed ~= "" then
				b_riverbed_depth = desc.depth_riverbed or ""
			end

			if desc.node_cave_liquid and desc.node_cave_liquid ~= "" then
				b_cave_liquid = minetest.get_content_id(desc.node_cave_liquid)
			end

			if desc.node_dungeon and desc.node_dungeon ~= "" then
				b_dungeon = minetest.get_content_id(desc.node_dungeon)
			end

			if desc.node_dungeon_alt and desc.node_dungeon_alt ~= "" then
				b_dungeon_alt = minetest.get_content_id(desc.node_dungeon_alt)
			end

			if desc.node_dungeon_stair and desc.node_dungeon_stair ~= "" then
				b_dungeon_stair = minetest.get_content_id(desc.node_dungeon_stair)
			end

			if desc.node_dust and desc.node_dust ~= "" then
				b_node_dust = minetest.get_content_id(desc.node_dust)
			end
--]]
			if desc.vertical_blend then
				lib_mg_voronoi.biome_info[desc.name].vertical_blend = desc.vertical_blend or 0
			end

			if desc.y_min then
				lib_mg_voronoi.biome_info[desc.name].b_miny = desc.y_min or -31000
			end

			if desc.y_max then
				lib_mg_voronoi.biome_info[desc.name].b_maxy = desc.y_max or 31000
			end

			lib_mg_voronoi.biome_info[desc.name].min_pos = desc.min_pos or {x=-31000, y=-31000, z=-31000}
			if desc.y_min then
				lib_mg_voronoi.biome_info[desc.name].min_pos.y = math.max(lib_mg_voronoi.biome_info[desc.name].min_pos.y, desc.y_min)
			end

			lib_mg_voronoi.biome_info[desc.name].max_pos = desc.max_pos or {x=31000, y=31000, z=31000}
			if desc.y_max then
				lib_mg_voronoi.biome_info[desc.name].max_pos.y = math.min(lib_mg_voronoi.biome_info[desc.name].max_pos.y, desc.y_max)
			end

			if desc.heat_point then
				lib_mg_voronoi.biome_info[desc.name].b_heat = desc.heat_point or 50
			end

			if desc.humidity_point then
				lib_mg_voronoi.biome_info[desc.name].b_humid = desc.humidity_point or 50
			end

		end
	end


--# FUNCTIONS
	local function rangelim(v, min, max)
		if v < min then return min end
		if v > max then return max end
		return v
	end

	local function get_heat_scalar(z)

		if lib_mg_voronoi.use_heat_scalar == true then
			local t_z = abs(z)
			local t_heat = 0
			local t_heat_scale = 0.0071875 
			local t_heat_factor = 0
	
			local t_heat_mid = ((lib_mg_voronoi.mg_map_size * lib_mg_voronoi.mg_world_scale) * 0.25)
			local t_diff = abs(t_heat_mid - t_z)
	
			if t_z >= t_heat_mid then
				t_heat_factor = t_heat_scale * -1
			elseif t_z <= t_heat_mid then
				t_heat_factor = t_heat_scale
			end
	
			local t_map_scale = t_heat_factor / lib_mg_voronoi.mg_world_scale
			return t_diff * t_map_scale
		else
			return 0
		end
	end

	local function get_humid_scalar(z, w)

		if lib_mg_voronoi.use_heat_scalar == true then
			local t_z = abs(z)
			local t_heat_scale = 0.0071875 
			local t_heat_factor = 0
	
			local t_heat_mid = ((lib_mg_voronoi.mg_map_size * lib_mg_voronoi.mg_world_scale) * 0.25)
			local t_diff = abs(t_heat_mid - t_z)
	
			if t_z > t_heat_mid then
				t_heat_factor = t_heat_scale * -1
			elseif t_z <= t_heat_mid then
				t_heat_factor = t_heat_scale
			end
	
			local t_heat = t_heat_factor / lib_mg_voronoi.mg_world_scale
			return (t_diff * t_heat) - w
		else
			return 0
		end
	end

	local function get_terrain_height_cliffs(theight,cheight)
			-- cliffs
		local t_cliff = 0
		if theight > 1 and theight < cliffs_thresh then 
			local clifh = max(min(cheight,1),0) 
			if clifh > 0 then
				clifh = -1 * (clifh - 1) * (clifh - 1) + 1
				t_cliff = clifh
				theight = theight + (cliffs_thresh - theight) * clifh * ((theight < 2) and theight - 1 or 1)
			end
		end
		return theight, t_cliff
	end

	local mapgen_times = {
		liquid_lighting = {},
		loop2d = {},
		loop3d = {},
		mainloop = {},
		make_chunk = {},
		noisemaps = {},
		preparation = {},
		setdata = {},
		writing = {},
	}

	local data = {}

	local m_top1 = 12.5
	local m_top2 = 37.5
	local m_top3 = 62.5
	local m_top4 = 87.5

	local m_biome1 = 25
	local m_biome2 = 50
	local m_biome3 = 75

	minetest.register_on_generated(function(minp, maxp, seed)
		
		-- Start time of mapchunk generation.
		local t0 = os.clock()
		
		local sidelen = maxp.x - minp.x + 1
		local permapdims2d = {x = sidelen, y = sidelen, z = 0}
		local permapdims3d = {x = sidelen, y = sidelen, z = sidelen}

		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		data = vm:get_data()
		local a = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
		local csize = vector.add(vector.subtract(maxp, minp), 1)

		nobj_filler_depth = nobj_filler_depth or minetest.get_perlin_map(np_v7_filler_depth, permapdims2d)
		nbuf_filler_depth = nobj_filler_depth:get_2d_map({x=minp.x,y=minp.z})

		nobj_cliffs = nobj_cliffs or minetest.get_perlin_map(np_v7_cliffs, permapdims2d)
		nbuf_cliffs = nobj_cliffs:get_2d_map({x=minp.x,y=minp.z})

		nobj_heatmap = nobj_heatmap or minetest.get_perlin_map(np_heat, permapdims3d)
		nbuf_heatmap = nobj_heatmap:get_2d_map({x=minp.x,y=minp.z})
		nobj_heatblend = nobj_heatblend or minetest.get_perlin_map(np_heat_blend, permapdims3d)
		nbuf_heatblend = nobj_heatblend:get_2d_map({x=minp.x,y=minp.z})
		nobj_humiditymap = nobj_humiditymap or minetest.get_perlin_map(np_humid, permapdims3d)
		nbuf_humiditymap = nobj_humiditymap:get_2d_map({x=minp.x,y=minp.z})
		nobj_humidityblend = nobj_humidityblend or minetest.get_perlin_map(np_humid_blend, permapdims3d)
		nbuf_humidityblend = nobj_humidityblend:get_2d_map({x=minp.x,y=minp.z})
	
		-- Mapgen preparation is now finished. Check the timer to know the elapsed time.
		local t1 = os.clock()
	
		local write = false
		
		local center_of_chunk = { 
			x = maxp.x - lib_mg_voronoi.half_map_chunk_size, 
			y = maxp.y - lib_mg_voronoi.half_map_chunk_size, 
			z = maxp.z - lib_mg_voronoi.half_map_chunk_size
		}
		--current_chunk = center_of_chunk

		if lib_mg_voronoi.mg_add_voronoi == true then
			local mn_idx, mn_dist, mn_rise, mn_run, mn_edge = lib_mg_voronoi.get_nearest_cell({x = center_of_chunk.x, z = center_of_chunk.z}, dist_metric, 1)
			local mn_neighbors = lib_mg_voronoi.get_cell_neighbors(mn_idx)
			local pn_idx, pn_dist, pn_rise, pn_run, pn_edge = lib_mg_voronoi.get_nearest_cell({x = center_of_chunk.x, z = center_of_chunk.z}, dist_metric, 2)
			local pn_neighbors = lib_mg_voronoi.get_cell_neighbors(pn_idx)
			local cn_idx, cn_dist, cn_rise, cn_run, cn_edge = lib_mg_voronoi.get_nearest_cell({x = center_of_chunk.x, z = center_of_chunk.z}, dist_metric, 3)
			local cn_neighbors = lib_mg_voronoi.get_cell_neighbors(cn_idx)
		end
	
	--2D HEIGHTMAP GENERATION
		local index2d = 0
	
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
	
				index2d = (z - minp.z) * csize.x + (x - minp.x) + 1

-- ## NOISE SELECTION

				local nfiller = nbuf_filler_depth[z-minp.z+1][x-minp.x+1]
				local ncliff = nbuf_cliffs[z-minp.z+1][x-minp.x+1]

-- ## NOISE GENERATION
				local aterrain = 0

				local nterrain = minetest.get_perlin(np_terrain):get_2d({x=x,y=z})

				local hselect = minetest.get_perlin(np_v7_height):get_2d({x=x,y=z})
				local hselect = rangelim(hselect, 0, 1)

				local persist = minetest.get_perlin(np_v7_persist):get_2d({x=x,y=z})

				np_v7_base.persistence = persist;
				local height_base = minetest.get_perlin(np_v7_base):get_2d({x=x,y=z})
	
				np_v7_alt.persistence = persist;
				local height_alt = minetest.get_perlin(np_v7_alt):get_2d({x=x,y=z})
	
				if (height_alt > height_base) then
					aterrain = floor(height_alt)
				else
					aterrain = floor((height_base * hselect) + (height_alt * (1 - hselect)))
				end

-- ## VORONOI SELECTION

				local c_idx, c_dist, c_rise, c_run, c_edge = lib_mg_voronoi.get_nearest_cell({x = x, z = z}, dist_metric, 3)
				local p_idx, p_dist, p_rise, p_run, p_edge = lib_mg_voronoi.get_nearest_cell({x = x, z = z}, dist_metric, 2)
				local m_idx, m_dist, m_rise, m_run, m_edge = lib_mg_voronoi.get_nearest_cell({x = x, z = z}, dist_metric, 1)

				local mcontinental = m_dist * v_cscale
				local pcontinental = p_dist * v_pscale
				local ccontinental = c_dist * v_mscale
				local vcontinental = (mcontinental + pcontinental + ccontinental)

-- ## TERRAIN GENERATION

				local bcliff = get_terrain_height_cliffs(nterrain,ncliff)

				--local vterrain = (mg_base_height - vcontinental) + (mg_base_height * 0.4)
				local bterrain = ((mg_base_height + bcliff) - vcontinental) + (mg_base_height * 0.4)

				--local vheight = vterrain * (1/vcontinental)
				--local aheight = aterrain * (1/vcontinental)
				--local nheight = nterrain * (1/vcontinental)
				local bheight = (bterrain + nterrain) * (1/vcontinental)

				--local velevation = vheight * (mg_world_scale/0.01)
				--local aelevation = aheight * (mg_world_scale/0.01)
				--local nelevation = nheight * (mg_world_scale/0.01)
				local belevation = bheight * (mg_world_scale/0.01)

				--local televation = velevation + aelevation
				local televation = belevation

				local t_y, t_c = get_terrain_height_cliffs(televation,ncliff)

				lib_mg_voronoi.heightmap[index2d] = t_y
				lib_mg_voronoi.fillermap[index2d] = nfiller
				lib_mg_voronoi.cliffmap[index2d] =  t_c


-- ## BIOME SELECTION (lib_materials biome defs)

				local nheat = (nbuf_heatmap[z-minp.z+1][x-minp.x+1] + nbuf_heatblend[z-minp.z+1][x-minp.x+1]) + get_heat_scalar(z)
				local nhumid = nbuf_humiditymap[z-minp.z+1][x-minp.x+1] + nbuf_humidityblend[z-minp.z+1][x-minp.x+1]

				local t_heat, t_humid, t_altitude, t_name

				if nheat < m_top1 then
					t_heat = "cold"
				elseif nheat >= m_top1 and nheat < m_top2 then
					t_heat = "cool"
				elseif nheat >= m_top2 and nheat < m_top3 then
					t_heat = "temperate"
				elseif nheat >= m_top3 and nheat < m_top4 then
					t_heat = "warm"
				elseif nheat >= m_top4 then
					t_heat = "hot"
				else

				end

				if nhumid < m_top1 then
					t_humid = "_arid"
				elseif nhumid >= m_top1 and nhumid < m_top2 then
					t_humid = "_semiarid"
				elseif nhumid >= m_top2 and nhumid < m_top3 then
					t_humid = "_temperate"
				elseif nhumid >= m_top3 and nhumid < m_top4 then
					t_humid = "_semihumid"
				elseif nhumid >= m_top4 then
					t_humid = "_humid"
				else

				end

				if t_y < min_beach then
					t_altitude = "_ocean"
				elseif t_y >= min_beach and t_y < max_beach then
					t_altitude = "_beach"
				elseif t_y >= max_beach and t_y < max_highland then
					t_altitude = ""
				elseif t_y >= max_highland and t_y < max_mountain then
					t_altitude = "_mountain"
				elseif t_y >= max_mountain then
					t_altitude = "_strato"
				else
					
				end

				if t_heat and t_heat ~= "" and t_humid and t_humid ~= "" then
					t_name = t_heat .. t_humid .. t_altitude
				else
					if (t_heat == "hot") and (t_humid == "_humid") and (nheat > 90) and (nhumid > 90) and (t_altitude == "_beach") then
						t_name = "hot_humid_swamp"
					elseif (t_heat == "hot") and (t_humid == "_semihumid") and (nheat > 90) and (nhumid > 80) and (t_altitude == "_beach") then
						t_name = "hot_semihumid_swamp"
					elseif (t_heat == "warm") and (t_humid == "_humid") and (nheat > 80) and (nhumid > 90) and (t_altitude == "_beach") then
						t_name = "warm_humid_swamp"
					elseif (t_heat == "temperate") and (t_humid == "_humid") and (nheat > 57) and (nhumid > 90) and (t_altitude == "_beach") then
						t_name = "temperate_humid_swamp"
					else
						t_name = "temperate_temperate"
					end
				end

				if t_y >= -31000 and t_y < -20000 then
					t_name = "generic_mantle"
				elseif t_y >= -20000 and t_y < -15000 then
					t_name = "stone_basalt_01_layer"
				elseif t_y >= -15000 and t_y < -10000 then
					t_name = "stone_brown_layer"
				elseif t_y >= -10000 and t_y < -6000 then
					t_name = "stone_sand_layer"
				elseif t_y >= -6000 and t_y < -5000 then
					t_name = "desert_stone_layer"
				elseif t_y >= -5000 and t_y < -4000 then
					t_name = "desert_sandstone_layer"
				elseif t_y >= -4000 and t_y < -3000 then
					t_name = "generic_stone_limestone_01_layer"
				elseif t_y >= -3000 and t_y < -2000 then
					t_name = "generic_granite_layer"
				elseif t_y >= -2000 and t_y < min_ocean then
					t_name = "generic_stone_layer"
				else
					
				end

				lib_mg_voronoi.biomemap[index2d] = t_name

			end
		end
	
		local t2 = os.clock()
	
		local t3 = os.clock()
	--
	--2D HEIGHTMAP RENDER
		local index2d = 0
		for z = minp.z, maxp.z do
			for y = minp.y, maxp.y do
				for x = minp.x, maxp.x do
				 
					index2d = (z - minp.z) * csize.x + (x - minp.x) + 1   
					local ivm = a:index(x, y, z)

					local write_3d = false
					local theight = lib_mg_voronoi.heightmap[index2d]
					local tfilldepth = lib_mg_voronoi.fillermap[index2d]
					local t_cliff = lib_mg_voronoi.cliffmap[index2d] or 0
					local t_biome_name = lib_mg_voronoi.biomemap[index2d]
	
					local fill_depth = 4
					local top_depth = 1

-- ## BIOME GENERATION
					local t_air = c_air
					local t_ignore = c_ignore
					local t_top = c_top
					local t_filler = c_dirt
					local t_stone = c_stone
					local t_water = c_water

					t_stone = lib_mg_voronoi.biome_info[t_biome_name].b_stone
					t_filler = lib_mg_voronoi.biome_info[t_biome_name].b_filler
					fill_depth = lib_mg_voronoi.biome_info[t_biome_name].b_filler_depth + tfilldepth
					t_top = lib_mg_voronoi.biome_info[t_biome_name].b_top
					top_depth = 1
					t_water = lib_mg_voronoi.biome_info[t_biome_name].b_water

					if t_cliff > 0 then
						--if theight > lib_mg_voronoi.water_level then
						--	t_top = t_filler
						--end
						t_filler = t_stone
					end

-- ## NODE PLACEMENT FROM HEIGHTMAP

					local t_node = t_ignore

				--2D Terrain
					if y < (theight - (fill_depth + top_depth)) then
						t_node = t_stone
					elseif y >= (theight - (fill_depth + top_depth)) and y < (theight - top_depth) then
						t_node = t_filler
					elseif y >= (theight - top_depth) and y <= theight then
						t_node = t_top
					elseif y > theight and y <= lib_mg_voronoi.water_level then
					--Water Level (Sea Level)
						t_node = t_water
					end

					data[ivm] = t_node
					write = true

				end
			end
		end
		
		local t4 = os.clock()
	
		if write then
			vm:set_data(data)
		end
	
		local t5 = os.clock()
		
		if write then
	
			minetest.generate_ores(vm,minp,maxp)
			minetest.generate_decorations(vm,minp,maxp)
				
			vm:set_lighting({day = 0, night = 0})
			vm:calc_lighting()
			vm:update_liquids()
		end
	
		local t6 = os.clock()
	
		if write then
			vm:write_to_map()
		end
	
		local t7 = os.clock()
	
		-- Print generation time of this mapchunk.
		local chugent = math.ceil((os.clock() - t0) * 1000)
		print ("[lib_mg_voronoi] Mapchunk generation time " .. chugent .. " ms")
	
		table.insert(mapgen_times.noisemaps, 0)
		table.insert(mapgen_times.preparation, t1 - t0)
		table.insert(mapgen_times.loop2d, t2 - t1)
		table.insert(mapgen_times.loop3d, t3 - t2)
		table.insert(mapgen_times.mainloop, t4 - t3)
		table.insert(mapgen_times.setdata, t5 - t4)
		table.insert(mapgen_times.liquid_lighting, t6 - t5)
		table.insert(mapgen_times.writing, t7 - t6)
		table.insert(mapgen_times.make_chunk, t7 - t0)
	
		-- Deal with memory issues. This, of course, is supposed to be automatic.
		local mem = math.floor(collectgarbage("count")/1024)
		if mem > 1000 then
			print("lib_mg_voronoi is manually collecting garbage as memory use has exceeded 500K.")
			collectgarbage("collect")
		end
	end)

	local function mean( t )
		local sum = 0
		local count= 0
	
		for k,v in pairs(t) do
			if type(v) == 'number' then
				sum = sum + v
				count = count + 1
			end
		end
	
		return (sum / count)
	end

	minetest.register_on_shutdown(function()

		--if lib_mg_voronoi.mg_add_voronoi == true then
			lib_mg_voronoi.save_neighbors()
		--end

		if #mapgen_times.make_chunk == 0 then
			return
		end
	
		local average, standard_dev
		minetest.log("lib_mg_voronoi lua Mapgen Times:")
	
		average = mean(mapgen_times.liquid_lighting)
		minetest.log("  liquid_lighting: - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.loop2d)
		minetest.log(" 2D Noise loops: - - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.loop3d)
		minetest.log(" 3D Noise loops: - - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.mainloop)
		minetest.log(" Main Render loops: - - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.make_chunk)
		minetest.log("  makeChunk: - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.noisemaps)
		minetest.log("  noisemaps: - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.preparation)
		minetest.log("  preparation: - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.setdata)
		minetest.log("  writing: - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.writing)
		minetest.log("  writing: - - - - - - - - - - - - - - - -  "..average)
	end)


