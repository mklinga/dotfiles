-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

--awful.util.spawn_with_shell("xcompmgr -cF &")

-- {{{ Variable definitions
beautiful.init("/home/laite/.config/awesome/themes/laite2/theme.lua")
modkey = "Mod4"

terminal = "x-terminal-emulator"
terminal_tabbed = "urxvt -pe tabbedex"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
gtkeditor = "gvim"
filemanager = "ranger"
filemanager_cmd = terminal .. " -e " .. filemanager
guifilemanager = "thunar"
webbrowser = "chromium-browser"
xrandr = "sh /home/laite/bin/xr.sh"


layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.spiral,
    awful.layout.suit.max
}
-- }}}


-- {{{ Tags
tags = {}
local association_table = {}
local follow_associations = true;
local ass_current = nil

tags[1] = awful.tag({ "main", "www", "mail", "irc", "edit", "code", "m7", "m8", "feed"}, 1,
{ 
	layouts[2], layouts[2], layouts[7],          -- Tags: 1, 2, 3
	layouts[5], layouts[4], layouts[5],          --       4, 5 ,6
	layouts[2], layouts[7], layouts[2]           --       7, 8, 9
})

-- if we have dualscreen we 'associate' some tags to it
if screen.count() == 2 then

	-- we can create some hardcoded associations, but it's propably not a very good idea
	-- much better way is to let the user associate tags "on the fly"
	--
	-- association_table = { main=1, www=2, mail=3, irc=4, edit=5, code=6, m7=5, m8=5, feed=7 }

	tags[2] = awful.tag({ 1, 2, 3, 4, 5, 6, 7 }, 2, 
	{
		layouts[2], layouts[2], layouts[2], 			-- 1, 2, 3
		layouts[2], layouts[2], layouts[2], layouts[2]  -- 4, 5, 6, 7
	})

	for i=1,# tags[1] do
		-- this is the main function for assosiated screens
		tags[1][i]:add_signal("property::selected", function ()
			if follow_associations then 
				if association_table[tags[1][i].name] then
					if tags[1][i].name ~= ass_current then
						awful.tag.viewonly(tags[2][association_table[tags[1][i].name]])
					end
				end
			end
			ass_current = tags[1][i].name
		end)
	end
end
-- }}}
--

-- {{{ Wibox
mytextclock = awful.widget.textclock({ align = "right" }, "<span color=\"#808076\">%a %d.%m.%Y,</span><span color=\"#dcdccc\"> %H:%M </span>")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewprev),
                    awful.button({ }, 5, awful.tag.viewnext)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

    -- Create a promptbox for each screen
    mypromptbox = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox = awful.widget.layoutbox(1)
    mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	local labelf = function(t, args) 
		local text, bg_color, bg_image, icon = awful.widget.taglist.label.all(t, args)
		if awful.util.table.hasitem(t:clients(), client.focus) then
			text = string.gsub(text, "<span font_desc='(.+)'> ([^<]+) </span>", "<span font_desc='%1'><span color='" .. theme.fg_additi .. "'> %2 </span></span>")
		end
		return text, bg_color, bg_image, icon
	end

    mytaglist = awful.widget.taglist(1, labelf, mytaglist.buttons)
    mytasklist = awful.widget.tasklist(function(c)
						   local text, bg, status_image, icon = awful.widget.tasklist.label.currenttags(c, 1)
						   if text then text = "  " .. text end
						   return text, bg, status_image, nil
				  end, mytasklist.buttons)

    -- Create the wibox
    mywibox = awful.wibox({ ontop = false, position = "top", border_width = 0, screen = 1 })
    mywibox.widgets = {
        {
            mytaglist,
            mypromptbox,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox,
        mytextclock,
        mysystray or nil,
        --mytasklist,
        layout = awful.widget.layout.horizontal.rightleft
    }
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    --awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

	-- Follow associations on secondary screen
    awful.key({ modkey,           }, "a", function () follow_associations = not follow_associations end),
	-- mod4+shift+a creates an association
    awful.key({ modkey, "Shift"   }, "a", function () 
		local sel = awful.tag.selected(1)
		local sel2 = awful.tag.selected(2)
		association_table[sel.name] = awful.tag.getidx(sel2)
	end),
	-- mod4+control+a clears association for selected tag
    awful.key({ modkey, "Control"   }, "a", function () 
		local sel = awful.tag.selected(1)
		association_table[sel.name] = nil
	end),

    -- Standard programs
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "d", function () awful.util.spawn("dmenu_run -i -fn '-*-fixed-medium-r-*-*-*-100-100-100-c-*-iso10646-*' -m 0 -nb \"#3f3f3f\" -nf \"#dcdccc\" -sb \"#1e2320\" -sf \"#ececac\" ") end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("xfce4-appfinder") end),
    awful.key({ modkey,           }, "t", function () awful.util.spawn(guifilemanager) end),
    awful.key({ modkey,           }, "v", function () awful.util.spawn(gtkeditor) end),
    awful.key({ modkey,           }, "u", function () awful.util.spawn(terminal_tabbed) end),
    awful.key({ modkey,           }, "p", function () awful.util.spawn(filemanager_cmd) end),
    awful.key({ modkey,           }, "i", function () awful.util.spawn(webbrowser) end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn(xrandr) end),

	-- Helpers
    awful.key({ modkey, "Shift"   }, "d", function () awful.util.spawn("sh /home/laite/bin/dictnotify.sh") end),
	awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("sh /home/laite/bin/vol.sh +2") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("sh /home/laite/bin/vol.sh -2") end),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("sh /home/laite/bin/vol.sh 0") end),

	-- layout
    awful.key({ modkey,           }, "h",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "l",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "m", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift"   }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

	-- System
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey },            "r",     function () mypromptbox:run() end),

    awful.key({ modkey,           }, "Right",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Left",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "w", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
					 size_hints_honor = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Xfce4-appfinder" },
      properties = { floating = true } },
--    { rule = { name = "Confirm ModeSwitch"},
--      properties = { floating = true, tag = tags[1][1] } },
    { rule = { class = "Firefox" },
      properties = { floating = false } },
    { rule = { class = "File-roller" },
      properties = { floating = true } },
    { rule = { class = "Xarchiver" },
      properties = { floating = true } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { name = "Searching for a picture of"},
      properties = { floating = true } },
    { rule = { name = "Progress"},
      properties = { floating = true } },
    { rule = { name = "Edit Multiple Songs Properties"},
      properties = { floating = true } },
    { rule = { role = "D_laite_timebard"},
      properties = { focus = false } },
    { rule = { class = "Thunderbird" },
      properties = { border_width = "0", tag = tags[1][3] } },
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to awful.util.spawn(ute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Startup commands 
awful.util.spawn("sh /home/laite/bin/xmodmaps.sh")
awful.util.spawn("numlockx on")
awful.util.spawn("xset s off -dpms")
--awful.util.spawn("xrandr --output HDMI-0 --mode 1920x1080")

-- mpd scrobbler
-- awful.util.spawn("scrobby")
