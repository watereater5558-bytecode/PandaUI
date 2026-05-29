local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween
local NotificationModule = {
    Size = UDim2.new(0,300,1,-100-56),
    SizeLower = UDim2.new(0,300,1,-56),
    UICorner = 18,
    UIPadding = 14,
    Holder = nil,
    NotificationIndex = 0,
    Notifications = {}
}
function NotificationModule.Init(Parent)
    local NotModule = {
        Lower = false
    }
    function NotModule.SetLower(val)
        NotModule.Lower = val
        NotModule.Frame.Size = val and NotificationModule.SizeLower or NotificationModule.Size
    end
    NotModule.Frame = New("Frame", {
        Position = UDim2.new(1,-116/4,0,56),
        AnchorPoint = Vector2.new(1,0),
        Size = NotificationModule.Size ,
        Parent = Parent,
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            HorizontalAlignment = "Center",
			SortOrder = "LayoutOrder",
			VerticalAlignment = "Bottom",
			Padding = UDim.new(0, 8),
        }),
        New("UIPadding", {
            PaddingBottom = UDim.new(0,116/4)
        })
    })
    return NotModule
end
function NotificationModule.New(Config)
    local Notification = {
        Title = Config.Title or "Notification",
        Content = Config.Content or nil,
        Icon = Config.Icon or nil,
        IconThemed = Config.IconThemed,
        Background = Config.Background,
        BackgroundImageTransparency = Config.BackgroundImageTransparency,
        Duration = Config.Duration or 5,
        Buttons = Config.Buttons or {},
        CanClose = Config.CanClose ~= false,
        UIElements = {},
        Closed = false,
    }
    local Type = Config.Type or Config.Variant or nil
    local TypeColor = nil
    if Type then
        local typeColors = {
            Success = Color3.fromHex("#10b981"),
            Error = Color3.fromHex("#ef4444"),
            Warning = Color3.fromHex("#d97706"),
            Info = Color3.fromHex("#3b82f6"),
        }
        local typeIcons = {
            Success = "check-circle",
            Error = "x-circle",
            Warning = "alert-triangle",
            Info = "info",
        }
        TypeColor = typeColors[Type]
        if not Notification.Icon then
            Notification.Icon = typeIcons[Type]
        end
    end
    NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
    NotificationModule.Notifications[NotificationModule.NotificationIndex] = Notification
    local Icon
    if Notification.Icon then
        Icon = Creator.Image(
            Notification.Icon,
            Notification.Title .. ":" .. Notification.Icon,
            0,
            Config.Window,
            "Notification",
            Notification.IconThemed
        )
        Icon.Size = UDim2.new(0,26,0,26)
        Icon.Position = UDim2.new(0,NotificationModule.UIPadding,0,NotificationModule.UIPadding)
        if TypeColor then
            for _, child in next, Icon:GetDescendants() do
                if child:IsA("ImageLabel") then
                    child.ImageColor3 = TypeColor
                end
            end
        end
    end
    local CloseButton
    if Notification.CanClose then
        CloseButton = New("ImageButton", {
            Image = Creator.Icon("x")[1],
            ImageRectSize = Creator.Icon("x")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("x")[2].ImageRectPosition,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,16,0,16),
            Position = UDim2.new(1,-NotificationModule.UIPadding,0,NotificationModule.UIPadding),
            AnchorPoint = Vector2.new(1,0),
            ThemeTag = {
                ImageColor3 = "Text"
            },
            ImageTransparency = .4,
        }, {
            New("TextButton", {
                Size = UDim2.new(1,8,1,8),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
                Text = "",
            })
        })
    end
    local Duration = Creator.NewRoundFrame(NotificationModule.UICorner, "Squircle", {
        Size = UDim2.new(0,0,1,0),
        ThemeTag = {
            ImageTransparency = "NotificationDurationTransparency",
            ImageColor3 = "NotificationDuration",
        },
    })
    local TextContainer = New("Frame", {
        Size = UDim2.new(1,
            Notification.Icon and -28-NotificationModule.UIPadding or 0,
            1,0),
        Position = UDim2.new(1,0,0,0),
        AnchorPoint = Vector2.new(1,0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0,NotificationModule.UIPadding),
            PaddingLeft = UDim.new(0,NotificationModule.UIPadding),
            PaddingRight = UDim.new(0,NotificationModule.UIPadding),
            PaddingBottom = UDim.new(0,NotificationModule.UIPadding),
        }),
        New("TextLabel", {
            AutomaticSize = "Y",
            Size = UDim2.new(1,-30-NotificationModule.UIPadding,0,0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            TextSize = 18,
            ThemeTag = {
                TextColor3 = "NotificationTitle",
                TextTransparency = "NotificationTitleTransparency",
            },
            Text = Notification.Title,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold)
        }),
        New("UIListLayout", {
            Padding = UDim.new(0,NotificationModule.UIPadding/3)
        })
    })
    if Notification.Content then
        New("TextLabel", {
            AutomaticSize = "Y",
            Size = UDim2.new(1,0,0,0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            TextSize = 15,
            ThemeTag = {
                TextColor3 = "NotificationContent",
                TextTransparency = "NotificationContentTransparency",
            },
            Text = Notification.Content,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            Parent = TextContainer
        })
    end
    local Main = Creator.NewRoundFrame(NotificationModule.UICorner, "Squircle", {
        Size = UDim2.new(1,0,0,0),
        Position = UDim2.new(2,0,1,0),
        AnchorPoint = Vector2.new(0,1),
        AutomaticSize = "Y",
        ImageTransparency = .05,
        ThemeTag = {
            ImageColor3 = "Notification"
        },
    }, {
        Creator.NewRoundFrame(NotificationModule.UICorner, "Glass-1", {
            Size = UDim2.new(1,0,1,0),
            ThemeTag = {
                ImageColor3 = "NotificationBorder",
                ImageTransparency = "NotificationBorderTransparency",
            },
        }),
        New("Frame", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Name = "DurationFrame",
        }, {
            New("Frame", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
            }, {
                Duration,
            }),
        }),
        New("ImageLabel", {
            Name = "Background",
            Image = Notification.Background,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            ScaleType = "Crop",
            ImageTransparency = Notification.BackgroundImageTransparency
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,NotificationModule.UICorner),
            })
        }),
        TextContainer,
        Icon, CloseButton,
    })
    local IndicatorBar
    if TypeColor then
        IndicatorBar = New("Frame", {
            Size = UDim2.new(0, 4, 1, -16),
            Position = UDim2.new(0, 6, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = TypeColor,
            BorderSizePixel = 0,
            ZIndex = 5,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
            })
        })
        IndicatorBar.Parent = Main
    end
    local MainContainer = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,0),
        Parent = Config.Holder
    }, {
        Main
    })
    function Notification:Close()
        if not Notification.Closed then
            Notification.Closed = true
            Tween(MainContainer, 0.45, {Size = UDim2.new(1, 0, 0, -8)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(Main, 0.55, {Position = UDim2.new(2,0,1,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            task.wait(.45)
            MainContainer:Destroy()
        end
    end
    task.spawn(function()
        task.wait()
        Tween(MainContainer, 0.45, {Size = UDim2.new(
            1,
            0,
            0,
            Main.AbsoluteSize.Y
        )}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Main, 0.45, {Position = UDim2.new(0,0,1,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        if Notification.Duration then
            Duration.Size = UDim2.new(0,Main.DurationFrame.AbsoluteSize.X,1,0)
            Tween(Main.DurationFrame.Frame, Notification.Duration, {Size = UDim2.new(0,0,1,0)}, Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
            task.wait(Notification.Duration)
            Notification:Close()
        end
    end)
    if CloseButton then
        Creator.AddSignal(CloseButton.TextButton.MouseButton1Click, function()
            Notification:Close()
        end)
    end
    return Notification
end
return NotificationModule