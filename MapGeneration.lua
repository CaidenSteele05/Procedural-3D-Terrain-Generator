local BlockSize = 4
local ChunkSize = 20
local Noise_Intensity = 25
local PlayerRadius = 5

local Generated_Chunks = {}


local function Create_Block(size,y,biome)
	local texture = game:GetService("ReplicatedStorage").Texture:Clone()
	local part = Instance.new("Part")
	part.Anchored = true
	part.Size = Vector3.new(size,100,size)
	part.TopSurface = Enum.SurfaceType.Smooth
	
	if biome <0.25 then
		part.Color = Color3.fromHSV(1,1,math.clamp(y+0.5,0.4,1))
	elseif biome <0.5 then
		part.Color = Color3.fromHSV(0.25,1,math.clamp(y+0.5,0.4,1))
	elseif biome <0.75 then
		part.Color = Color3.fromHSV(0.5,1,math.clamp(y+0.5,0.4,1))
	else
		part.Color = Color3.fromHSV(0.75,1,math.clamp(y+0.5,0.4,1))
	end
		
	if math.abs(y) <0.08 then
		part.Color = Color3.fromHSV(0.668,1,math.clamp(y+0.5,0,1))
	end

	texture.Parent = part
	part.Parent = game.Workspace
	return part
end



local function Generate_Block(x,z)
	local y = math.noise(x/20,1,z/20)
	local biome = math.noise(x/150,1,z/150)+0.5
	
	local block = Create_Block(BlockSize,y,biome)
	
	if math.abs(y) < 0.08 then
		y-=0.7
	end
	block.Position = Vector3.new(x*BlockSize,y*Noise_Intensity,z*BlockSize)
	return block
end


local function Generate_Chunk(Chunk_x,Chunk_z)
	wait()
	local Chunk_Length = ChunkSize
	local blocks = {}
	for x = 1, ChunkSize do
		for z = 1, ChunkSize do
			local block = Generate_Block(x+Chunk_x*Chunk_Length,z+Chunk_z*Chunk_Length)
			table.insert(blocks,block)
		end
	end
	Generated_Chunks[Chunk_x..Chunk_z] = {Chunk_x,Chunk_z,blocks}
end

local function Delete_Chunk(Chunk_x,Chunk_z)
	wait()
	for i,v in pairs(Generated_Chunks[Chunk_x..Chunk_z][3]) do
		v:Destroy()
	end
	Generated_Chunks[Chunk_x..Chunk_z] = nil
end


for x = -1,1 do
	wait()
	for z = -1,1 do
		Generate_Chunk(x,z)
	end
end

while wait(0.2) do
	local v = game.Players.LocalPlayer
	if v.Character and v.Character.PrimaryPart then
		local pos = v.Character.PrimaryPart.Position
		local pos_x = math.floor(pos.X/BlockSize/ChunkSize)
		local pos_z = math.floor(pos.Z/BlockSize/ChunkSize)
		for x = -PlayerRadius, PlayerRadius do
			for z = -PlayerRadius, PlayerRadius do
				if not Generated_Chunks[pos_x+x..pos_z+z] then
					Generate_Chunk(pos_x+x,pos_z+z)
				else
					for i,v in pairs(Generated_Chunks) do
						if (v[1] <pos_x - PlayerRadius or v[1] >pos_x+PlayerRadius) or (v[2] <pos_z - PlayerRadius or v[2] >pos_z+PlayerRadius) then
							Delete_Chunk(v[1],v[2])
						end
					end
				end
			end
		end
	end
end
