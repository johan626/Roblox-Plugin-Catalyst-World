-- Module for writing voxel data to terrain
local VoxelWriter = {}

--[[
    Writes a 3D voxel grid to the workspace terrain.
    @param targetTerrain The Terrain object to write to.
    @param voxelData The 3D table representing the terrain voxels [x][y][z].
    @param position The bottom-front-left corner of the region to write.
--]]
function VoxelWriter.writeVoxels(targetTerrain, voxelData, position, seaLevel)
	local width = #voxelData
	if width == 0 then return end
	local height = #voxelData[1]
	if height == 0 then return end
	local depth = #voxelData[1][1]
	if depth == 0 then return end

	-- Create the initial region based on desired dimensions
	local initialRegion = Region3.new(
		position,
		position + Vector3.new(width * 4, height * 4, depth * 4)
	)

	-- Expand the region to align with the 4x4x4 voxel grid
	local expandedRegion = initialRegion:ExpandToGrid(4)

	local expandedRegionMin = expandedRegion.CFrame.p - (expandedRegion.Size / 2)
	local offset = (position - expandedRegionMin) / 4
	local offsetX = math.round(offset.X)
	local offsetY = math.round(offset.Y)
	local offsetZ = math.round(offset.Z)

	local regionSize = expandedRegion.Size / 4
	local regionWidth = regionSize.X
	local regionHeight = regionSize.Y
	local regionDepth = regionSize.Z

	local materials = {}
	local occupancies = {}

	for z = 1, regionDepth do
		materials[z] = {}
		occupancies[z] = {}
		for y = 1, regionHeight do
			materials[z][y] = {}
			occupancies[z][y] = {}
			for x = 1, regionWidth do
				local dataX = x - offsetX
				local dataY = y - offsetY
				local dataZ = z - offsetZ

				local material = Enum.Material.Air
				local occupancy = 0

				if dataX >= 1 and dataX <= width and
					dataY >= 1 and dataY <= height and
					dataZ >= 1 and dataZ <= depth then

					local sourceMaterial = voxelData[dataX][dataY][dataZ]
					if sourceMaterial ~= Enum.Material.Air then
						material = sourceMaterial
						occupancy = 1
					end
				end

				materials[z][y][x] = material
				occupancies[z][y][x] = occupancy
			end
		end
	end

	local success, err = pcall(function()
		targetTerrain:WriteVoxels(expandedRegion, 4, materials, occupancies)
	end)

	if not success then
		warn("Failed to write voxels:", err)
		return nil, nil
	end

	return expandedRegion, position.Y + seaLevel
end

return VoxelWriter
