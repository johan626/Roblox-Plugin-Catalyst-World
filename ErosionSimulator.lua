-- Module for simulating hydraulic erosion on a heightmap
local ErosionSimulator = {}

function ErosionSimulator.calculateHeightAndGradient(heightmap, width, depth, posX, posY)
	local x = math.floor(posX)
	local y = math.floor(posY)
	local u = posX - x
	local v = posY - y

	-- Bilinear interpolation for height
	local h1 = heightmap[x][y]
	local h2 = heightmap[x+1][y]
	local h3 = heightmap[x][y+1]
	local h4 = heightmap[x+1][y+1]

	local height = (h1 * (1-u) + h2 * u) * (1-v) + (h3 * (1-u) + h4 * u) * v

	local gradientX = (h2 - h1) * (1 - v) + (h4 - h3) * v
	local gradientY = (h3 - h1) * (1 - u) + (h4 - h2) * u

	return {height = height, gradientX = gradientX, gradientY = gradientY}
end

function ErosionSimulator.depositSediment(heightmap, posX, posY, amount)
	local x = math.floor(posX)
	local y = math.floor(posY)
	local u = posX - x
	local v = posY - y

	heightmap[x][y] = heightmap[x][y] + amount * (1-u) * (1-v)
	heightmap[x+1][y] = heightmap[x+1][y] + amount * u * (1-v)
	heightmap[x][y+1] = heightmap[x][y+1] + amount * (1-u) * v
	heightmap[x+1][y+1] = heightmap[x+1][y+1] + amount * u * v
end

function ErosionSimulator.erode(heightmap, posX, posY, amount, u, v)
	local x = math.floor(posX)
	local y = math.floor(posY)

	heightmap[x][y] = heightmap[x][y] - amount * (1-u) * (1-v)
	heightmap[x+1][y] = heightmap[x+1][y] - amount * u * (1-v)
	heightmap[x][y+1] = heightmap[x][y+1] - amount * (1-u) * v
	heightmap[x+1][y+1] = heightmap[x+1][y+1] - amount * u * v
end

function ErosionSimulator.simulate(heightmap, iterations)
	local width = #heightmap
	local depth = #heightmap[1]

	if width < 4 or depth < 4 then
		warn("Terrain is too small for erosion simulation. Minimum size is 4x4.")
		return heightmap
	end

	local inertia = 0.05
	local sedimentCapacityFactor = 4
	local minSedimentCapacity = 0.01
	local erodeSpeed = 0.3
	local depositSpeed = 0.3
	local evaporateSpeed = 0.01
	local gravity = 4
	local maxDropletLifetime = 30

	for i = 1, iterations do
		local posX = 1 + math.random() * (width - 3)
		local posY = 1 + math.random() * (depth - 3)
		local dirX, dirY = 0, 0
		local speed = 1
		local water = 1
		local sediment = 0

		for lifetime = 1, maxDropletLifetime do
			local oldX, oldY = math.floor(posX), math.floor(posY)
			local u = posX - oldX
			local v = posY - oldY

			local heightAndGradient = ErosionSimulator.calculateHeightAndGradient(heightmap, width, depth, posX, posY)
			local height = heightAndGradient.height
			local gradientX = heightAndGradient.gradientX
			local gradientY = heightAndGradient.gradientY

			dirX = (dirX * inertia - gradientX * (1 - inertia))
			dirY = (dirY * inertia - gradientY * (1 - inertia))

			local len = math.sqrt(dirX * dirX + dirY * dirY)
			if len > 0 then
				dirX = dirX / len
				dirY = dirY / len
			end

			local newPosX = posX + dirX
			local newPosY = posY + dirY

			if newPosX < 1 or newPosX >= width - 1 or newPosY < 1 or newPosY >= depth - 1 then
				break
			end

			posX = newPosX
			posY = newPosY

			local newHeight = ErosionSimulator.calculateHeightAndGradient(heightmap, width, depth, posX, posY).height
			local deltaHeight = newHeight - height

			local sedimentCapacity = math.max(-deltaHeight * speed * water * sedimentCapacityFactor, minSedimentCapacity)

			if sediment > sedimentCapacity or deltaHeight > 0 then
				local amountToDeposit = (deltaHeight > 0) and math.min(sediment, deltaHeight) or (sediment - sedimentCapacity) * depositSpeed
				sediment = sediment - amountToDeposit
				ErosionSimulator.depositSediment(heightmap, posX, posY, amountToDeposit)
			else
				local amountToErode = math.min((sedimentCapacity - sediment) * erodeSpeed, -deltaHeight)
				sediment = sediment + amountToErode
				ErosionSimulator.erode(heightmap, posX, posY, amountToErode, u, v)
			end

			speed = math.sqrt(math.max(0, speed * speed + deltaHeight * gravity))
			water = water * (1 - evaporateSpeed)
		end
	end

	return heightmap
end

return ErosionSimulator
