from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os
import subprocess


mod = "mod4"
terminal = guess_terminal()

# Получение кратного имени раскладки (ru или en) 
# def get_keyboard_layout():
#    result = subprocess.run(
#        ['xset', '-q'],
#        capture_output=True,
#        text=True
#    )
#    output = result.stdout
#
#    # Извлечение LED mask с помощью grep и awk через Python
#    for line in output.splitlines():
#        if "LED mask" in line:
#            # Разбитие строки на части и взятие последнего поля
#            led_mask = line.split()[-1]
#            break
#    else:
#        led_mask = "00000000"  # значение по умолчанию, если не найдено
#
#    if led_mask == "00000000":
#        return f'<span foreground="{colors[6][0]}">А</span>'
#    else:
#        return f'<span foreground="{colors[3][0]}">Р</span>'

# Настройка положения экранов между собой
def autostart():
    subprocess.call([
        "xrandr",
        "--output", "DP-0", "--off", 
        "--output", "DP-1", "--mode", "1920x1080", "--pos", "0x0", "--rotate", "normal",
        "--output", "HDMI-0", "--mode", "2560x1440", "--pos", "1920x0", "--rotate", "normal",
        "--output", "DP-2", "--off", 
        "--output", "DP-3", "--off", 
        "--output", "DP-4", "--off", 
        "--output", "DP-5", "--off", 
    ])

@hook.subscribe.startup_once
def start_once():
    autostart()

myTerm = "alacritty" 

keys = [
    # Key([mod, "shift"], "e", lazy.window.togroup(), desc="Переместить окно на другой экран"),
    #     Key([mod, "control"], "e", lazy.function(lambda qtile: qtile.current_window.tostack(qtile.screens[(qtile.current_screen.index + 1) % len(qtile.screens)])),
    #     desc="Переместить окно на следующий экран и сфокусировать его"),
    Key([mod], "b", lazy.hide_show_bar(position="top"), desc="Hide show bar"), # сокрытие информационной панели
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    # Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "d", lazy.spawn("rofi -show drun -show-icons"), desc='Run Launcher'),
    Key(
        [mod], 
        "s",
        lazy.spawn('sh -c "maim -s | xclip -selection clipboard -t image/png -i"'),
        desc="Screenshot"
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "12"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc=f"Switch to & move focused window to group {i.name}",
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

colors = [
    ["#1a1b26", "#1a1b26"],  # bg        (primary.background)
    ["#a9b1d6", "#a9b1d6"],  # fg        (primary.foreground)
    ["#32344a", "#32344a"],  # color01   (normal.black)
    ["#f7768e", "#f7768e"],  # color02   (normal.red)
    ["#9ece6a", "#9ece6a"],  # color03   (normal.green)
    ["#e0af68", "#e0af68"],  # color04   (normal.yellow)
    ["#7aa2f7", "#7aa2f7"],  # color05   (normal.blue)
    ["#ad8ee6", "#ad8ee6"],  # color06   (normal.magenta)
    ["#0db9d7", "#0db9d7"],  # color15   (bright.cyan)
    ["#444b6a", "#444b6a"]   # color[9]  (bright.black)
]

# helper in case your colors are ["#hex", "#hex"]
def C(x): return x[0] if isinstance(x, (list, tuple)) else x

layout_theme = {
    "border_width" : 1,
    "margin" : 1,
    "border_focus" : colors[6],
    "border_normal" : colors[0],
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Fira Code Bold",
    # font="",
    fontsize=16,
    padding=0,
    background=colors[0],
)

extension_defaults = widget_defaults.copy()

sep = widget.Sep(linewidth=1, padding=8, foreground=colors[9])

screens = [
    Screen(
        top=bar.Bar(
            widgets = [
                widget.GroupBox(
                    fontsize = 18,
                    margin_y = 5,
                    margin_x = 5,
                    padding_y = 0,
                    padding_x = 2,
                    borderwidth = 3,
                    active = colors[9],
                    inactive = colors[9],
                    rounded = False,
                    highlight_color = colors[0],
                    highlight_method = "line",
                    this_current_screen_border = colors[9],
                    this_screen_border = colors[0],
                    other_current_screen_border = colors[9],
                    other_screen_border = colors[0],
                ),
                widget.WindowName(
                    foreground = colors[9],
                    padding = 8,
                    max_chars = 100
                ),
                widget.Spacer(stretch=True),
                # widget.Prompt(
                #     # font = "",
                #     fontsize=14,
                #     foreground = colors[1]
                # ),
                # widget.CurrentLayout(
                #     foreground = colors[1],
                #     padding = 5
                # ),
                # widget.TextBox(
                #     text = '|',
                #     # font = "Ubuntu Mono",
                #     foreground = colors[9],
                #     padding = 2,
                #     fontsize = 14
                # ),
                # widget.Image(
                #    filename = "~/.config/qtile/icons/i.png",
                #    scale = "False",
                #    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("qtilekeys-yad")},
                # ),
               # widget.ThermalSensor(
               #     foreground = colors[9],
               #     tag_sensor='amdgpu-pci-0300', # Укажите свой датчик из команды sensors
               #     fmt='ГП: {}',
               # ),
               # sep,
                widget.CPU(
                    update_interval = 2,
                    foreground = colors[9],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e btop')},
                    # format="ЦПУ: {load_percent}%",
                    format="ЦПУ: {load_percent:.0f}%", # отображение загрузки ЦПУ без десятичных значений
                ),
                widget.ThermalSensor(
                    foreground = colors[9],
                    format='{temp:.0f}°', # Формат отображения
                    tag_sensor='Package id 0',      # Датчик (опционально, зависит от CPU)
                    update_interval=2,              # Интервал обновления в сек
                ),
                widget.Spacer(
                   length = 6, 
                ),
                sep,
                widget.Memory(
                    update_interval = 2,
                    foreground = colors[9],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e btop')},
                    # format = 'ОЗУ: {MemUsed:.0f}{mm}',
                    format = 'ОЗУ: {MemPercent:.0f}%',
                ),
                sep,
                widget.DF(
                    update_interval = 60,
                    foreground = colors[9],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-disk')},
                    partition = '/',
                    # format = '{uf}{m}',
                    # format = 'ЗУ {r:.1f}%',
                    format = 'ЗУ {r:.1f}%',
                    # fmt = 'ЗУ: {}',
                    visible_on_warn = False,
                ),
                # sep,
                # widget.GenPollText(
                #     update_interval = 300,
                #     func = lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True),
                #     foreground = colors[3],
                #     padding = 8, 
                #     fmt = 'Ядро: {}',
                # ),
                # sep,
                # widget.Battery(
                #    foreground=colors[6],           # pick a palette slot you like
                #    padding=8,
                #    update_interval=5,
                #    format='{percent:2.0%} {char} {hour:d}:{min:02d}',  # e.g. "73% ⚡ 1:45"
                #    fmt='Bat: {}',
                #    charge_char='',               # shown while charging
                #    discharge_char='',            # Nerd icon; use '-' if you prefer plain ascii
                #    full_char='✔',                 # when at/near 100%
                #    unknown_char='?',
                #    empty_char='!', 
                #    mouse_callbacks={
                #        'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e upower -i $(upower -e | grep BAT)'),
                #    },
                #),
                #sep,
                # widget.Volume(
                #     foreground = colors[7],
                #     padding = 8, 
                #     fmt = 'Звук: {}',
                # ),
                sep,
                widget.Clock(
                    foreground = colors[9],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-date')},
                    format = "%a, %d %b",
                ),
                sep,
                widget.Clock(
                    foreground = colors[4],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-date')},
                    format = "%H:%M",
                ),
                # sep,
                # widget.GenPollText(
                #     update_interval=1, # интервал обновления в секундах
                #     func=get_keyboard_layout,
                #     # foreground = colors[4],
                #     padding = 8, 
                # ),
                widget.Systray(padding = 6),
                widget.Spacer(length = 8),
            ],
            margin=[0, 0, 0, 0], 
            size=30
        ),
    ),
    # Screen(
    #     top=bar.Bar(
    #         widgets = [
    #             widget.Clock(
    #                 foreground = colors[8],
    #                 padding = 8, 
    #                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-date')},
    #                 format = "%A %A - %d %b - %H:%M {}",
    #             ),
    #         ],
    #         margin=[0, 0, 0, 0], 
    #         size=30
    #     ),
    # ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

wmname = "LG3D"
