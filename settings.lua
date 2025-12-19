data:extend({
    -- Startup settings
    {
        type = "bool-setting",
        name = "nso-mod-compat-mode",
        setting_type = "startup",
        default_value = false,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "nso-remove-items",
        setting_type = "startup",
        default_value = true,
        order = "b"
    }
})