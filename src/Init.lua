local PandaUI = {
	Window = nil,
	Theme = nil,
	Creator = require("./modules/Creator"),
	LocalizationModule = require("./modules/Localization"),
	NotificationModule = require("./components/Notification"),
	Themes = nil,
	Transparent = false,
	TransparencyValue = 0.15,
	UIScale = 1,
	ConfigManager = nil,
	Version = "0.0.0",
	Services = require("./utils/services/Init"),
	OnThemeChangeFunction = nil,
	cloneref = nil,
	UIScaleObj = nil,
}
local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)
PandaUI.cloneref = cloneref
local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))
local LocalPlayer = Players.LocalPlayer or nil
local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
	PandaUI.Version = Package.version
end
local KeySystem = require("./components/KeySystem")
local Creator = PandaUI.Creator
local New = Creator.New
local Acrylic = require("./utils/Acrylic/Init")
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))
local UIScaleObj = New("UIScale", {
	Scale = PandaUI.UIScale,
})
PandaUI.UIScaleObj = UIScaleObj
PandaUI.ScreenGui = New("ScreenGui", {
	Name = "PandaUI",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	DisplayOrder = -99999,
}, {
	New("Folder", {
		Name = "Window",
	}),
	New("Folder", {
		Name = "KeySystem",
	}),
	New("Folder", {
		Name = "Popups",
	}),
	New("Folder", {
		Name = "ToolTips",
	}),
})
PandaUI.NotificationGui = New("ScreenGui", {
	Name = "PandaUI/Notifications",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
PandaUI.DropdownGui = New("ScreenGui", {
	Name = "PandaUI/Dropdowns",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
PandaUI.TooltipGui = New("ScreenGui", {
	Name = "PandaUI/Tooltips",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
ProtectGui(PandaUI.ScreenGui)
ProtectGui(PandaUI.NotificationGui)
ProtectGui(PandaUI.DropdownGui)
ProtectGui(PandaUI.TooltipGui)
Creator.Init(PandaUI)
function PandaUI:SetParent(parent)
	if PandaUI.ScreenGui then
		PandaUI.ScreenGui.Parent = parent
	end
	if PandaUI.NotificationGui then
		PandaUI.NotificationGui.Parent = parent
	end
	if PandaUI.DropdownGui then
		PandaUI.DropdownGui.Parent = parent
	end
	if PandaUI.TooltipGui then
		PandaUI.TooltipGui.Parent = parent
	end
end
math.clamp(PandaUI.TransparencyValue, 0, 1)
local Holder = PandaUI.NotificationModule.Init(PandaUI.NotificationGui)
function PandaUI:Notify(Config)
	Config.Holder = Holder.Frame
	Config.Window = PandaUI.Window
	return PandaUI.NotificationModule.New(Config)
end
function PandaUI:SetNotificationLower(Val)
	Holder.SetLower(Val)
end
function PandaUI:SetFont(FontId)
	Creator.UpdateFont(FontId)
end
function PandaUI:OnThemeChange(func)
	PandaUI.OnThemeChangeFunction = func
end
function PandaUI:AddTheme(LTheme)
	PandaUI.Themes[LTheme.Name] = LTheme
	return LTheme
end
function PandaUI:CreateTheme(Name, Settings)
	local Theme = {
		Name = Name,
		Accent = Settings.Accent or Color3.fromHex("#18181b"),
		Dialog = Settings.Dialog or Color3.fromHex("#161616"),
		Outline = Settings.Outline or Settings.Text or Color3.fromHex("#FFFFFF"),
		Text = Settings.Text or Color3.fromHex("#FFFFFF"),
		Placeholder = Settings.Placeholder or Color3.fromHex("#7a7a7a"),
		Background = Settings.Background or Color3.fromHex("#101010"),
		Button = Settings.Button or Color3.fromHex("#52525b"),
		Icon = Settings.Icon or Settings.Primary or Color3.fromHex("#a1a1aa"),
		Toggle = Settings.Toggle or Color3.fromHex("#33C759"),
		Slider = Settings.Slider or Color3.fromHex("#0091FF"),
		Checkbox = Settings.Checkbox or Color3.fromHex("#0091FF"),
		Primary = Settings.Primary or Color3.fromHex("#0091FF"),
		ElementBackground = Settings.ElementBackground or Color3.fromHex("#2A2A2C"),
		ElementBackgroundTransparency = Settings.ElementBackgroundTransparency or 0,
		PanelBackground = Settings.PanelBackground or Color3.fromHex("#FFFFFF"),
		PanelBackgroundTransparency = Settings.PanelBackgroundTransparency or 0.95,
	}
	return PandaUI:AddTheme(Theme)
end
function PandaUI:SetTheme(Value)
	if PandaUI.Themes[Value] then
		PandaUI.Theme = PandaUI.Themes[Value]
		Creator.SetTheme(PandaUI.Themes[Value])
		if PandaUI.OnThemeChangeFunction then
			PandaUI.OnThemeChangeFunction(Value)
		end
		return PandaUI.Themes[Value]
	end
	return nil
end
function PandaUI:GetThemes()
	return PandaUI.Themes
end
function PandaUI:GetCurrentTheme()
	return PandaUI.Theme.Name
end
function PandaUI:GetTransparency()
	return PandaUI.Transparent or false
end
function PandaUI:GetWindowSize()
	return PandaUI.Window.UIElements.Main.Size
end
function PandaUI:Localization(LocalizationConfig)
	return PandaUI.LocalizationModule:New(LocalizationConfig, Creator)
end
function PandaUI:SetLanguage(Value)
	if Creator.Localization then
		return Creator.SetLanguage(Value)
	end
	return false
end
function PandaUI:ToggleAcrylic(Value)
	if PandaUI.Window and PandaUI.Window.AcrylicPaint and PandaUI.Window.AcrylicPaint.Model then
		PandaUI.Window.Acrylic = Value
		PandaUI.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value then
			Acrylic.Enable()
		else
			Acrylic.Disable()
		end
	end
end
function PandaUI:Gradient(stops, props)
	local colorSequence = {}
	local transparencySequence = {}
	for posStr, stop in next, stops do
		local position = tonumber(posStr)
		if position then
			position = math.clamp(position / 100, 0, 1)
			local color = stop.Color
			if typeof(color) == "string" and string.sub(color, 1, 1) == "#" then
				color = Color3.fromHex(color)
			end
			local transparency = stop.Transparency or 0
			table.insert(colorSequence, ColorSequenceKeypoint.new(position, color))
			table.insert(transparencySequence, NumberSequenceKeypoint.new(position, transparency))
		end
	end
	table.sort(colorSequence, function(a, b)
		return a.Time < b.Time
	end)
	table.sort(transparencySequence, function(a, b)
		return a.Time < b.Time
	end)
	if #colorSequence < 2 then
		table.insert(colorSequence, ColorSequenceKeypoint.new(1, colorSequence[1].Value))
		table.insert(transparencySequence, NumberSequenceKeypoint.new(1, transparencySequence[1].Value))
	end
	local gradientData = {
		Color = ColorSequence.new(colorSequence),
		Transparency = NumberSequence.new(transparencySequence),
	}
	if props then
		for k, v in pairs(props) do
			gradientData[k] = v
		end
	end
	return gradientData
end
function PandaUI:Popup(PopupConfig)
	PopupConfig.PandaUI = PandaUI
	return require("./components/popup/Init").new(PopupConfig, PandaUI.ScreenGui.Popups)
end
PandaUI.Themes = require("./themes/Init")(PandaUI, Creator)
Creator.Themes = PandaUI.Themes
PandaUI:SetTheme("Dark")
PandaUI:SetLanguage(Creator.Language)
function PandaUI:ClearSavedKey()
	if PandaUI.WilkinsInstance then
		PandaUI.WilkinsInstance.clearSavedKey()
	elseif PandaUI.CookiesInstance then
		PandaUI.CookiesInstance.clearSavedKey()
	else
		local wsCtor
		local ws
		local ctors = {
			WebSocket and WebSocket.connect,
			syn and syn.websocket and syn.websocket.connect,
			websocket and websocket.connect
		}
		for _, ctor in ipairs(ctors) do
			if typeof(ctor) == "function" then
				local success, res = pcall(ctor, "wss://secure.pandauth.com/ws?type=wilkins-lib")
				if success and (typeof(res) == "table" or typeof(res) == "userdata") then
					local hasOnMessage = false
					pcall(function()
						hasOnMessage = (res.OnMessage ~= nil)
					end)
					if hasOnMessage then
						wsCtor = ctor
						ws = res
						break
					end
				end
			end
		end
		if ws then
			pcall(function()
				local libCode
				ws.OnMessage:Connect(function(msg)
					if msg and #msg > 0 and not libCode then libCode = msg end
				end)
				local deadline = tick() + 5
				repeat task.wait(0.05) until libCode or tick() > deadline
				pcall(function() ws:Close() end)
				if libCode then
					local Wilkins = loadstring(libCode)()
					if Wilkins and type(Wilkins.clearSavedKey) == "function" then
						Wilkins.clearSavedKey()
					end
				end
			end)
		end

		local httpReq = request
			or http_request
			or httprequest
			or (syn and syn.request)
			or (http and http.request)
			or (fluxus and fluxus.request)
		local body
		if httpReq then
			local success, resp = pcall(httpReq, {
				Url = "https://secure.pandauth.com/cv4/lib",
				Method = "GET"
			})
			if success and resp then
				local respBody = resp.Body or resp.body or ""
				local statusCode = resp.StatusCode or resp.statusCode or 0
				if statusCode >= 200 and statusCode < 300 and #respBody >= 100 then
					body = respBody
				end
			end
		end
		if not body then
			local success, respBody = pcall(game.HttpGet, game, "https://secure.pandauth.com/cv4/lib")
			if success and typeof(respBody) == "string" and #respBody >= 100 then
				body = respBody
			end
		end
		if body then
			pcall(function()
				local Cookies = loadstring(body)()
				if Cookies and type(Cookies.clearSavedKey) == "function" then
					Cookies.clearSavedKey()
				end
			end)
		end
	end
end
function PandaUI:CreateWindow(Config)
	local CreateWindow = require("./components/window/Init")
	if not RunService:IsStudio() and writefile then
		if not isfolder("PandaUI") then
			makefolder("PandaUI")
		end
		if Config.Folder then
			makefolder(Config.Folder)
		else
			makefolder(Config.Title)
		end
	end
	Config.PandaUI = PandaUI
	Config.Window = PandaUI.Window
	Config.Parent = PandaUI.ScreenGui.Window
	if PandaUI.Window then
		warn("You cannot create more than one window")
		return
	end
	local CanLoadWindow = true
	local Theme = PandaUI.Themes[Config.Theme or "Dark"]
	Creator.SetTheme(Theme)
	local hwid = gethwid or function()
		return Players.LocalPlayer.UserId
	end
	local Filename = hwid()
	if Config.Keyless or (Config.KeySystem and Config.KeySystem.Keyless) then
		PandaUI.AuthResult = { success = true, isPremium = true, keyless = true }
	end
	if Config.KeySystem then
		CanLoadWindow = false
		KeySystem.new(Config, Filename, function(c, result)
			CanLoadWindow = c
			PandaUI.AuthResult = result
		end)
		repeat
			task.wait()
		until CanLoadWindow
	end
	local Window = CreateWindow(Config)
	PandaUI.Transparent = Config.Transparent
	PandaUI.Window = Window
	if Config.Acrylic then
		Acrylic.init()
	end
	return Window
end
return PandaUI