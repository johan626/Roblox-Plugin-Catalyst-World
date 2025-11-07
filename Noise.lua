-- Wrapper module to switch between different noise algorithms
local Noise = {}

local PerlinNoise = require(script.Parent:WaitForChild("PerlinNoise"))

local activeAlgorithm = "Default" -- "Default" or "Custom"

function Noise.setAlgorithm(algorithmName)
	if algorithmName == "Custom Perlin" then
		activeAlgorithm = "Custom"
	else
		activeAlgorithm = "Default"
	end
end

function Noise.get(x, y, z)
	if activeAlgorithm == "Custom" then
		return PerlinNoise.noise(x, y, z)
	else
		return math.noise(x, y, z)
	end
end

return Noise
