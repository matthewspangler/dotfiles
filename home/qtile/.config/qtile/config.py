# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
# Copyright (c) 2020 Matthew Spangler
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from theme import pywal

## Main configuration

mod = "mod4"
terminal = 'urxvt' #guess_terminal()

# add 'PlayPause', 'Next' or 'Previous'
music_cmd = ('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify '
             '/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.')

## Screenshot function
def screenshot(save=True, copy=True):
    def f(qtile):
        path = Path.home() / 'Pictures'
        path /= f'screenshot_{str(int(time() * 100))}.png'
        shot = subprocess.run(['maim'], stdout=subprocess.PIPE)

        if save:
            with open(path, 'wb') as sc:
                sc.write(shot.stdout)

        if copy:
            subprocess.run(['xclip', '-selection', 'clipboard', '-t',
                            'image/png'], input=shot.stdout)
    return f

## Music control function
def next_prev(action):
    def f(qtile):
        qtile.cmd_spawn(music_cmd + action)
    return f

## Backlight function
def backlight(action):
    def f(qtile):
        brightness = int(subprocess.run(['xbacklight', '-get'],
                                        stdout=subprocess.PIPE).stdout)
        if brightness != 1 or action != 'dec':
            if (brightness > 49 and action == 'dec') \
                                or (brightness > 39 and action == 'inc'):
                subprocess.run(['xbacklight', f'-{action}', '10',
                                '-fps', '10'])
            else:
                subprocess.run(['xbacklight', f'-{action}', '1'])
    return f

keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "j", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "control"], "j", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),

    # Spawn Rofi shortcut
    Key([mod], "d", lazy.spawn("rofi -show run"), desc="Spawn rofi"),

    # Screen
    Key([], 'XF86MonBrightnessUp',   lazy.function(backlight('inc'))),
    Key([], 'XF86MonBrightnessDown', lazy.function(backlight('dec'))),

    # Audio
    Key([], 'XF86AudioMute', lazy.spawn('ponymix toggle')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('ponymix increase 5')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('ponymix decrease 5')),
    Key([], 'XF86AudioPlay', lazy.spawn(music_cmd + 'PlayPause')),
    Key([], 'XF86AudioNext', lazy.function(next_prev('Next'))),
    Key([], 'XF86AudioPrev', lazy.function(next_prev('Previous'))),

    # Screenshots
    #Key([], 'Print', lazy.function(screenshot())),
    #Key(['control'], 'Print', lazy.spawn('deepin-screenshot')),
]

group_names = [("WWW", {'layout': 'max'}),
               ("DEV", {'layout': 'monadtall'}),
               ("SYS", {'layout': 'monadtall'}),
               ("ORG", {'layout': 'monadtall'}),
               ("DOC", {'layout': 'max'}),
               ("JACK", {'layout': 'floating'}),
               ("DAW", {'layout': 'max'}),
               ("ART", {'layout': 'floating'}),
               ("GAME", {'layout': 'floating'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group

# This allows you to drag windows around with the mouse if you want.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

## Themes

layout_theme = {
    "border_width":     2,
    "margin":           10,
    "border_focus":     pywal["foreground"],
    "border_normal":    pywal["background"]
}

layout_colors = {
    "border_focus":     pywal["foreground"],
    "border_normal":    pywal["background"]
}

seperator_theme = {
    "padding":		7,
    "linewidth":	1,
    "foreground":	pywal["foreground"],
    "height_percent":	80
}

## Layouts

layouts = [
    #layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    layout.Bsp(**layout_theme),
    # layout.Columns(),
    layout.Matrix(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Tile(**layout_colors),
    layout.Max(**layout_colors),
    layout.Floating(**layout_colors),
    layout.Stack(**layout_colors, num_stacks=2)
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='Inconsolata for Powerline',
    fontsize=15,
    padding=3,
    foreground=pywal["foreground"],
    background=pywal["background"],
)
extension_defaults = widget_defaults.copy()

groupbox_theme = {
    "highlight_color": 			pywal["foreground"],
    "foreground":			pywal["foreground"],
    "block_highlight_text_color":	pywal["foreground"],
    "inactive": 			pywal["color8"],
    "highlight_method":			"block",
    "active":				pywal["color3"],
    "this_current_screen_border":	pywal["color2"],
    "this_screen_border":		pywal["color2"]
}

## Screens

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(**groupbox_theme),
                widget.Sep(**seperator_theme),
                widget.CurrentLayout(),
                widget.Sep(**seperator_theme),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),
                widget.Sep(**seperator_theme),
                widget.Battery(),
                widget.Sep(**seperator_theme),
                widget.Clock(format='%a %I:%M %p'),
                widget.QuickExit(),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

import os
import subprocess

@hook.subscribe.startup
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])
