<!--<h1 align="center">PandaUI</h1> -->

<!--
<picture>
    <source srcset="docs/banner-dark.webp" media="(prefers-color-scheme: dark)">
    <source srcset="docs/banner-light.webp" media="(prefers-color-scheme: light)">
    <img src="docs/banner-light.webp" alt="PandaUI Banner">
</picture>-->

<img src="docs/PandaUI – Themes.png" alt="PandaUI Banner">

> [!WARNING]
> This PandaUI was not inspired by, and the name has nothing to do with UI Frameworks

> [!WARNING]
> PandaUI is currently in Beta.
> This project is still under active development. Bugs, issues, and unstable features may occur. We’re constantly working on improvements, so please be patient and report any problems you encounter.

## Credits

#### Icons (https://github.com/Footagesus/Icons)

- [Lucide-Icons](https://github.com/lucide-icons/lucide)
- [Craft Icons](https://www.figma.com/community/file/1415718327120418204)
- [Geist Icons](https://vercel.com/geist/icons)
- [Solar Icons](https://icones.js.org/collection/solar)
- [SF Symbols](https://sf-symbols-one.vercel.app/)

### Links

- [Discord Server](https://discord.gg/ftgs-development-hub-1300692552005189632)
- [Documentation](https://Footagesus.github.io/PandaUI-Docs/)
- [Installation](https://footagesus.github.io/PandaUI-Docs/docs/installation)
- [Example](/main_example.lua) (wip)
    ```luau
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/PandaUI/refs/heads/main/main_example.lua'))()
    ```

## Fork Features & Enhancements (v1.7.0)

This fork introduces several premium features and quality of life enhancements to the Wind UI library:

1. **Preset Themes**: Added Dracula, Cyberpunk, Aurora, and Sakura theme presets.
2. **Dynamic Theme Creator**: Register custom themes at runtime using `PandaUI:CreateTheme(Name, Settings)`.
3. **Banner Component**: A card element (`Tab:Banner(Config)`) for alerts, warnings, and success messages with high-contrast text rendering.
4. **Toast Notification Statuses**: Pre-configured `Success`, `Error`, `Warning`, and `Info` notifications with vertical accent bars.
5. **Keybind Modes**: Supports `Toggle` (fires callback with true/false state) and `Hold` (fires true on press, false on release) keybind modes.
6. **Element Tooltips**: Show floating cursor-tracking tooltips on any element by passing `Tooltip = "..."` to its config.
7. **Custom Toggle Colors**: Customize individual toggle active colors by specifying `ToggleColor` or `ActiveColor`.
8. **Dropdown Summaries**: Multi-select dropdowns support `MaxItemsDisplay` to automatically summarize selected values (e.g. "4 items selected") and prevent label overflow.
