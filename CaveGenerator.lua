-- Module for carving caves into a 3D voxel grid
local CaveGenerator = {}
local Noise = require(script.Parent:WaitForChild("Noise"))

--[[
    Carves caves into a solid 3D voxel grid using 3D Perlin noise.
    @param voxelData The 3D table representing the solid terrain voxels.
    @param seed The random seed.
    @param density The threshold for carving (higher means fewer caves).
    @param scale The frequency/scale of the 3D noise.
    @returns The modified 3D voxelData table with caves carved out.
--]]
function CaveGenerator.carveCaves(voxelData, seed, density, scale, offsetX, offsetY, offsetZ)
	local width = #voxelData
	local height = #voxelData[1]
	local depth = #voxelData[1][1]

	offsetX = offsetX or 0
	offsetY = offsetY or 0
	offsetZ = offsetZ or 0

	for x = 1, width do
		for y = 1, height do
			for z = 1, depth do
				-- Only carve caves below the original surface
				if voxelData[x][y][z] == Enum.Material.Rock then
					local worldX = x + offsetX
					local worldY = y + offsetY
					local worldZ = z + offsetZ

					local noiseVal = Noise.get(
						worldX / scale + seed,
						worldY / scale + seed,
						worldZ / scale + seed
					)

					if noiseVal > (density / 10) then
						voxelData[x][y][z] = Enum.Material.Air
					end
				end
			end
		end
	end

	return voxelData
end

return CaveGenerator
