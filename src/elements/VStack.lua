local Creator = require("../modules/Creator")
local New = Creator.New
local Element = {}
function Element:New(Config)
    local VStackModule = {
        __type = "VStack",
        Elements = {},
        ElementFrame = nil,
    }
    local VStackFrame = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
        Parent = Config.Parent,
    }, {
        New("UIListLayout", {
            FillDirection = "Vertical",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0, Config.Tab and Config.Tab.Gap or (Config.Window.NewElements and 1 or 6))
        }),
    })
    VStackModule.ElementFrame = VStackFrame
    local ElementsModule = Config.ElementsModule
    ElementsModule.Load(
        VStackModule,
        VStackFrame,
        ElementsModule.Elements,
        Config.Window,
        Config.PandaUI,
        nil,
        ElementsModule,
        Config.UIScale,
        Config.Tab
    )
    return VStackModule.__type, VStackModule
end
return Element