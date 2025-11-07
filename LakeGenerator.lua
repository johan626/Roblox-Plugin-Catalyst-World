-- Module for finding and filling lakes in a heightmap
local LakeGenerator = {}

-- Helper: Simple Priority Queue (Min-Heap) implementation
local PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

function PriorityQueue.new()
	return setmetatable({heap = {}}, PriorityQueue)
end

function PriorityQueue:push(item, priority)
	table.insert(self.heap, {item = item, priority = priority})
	local index = #self.heap
	while index > 1 and self.heap[index].priority < self.heap[math.floor(index/2)].priority do
		self.heap[index], self.heap[math.floor(index/2)] = self.heap[math.floor(index/2)], self.heap[index]
		index = math.floor(index/2)
	end
end

function PriorityQueue:pop()
	if #self.heap == 0 then return nil, nil end

	local top = self.heap[1]
	local last = self.heap[#self.heap]
	if #self.heap > 1 then
		self.heap[1] = last
	end
	table.remove(self.heap)

	local index = 1
	while true do
		local left = 2 * index
		local right = 2 * index + 1
		local smallest = index

		if left <= #self.heap and self.heap[left].priority < self.heap[smallest].priority then
			smallest = left
		end
		if right <= #self.heap and self.heap[right].priority < self.heap[smallest].priority then
			smallest = right
		end

		if smallest ~= index then
			self.heap[index], self.heap[smallest] = self.heap[smallest], self.heap[index]
			index = smallest
		else
			break
		end
	end

	return top.item, top.priority
end

function PriorityQueue:isEmpty()
	return #self.heap == 0
end


--[[
    Identifies basins in the heightmap and fills them with water to create lakes.
    This uses a depression-filling algorithm based on a priority queue flood-fill from the boundaries.
    @param heightmap The 2D heightmap table [x][z].
    @param seaLevel The global sea level, to avoid filling areas already underwater.
    @return The modified heightmap with lakes filled in.
--]]
function LakeGenerator.findAndFillLakes(heightmap, seaLevel)
	print("Starting lake generation...")
	local width = #heightmap
	local depth = #heightmap[1]

	-- 1. Initialize a processed heightmap and a priority queue with boundary cells.
	local processedHeightmap = {}
	for i = 1, width do
		processedHeightmap[i] = table.pack(table.unpack(heightmap[i]))
	end

	local pq = PriorityQueue.new()
	local visited = {}
	for x = 1, width do
		visited[x] = {}
		for z = 1, depth do
			visited[x][z] = false
		end
	end

	-- Add all boundary cells to the queue
	for x = 1, width do
		for z = 1, depth do
			if x == 1 or x == width or z == 1 or z == depth then
				pq:push({x=x, z=z}, heightmap[x][z])
				visited[x][z] = true
			end
		end
	end

	-- 2. Process the heightmap to fill all depressions connected to the map edge.
	-- This creates a "spillway" map where water can flow out.
	while not pq:isEmpty() do
		local cell, height = pq:pop()

		local neighbors = {
			{x = cell.x + 1, z = cell.z}, {x = cell.x - 1, z = cell.z},
			{x = cell.x, z = cell.z + 1}, {x = cell.x, z = cell.z - 1}
		}

		for _, neighbor in ipairs(neighbors) do
			local nx, nz = neighbor.x, neighbor.z
			if nx >= 1 and nx <= width and nz >= 1 and nz <= depth and not visited[nx][nz] then
				visited[nx][nz] = true
				local neighborOriginalHeight = heightmap[nx][nz]
				local spillHeight = math.max(height, neighborOriginalHeight)
				processedHeightmap[nx][nz] = spillHeight
				pq:push({x=nx, z=nz}, spillHeight)
			end
		end
	end

	-- 3. Compare the original map with the processed map.
	-- Any area where the processed map is higher is a basin that should be a lake.
	local lakeCount = 0
	for x = 1, width do
		for z = 1, depth do
			local originalHeight = heightmap[x][z]
			local filledHeight = processedHeightmap[x][z]

			-- If the filled height is greater than the original, it's a depression.
			-- We also check that the resulting lake is above the main sea level.
			if filledHeight > originalHeight and filledHeight > seaLevel then
				heightmap[x][z] = filledHeight
				lakeCount = lakeCount + 1
			end
		end
	end

	if lakeCount > 0 then
		print("Lake generation complete. Filled " .. lakeCount .. " cells to form lakes.")
	else
		print("No suitable basins found for lake generation.")
	end

	return heightmap
end

return LakeGenerator
