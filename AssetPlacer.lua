-- Module for placing assets on terrain
local AssetPlacer = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[
    Places assets from a specified folder onto the terrain.
    @param targetTerrain The Terrain object.
    @param region The Region3 where terrain exists.
    @param assetFolderPath The path to the folder in ReplicatedStorage containing the assets.
    @param density The density of assets to place (0 to 1).
    @param allowedMaterials A table of Enum.Material to place assets on.
--]]
function AssetPlacer.placeAssets(targetTerrain, region, assetFolderPath, density, allowedMaterials)
	local assetFolder = ReplicatedStorage:FindFirstChild(assetFolderPath)
	if not assetFolder then
		warn("Asset folder not found:", assetFolderPath)
		return
	end

	local assets = assetFolder:GetChildren()
	if #assets == 0 then
		warn("No assets found in folder:", assetFolderPath)
		return
	end

	local regionMin = region.CFrame.p - (region.Size / 2)
	local regionMax = region.CFrame.p + (region.Size / 2)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = {targetTerrain}

	local numberOfAssetsToPlace = math.floor((region.Size.X / 4) * (region.Size.Z / 4) * density * 0.1) -- Heuristic

	for i = 1, numberOfAssetsToPlace do
		-- Choose a random asset
		local asset = assets[math.random(#assets)]:Clone()

		-- Raycast from a random point above the terrain
		local randomX = math.random(regionMin.X, regionMax.X)
		local randomZ = math.random(regionMin.Z, regionMax.Z)
		local rayOrigin = Vector3.new(randomX, regionMax.Y + 50, randomZ)

		local result = workspace:Raycast(rayOrigin, Vector3.new(0, -500, 0), raycastParams)

		local canPlace = false
		if result then
			for _, material in ipairs(allowedMaterials) do
				if result.Material == material then
					canPlace = true
					break
				end
			end
		end

		if canPlace then
			local assetCFrame = CFrame.new(result.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
			asset:SetPrimaryPartCFrame(assetCFrame)
			asset.Parent = workspace
		else
			asset:Destroy()
		end
	end
end

return AssetPlacer
