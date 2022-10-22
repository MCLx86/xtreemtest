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


local function beta_menu_formspec()
	return "size[8,2.5,true]" ..
	"style[label_button;border=false]" ..
	"button[0.5,0.5;7,0.5;label_button;" ..
	fgettext("You have no games installed.") .. "]" ..
	"button[0.5,1.5;2.5,0.5;world_create_open_cdb;" .. fgettext("Install a game") .. "]" ..
	"button[5.0,1.5;2.5,0.5;world_create_cancel;" .. fgettext("Cancel") .. "]"
end