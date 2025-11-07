-- Module for handling terrain generation logic
local TerrainGenerator = {}
local Noise = require(script.Parent:WaitForChild("Noise"))

--[[
    Generates a 2D heightmap using Perlin noise.
    @param width The width of the heightmap.
    @param height The height of the heightmap.
    @param seed The random seed.
    @param frequency The frequency of the noise (how detailed it is).
    @param amplitude The amplitude of the noise (how high the mountains are).
    @param octaves The number of noise layers to combine.
    @param persistence The persistence of the octaves.
    @returns A 2D array representing the heightmap.
--]]
function TerrainGenerator.generateHeightmap(width, height, seed, frequency, amplitude, octaves, persistence, baseType, offsetX, offsetZ, totalWidth, totalHeight)
	local heightmap = {}
	offsetX = offsetX or 0
	offsetZ = offsetZ or 0
	totalWidth = totalWidth or width
	totalHeight = totalHeight or height

	for x = 1, width do
		heightmap[x] = {}
		for z = 1, height do
			local total = 0
			local currentFrequency = frequency
			local currentAmplitude = amplitude
			local maxValue = 0

			local worldX = x + offsetX
			local worldZ = z + offsetZ

			for i = 1, octaves do
				local noiseVal = (Noise.get(
					worldX / totalWidth * currentFrequency + seed,
					worldZ / totalHeight * currentFrequency + seed
					) + 0.5) -- Normalize to 0-1 range
				total = total + noiseVal * currentAmplitude

				maxValue = maxValue + currentAmplitude
				currentAmplitude = currentAmplitude * persistence
				currentFrequency = currentFrequency * 2
			end

			local normalizedTotal = (total / maxValue)

			if baseType == "Mountains" then
				-- Mountains should be sharp
				normalizedTotal = math.pow(normalizedTotal, 2)
			elseif baseType == "Plains" then
				-- Plains should be flat
				normalizedTotal = math.pow(normalizedTotal, 0.5)
			elseif baseType == "Islands" then
				-- Create a radial gradient to form an island
				local centerX = totalWidth / 2
				local centerZ = totalHeight / 2
				local dx = worldX - centerX
				local dz = worldZ - centerZ
				local dist = math.sqrt(dx*dx + dz*dz)

				-- Normalize distance to a 0-1 range
				local maxDist = math.min(centerX, centerZ)
				local normalizedDist = math.clamp(dist / maxDist, 0, 1)

				-- Create a falloff gradient (e.g., inverted parabola)
				local gradient = 1 - (normalizedDist ^ 2)

				-- Apply the gradient to the noise
				normalizedTotal = normalizedTotal * gradient
			elseif baseType == "Canyons" then
				-- Create steep walls and flat bottoms
				normalizedTotal = math.abs(normalizedTotal - 0.5) * 2 -- Remap to 0-1 with valley at 0
				normalizedTotal = 1 - math.pow(1 - normalizedTotal, 4) -- Sharpen the valley walls
				normalizedTotal = 1 - normalizedTotal -- Invert back
			elseif baseType == "Volcanoes" then
				local centerX = totalWidth / 2
				local centerZ = totalHeight / 2
				local dx = worldX - centerX
				local dz = worldZ - centerZ
				local dist = math.sqrt(dx*dx + dz*dz)

				local maxDist = math.min(centerX, centerZ)
				local normalizedDist = math.clamp(dist / maxDist, 0, 1)

				-- Create the main cone shape
				local volcanoShape = 1 - normalizedDist

				-- Carve a crater in the center
				local craterRadius = 0.2
				if normalizedDist < craterRadius then
					volcanoShape = volcanoShape * (normalizedDist / craterRadius)
				end

				-- Combine with Perlin noise for detail
				normalizedTotal = volcanoShape * 0.7 + normalizedTotal * 0.3
			end

			heightmap[x][z] = normalizedTotal * amplitude
		end
	end

	return heightmap
end

function TerrainGenerator.applyTerracing(heightmap, terraceHeight)
	if not terraceHeight or terraceHeight <= 0 then
		return heightmap
	end

	local width = #heightmap
	local depth = #heightmap[1]

	for x = 1, width do
		for z = 1, depth do
			local currentHeight = heightmap[x][z]
			heightmap[x][z] = math.floor(currentHeight / terraceHeight) * terraceHeight
		end
	end

	return heightmap
end

return TerrainGenerator
