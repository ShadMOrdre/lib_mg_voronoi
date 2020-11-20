


--##
--##	CONSTANTS and SETTINGS
--##


	lib_mg_voronoi.mg_voronoi_defaults = false

	lib_mg_voronoi.mg_distance_metric = "cm"

	lib_mg_voronoi.mg_world_scale = 0.1

	--lib_mg_voronoi.mg_biome_scale = 1
	lib_mg_voronoi.mg_biome_scale = lib_mg_voronoi.mg_world_scale
	--#  "full" -- loads all available biomes;	"dev" -- uses dirt with grass, dirt, stone, water
	lib_mg_voronoi.mg_biome_mode = "full"

	--lib_mg_voronoi.mg_noise_spread = 2400
	lib_mg_voronoi.mg_noise_spread = 600
--##	(2400 * 0.1) * 0.25 == 240 / 4 == 60
	--lib_mg_voronoi.mg_noise_scale = (lib_mg_voronoi.mg_noise_spread * 0.1) * 0.25
	--lib_mg_voronoi.mg_noise_scale = 100
	lib_mg_voronoi.mg_noise_scale = 25
	lib_mg_voronoi.mg_noise_offset = -4 * lib_mg_voronoi.mg_world_scale
	--lib_mg_voronoi.mg_noise_offset = 0
	--lib_mg_voronoi.mg_noise_octaves = 6
	lib_mg_voronoi.mg_noise_octaves = 8
	--lib_mg_voronoi.mg_noise_persist = 0.4
	lib_mg_voronoi.mg_noise_persist = 0.3
	--lib_mg_voronoi.mg_noise_lacunarity = 2.11
	lib_mg_voronoi.mg_noise_lacunarity = 2.19

	--lib_mg_voronoi.mg_base_height = (lib_mg_voronoi.mg_noise_spread * 0.125) * lib_mg_voronoi.mg_world_scale
	lib_mg_voronoi.mg_base_height = 300 * lib_mg_voronoi.mg_world_scale

	lib_mg_voronoi.mg_para_scale = 2.64575131106

	lib_mg_voronoi.mg_map_size = 60000

	lib_mg_voronoi.mgvalleys_river_size = 5
	--lib_mg_voronoi.water_level = minetest.get_mapgen_setting("water_level")

	lib_mg_voronoi.water_level = (1 * lib_mg_voronoi.mg_world_scale)

	lib_mg_voronoi.use_heat_scalar = false

	lib_mg_voronoi.mg_mountain = lib_materials.maxheight_highland


--##		--729	--358	--31	--29	--43	--17	--330	--83
--##
--##		729 = 9^3	358 = 7^2 + 15		693 = 9*11*7		15^3 = 3375
--##		1331 = 11^3	2431 = 13*17*11		4913 = 17^3		13^3 = 2197
--##

	lib_mg_voronoi.voronoi_type = "recursive"     --"single" or "recursive"
	lib_mg_voronoi.voronoi_cells = 2197
	lib_mg_voronoi.voronoi_recursion_1 = 13
	lib_mg_voronoi.voronoi_recursion_2 = 13
	lib_mg_voronoi.voronoi_recursion_3 = 17

--##
--##	
--##

	lib_mg_voronoi.points = {}
	lib_mg_voronoi.cellmap = {}
	lib_mg_voronoi.neighbors = {}
	
	lib_mg_voronoi.heightmap = {}
	lib_mg_voronoi.fillermap = {}
	lib_mg_voronoi.biomemap = {} 
	--lib_mg_voronoi.heatmap = {} 
	--lib_mg_voronoi.humiditymap = {} 
	lib_mg_voronoi.edgemap = {}
	lib_mg_voronoi.cliffmap = {}





--##
--##	CONENT_IDs
--##
--[[
	lib_mg_voronoi.C = {}
	
	lib_mg_voronoi.C["c_air"]			= minetest.get_content_id("air")
	lib_mg_voronoi.C["c_ignore"]			= minetest.get_content_id("ignore")
	
	lib_mg_voronoi.C["c_mossy"]			= minetest.get_content_id("lib_materials:stone_cobble_mossy")
	lib_mg_voronoi.C["c_gravel"]			= minetest.get_content_id("lib_materials:stone_gravel")

	lib_mg_voronoi.C["c_desertsand"]		= minetest.get_content_id("lib_materials:sand_desert")
	lib_mg_voronoi.C["c_desertsandstone"]		= minetest.get_content_id("lib_materials:stone_sandstone_desert")
	lib_mg_voronoi.C["c_desertstone"]		= minetest.get_content_id("lib_materials:stone_desert")
	lib_mg_voronoi.C["c_desertstoneblock"]		= minetest.get_content_id("lib_materials:stone_desert_block")
	lib_mg_voronoi.C["c_desertstonebrick"]		= minetest.get_content_id("lib_materials:stone_desert_brick")
	lib_mg_voronoi.C["c_sand"]			= minetest.get_content_id("lib_materials:sand")
	lib_mg_voronoi.C["c_sandstone"]			= minetest.get_content_id("lib_materials:stone_sandstone")
	lib_mg_voronoi.C["c_silversand"]		= minetest.get_content_id("lib_materials:sand_silver")
	lib_mg_voronoi.C["c_silversandstone"]		= minetest.get_content_id("lib_materials:stone_sandstone_silver")
	lib_mg_voronoi.C["c_stone"]			= minetest.get_content_id("lib_materials:stone")
	lib_mg_voronoi.C["c_brick"]			= minetest.get_content_id("lib_materials:stone_brick")
	lib_mg_voronoi.C["c_block"]			= minetest.get_content_id("lib_materials:stone_block")
	lib_mg_voronoi.C["c_cobble"]			= minetest.get_content_id("lib_materials:stone_cobble")
	lib_mg_voronoi.C["c_obsidian"]			= minetest.get_content_id("lib_materials:stone_obsidian")

	lib_mg_voronoi.C["c_dirt"]			= minetest.get_content_id("lib_materials:dirt")
	lib_mg_voronoi.C["c_dirtdry"]			= minetest.get_content_id("lib_materials:dirt_dry")
	lib_mg_voronoi.C["c_dirtgrass"]			= minetest.get_content_id("lib_materials:dirt_with_grass")
	lib_mg_voronoi.C["c_dirtdrygrass"]		= minetest.get_content_id("lib_materials:dirt_with_grass_dry")
	lib_mg_voronoi.C["c_dirtdrydrygrass"]		= minetest.get_content_id("lib_materials:dirt_dry_with_grass_dry")
	lib_mg_voronoi.C["c_dirtbrowngrass"]		= minetest.get_content_id("lib_materials:dirt_with_grass_brown")
	lib_mg_voronoi.C["c_dirtgreengrass"]		= minetest.get_content_id("lib_materials:dirt_with_grass_green")
	lib_mg_voronoi.C["c_dirtjunglegrass"]		= minetest.get_content_id("lib_materials:dirt_with_grass_jungle_01")
	lib_mg_voronoi.C["c_dirtperm"]			= minetest.get_content_id("lib_materials:dirt_permafrost")
	lib_mg_voronoi.C["c_top"]			= minetest.get_content_id("lib_materials:dirt_with_grass_green")
	lib_mg_voronoi.C["c_coniferous"]		= minetest.get_content_id("lib_materials:dirt_with_litter_coniferous")
	lib_mg_voronoi.C["c_rainforest"]		= minetest.get_content_id("lib_materials:dirt_with_litter_rainforest")
	
	lib_mg_voronoi.C["c_snow"]			= minetest.get_content_id("lib_materials:dirt_with_snow")
	lib_mg_voronoi.C["c_ice"]			= minetest.get_content_id("lib_materials:ice")
	
	lib_mg_voronoi.C["c_water"]			= minetest.get_content_id("lib_materials:liquid_water_source")
	lib_mg_voronoi.C["c_river"]			= minetest.get_content_id("lib_materials:liquid_water_river_source")
	lib_mg_voronoi.C["c_muddy"]			= minetest.get_content_id("lib_materials:liquid_water_river_muddy_source")
	lib_mg_voronoi.C["c_swamp"]			= minetest.get_content_id("lib_materials:liquid_water_swamp_source")
	
	lib_mg_voronoi.C["c_lava"]			= minetest.get_content_id("lib_materials:liquid_lava_source")
	
	
	lib_mg_voronoi.C["c_tree"]			= minetest.get_content_id("lib_ecology:tree_default_trunk")

	lib_mg_voronoi.C["c_dirtgrasshothumid"]			= minetest.get_content_id("lib_materials:dirt_with_grass_hot_humid")
	lib_mg_voronoi.C["c_dirtgrasshotsemihumid"]			= minetest.get_content_id("lib_materials:dirt_with_grass_hot_semihumid")
	lib_mg_voronoi.C["c_dirtgrasshottemperate"]			= minetest.get_content_id("lib_materials:dirt_with_grass_hot_temperate")
	lib_mg_voronoi.C["c_dirtgrasshotsemiarid"]			= minetest.get_content_id("lib_materials:dirt_with_grass_hot_semiarid")
	lib_mg_voronoi.C["c_dirtgrasswarmhumid"]			= minetest.get_content_id("lib_materials:dirt_with_grass_warm_humid")
	lib_mg_voronoi.C["c_dirtgrasswarmsemihumid"]		= minetest.get_content_id("lib_materials:dirt_with_grass_warm_semihumid")
	lib_mg_voronoi.C["c_dirtgrasswarmtemperate"]		= minetest.get_content_id("lib_materials:dirt_with_grass_warm_temperate")
	lib_mg_voronoi.C["c_dirtgrasswarmsemiarid"]			= minetest.get_content_id("lib_materials:dirt_with_grass_warm_semiarid")
	lib_mg_voronoi.C["c_dirtgrasstemperatehumid"]		= minetest.get_content_id("lib_materials:dirt_with_grass_temperate_humid")
	lib_mg_voronoi.C["c_dirtgrasstemperatesemihumid"]		= minetest.get_content_id("lib_materials:dirt_with_grass_temperate_semihumid")
	lib_mg_voronoi.C["c_dirtgrasstemperatetemperate"]		= minetest.get_content_id("lib_materials:dirt_with_grass_temperate_temperate")
	lib_mg_voronoi.C["c_dirtgrasstemperatesemiarid"]		= minetest.get_content_id("lib_materials:dirt_with_grass_temperate_semiarid")
	lib_mg_voronoi.C["c_dirtgrasscoolhumid"]			= minetest.get_content_id("lib_materials:dirt_with_grass_cool_humid")
	lib_mg_voronoi.C["c_dirtgrasscoolsemihumid"]		= minetest.get_content_id("lib_materials:dirt_with_grass_cool_semihumid")
	lib_mg_voronoi.C["c_dirtgrasscooltemperate"]		= minetest.get_content_id("lib_materials:dirt_with_grass_cool_temperate")
	lib_mg_voronoi.C["c_dirtgrasscoolsemiarid"]			= minetest.get_content_id("lib_materials:dirt_with_grass_cool_semiarid")
--]]


--##
--##	NOISES
--##

	lib_mg_voronoi.P = {}
	


--#	Islands Noises
--[[
	lib_mg_voronoi.P["np_terrain"] = {
		offset = lib_mg_voronoi.mg_noise_offset,
		scale = lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale,
		seed = 5934,
		spread = {x = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), y = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), z = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale)},
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		--flags = "defaults"
	}
--]]
--[[
	lib_mg_voronoi.P["np_terrain2"] = {
		flags = "defaults",
		offset = -4,
		scale = 25,
		spread = {x = 600, y = 600, z = 600},
		seed = 5934,
		octaves = 5,
		persist = 0.5,
		lacunarity = 2.19,
	}
--]]
--[[
	lib_mg_voronoi.P["np_cliffs"] = {
		offset = 0,					
		scale = 0.72,
		spread = {x = 180, y = 180, z = 180},
		seed = 78901,
		--octaves = 2,
		octaves = 5,
		--persist = 0.4,
		persist = 0.5,
		lacunarity = 2.19,
	--	flags = "absvalue"
	}
--]]
--#	3D Noises
--	lib_mg_voronoi.P["np_3dterrain"] = {
--		offset = 0,
--		scale = lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale,
--		seed = 5934,
--		spread = {x = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), y = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), z = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale)},
--		octaves = lib_mg_voronoi.mg_noise_octaves,
--		persist = lib_mg_voronoi.mg_noise_persist,
--		lacunarity = 2.19,
--		--flags = "defaults"
--	}
--[[
	lib_mg_voronoi.P["np_3dterrain"] = {
		offset = 0,
		scale = 1,
		--spread = {x = (96 * lib_mg_voronoi.mg_world_scale), y = (48 * lib_mg_voronoi.mg_world_scale), z = (96 * lib_mg_voronoi.mg_world_scale)},
		spread = {x = (384 * lib_mg_voronoi.mg_world_scale), y = (192 * lib_mg_voronoi.mg_world_scale), z = (384 * lib_mg_voronoi.mg_world_scale)},
		seed = 5934,
		octaves = 7,
		persist = 0.4,
		lacunarity = 2.19,
		--flags = ""
	}
	lib_mg_voronoi.P["np_3dterrain_cave"] = {
		offset = 0,
		scale = 1,
		spread = {x = (384 * lib_mg_voronoi.mg_world_scale), y = (192 * lib_mg_voronoi.mg_world_scale), z = (384 * lib_mg_voronoi.mg_world_scale)},
		seed = 5934,
		--seed = 5900033,
		octaves = 4,
		persist = 0.4,
		--lacunarity = 2.19,
		lacunarity = 2.11,
		--flags = ""
	}
--]]
--	lib_mg_voronoi.P["np_3dterrain_cave"] = {
--		offset = 0,
--		scale = 1,
--		spread = {x = (384 * lib_mg_voronoi.mg_world_scale), y = (192 * lib_mg_voronoi.mg_world_scale), z = (384 * lib_mg_voronoi.mg_world_scale)},
--		seed = 5934,
--		--seed = 5900033,
--		octaves = 5,
--		persist = 0.5,
--		--lacunarity = 2.19,
--		lacunarity = 2,
--		--flags = ""
--	}
--[[
--#	Biome Noises
	--lib_mg_voronoi.P["np_heat"] = minetest.get_mapgen_setting_noiseparams("mg_biome_np_heat") or {
	lib_mg_voronoi.P["np_heat"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 50,
		scale = 50,
		spread = {x = (1000 * lib_mg_voronoi.mg_world_scale), y = (1000 * lib_mg_voronoi.mg_world_scale), z = (1000 * lib_mg_voronoi.mg_world_scale)},
		seed = 5349,
		octaves = 3,
		persist = 0.5,
	}
	--lib_mg_voronoi.P["np_heat_blend"] = minetest.get_mapgen_setting_noiseparams("mg_biome_np_heat_blend") or {
	lib_mg_voronoi.P["np_heat_blend"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.5,
		spread = {x = 8, y = 8, z = 8},
		seed = 13,
		octaves = 2,
		persist = 1,
	}
	--lib_mg_voronoi.P["np_humid"] = minetest.get_mapgen_setting_noiseparams("mg_biome_np_humidity") or {
	lib_mg_voronoi.P["np_humid"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 50,
		scale = 50,
		spread = {x = (1000 * lib_mg_voronoi.mg_world_scale), y = (1000 * lib_mg_voronoi.mg_world_scale), z = (1000 * lib_mg_voronoi.mg_world_scale)},
		seed = 842,
		octaves = 3,
		persist = 0.5,
	}
	--lib_mg_voronoi.P["np_humid_blend"] = minetest.get_mapgen_setting_noiseparams("mg_biome_np_humidity_blend") or {
	lib_mg_voronoi.P["np_humid_blend"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.5,
		spread = {x = 8, y = 8, z = 8},
		seed = 90003,
		octaves = 2,
		persist = 1,
	}
--]]

--[[
--#	Wind
	lib_mg_voronoi.P["np_windspeed"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 100,
		spread = {x = (1000 * lib_mg_voronoi.mg_world_scale), y = (1000 * lib_mg_voronoi.mg_world_scale), z = (1000 * lib_mg_voronoi.mg_world_scale)},
		seed = 7854,
		octaves = 1,
		persist = 0.63,
	}
	lib_mg_voronoi.P["np_winddir"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 100,
		spread = {x = (1000 * lib_mg_voronoi.mg_world_scale), y = (1000 * lib_mg_voronoi.mg_world_scale), z = (1000 * lib_mg_voronoi.mg_world_scale)},
		seed = 1234,
		octaves = 1,
		persist = 0.63,
	}
--]]

--[[
--#	v7 Noises

	lib_mg_voronoi.P["mgv7_np_terrain_alt"] = {
		--offset = (lib_mg_voronoi.mg_noise_spread * 0.1) * 0.5,
		--offset = ((lib_mg_voronoi.mg_noise_spread * 0.1) * 1.5) * lib_mg_voronoi.mg_world_scale,
		--offset = (lib_mg_voronoi.mg_noise_spread * 0.1) * lib_mg_voronoi.mg_world_scale,
		offset = lib_mg_voronoi.mg_noise_offset,
		scale = lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale,
		--scale = 50,
		seed = 5934,
		spread = {x = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), y = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), z = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale)},
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		--flags = "defaults"
	}
	lib_mg_voronoi.P["mgv7_np_terrain_base"] = {
		--offset = (lib_mg_voronoi.mg_noise_spread * 0.1) * 0.5,
		--offset = ((lib_mg_voronoi.mg_noise_spread * 0.1) * 1.5) * lib_mg_voronoi.mg_world_scale,
		--offset = (lib_mg_voronoi.mg_noise_spread * 0.1) * lib_mg_voronoi.mg_world_scale,
		offset = lib_mg_voronoi.mg_noise_offset,
		--scale = (lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale) * 2.8,
		scale = (lib_mg_voronoi.mg_noise_scale * lib_mg_voronoi.mg_world_scale) * 2.8,
		seed = 82341,
		spread = {x = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), y = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale), z = (lib_mg_voronoi.mg_noise_spread * lib_mg_voronoi.mg_world_scale)},
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		flags = "defaults"
	}
	lib_mg_voronoi.P["mgv7_np_height_select"] = {
		flags = "defaults",
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		offset = lib_mg_voronoi.mg_noise_offset,
		scale = 1,
		spread = {x = (1000 * lib_mg_voronoi.mg_world_scale), y = (1000 * lib_mg_voronoi.mg_world_scale), z = (1000 * lib_mg_voronoi.mg_world_scale)},
		seed = 4213,
		octaves = lib_mg_voronoi.mg_noise_octaves,
		persist = lib_mg_voronoi.mg_noise_persist,
	}
	lib_mg_voronoi.P["mgv7_np_terrain_persist"] = {
		flags = "defaults",
		lacunarity = lib_mg_voronoi.mg_noise_lacunarity,
		offset = 0.6,
		scale = 0.1,
		spread = {x = (2000 * lib_mg_voronoi.mg_world_scale), y = (2000 * lib_mg_voronoi.mg_world_scale), z = (2000 * lib_mg_voronoi.mg_world_scale)},
		seed = 539,
		octaves = 3,
		persist = 0.6,
	}
--]]
--[[
	lib_mg_voronoi.P["mgv7_np_terrain_alt"] = {
		flags = "eased",
		lacunarity = 2.0,
		offset = -4,
		scale = 25,
		spread = {x = 600, y = 600, z = 600},
		seed = 5934,
		octaves = 5,
		persist = 0.6,
	}
	lib_mg_voronoi.P["mgv7_np_terrain_base"] = {
		flags = "eased",
		lacunarity = 2.0,
		offset = -4,
		scale = 70,
		spread = {x = 600, y = 600, z = 600},
		seed = 82341,
		octaves = 5,
		persist = 0.6,
	}

	lib_mg_voronoi.P["mgv7_np_height_select"] = {
		flags = "eased",
		lacunarity = 2.0,
		offset = -8,
		scale = 16,
		spread = {x = 500, y = 500, z = 500},
		seed = 4213,
		octaves = 6,
		persist = 0.7,
	}
	lib_mg_voronoi.P["mgv7_np_terrain_persist"] = {
		flags = "eased",
		lacunarity = 2.0,
		offset = 0.6,
		scale = 0.1,
		spread = {x = 2000, y = 2000, z = 2000},
		seed = 539,
		octaves = 3,
		persist = 0.6,
	}
--]]

--[[
--#	v6 Noises
	lib_mg_voronoi.P["mgv6_np_terrain_base"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = -4,
		scale = 20,
		spread = {x = 250, y = 250, z = 250},
		seed = 82341,
		octaves = 5,
		persist = 0.6,
	}
	lib_mg_voronoi.P["mgv6_np_terrain_higher"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 20,
		scale = 16,
		spread = {x = 500, y = 500, z = 500},
		seed = 85039,
		octaves = 5,
		persist = 0.6,
	}
	lib_mg_voronoi.P["mgv6_np_steepness"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0.85,
		scale = 0.5,
		spread = {x = 125, y = 125, z = 125},
		seed = -932,
		octaves = 5,
		persist = 0.7,
	}
	lib_mg_voronoi.P["mgv6_np_height_select"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1,
		spread = {x = 250, y = 250, z = 250},
		seed = 4213,
		octaves = 5,
		persist = 0.69,
	}

--#	Valleys Noises
	lib_mg_voronoi.P["mgvalleys_np_rivers"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.2,
		spread = {x = 256, y = 256, z = 256},
		seed = 1605,
		octaves = 3,
		persist = 0.5,
	}
	lib_mg_voronoi.P["mgvalleys_np_terrain_height"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0.5,
		scale = 0.5,
		spread = {x = 128, y = 128, z = 128},
		seed = 746,
		octaves = 1,
		persist = 1,
	}
	lib_mg_voronoi.P["mgvalleys_np_valley_depth"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1,
		spread = {x = 256, y = 256, z = 256},
		seed = -6050,
		octaves = 5,
		persist = 0.6,
	}
	lib_mg_voronoi.P["mgvalleys_np_valley_profile"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = -10,
		scale = 50,
		spread = {x = 1024, y = 1024, z = 1024},
		seed = 5202,
		octaves = 6,
		persist = 0.4,
	}
	lib_mg_voronoi.P["mgvalleys_np_inter_valley_fill"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 5,
		scale = 4,
		spread = {x = 512, y = 512, z = 512},
		seed = -1914,
		octaves = 1,
		persist = 1,
	}
	lib_mg_voronoi.P["mgvalleys_np_inter_valley_slope"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1,
		spread = {x = 256, y = 512, z = 256},
		seed = 1993,
		octaves = 6,
		persist = 0.8,
	}
--]]






--[[valleys DEFAULTS
	lib_mg_voronoi.P["mgvalleys_np_rivers"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.2,
		spread = {x = 256, y = 256, z = 256},
		seed = 1605,
		octaves = 3,
		persistence = 0.5,
	}
	lib_mg_voronoi.P["mgvalleys_np_terrain_height"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0.5,
		scale = 0.5,
		spread = {x = 128, y = 128, z = 128},
		seed = 746,
		octaves = 1,
		persistence = 1,
	}
	lib_mg_voronoi.P["mgvalleys_np_valley_depth"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1,
		spread = {x = 256, y = 256, z = 256},
		seed = -6050,
		octaves = 5,
		persistence = 0.6,
	}
	lib_mg_voronoi.P["mgvalleys_np_valley_profile"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = -10,
		scale = 50,
		spread = {x = 1024, y = 1024, z = 1024},
		seed = 5202,
		octaves = 6,
		persistence = 0.4,
	}
	lib_mg_voronoi.P["mgvalleys_np_inter_valley_fill"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 5,
		scale = 4,
		spread = {x = 512, y = 512, z = 512},
		seed = -1914,
		octaves = 1,
		persistence = 1,
	}
	lib_mg_voronoi.P["mgvalleys_np_inter_valley_slope"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1,
		spread = {x = 256, y = 512, z = 256},
		seed = 1993,
		octaves = 6,
		persistence = 0.8,
	}
--]]


--[[v6 DEFAULTS
	lib_mg_voronoi.P["mgv6_np_terrain_base"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = -4,
		scale = 20,
		spread = {x = 250, y = 250, z = 250},
		seed = 82341,
		octaves = 5,
		persistence = 0.6,
	}
	lib_mg_voronoi.P["mgv6_np_terrain_higher"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 20,
		scale = 16,
		spread = {x = 500, y = 500, z = 500},
		seed = 85039,
		octaves = 5,
		persistence = 0.6,
	}
	lib_mg_voronoi.P["mgv6_np_steepness"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0.85,
		scale = 0.5,
		spread = {x = 125, y = 125, z = 125},
		seed = -932,
		octaves = 5,
		persistence = 0.7,
	}
	lib_mg_voronoi.P["mgv6_np_height_select"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1,
		spread = {x = 250, y = 250, z = 250},
		seed = 4213,
		octaves = 5,
		persistence = 0.69,
	}
--]]


--[[v7 DEFAULTS
	lib_mg_voronoi.P["mgv7_np_terrain_alt"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 4,
		scale = 25,
		spread = {x = 600, y = 600, z = 600},
		seed = 5934,
		octaves = 5,
		persistence = 0.6,
	}
	lib_mg_voronoi.P["mgv7_np_terrain_base"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 4,
		scale = 70,
		spread = {x = 600, y = 600, z = 600},
		seed = 82341,
		octaves = 5,
		persistence = 0.6,
	}
	lib_mg_voronoi.P["mgv7_np_height_select"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = -8,
		scale = 16,
		spread = {x = 500, y = 500, z = 500},
		seed = 4213,
		octaves = 6,
		persistence = 0.7,
	}
	lib_mg_voronoi.P["mgv7_np_terrain_persist"] = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0.6,
		scale = 0.1,
		spread = {x = 2000, y = 2000, z = 2000},
		seed = 539,
		octaves = 3,
		persistence = 0.6,
	}
--]]








