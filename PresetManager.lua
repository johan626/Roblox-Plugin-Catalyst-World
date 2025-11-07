-- Module to manage saving and loading of user-defined settings presets
local PresetManager = {}

local SETTINGS_KEY = "GeoCraft_SettingsPresets"
local pluginInstance = nil

--[[
    Initializes the manager with the plugin instance.
    @param plugin The main plugin object.
--]]
function PresetManager.initialize(plugin)
	pluginInstance = plugin
end

--[[
    Saves a preset object under a given name.
    @param name The name of the preset.
    @param settings The table of settings to save.
--]]
function PresetManager.savePreset(name, settings)
	if not pluginInstance or not name or not settings then return end

	local allPresets = pluginInstance:GetSetting(SETTINGS_KEY) or {}
	allPresets[name] = settings

	pluginInstance:SetSetting(SETTINGS_KEY, allPresets)
	print("Preset '" .. name .. "' saved.")
end

--[[
    Loads a preset by its name.
    @param name The name of the preset to load.
    @return The settings table, or nil if not found.
--]]
function PresetManager.loadPreset(name)
	if not pluginInstance or not name then return nil end

	local allPresets = pluginInstance:GetSetting(SETTINGS_KEY) or {}
	return allPresets[name]
end

--[[
    Deletes a preset by its name.
    @param name The name of the preset to delete.
--]]
function PresetManager.deletePreset(name)
	if not pluginInstance or not name then return end

	local allPresets = pluginInstance:GetSetting(SETTINGS_KEY) or {}
	allPresets[name] = nil

	pluginInstance:SetSetting(SETTINGS_KEY, allPresets)
	print("Preset '" .. name .. "' deleted.")
end

--[[
    Gets a list of all saved preset names.
    @return A sorted list of preset names.
--]]
function PresetManager.getPresetNames()
	if not pluginInstance then return {} end

	local allPresets = pluginInstance:GetSetting(SETTINGS_KEY) or {}
	local names = {}
	for name, _ in pairs(allPresets) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

return PresetManager
