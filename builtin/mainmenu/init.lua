--Minetest
--Copyright (C) 2014 sapier
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

mt_color_grey  = "#AAAAAA"
mt_color_blue  = "#6389FF"
mt_color_green = "#72FF63"
mt_color_dark_green = "#25C191"

--for all other colors ask sfan5 to complete his work!

local menupath = core.get_mainmenu_path()
local basepath = core.get_builtin_path()
local menustyle = core.settings:get("main_menu_style")
defaulttexturedir = core.get_texturepath_share() .. DIR_DELIM .. "base" ..
					DIR_DELIM .. "pack" .. DIR_DELIM

dofile(basepath .. "common" .. DIR_DELIM .. "async_event.lua")
dofile(basepath .. "common" .. DIR_DELIM .. "filterlist.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "dialog.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "tabview.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "tabview_layouts.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "ui.lua")
dofile(menupath .. DIR_DELIM .. "common.lua")
dofile(menupath .. DIR_DELIM .. "pkgmgr.lua")
dofile(menupath .. DIR_DELIM .. "textures.lua")

dofile(menupath .. DIR_DELIM .. "dlg_config_world.lua")
dofile(menupath .. DIR_DELIM .. "dlg_settings_advanced.lua")
dofile(menupath .. DIR_DELIM .. "dlg_contentstore.lua")
if menustyle ~= "simple" then
	dofile(menupath .. DIR_DELIM .. "dlg_create_world.lua")
	dofile(menupath .. DIR_DELIM .. "dlg_delete_content.lua")
	dofile(menupath .. DIR_DELIM .. "dlg_delete_world.lua")
	dofile(menupath .. DIR_DELIM .. "dlg_rename_modpack.lua")
end

local tabs = {}

tabs.settings = dofile(menupath .. DIR_DELIM .. "tab_settings.lua")
tabs.content  = dofile(menupath .. DIR_DELIM .. "tab_content.lua")
tabs.about  = dofile(menupath .. DIR_DELIM .. "tab_about.lua")
if menustyle == "simple" then
	tabs.simple_main = dofile(menupath .. DIR_DELIM .. "tab_simple_main.lua")
else
	tabs.world = dofile(menupath .. DIR_DELIM .. "tab_local.lua")
	tabs.online = dofile(menupath .. DIR_DELIM .. "tab_online.lua")

	tabs.new_game = {
		name = "new",
		caption = fgettext("New Game"),
		show = function(_, _, this)
			local create_world_dlg = create_create_world_dlg(true)
			create_world_dlg:set_parent(this)
			this:hide()
			create_world_dlg:show()
			return true
		end
	}
end

--------------------------------------------------------------------------------
local function main_event_handler(tabview, event)
	if event == "MenuQuit" then
		core.close()
	end
	return true
end

--------------------------------------------------------------------------------
local function init_globals()
	-- Init gamedata
	gamedata.worldindex = 0

	if menustyle == "simple" then
		local world_list = core.get_worlds()
		local world_index

		local found_singleplayerworld = false
		for i, world in ipairs(world_list) do
			if world.name == "singleplayerworld" then
				found_singleplayerworld = true
				world_index = i
				break
			end
		end

		if not found_singleplayerworld then
			core.create_world("singleplayerworld", 1)

			world_list = core.get_worlds()

			for i, world in ipairs(world_list) do
				if world.name == "singleplayerworld" then
					world_index = i
					break
				end
			end
		end

		gamedata.worldindex = world_index
	else
		menudata.worldlist = filterlist.create(
			core.get_worlds,
			compare_worlds,
			-- Unique id comparison function
			function(element, uid)
				return element.name == uid
			end,
			-- Filter function
			function(element, gameid)
				return element.gameid == gameid
			end
		)

		menudata.worldlist:add_sort_mechanism("alphabetic", sort_worlds_alphabetic)
		menudata.worldlist:set_sortmode("alphabetic")

		if not core.settings:get("menu_last_game") then
			local default_game = core.settings:get("default_game") or "minetest"
			core.settings:set("menu_last_game", default_game)
		end

		mm_texture.init()
	end

	-- Create main tabview
	local tv_main = tabview_create("maintab", {x = 15.5, y = 9}, {x = 0, y = 0}, tabview_layouts.mainmenu)
	tv_main.icon = "/home/ruben/dev/minetest/games/minetest_game/menu/icon.png"

	if menustyle == "simple" then
		tv_main:add(tabs.simple_main)
	else
		tv_main:set_autosave_tab(true)
		tv_main:add(tabs.online)
		tv_main:add(tabs.world)
	end
	tv_main:add(tabs.content)
	tv_main:add(tabs.settings)
	tv_main:add(tabs.about)

	tv_main:set_global_event_handler(main_event_handler)
	tv_main:set_fixed_size(false)

	local last_tab = core.settings:get("maintab_LAST")
	if menustyle ~= "simple" and last_tab and tv_main.current_tab ~= last_tab then
		tv_main:set_tab(last_tab)
	else
		tv_main:set_tab("local")
	end

	ui.set_default("maintab")
	tv_main:show()

	ui.update()

	core.sound_play("main_menu", true)
end

init_globals()