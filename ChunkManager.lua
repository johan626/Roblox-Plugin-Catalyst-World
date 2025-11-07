-- Module for managing terrain generation in chunks
local ChunkManager = {}

local MAX_CHUNK_SIZE = 256 -- in voxels (256 * 4 = 1024 studs)

--[[
    Divides a large generation task into a list of smaller chunks.
    @param totalWidth The total width of the terrain to generate.
    @param totalDepth The total depth of the terrain to generate.
    @returns A table of chunk tasks, each with an offsetX, offsetZ, width, and depth.
--]]
function ChunkManager.createChunkList(totalWidth, totalDepth)
	local chunks = {}

	local numChunksX = math.ceil(totalWidth / MAX_CHUNK_SIZE)
	local numChunksZ = math.ceil(totalDepth / MAX_CHUNK_SIZE)

	for chunkX = 0, numChunksX - 1 do
		for chunkZ = 0, numChunksZ - 1 do
			local offsetX = chunkX * MAX_CHUNK_SIZE
			local offsetZ = chunkZ * MAX_CHUNK_SIZE

			local chunkWidth = math.min(MAX_CHUNK_SIZE, totalWidth - offsetX)
			local chunkDepth = math.min(MAX_CHUNK_SIZE, totalDepth - offsetZ)

			table.insert(chunks, {
				offsetX = offsetX,
				offsetZ = offsetZ,
				width = chunkWidth,
				depth = chunkDepth
			})
		end
	end

	return chunks
end

return ChunkManager
