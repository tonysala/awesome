-- Custom AWESOMEWM theme

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local os    = os
local table = gears.table

local theme              = {}

theme.dir                = os.getenv("HOME") .. "/.config/awesome/themes/arch"
theme.wallpaper          = theme.dir .. "/wall.png"
theme.font               = "JetBrains Mono Light 10"

-- Colors
local COLOR_NAVY         = "#2E3441"
local COLOR_NAVY_LIGHTER = "#3B4253"
local COLOR_RED          = "#C16069"
local COLOR_GREEN        = "#A2BF8A"
local COLOR_YELLOW       = "#EDCC87"
local COLOR_BLUE         = "#80A0C2"
local COLOR_PURPLE       = "#B58DAE"
local COLOR_WHITE        = "#E5E9F0"

-- Colors
theme.fg_normal = COLOR_WHITE
theme.fg_focus  = COLOR_RED
theme.fg_urgent = COLOR_RED
theme.bg_normal = COLOR_NAVY
theme.bg_focus  = COLOR_NAVY_LIGHTER
theme.bg_urgent = COLOR_NAVY

-- Borders
theme.border_width  = 0
theme.border_normal = COLOR_NAVY
theme.border_focus  = COLOR_NAVY
theme.border_marked = COLOR_NAVY

-- Titlebars
theme.titlebar_bg_focus  = COLOR_NAVY_LIGHTER
theme.titlebar_bg_normal = COLOR_NAVY

-- Dimensions
theme.border_width             = 0
theme.menu_height              = 16
theme.menu_width               = 140

-- Theme icons
theme.menu_submenu_icon        = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel      = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel    = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile              = theme.dir .. "/icons/tile.png"
theme.layout_tileleft          = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom        = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop           = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv             = theme.dir .. "/icons/fairv.png"
theme.layout_fairh             = theme.dir .. "/icons/fairh.png"
theme.layout_spiral            = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle           = theme.dir .. "/icons/dwindle.png"
theme.layout_max               = theme.dir .. "/icons/max.png"
theme.layout_fullscreen        = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier         = theme.dir .. "/icons/magnifier.png"
theme.layout_floating          = theme.dir .. "/icons/floating.png"
theme.widget_ac                = theme.dir .. "/icons/ac.png"
theme.widget_battery           = theme.dir .. "/icons/battery.png"
theme.widget_battery_low       = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty     = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem               = theme.dir .. "/icons/mem.png"
theme.widget_cpu               = theme.dir .. "/icons/cpu.png"
theme.widget_temp              = theme.dir .. "/icons/temp.png"
theme.widget_net               = theme.dir .. "/icons/net.png"
theme.widget_hdd               = theme.dir .. "/icons/hdd.png"
theme.widget_music             = theme.dir .. "/icons/note.png"
theme.widget_music_on          = theme.dir .. "/icons/note_on.png"
theme.widget_vol               = theme.dir .. "/icons/vol.png"
theme.widget_vol_low           = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no            = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute          = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail              = theme.dir .. "/icons/mail.png"
theme.widget_mail_on           = theme.dir .. "/icons/mail_on.png"

-- Tasklist settings
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon    = true
theme.useless_gap              = 4

local markup = lain.util.markup

-- Clock widget
theme.clock_icon = wibox.widget.imagebox(theme.widget_clock, true)
theme.clock = awful.widget.watch("date +'%a %d %b %R'", 60, function(widget, stdout)
    widget:set_markup(markup.font(theme.font, stdout))
end)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { theme.clock },
    notification_preset = {
        font = "JetBrains Mono Light 9",
        fg = theme.fg_normal,
        bg = theme.bg_normal
    }
})

-- Mail IMAP check
theme.mail_icon = wibox.widget.imagebox(theme.widget_mail, true)
-- commented because it needs to be set before use
theme.mail_icon:buttons(table.join(awful.button({ }, 1, function () awful.spawn(mail) end)))
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "imap.gmail.com",
    mail     = "tonysala32@gmail.com",
    password = "spainladderbusinessyear",
    settings = function()
--        if mailcount > 0 then
--            widget:set_text(" " .. mailcount .. " ")
--            theme.mail_icon:set_image(theme.widget_mail_on)
--        else
--            widget:set_text("")
--            mailicon:set_image(theme.widget_mail)
--        end
    end
})

-- MPD
local music_player = awful.util.terminal .. " -title Music -g 130x34-320+16 -e ncmpcpp"
theme.mpd_icon = wibox.widget.imagebox(theme.widget_music, true)
theme.mpd_icon:buttons(
    table.join(
        awful.button({ modkey }, 1, function() awful.spawn.with_shell(music_player) end),
        awful.button({}, 1, function()
            os.execute("mpc prev")
            theme.mpd.update()
        end),
        awful.button({}, 2, function()
            os.execute("mpc toggle")
            theme.mpd.update()
        end),
        awful.button({}, 3, function()
            os.execute("mpc next")
            theme.mpd.update()
        end)
    )
)
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title = mpd_now.title .. " "
            theme.mpd_icon:set_image(theme.widget_music_on)
        elseif mpd_now.state == "pause" then
            artist = " mpd "
            title = "paused "
        else
            artist = ""
            title = ""
            theme.mpd_icon:set_image(theme.widget_music)
        end

        widget:set_markup(markup.font(theme.font, markup("#EA6F81", artist) .. title))
    end
})

-- MEM
theme.mem_icon = wibox.widget.imagebox(theme.widget_mem, true)
theme.mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
theme.cpu_icon = wibox.widget.imagebox(theme.widget_cpu, true)
theme.cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp
theme.temp_icon = wibox.widget.imagebox(theme.widget_temp, true)
theme.temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. math.floor(coretemp_now) .. "°C "))
    end
})

-- Coinbase
theme.coinbase = lain.widget.coinbase({
    symbol = "algo",
    initial_markup = markup.font(theme.font, " ... "),
    timeout = 10,
    settings = function(symbol, price)
        widget:set_markup(markup.font(theme.font, "ALG: " .. string.format("£%.4f ", price)))
    end
})

-- Battery
theme.bat_icon = wibox.widget.imagebox(theme.widget_battery, true)
theme.bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                theme.bat_icon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                theme.bat_icon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                theme.bat_icon:set_image(theme.widget_battery_low)
            else
                theme.bat_icon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            theme.bat_icon:set_image(theme.widget_ac)
        end
    end
})

-- ALSA volume
theme.vol_icon = wibox.widget.imagebox(theme.widget_vol, true)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            theme.vol_icon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            theme.vol_icon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            theme.vol_icon:set_image(theme.widget_vol_low)
        else
            theme.vol_icon:set_image(theme.widget_vol)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
    end
})

-- Net
theme.net_icon = wibox.widget.imagebox(theme.widget_net, true)
theme.net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(theme.font,
            markup("#7AC82E", " " .. net_now.received .. "KB/s  ↓") .. markup("#46A8C3", "↑ " .. net_now.sent .. "KB/s ")))
    end
})

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.topwibox = awful.wibar({
        position = "top",
        screen = s,
        height = 18,
        border_width = 1,
        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the wibox
    s.topwibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal, -- Left widgets
            s.mytaglist,
            s.mypromptbox,
        },
        nil, -- Middle widget
        {
            layout = wibox.layout.fixed.horizontal, -- Right widgets
            wibox.widget.systray(),
            wibox.container.background(
                wibox.container.margin(theme.mpd_icon, 6, 0),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.mpd.widget, 0, 6),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.vol_icon, 6, 0),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.volume.widget, 0, 6),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.mail_icon, 3, 0),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.mail.widget, 0, 3),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.mem_icon, 6, 0),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.mem.widget, 0, 6),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.cpu_icon, 6, 0),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.cpu.widget, 0, 6),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.temp_icon, 6, 0),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.temp.widget, 0, 6),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.coinbase.widget, 6, 3),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.bat_icon, 6, 0),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.bat.widget, 0, 6),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(theme.net_icon, 6, 0),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.net.widget, 0, 0),
                COLOR_NAVY
            ),
            wibox.container.background(
                wibox.container.margin(theme.clock, 6, 6),
                COLOR_NAVY_LIGHTER
            ),
            wibox.container.background(
                wibox.container.margin(s.mylayoutbox, 6, 6),
                COLOR_NAVY
            ),
        },
    }

    -- Create the bottom wibox
    s.bottomwibox = awful.wibar({
        position = "bottom",
        screen = s,
        border_width = 0,
        height = 20,
        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the bottom wibox
    s.bottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal, -- Left widgets
        },
        s.mytasklist, -- Middle widget
        {
            layout = wibox.layout.fixed.horizontal, -- Right widgets
        },
    }
end

return theme
