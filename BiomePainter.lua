-- Module for painting biomes onto existing terrain using a preset-based system.
local BiomePainter = {}
local Noise = require(script.Parent:WaitForChild("Noise"))

-- Helper function to get surface height at a specific coordinate
local function getSurfaceHeight(x, z, sizeX, sizeZ, sizeY, occupancies)
	if x < 1 or x > sizeX or z < 1 or z > sizeZ then
		return -1 -- Outside bounds
	end
	for y = sizeY, 1, -1 do
		if occupancies[z][y][x] > 0.5 then
			return y * 4
		end
	end
	return -1
end

-- Internal function to blend materials at biome borders
local function blendBorders(materials, sizeX, sizeZ, sizeY, occupancies, blendIntensity)
	local originalMaterials = {}
	for z = 1, sizeZ do
		originalMaterials[z] = {}
		for y = 1, sizeY do
			originalMaterials[z][y] = {}
			for x = 1, sizeX do
				originalMaterials[z][y][x] = materials[z][y][x]
			end
		end
	end

	local blendFrequency = 3
	local blendThreshold = 0.5 + (blendIntensity * 0.2) -- Intensity from 0-1 maps to threshold 0.5-0.7

	for z = 1, sizeZ do
		for x = 1, sizeX do
			local surfaceY = 0
			for y = sizeY, 1, -1 do
				if occupancies[z][y][x] > 0.5 and originalMaterials[z][y][x] ~= Enum.Material.Water then
					surfaceY = y
					break
				end
			end

			if surfaceY > 0 then
				local currentMaterial = originalMaterials[z][surfaceY][x]
				local neighborMaterial = nil

				local neighbors = {{x+1, z}, {x-1, z}, {x, z+1}, {x, z-1}}
				for _, n in ipairs(neighbors) do
					local nx, nz = n[1], n[2]
					if nx >= 1 and nx <= sizeX and nz >= 1 and nz <= sizeZ then
						local neighborSurfaceY = 0
						for y = sizeY, 1, -1 do
							if occupancies[nz][y][nx] > 0.5 and originalMaterials[nz][y][nx] ~= Enum.Material.Water then
								neighborSurfaceY = y
								break
							end
						end
						if neighborSurfaceY > 0 and originalMaterials[nz][neighborSurfaceY][nx] ~= currentMaterial then
							neighborMaterial = originalMaterials[nz][neighborSurfaceY][nx]
							break
						end
					end
				end

				if neighborMaterial then
					local noiseVal = Noise.get(x / 25 * blendFrequency, z / 25 * blendFrequency, 99)
					if noiseVal > blendThreshold then
						materials[z][surfaceY][x] = neighborMaterial
					end
				end
			end
		end
	end
	return materials
end

--[[
    Paints biome materials onto a terrain region based on a biome preset object.
    @param targetTerrain The Terrain object to modify.
    @param region The Region3 of the terrain to paint.
    @param seaLevelY The current sea level Y coordinate in studs.
    @param biomePreset An object containing the rules for painting.
    @param temperatureMap The global temperature map.
    @param humidityMap The global humidity map.
    @param chunkOffsetX The X offset of the current chunk.
    @param chunkOffsetZ The Z offset of the current chunk.
    @param shouldBlend Whether to apply the blending algorithm.
    @param blendIntensity The intensity of the blending effect.
--]]
function BiomePainter.paintBiomes(targetTerrain, region, seaLevelY, biomePreset, temperatureMap, humidityMap, chunkOffsetX, chunkOffsetZ, shouldBlend, blendIntensity)
	-- Read the existing terrain data for the specified region
	local materials, occupancies = targetTerrain:ReadVoxels(region, 4)

	local size = region.Size / 4
	local sizeX, sizeY, sizeZ = math.ceil(size.X), math.ceil(size.Y), math.ceil(size.Z)

	local regionMin = region.CFrame.p - (region.Size / 2)

	-- Create a lookup table for water voxels for faster neighbor checks
	local waterLocations = {}
	for z = 1, sizeZ do
		waterLocations[z] = {}
		for x = 1, sizeX do
			waterLocations[z][x] = false
			for y = 1, sizeY do
				if materials[z][y][x] == Enum.Material.Water then
					waterLocations[z][x] = true
					break
				end
			end
		end
	end

	-- Iterate through each voxel column to find the surface and paint it
	for z = 1, sizeZ do
		for x = 1, sizeX do
			local surfaceY = 0

			-- Find the highest solid voxel (the surface) in this column
			for y = sizeY, 1, -1 do
				if occupancies[z][y][x] > 0.5 and materials[z][y][x] ~= Enum.Material.Water then
					surfaceY = y
					break
				end
			end

			if surfaceY > 0 then
				local voxelWorldY = regionMin.Y + (surfaceY - 1) * 4

				-- Calculate surface steepness (slope)
				local hL = getSurfaceHeight(x - 1, z, sizeX, sizeZ, sizeY, occupancies)
				local hR = getSurfaceHeight(x + 1, z, sizeX, sizeZ, sizeY, occupancies)
				local hD = getSurfaceHeight(x, z - 1, sizeX, sizeZ, sizeY, occupancies)
				local hU = getSurfaceHeight(x, z + 1, sizeX, sizeZ, sizeY, occupancies)

				local normal = Vector3.new(hL - hR, 8, hD - hU).Unit
				local steepness = math.deg(math.acos(normal:Dot(Vector3.yAxis)))

				-- Get climate data for the current world coordinate
				local worldX = chunkOffsetX + x
				local worldZ = chunkOffsetZ + z
				local temperature = temperatureMap[worldX] and temperatureMap[worldX][worldZ] or 50 -- Default to 50 if out of bounds
				local humidity = humidityMap[worldX] and humidityMap[worldX][worldZ] or 50

				-- Apply biome rules from the preset
				local materialToApply = biomePreset.baseMaterial

				for _, rule in ipairs(biomePreset.rules) do
					local conditionsMet = true
					if rule.maxAltitude and voxelWorldY > rule.maxAltitude then conditionsMet = false end
					if rule.minAltitude and voxelWorldY < rule.minAltitude then conditionsMet = false end
					if rule.maxSteepness and steepness > rule.maxSteepness then conditionsMet = false end
					if rule.minSteepness and steepness < rule.minSteepness then conditionsMet = false end
					if rule.maxTemperature and temperature > rule.maxTemperature then conditionsMet = false end
					if rule.minTemperature and temperature < rule.minTemperature then conditionsMet = false end
					if rule.maxHumidity and humidity > rule.maxHumidity then conditionsMet = false end
					if rule.minHumidity and humidity < rule.minHumidity then conditionsMet = false end

					if rule.nearWater and not waterLocations[z][x] then
						local isNearWater = false
						local checkRadius = math.ceil((rule.nearWater.maxDistance or 10) / 4)
						for dz = -checkRadius, checkRadius do
							for dx = -checkRadius, checkRadius do
								local checkX, checkZ = x + dx, z + dz
								if checkX >= 1 and checkX <= sizeX and checkZ >= 1 and checkZ <= sizeZ then
									if waterLocations[checkZ][checkX] then
										isNearWater = true
										break
									end
								end
							end
							if isNearWater then break end
						end
						if not isNearWater then conditionsMet = false end
					end

					if conditionsMet then
						materialToApply = rule.material
						break -- Apply the first rule that matches and stop.
					end
				end

				materials[z][surfaceY][x] = materialToApply
			end
		end
	end

	-- Apply blending if enabled
	if shouldBlend then
		materials = blendBorders(materials, sizeX, sizeZ, sizeY, occupancies, blendIntensity)
	end

	-- Write only the modified materials back to the terrain
	targetTerrain:WriteVoxels(region, 4, materials, occupancies)
end

return BiomePainter
