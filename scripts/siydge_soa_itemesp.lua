local game = dx9.GetDatamodel()
local workspace = dx9.FindFirstChild(game,"Workspace")
local interactable = dx9.FindFirstChild(workspace,"Interactable")
local pickups = dx9.GetChildren(dx9.FindFirstChild(interactable,"PickUps"))
local mouse = dx9.GetMouse()

function getdist(pos1,pos2)
    return math.sqrt((pos1.x-pos2.x)^2+(pos1.y-pos2.y)^2)
end

for i,v in pairs(pickups) do
    local Main = dx9.FindFirstChild(v,"Main")
    local pos = dx9.GetPosition(Main)
    local w2s = dx9.WorldToScreen({pos.x,pos.y,pos.z})
	if w2s.x > 1 and w2s.y > 1 then
	    local offset = dx9.WorldToScreen({pos.x,pos.y-2,pos.z})
	    local size = (offset.y-w2s.y)/2
		dx9.DrawBox({w2s.x-size,w2s.y-size},{w2s.x+size,w2s.y+size},{255,255,255})
		dx9.DrawLine({mouse.x-20,mouse.y},{mouse.x+20,mouse.y},{255,255,255})
		dx9.DrawLine({mouse.x,mouse.y-20},{mouse.x,mouse.y+20},{255,255,255})
		if size > 5 or getdist(mouse,w2s) < 20 then
			dx9.DrawString({w2s.x,w2s.y},{255,255,255},dx9.GetName(v))
		end
	end
end