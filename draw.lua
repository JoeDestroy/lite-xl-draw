-- mod-version:2 lite-xl 2.0
local core = require "core"
local common = require "core.common"
local style = require "core.style"
local command = require "core.command"
local config = require "core.config"
local View = require "core.view"
local keymap = require "core.keymap"

-- Color you will draw with
style.draw_color = {common.color "#00ff00"}

-- Grid lines color
style.rect_color = {common.color "#aaaaaa"}

-- Background color
style.back_color = {common.color "#ffffff"}

config.pixel_size = 20

local pixel_positions = {}

local draw_state = false

local DrawView = View:extend()

function DrawView:new()
	DrawView.super.new(self)
end

function DrawView:draw()	
	self:draw_background(style.back_color)
	
	local x_off, y_off = self:get_content_offset()
	local x, y, w, h = self:get_content_bounds()
	
	local hor_line_count = common.round(w / config.pixel_size)
	local ver_line_count = common.round(w / config.pixel_size)
	
	for i = 1, hor_line_count do
		renderer.draw_rect(x_off, (i * config.pixel_size) + y_off, w, 1, style.rect_color)
	end
	
	for e = 1, ver_line_count do
		renderer.draw_rect((e * config.pixel_size) + x_off, y_off, 1, h, style.rect_color)
	end
	
	for _, pos in ipairs(pixel_positions) do
		renderer.draw_rect(pos[1] + x_off + (x_off % config.pixel_size), pos[2] + y_off + (y_off % config.pixel_size), config.pixel_size, config.pixel_size, style.draw_color)
	end
end

function DrawView:on_mouse_pressed(button, mouse_x, mouse_y, clicks)
	draw_state = true
end

function DrawView:on_mouse_released(button, x, y)
	draw_state = false
end

function DrawView:on_mouse_moved(x, y, dx, dy)
	if draw_state then
		local x_off, y_off = self:get_content_offset()
		pixel_positions[#pixel_positions+1] = {x - x_off - (x % config.pixel_size), y - y_off - (y % config.pixel_size)}
	end
end

function DrawView:get_name()
	return "Draw"
end

local function open_draw_view()
	local node = core.root_view:get_active_node()
	node:add_view(DrawView())
end


command.add(nil, {
	["draw:open"] = open_draw_view
})

return DrawView
