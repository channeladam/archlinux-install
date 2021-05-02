# Manual Configuration

## Panel

latte-dock - widget added into Panel


## Turn off screen after lock

- System Settings -> Notifications -> Applications: Configure button
- Screen Saver -> Configure Events button
- Screen locked -> Run command: /bin/sleep 5; /usr/bin/xset dpms force off

## Activate and raise window on mouse scroll

- System Settings -> Workspace -> Window Management -> Window Behaviour -> Window Actions
- Mouse wheel:  Activeate, raise and scroll


---
## Theme

### Settings

- System settings -> Startup & Shutdown -> Login Screen (SDDM) -> Breath2

- System Settings -> Appearance -> Global Theme -> Breeze Dark
- System Settings -> Appearance -> Application Style -> Fusion
- System Settings -> Appearance -> Application Style -> Configure Gnome/GTK Application Style -> Breeze
- System Settings -> Appearance -> Plasma Style -> Breeze Dark
- System Settings -> Appearance -> Colours -> Materia Dark

- System Settings -> Appearance -> Window Decorations
  - Theme: Breeze
    - Button size: Medium
    - Draw titlebar background gradient
    - Shadows: Small, 25%, light blue #0bcaff
    - Window border size: No Borders
  - Titlebar Buttons: (Pin on all desktops, Keep above) on left, remove Help

- System Settings -> Appearance -> Icons -> Papirus-Dark

- System Settings -> Cursors -> Volantes Cursors;  Size 64

- System Settings -> Appearance -> Splash Screen -> Breath2

- System Settings -> Workspace -> Window Management -> Task Switcher -> Grid


---
## KDE Keyboard Shortcuts


### Tiling keyboard shortcuts

Meta + arrows to Tile window


### Toggle Compositor
Shift-Alt-F12


# Troubleshooting

## Present Windows
Present Windows does not work when the Compositor is disabled.


## Slow

Turn off the Desktop Effect: Blur - it chews 70% GPU with many windows open!

- System Settings -> Workspace Behaviour -> Desktop Effects -> Blur

