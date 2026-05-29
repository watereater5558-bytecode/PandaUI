local Localization = {}
function Localization:New(LocalizationConfig, Creator)
    local LocalizationModule = {
        Enabled = LocalizationConfig.Enabled or false,
        Translations = LocalizationConfig.Translations or {},
        Prefix = LocalizationConfig.Prefix or "loc:",
        DefaultLanguage = LocalizationConfig.DefaultLanguage or "en"
    }
    Creator.Localization = LocalizationModule
    return LocalizationModule
end
return Localization