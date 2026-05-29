# 1.7.0

`1.7.0` is a major feature update for PandaUI.

## Changelog:

- **Themes Preset Expansion**: Added Dracula, Cyberpunk, Aurora, and Sakura themes.
- **Dynamic Custom Themes**: Added `PandaUI:CreateTheme(Name, Settings)` method allowing runtime creation and registration of custom themes.
- **Banner Element**: Added the `Banner` element to display styled status alerts (Info, Success, Warning, Error) with high-contrast text contrast.
- **Notification Variants**: Updated `PandaUI:Notify(Config)` to support variants (Success, Error, Warning, Info) with a vertical status bar indicator on the left side of the toast.
- **Toggle and Hold Keybind Modes**: Keybind element now supports `Mode = "Toggle"` (returning a boolean state to the callback) and `Mode = "Hold"` (returning true on key press, and false on key release).
- **Element Tooltips**: Added a `Tooltip` configuration parameter for all page elements (buttons, toggles, dropdowns, etc.) which spawns a cursor-tracking label.
- **Custom Toggle Active Colors**: Added a `ToggleColor` (or `ActiveColor`) parameter to Toggle elements for setting individual switch colors.
- **Dropdown Item Count Summary**: Added a `MaxItemsDisplay` option to multi-select Dropdowns to summarize selections and avoid label overflow.

# 1.6.64-fix

`1.6.64-fix` is a fixed version of [1.6.64 (deleted version, cuz it is broken)](https://github.com/Footagesus/PandaUI/blob/8c68c3f221e1f5d9e0d12f53a8919b490aa46ad3/changelog.md)

## Changelog:

- Added `CustomEmptyPage` to `Tab`
- Added `TabTitleAlign` to `Tab` (applies to `ShowTabTitle`)
- Fix Dropdown Width
- Added New Elements: HStack & VStack (Group == HStack)
- Added Glass effect to toggle
- Moved Toggle Click Hitbox
- Some changes in Dialog's/Popup's
- Fixed Key System issues
- Various minor bug fixes and improvements

-# reupload
