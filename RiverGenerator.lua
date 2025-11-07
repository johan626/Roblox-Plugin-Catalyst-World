-- Module for carving rivers into a heightmap
local RiverGenerator = {}

--[[
    Modifies a heightmap to include river paths.
    @param heightmap The 2D heightmap to modify.
    @param riverCount The number of rivers to generate.
    @param riverDepth The depth of the rivers in studs.
    @returns The modified heightmap.
--]]
function RiverGenerator.carveRivers(heightmap, riverCount, riverDepth)
	local width = #heightmap
	local depth = #heightmap[1]

	for i = 1, riverCount do
		-- Start river at a random high point
		local startX = math.random(1, width)
		local startZ = math.random(1, depth)

		local currentX = startX
		local currentZ = startZ

		local path = {}
		table.insert(path, {x = currentX, z = currentZ})

		-- Carve path downwards for a certain number of steps
		for step = 1, 200 do
			-- Find the lowest neighbor
			local lowestHeight = heightmap[currentX][currentZ]
			local nextX, nextZ = currentX, currentZ

			for dx = -1, 1 do
				for dz = -1, 1 do
					if dx == 0 and dz == 0 then
						-- Skip the current point
					else
						local newX = currentX + dx
						local newZ = currentZ + dz

						if newX >= 1 and newX <= width and newZ >= 1 and newZ <= depth then
							if heightmap[newX][newZ] < lowestHeight then
								lowestHeight = heightmap[newX][newZ]
								nextX, nextZ = newX, newZ
							end
						end
					end
				end
			end

			-- If we are stuck in a local minimum, stop
			if nextX == currentX and nextZ == currentZ then
				break
			end

			currentX, currentZ = nextX, nextZ
			table.insert(path, {x = currentX, z = currentZ})
		end

		-- Carve the river path into the heightmap
		for _, point in ipairs(path) do
			heightmap[point.x][point.z] = heightmap[point.x][point.z] - riverDepth
		end
	end

	return heightmap
end

return RiverGenerator
