-- Module for creating waterfalls on cliffs
local WaterfallGenerator = {}

--[[
    Finds suitable cliffs in the voxel data and carves waterfalls into them.
    A suitable cliff is a steep drop near a potential water source (a lake or high ground).

    @param voxelData The 3D voxel data table [x][y][z].
    @param seaLevel The global sea level.
    @return The modified voxelData.
--]]
function WaterfallGenerator.createWaterfalls(voxelData, seaLevel)
	print("Starting waterfall generation...")
	local width = #voxelData
	local height = #voxelData[1]
	local depth = #voxelData[1][1]

	local potentialCliffs = {}

	-- 1. Detect potential cliffs by finding sheer drops.
	-- We iterate from the top down to find surfaces.
	for x = 2, width - 1 do
		for z = 2, depth - 1 do
			local surfaceY = 0
			for y = height, 1, -1 do
				if voxelData[x][y][z] ~= Enum.Material.Air and voxelData[x][y][z] ~= Enum.Material.Water then
					surfaceY = y
					break
				end
			end

			if surfaceY > 0 then
				-- Check neighbors for a significant drop
				local minNeighborHeight = height
				local neighbors = {{x+1, z}, {x-1, z}, {x, z+1}, {x, z-1}}
				for _, n in ipairs(neighbors) do
					local nx, nz = n[1], n[2]
					local neighborSurfaceY = 0
					for y = height, 1, -1 do
						if voxelData[nx][y][nz] ~= Enum.Material.Air then
							neighborSurfaceY = y
							break
						end
					end
					if neighborSurfaceY < minNeighborHeight then
						minNeighborHeight = neighborSurfaceY
					end
				end

				local cliffHeight = surfaceY - minNeighborHeight
				if cliffHeight > 5 and surfaceY > seaLevel / 4 + 5 then -- Min height of 20 studs, and above sea level
					table.insert(potentialCliffs, {x=x, z=z, y=surfaceY, height=cliffHeight})
				end
			end
		end
	end

	if #potentialCliffs == 0 then
		print("No suitable cliffs found for waterfalls.")
		return voxelData
	end

	-- 2. Select a few cliffs and carve waterfalls.
	-- For simplicity, we'll just create a few waterfalls from the list.
	local waterfallCount = math.min(5, #potentialCliffs)
	local waterfallsCreated = 0

	-- Shuffle the cliffs to get random locations
	for i = #potentialCliffs, 2, -1 do
		local j = math.random(i)
		potentialCliffs[i], potentialCliffs[j] = potentialCliffs[j], potentialCliffs[i]
	end

	for i = 1, #potentialCliffs do
		if waterfallsCreated >= waterfallCount then break end

		local cliff = potentialCliffs[i]

		-- Find the exact drop point
		local dropX, dropZ = cliff.x, cliff.z
		local lowestNeighborY = cliff.y
		local neighbors = {{cliff.x+1, cliff.z}, {cliff.x-1, cliff.z}, {cliff.x, cliff.z+1}, {cliff.x, cliff.z-1}}
		for _, n in ipairs(neighbors) do
			local nx, nz = n[1], n[2]
			local neighborSurfaceY = 0
			for y = height, 1, -1 do
				if voxelData[nx][y][nz] ~= Enum.Material.Air then
					neighborSurfaceY = y
					break
				end
			end
			if neighborSurfaceY < lowestNeighborY then
				lowestNeighborY = neighborSurfaceY
				dropX, dropZ = nx, nz -- The fall is into this neighbor's column
			end
		end

		-- Carve the waterfall
		for y = cliff.y, lowestNeighborY, -1 do
			-- Carve a 1x1 or 2x2 hole for the water
			voxelData[cliff.x][y][cliff.z] = Enum.Material.Water
			voxelData[dropX][y][dropZ] = Enum.Material.Air -- Ensure space to fall into
		end

		-- Create a small splash pool at the bottom
		local poolRadius = 2
		for dx = -poolRadius, poolRadius do
			for dz = -poolRadius, poolRadius do
				local px, pz = dropX + dx, dropZ + dz
				if px > 0 and px <= width and pz > 0 and pz <= depth then
					if (dx^2 + dz^2) < poolRadius^2 then
						voxelData[px][lowestNeighborY][pz] = Enum.Material.Water
					end
				end
			end
		end

		waterfallsCreated = waterfallsCreated + 1
	end

	print("Waterfall generation complete. Created " .. waterfallsCreated .. " waterfalls.")
	return voxelData
end

return WaterfallGenerator
