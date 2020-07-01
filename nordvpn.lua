local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local naughty = require("naughty")

local GET_NORDVPN_STATUS_CMD = "nordvpn status"
local NORDVPN_CONNECT_CMD = "nordvpn c"
local NORDVPN_DISCONNECT_CMD = "nordvpn d"

local nordvpn_widget = wibox.widget {
	{
		id = "status",
		widget = wibox.widget.textbox,
		font = 'Roboto Mono 9'
	},
	layout = wibox.layout.align.horizontal,
	set_text = function(self, path)
		self.status.markup = path
	end,
}

local sanitize_text = function(stdout)
	if string.find(stdout, "Connected") ~= nil then return "VPN"
	elseif string.find(stdout, "Connecting") ~= nil then return "Connecting"
	elseif string.find(stdout, "Disconnecting") ~= nil then return "Disconnecting"
	elseif string.find(stdout, "Restarting") ~= nil then return "Restarting"
	end 
	return "No VPN"
end


local update_widget_text = function(widget, stdout, _, _, _)
	local status_oneline = sanitize_text(stdout) -- " |" .. sanitize_text(stdout) .. "| "
	widget:set_text(status_oneline)
end

watch(GET_NORDVPN_STATUS_CMD, 1, update_widget_text, nordvpn_widget)

--Add mouse controls


nordvpn_widget:connect_signal("button::press", function(_, _, _, button)
	if (button == 1) then
		awful.spawn.easy_async(GET_NORDVPN_STATUS_CMD, function(stdout, stderr, exitreason, exitcode)
			if string.find(stdout, "Connected") ~= nil then awful.spawn.with_shell(NORDVPN_DISCONNECT_CMD)
			else awful.spawn.with_shell(NORDVPN_CONNECT_CMD)
			end
		end)
	end
end)
	


--Add hover info

local notification
function show_vpn_status()
    awful.spawn.easy_async([[bash -c 'nordvpn status']],
        function(stdout, _, _, _)
            notification = naughty.notify {
                text = stdout,
                title = "VPN Status",
                timeout = 5,
                hover_timeout = 0.5,
                width = 200,
            }
        end)
end

nordvpn_widget:connect_signal("mouse::enter", function() show_vpn_status() end)
nordvpn_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

return nordvpn_widget
