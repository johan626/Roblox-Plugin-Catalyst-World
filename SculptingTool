-- Module to handle real-time terrain sculpting
local SculptingTool = {}

local HistoryManager = require(script.Parent:WaitForChild("HistoryManager"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local toolActive = false
local currentSettings = {
	targetTerrain = nil,
	mode = "Raise", -- "Raise", "Lower", "Erode", or "Plant"
	brushSize = 20,
	brushStrength = 5,
	erosionDroplets = 5000,
	assetFolderPath = "GeoCraftAssets",
	allowedMaterials = {Enum.Material.Grass}
}
local brushVisualizer = nil
local pluginInstance = nil

-- Function to create the brush visualizer part
local function createVisualizer()
	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(0, 255, 255)
	part.Transparency = 0.7
	part.Anchored = true
	part.CanCollide = false
	part.Locked = true
	part.Size = Vector3.new(1, 1, 1) -- Will be resized
	part.Parent = workspace
	return part
end

-- Activates the sculpting tool
function SculptingTool.activate(plugin)
	if toolActive then return end
	print("Sculpting tool activated.")
	toolActive = true
	pluginInstance = plugin

	if not brushVisualizer then
		brushVisualizer = createVisualizer()
	end
	brushVisualizer.Parent = workspace
end

-- Deactivates the sculpting tool
function SculptingTool.deactivate()
	if not toolActive then return end
	print("Sculpting tool deactivated.")
	toolActive = false
	pluginInstance = nil

	if brushVisualizer then
		brushVisualizer.Parent = nil
	end
end

-- Updates the tool's settings from the UI
function SculptingTool.updateSettings(settings)
	for key, value in pairs(settings) do
		currentSettings[key] = value
	end
end

-- Called when the mouse moves to update the brush visualizer
function SculptingTool.updateBrush(mouseRay)
	if not toolActive or not brushVisualizer or not currentSettings.targetTerrain then return end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = {currentSettings.targetTerrain}

	local result = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)

	if result then
		brushVisualizer.Position = result.Position
		brushVisualizer.Size = Vector3.new(currentSettings.brushSize, currentSettings.brushSize, currentSettings.brushSize)
		brushVisualizer.Parent = workspace -- Ensure it's visible
	else
		brushVisualizer.Parent = nil -- Hide if not pointing at terrain
	end
end

-- Internal function for the erosion brush simulation
local function applyErosion(materials, occupancies, regionSize)
	-- 1. Create a local heightmap from the occupancy data
	local localHeightmap = {}
	for x = 1, regionSize.X do
		localHeightmap[x] = {}
		for z = 1, regionSize.Z do
			local surfaceY = 0
			for y = regionSize.Y, 1, -1 do
				if occupancies[z][y][x] > 0 then
					surfaceY = y + (occupancies[z][y][x] - 0.5)
					break
				end
			end
			localHeightmap[x][z] = surfaceY
		end
	end

	-- 2. Run a simplified erosion simulation
	local droplets = currentSettings.erosionDroplets
	for i = 1, droplets do
		local posX = math.random(1, regionSize.X)
		local posZ = math.random(1, regionSize.Z)

		local sediment = 0
		local speed = 1
		local water = 1

		for lifetime = 1, 10 do -- Short lifetime for real-time performance
			local x0, z0 = math.floor(posX), math.floor(posZ)
			if x0 < 1 or x0 >= regionSize.X or z0 < 1 or z0 >= regionSize.Z then break end

			-- Simplified gradient calculation
			local h0 = localHeightmap[x0][z0]
			local hx = localHeightmap[x0+1][z0]
			local hz = localHeightmap[x0][z0+1]
			local gx, gz = hx - h0, hz - h0

			-- Move droplet
			posX = posX - gx
			posZ = posZ - gz

			-- Erode/deposit
			local newX, newZ = math.floor(posX), math.floor(posZ)
			if newX < 1 or newX >= regionSize.X or newZ < 1 or newZ >= regionSize.Z then break end

			local newH = localHeightmap[newX][newZ]
			local deltaH = h0 - newH

			local capacity = math.max(0, deltaH * speed * water * 4) -- sediment capacity

			if sediment > capacity then
				-- Deposit
				local amount = (sediment - capacity) * 0.5
				localHeightmap[x0][z0] = localHeightmap[x0][z0] + amount
				sediment = sediment - amount
			else
				-- Erode
				local amount = math.min((capacity - sediment) * 0.5, localHeightmap[x0][z0] * 0.1)
				localHeightmap[x0][z0] = localHeightmap[x0][z0] - amount
				sediment = sediment + amount
			end
		end
	end

	-- 3. Convert modified heightmap back to occupancy
	for x = 1, regionSize.X do
		for z = 1, regionSize.Z do
			local newHeight = localHeightmap[x][z]
			for y = 1, regionSize.Y do
				local voxelBottom = y - 0.5
				local voxelTop = y + 0.5
				if newHeight > voxelTop then
					occupancies[z][y][x] = 1
				elseif newHeight > voxelBottom then
					occupancies[z][y][x] = (newHeight - voxelBottom)
				else
					occupancies[z][y][x] = 0
				end
			end
		end
	end

	return materials, occupancies
end

-- Internal function for the asset planting brush
local function applyPlanting(center)
	local assetFolder = ReplicatedStorage:FindFirstChild(currentSettings.assetFolderPath)
	if not assetFolder then
		warn("Asset folder not found:", currentSettings.assetFolderPath)
		return
	end

	local assets = assetFolder:GetChildren()
	if #assets == 0 then return end

	local density = currentSettings.brushStrength -- Reuse strength as density
	local assetsToPlace = math.ceil((currentSettings.brushSize / 10)^2 * (density / 10))

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = {currentSettings.targetTerrain}

	for i = 1, assetsToPlace do
		local asset = assets[math.random(#assets)]:Clone()

		local randomAngle = math.random() * 2 * math.pi
		local randomDist = math.random() * (currentSettings.brushSize / 2)
		local randomX = center.X + math.cos(randomAngle) * randomDist
		local randomZ = center.Z + math.sin(randomAngle) * randomDist

		local rayOrigin = Vector3.new(randomX, center.Y + 100, randomZ)
		local result = workspace:Raycast(rayOrigin, Vector3.new(0, -200, 0), raycastParams)

		local canPlace = false
		if result then
			for _, material in ipairs(currentSettings.allowedMaterials) do
				if result.Material == material then
					canPlace = true
					break
				end
			end
		end

		if canPlace then
			asset:SetPrimaryPartCFrame(CFrame.new(result.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0))
			asset.Parent = workspace
		else
			asset:Destroy()
		end
	end
end


-- Called when the mouse is clicked to apply the brush effect
function SculptingTool.applyBrush(mouseRay)
	if not toolActive or not currentSettings.targetTerrain then return end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = {currentSettings.targetTerrain}

	local result = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)
	if not result then return end

	if currentSettings.mode == "Plant" then
		applyPlanting(result.Position)
		return -- Planting mode doesn't modify voxels directly
	end

	local center = result.Position
	local size = Vector3.new(currentSettings.brushSize, currentSettings.brushSize, currentSettings.brushSize)

	local region = Region3.new(center - size/2, center + size/2):ExpandToGrid(4)

	if region.Size.X > 512 or region.Size.Y > 512 or region.Size.Z > 512 then
		warn("Brush size is too large for a single operation. Try a smaller size.")
		return
	end

	local materials, occupancies = currentSettings.targetTerrain:ReadVoxels(region, 4)
	local regionSize = region.Size / 4

	if currentSettings.mode == "Erode" then
		materials, occupancies = applyErosion(materials, occupancies, regionSize)
	else -- Raise or Lower
		local regionCenterInVoxels = regionSize / 2
		local strength = currentSettings.mode == "Raise" and (currentSettings.brushStrength / 100) or (-currentSettings.brushStrength / 100)

		for x = 1, regionSize.X do
			for y = 1, regionSize.Y do
				for z = 1, regionSize.Z do
					local posInRegion = Vector3.new(x, y, z)
					local distance = (posInRegion - regionCenterInVoxels).Magnitude
					local radius = currentSettings.brushSize / 8 -- Voxel radius

					if distance < radius then
						local falloff = 1 - (distance / radius)^2 -- Smooth falloff
						local currentOccupancy = occupancies[z][y][x]
						local newOccupancy = math.clamp(currentOccupancy + (strength * falloff), 0, 1)
						occupancies[z][y][x] = newOccupancy
					end
				end
			end
		end
	end

	HistoryManager.recordAction(currentSettings.targetTerrain, region)
	currentSettings.targetTerrain:WriteVoxels(region, 4, materials, occupancies)
end

return SculptingTool
