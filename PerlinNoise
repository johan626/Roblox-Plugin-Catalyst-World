-- Custom Perlin Noise implementation
local PerlinNoise = {}

local p = {}
for i = 0, 255 do
	p[i] = math.random(0, 255)
end
for i = 0, 255 do
	p[i + 256] = p[i]
end

local function fade(t)
	return t * t * t * (t * (t * 6 - 15) + 10)
end

local function lerp(t, a, b)
	return a + t * (b - a)
end

local function grad(hash, x, y, z)
	local h = bit32.band(hash, 15)
	local u = h < 8 and x or y
	local v = h < 4 and y or (h == 12 or h == 14 and x or z)
	return ((bit32.band(h, 1) == 0) and u or -u) + ((bit32.band(h, 2) == 0) and v or -v)
end

function PerlinNoise.noise(x, y, z)
	x = x or 0
	y = y or 0
	z = z or 0

	local X = math.floor(x)
	local Y = math.floor(y)
	local Z = math.floor(z)

	x = x - X
	y = y - Y
	z = z - Z

	X = bit32.band(X, 255)
	Y = bit32.band(Y, 255)
	Z = bit32.band(Z, 255)

	local u = fade(x)
	local v = fade(y)
	local w = fade(z)

	local A = p[X] + Y
	local AA = p[A] + Z
	local AB = p[A + 1] + Z
	local B = p[X + 1] + Y
	local BA = p[B] + Z
	local BB = p[B + 1] + Z

	local res = lerp(w, lerp(v, lerp(u, grad(p[AA], x, y, z), grad(p[BA], x - 1, y, z)),
		lerp(u, grad(p[AB], x, y - 1, z), grad(p[BB], x - 1, y - 1, z))),
		lerp(v, lerp(u, grad(p[AA + 1], x, y, z - 1), grad(p[BA + 1], x - 1, y, z - 1)),
			lerp(u, grad(p[AB + 1], x, y - 1, z - 1), grad(p[BB + 1], x - 1, y - 1, z - 1))))

	-- Scale to [-0.5, 0.5] to match math.noise
	return res * 0.5
end

return PerlinNoise
