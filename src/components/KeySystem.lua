local KeySystem = {}
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween
local CreateButton = require("./ui/Button").New
local CreateInput = require("./ui/Input").New

function KeySystem.new(Config, Filename, func)
	if Config.Keyless or (Config.KeySystem and Config.KeySystem.Keyless) then
		func(true)
		return
	end

	local wsCtor = (WebSocket and WebSocket.connect)
		or (syn and syn.websocket and syn.websocket.connect)
		or (websocket and websocket.connect)

	if not wsCtor then
		warn("[PandaUI] Your executor does not support WebSocket.")
		func(false)
		return
	end

	local libCode
	do
		local ws = wsCtor("wss://secure.pandauth.com/ws?type=wilkins-lib")
		if ws then
			ws.OnMessage:Connect(function(msg)
				if msg and #msg > 0 and not libCode then
					libCode = msg
				end
			end)
			local deadline = tick() + 15
			repeat task.wait(0.05) until libCode or tick() > deadline
			pcall(function() ws:Close() end)
		end
	end

	if not libCode then
		warn("[PandaUI] Failed to fetch Wilkins library (timeout).")
		func(false)
		return
	end

	local Wilkins = loadstring(libCode)()
	if not Wilkins or type(Wilkins.configure) ~= "function" then
		warn("[PandaUI] Wilkins library failed to initialize.")
		func(false)
		return
	end

	Config.PandaUI.WilkinsInstance = Wilkins

	local serviceId = Config.KeySystem.ServiceId or "your-service-id"
	Wilkins.configure({
		serviceId = serviceId,
		debug = Config.KeySystem.Debug or false,
		kickOnDetect = Config.KeySystem.KickOnDetect or false,
		openDashboard = Config.KeySystem.OpenDashboard or false,
		validationTimeout = Config.KeySystem.ValidationTimeout or 600,
		onTamper = function(flags)
			warn("[PandaUI] Tamper flagged:", table.concat(flags or {}, ","))
		end,
		onSessionEnd = function(reason, msg)
			warn("[PandaUI] Session ended:", reason, msg or "")
		end,
	})

	local savedKey = Wilkins.loadSavedKey()
	if savedKey and savedKey ~= "" then
		local result = Wilkins.validate(savedKey)
		if result.success then
			task.spawn(function()
				while Wilkins.isConnected() do
					task.wait(5)
				end
			end)
			func(true)
			return
		else
			Wilkins.clearSavedKey()
		end
	end

	local KeyDialogInit = require("./window/Dialog")
	local KeyDialog = KeyDialogInit.Create(true, "Popup", Config.Window, Config.PandaUI, Config.PandaUI.ScreenGui.KeySystem)
	local EnteredKey = ""
	local ThumbnailSize = (Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Width) or 200
	local UISize = 430
	if Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image then
		UISize = 430 + (ThumbnailSize / 2)
	end

	KeyDialog.UIElements.Main.AutomaticSize = "Y"
	KeyDialog.UIElements.Main.Size = UDim2.new(0, UISize, 0, 0)
	
	local IconFrame
	if Config.Icon then
		IconFrame = Creator.Image(Config.Icon, Config.Title .. ":" .. Config.Icon, 0, "Temp", "KeySystem", Config.IconThemed)
		IconFrame.Size = UDim2.new(0, 24, 0, 24)
		IconFrame.LayoutOrder = -1
	end

	local Title = New("TextLabel", {
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		Text = Config.KeySystem.Title or Config.Title,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		ThemeTag = {
			TextColor3 = "Text",
		},
		TextSize = 20,
	})

	local KeySystemTitle = New("TextLabel", {
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		Text = "Key System",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		TextTransparency = 1,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		ThemeTag = {
			TextColor3 = "Text",
		},
		TextSize = 16,
	})

	local IconAndTitleContainer = New("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = "XY",
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 14),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
		}),
		IconFrame,
		Title,
	})

	local TitleContainer = New("Frame", {
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
	}, {
		IconAndTitleContainer,
		KeySystemTitle,
	})

	local InputFrame = CreateInput("Enter Key", "key", nil, "Input", function(k)
		EnteredKey = k
	end)

	local NoteText
	if Config.KeySystem.Note and Config.KeySystem.Note ~= "" then
		NoteText = New("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextXAlignment = "Left",
			Text = Config.KeySystem.Note,
			TextSize = 18,
			TextTransparency = 0.4,
			ThemeTag = {
				TextColor3 = "Text",
			},
			BackgroundTransparency = 1,
			RichText = true,
			TextWrapped = true,
		})
	end

	local ButtonsContainer = New("Frame", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
	}, {
		New("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = "X",
			Size = UDim2.new(0, 0, 1, 0),
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 18 / 2),
				FillDirection = "Horizontal",
			}),
		}),
	})

	local ThumbnailFrame
	if Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image then
		local ThumbnailTitle
		if Config.KeySystem.Thumbnail.Title then
			ThumbnailTitle = New("TextLabel", {
				Text = Config.KeySystem.Thumbnail.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 18,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				BackgroundTransparency = 1,
				AutomaticSize = "XY",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
		end
		ThumbnailFrame = New("ImageLabel", {
			Image = Config.KeySystem.Thumbnail.Image,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ThumbnailSize, 1, -12),
			Position = UDim2.new(0, 6, 0, 6),
			Parent = KeyDialog.UIElements.Main,
			ScaleType = "Crop",
		}, {
			ThumbnailTitle,
			New("UICorner", {
				CornerRadius = UDim.new(0, 26 - 6),
			}),
		})
	end

	local MainFrame = New("Frame", {
		Size = UDim2.new(1, ThumbnailFrame and -ThumbnailSize or 0, 1, 0),
		Position = UDim2.new(0, ThumbnailFrame and ThumbnailSize or 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = KeyDialog.UIElements.Main,
	}, {
		New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 18),
				FillDirection = "Vertical",
			}),
			TitleContainer,
			NoteText,
			InputFrame,
			ButtonsContainer,
			New("UIPadding", {
				PaddingTop = UDim.new(0, 16),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
				PaddingBottom = UDim.new(0, 16),
			}),
		}),
	})

	local ExitButton = CreateButton("Exit", "log-out", function()
		KeyDialog:Close()()
	end, "Tertiary", ButtonsContainer.Frame)

	if ThumbnailFrame then
		ExitButton.Parent = ThumbnailFrame
		ExitButton.Size = UDim2.new(0, 0, 0, 42)
		ExitButton.Position = UDim2.new(0, 10, 1, -10)
		ExitButton.AnchorPoint = Vector2.new(0, 1)
	end

	CreateButton("Get key", "key", function()
		local info = Wilkins.copyGetKeyUrl()
		if info.success then
			Config.PandaUI:Notify({
				Title = "Key System",
				Content = "Key URL copied to clipboard.",
				Icon = "key",
			})
		else
			setclipboard(info.url or Wilkins.getKeyUrl() or "")
			Config.PandaUI:Notify({
				Title = "Key System",
				Content = "Key URL copied via fallback.",
				Icon = "key",
			})
		end
	end, "Secondary", ButtonsContainer.Frame)

	CreateButton("Clear Key", "trash", function()
		Wilkins.clearSavedKey()
		Config.PandaUI:Notify({
			Title = "Key System",
			Content = "Saved key cleared.",
			Icon = "trash",
		})
	end, "Secondary", ButtonsContainer.Frame)

	local SubmitButton = CreateButton("Submit", "arrow-right", function()
		local key = tostring(EnteredKey or "")
		if key == "" then
			Config.PandaUI:Notify({
				Title = "Key System",
				Content = "Please enter a key.",
				Icon = "triangle-alert",
			})
			return
		end

		local result = Wilkins.validate(key)
		if result.success then
			KeyDialog:Close()()
			task.spawn(function()
				while Wilkins.isConnected() do
					task.wait(5)
				end
			end)
			task.wait(0.4)
			func(true)
		else
			Wilkins.clearSavedKey()
			Config.PandaUI:Notify({
				Title = "Key System Error",
				Content = result.error or "Invalid key",
				Icon = "triangle-alert",
			})
		end
	end, "Primary", ButtonsContainer)

	SubmitButton.AnchorPoint = Vector2.new(1, 0.5)
	SubmitButton.Position = UDim2.new(1, 0, 0.5, 0)

	KeyDialog:Open()
end

return KeySystem