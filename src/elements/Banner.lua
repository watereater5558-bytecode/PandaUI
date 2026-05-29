local Creator = require("../modules/Creator")
local New = Creator.New
local Element = {}
function Element:New(Config)
	local BannerType = Config.Type or Config.Variant or "Info"
	local typeColors = {
		Success = Color3.fromHex("#16a34a"),
		Error = Color3.fromHex("#dc2626"),
		Warning = Color3.fromHex("#d97706"),
		Info = Color3.fromHex("#0284c7"),
	}
	local typeIcons = {
		Success = "check-circle",
		Error = "x-circle",
		Warning = "alert-triangle",
		Info = "info",
	}
	Config.Color = Config.Color or typeColors[BannerType] or typeColors.Info
	Config.Image = Config.Image or Config.Icon or typeIcons[BannerType] or typeIcons.Info
	Config.Hover = Config.Hover or false
	Config.Justify = Config.Justify or "Left"
	Config.TextOffset = Config.TextOffset or 0
	Config.ParentConfig = Config
	local BannerModule = {
		__type = "Banner",
		Title = Config.Title or BannerType,
		Desc = Config.Desc or "",
		Locked = Config.Locked or false,
	}
	local BannerFrame = require("../components/window/Element")(Config)
	BannerModule.BannerFrame = BannerFrame
	function BannerModule:SetTitle(title)
		BannerModule.Title = title
		BannerFrame:SetTitle(title)
	end
	function BannerModule:SetDesc(desc)
		BannerModule.Desc = desc
		BannerFrame:SetDesc(desc)
	end
	function BannerModule:Destroy()
		BannerFrame:Destroy()
		BannerModule = nil
	end
	BannerModule.ElementFrame = BannerFrame.UIElements.Main
	return BannerModule.__type, BannerModule
end
return Element