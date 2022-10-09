--Minetest
--Copyright (C) 2013 sapier
--Copyright (C) 2022 Migdyn
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

-- https://github.com/orgs/minetest/teams/engine/members


return {
	name = "beta",
	caption = fgettext("Beta Menu"),
	cbf_formspec = function(tabview, name, tabdata)
		
		local version = core.get_version()


		local fs = "image[1.5,0.6;7.5,2.5;" .. core.formspec_escape(defaulttexturedir .. "menu_header.png") .. "]" ..
			"style[label_button;border=false]" ..
			"button[0.1,4;8.3,1.5;online_play;Play on-line (real people, not bots)]" ..
			"button[0.1,6;8.3,1.5;local_play;Play locally]" ..
			"button[0.1,8;8.3,1.5;xtreemcoins;Get XtreemCoins]"
			
		
		return fs, "size[15.5,10.1,false]real_coordinates[true]"
	end,
	cbf_button_handler = function(this, fields, name, tabdata)
		if fields.online_play then
			
		end

		if fields.local_play then
			
		end

		if fields.xtreemcoins then
			
		end
	end,
}
