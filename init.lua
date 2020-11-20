
-------------------------------------------------------------
-- lib_mg_voronoi  ©2020 Shad MOrdre (shadmordre@minetest.net)--
-------------------------------------------------------------

lib_mg_voronoi = {}
lib_mg_voronoi.name = "lib_mg_voronoi"
lib_mg_voronoi.ver_max = 0
lib_mg_voronoi.ver_min = 1
lib_mg_voronoi.ver_rev = 0
lib_mg_voronoi.ver_str = lib_mg_voronoi.ver_max .. "." .. lib_mg_voronoi.ver_min .. "." .. lib_mg_voronoi.ver_rev
lib_mg_voronoi.authorship = "ShadMOrdre.  Additional credits to Termos' Islands mod; Gael-de-Sailleys' Valleys; duane-r Valleys_c, burli mapgen, and paramats' mapgens"
lib_mg_voronoi.license = "LGLv2.1"
lib_mg_voronoi.copyright = "2019"
lib_mg_voronoi.path_mod = minetest.get_modpath(minetest.get_current_modname())
lib_mg_voronoi.path_world = minetest.get_worldpath()

local S
local NS
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	-- S = function(s) return s end
	-- internationalization boilerplate
	S, NS = dofile(lib_mg_voronoi.path_mod.."/intllib.lua")
end
lib_mg_voronoi.intllib = S

minetest.log(S("[MOD] lib_mg_voronoi:  Loading..."))
minetest.log(S("[MOD] lib_mg_voronoi:  Version:") .. S(lib_mg_voronoi.ver_str))
minetest.log(S("[MOD] lib_mg_voronoi:  Legal Info: Copyright ") .. S(lib_mg_voronoi.copyright) .. " " .. S(lib_mg_voronoi.authorship) .. "")
minetest.log(S("[MOD] lib_mg_voronoi:  License: ") .. S(lib_mg_voronoi.license) .. "")


	lib_mg_voronoi.voxel_mg_voronoi = minetest.setting_get("lib_mg_voronoi_enable") or true				--true

-- switch for debugging
	lib_mg_voronoi.debug = false

	if lib_mg_voronoi.voxel_mg_voronoi == true then

		lib_mg_voronoi.nodes = "lib_materials"		--"default"
	
		lib_mg_voronoi.max_height_difference = 4
		lib_mg_voronoi.half_map_chunk_size = 40
		lib_mg_voronoi.quarter_map_chunk_size = 20
	
		dofile(lib_mg_voronoi.path_mod.."/lib_mg_voronoi_config.lua")
		dofile(lib_mg_voronoi.path_mod.."/src/lib_mg_voronoi_functions_io.lua")
		dofile(lib_mg_voronoi.path_mod.."/src/lib_mg_voronoi_functions.lua")
		--dofile(lib_mg_voronoi.path_mod.."/src/lib_mg_voronoi_biomes.lua")
	
		lib_mg_voronoi.set_dist_func(lib_mg_voronoi.mg_distance_metric)

		--if lib_mg_voronoi.mg_add_voronoi == true or lib_mg_voronoi.mg_add_voronoi == true then
			dofile(lib_mg_voronoi.path_mod.."/src/lib_mg_voronoi_functions_voronoi.lua")
		--end
	
		--dofile(lib_mg_voronoi.path_mod.."/lib_mg_voronoi_schems.lua")

		dofile(lib_mg_voronoi.path_mod.."/lib_mg_voronoi_mapgen.lua")					--WORKING MAPGEN with and without biomes
	end


minetest.log(S("[MOD] lib_mg_voronoi:  Successfully loaded."))








