local PandaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/watereater5558-bytecode/PandaUI/main/Main.lua?t=" .. os.time()))()

local Window = PandaUI:CreateWindow({
	Title = "PandaUI Full Demo",
	Theme = "Dark",
	Acrylic = true,
	KeySystem = {
		ServiceId = "your-service-id", -- Get this from your PandaAuth Dashboard
		Title = "Panda Validation",
		Note = "Get key via link in get key section.",
		SaveKey = true,
		Keyless = false,
	}
})

local auth = PandaUI.AuthResult
local userTier = "Free User"
if auth and auth.isPremium then
	userTier = "Premium VIP User"
end

PandaUI:Notify({
	Title = "Welcome!",
	Content = "Authenticated as: " .. userTier,
	Duration = 5,
	Icon = "shield-check"
})

local Tab1 = Window:Tab({ Title = "Dashboard", Icon = "home" })
local Section1 = Tab1:Section({ Title = "Authentication Information" })

Section1:Paragraph({
	Title = "License Tier: " .. userTier,
	Desc = "Your current authentication status."
})

if auth and auth.isPremium then
	Section1:Paragraph({
		Title = "Premium Active",
		Desc = "Thanks for supporting us with premium!"
	})
end

Section1:Button({
	Title = "Reset Saved License Key",
	Callback = function()
		PandaUI:ClearSavedKey()
		PandaUI:Notify({
			Title = "Key System",
			Content = "Saved key cleared. Restart to re-verify.",
			Duration = 3,
			Icon = "trash"
		})
	end
})

local Tab2 = Window:Tab({ Title = "UI Elements", Icon = "layout" })
local Section2 = Tab2:Section({ Title = "Basic Elements" })

local button = Section2:Button({
	Title = "Click Me",
	Tooltip = "This displays a popup notification when clicked.",
	Callback = function()
		PandaUI:Notify({
			Title = "Button Clicked",
			Content = "You clicked the demo button!",
			Duration = 2,
			Icon = "smile"
		})
	end
})

Section2:Toggle({
	Title = "Auto Loot",
	Type = "Checkbox",
	Default = false,
	Callback = function(val)
		PandaUI:Notify({
			Title = "Checkbox Toggled",
			Content = "Value is now: " .. tostring(val),
			Duration = 2
		})
	end
})

Section2:Toggle({
	Title = "Kill Aura",
	Default = false,
	Callback = function(val)
		PandaUI:Notify({
			Title = "Toggle Fired",
			Content = "Kill aura state: " .. tostring(val),
			Duration = 2
		})
	end
})

Section2:Dropdown({
	Title = "Choose Teleport Location",
	Multi = false,
	Values = { "Spawn", "Lobby", "Arena", "Shop" },
	Default = "Spawn",
	Callback = function(selected)
		PandaUI:Notify({
			Title = "Dropdown Choice",
			Content = "Selected: " .. selected,
			Duration = 2
		})
	end
})

Section2:Input({
	Title = "WalkSpeed Multiplier",
	Placeholder = "Enter speed (e.g. 50)",
	Callback = function(text)
		PandaUI:Notify({
			Title = "Input Submitted",
			Content = "New speed limit: " .. text,
			Duration = 2
		})
	end
})

Section2:Code({
	Content = "local plr = game.Players.LocalPlayer\nprint(plr.Name)",
	ReadOnly = true
})

local Tab3 = Window:Tab({ Title = "Themes & Dialogs", Icon = "palette" })
local Section3 = Tab3:Section({ Title = "Aesthetic Styles" })

Section3:Button({
	Title = "Set Theme: Sky",
	Callback = function()
		PandaUI:SetTheme("Sky")
	end
})

Section3:Button({
	Title = "Set Theme: Dracula",
	Callback = function()
		PandaUI:SetTheme("Dracula")
	end
})

Section3:Button({
	Title = "Trigger Confirmation Dialog",
	Callback = function()
		PandaUI:Popup({
			Title = "Critical Choice",
			Content = "Do you wish to activate dangerous exploits?",
			Buttons = {
				{
					Title = "Agree",
					Icon = "check",
					Variant = "Primary",
					Callback = function()
						print("Agreed")
					end
				},
				{
					Title = "Cancel",
					Icon = "x",
					Variant = "Secondary",
					Callback = function()
						print("Cancelled")
					end
				}
			}
		})
	end
})
