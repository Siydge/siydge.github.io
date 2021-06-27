-- Typical Colors 2 Pickup/Item ESP v0.1
-- Still in Early Development, since I lost half the code.
local on = true local off = false
local config = {
	itemesp = {
		enabled = on,
		rainbow = on,
		color = {255,255,255},
		outline = off,
		tracers = off,
		name = on,
	}
}

local game = dx9.GetDatamodel()
local workspace = dx9.FindFirstChild(game,"Workspace")
local map = dx9.FindFirstChild(workspace,"Map")

if config.itemesp.enabled == true then
	local items = dx9.GetChildren(dx9.FindFirstChild(map,"Items"))
	for i,v in pairs(items) do
		local pos = dx9.GetPosition(v)
		local w2s = dx9.WorldToScreen({pos.x,pos.y,pos.z})
		if w2s.x > 1 or w2s.y > 1 then
			local offset = dx9.WorldToScreen({pos.x,pos.y-2,pos.z})
			local size = ((offset.y-w2s.y)/10)
			local col = config.itemesp.color
			if config.itemesp.rainbow == true then
				local siner = (math.sin((os.clock()+1)*4)+1)/2
				local sineg = (math.sin((os.clock()+2)*4)+1)/2
				local sineb = (math.sin((os.clock()+3)*4)+1)/2
				col = {siner*255,sineg*255,sineb*255}
			end
			if config.itemesp.tracers == true then
				local centerx = dx9.size().width/2
				local bottomy = dx9.size().height
				dx9.DrawLine({w2s.x,w2s.y},{centerx,bottomy},col)
			end
			if config.itemesp.name == true then 
				local name = dx9.GetName(v)
				dx9.DrawString({w2s.x+size,w2s.y-size-12},{255,255,255},name)
			end
			dx9.DrawBox({w2s.x-size,w2s.y-size},{w2s.x+size,w2s.y+size},col)
			if config.itemesp.outline == true then
				dx9.DrawBox({w2s.x-2-size,w2s.y-2-size},{w2s.x+2+size,w2s.y+2+size},{0,0,0})
				dx9.DrawBox({w2s.x+2-size,w2s.y+2-size},{w2s.x-2+size,w2s.y-2+size},{0,0,0})
			end
		end
	end
end