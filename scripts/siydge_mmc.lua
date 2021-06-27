local game = dx9.GetDatamodel()
local workspace = dx9.FindFirstChild(game,"Workspace")
local map = dx9.FindFirstChild(workspace,"map")
local enemies = dx9.GetChildren(dx9.FindFirstChild(map,"enemies"))
local closest = nil
local mouse = dx9.GetMouse()
function getdist(pos1,pos2)
    return math.sqrt((pos1.x-pos2.x)^2+(pos1.y-pos2.y)^2)
end
for i,v in pairs(enemies) do
    local head = dx9.FindFirstChild(v,"Head")
    local pos = dx9.GetPosition(head)
    local w2s = dx9.WorldToScreen({pos.x,pos.y,pos.z})
    local offset = dx9.WorldToScreen({pos.x,pos.y-2,pos.z})
    local size = (offset.y-w2s.y)/10
    if (w2s.x > 0 and w2s.y > 0) and (w2s.x < dx9.size().width and w2s.y < dx9.size().height) then
        local dist = getdist(w2s,mouse)
        local total = dist/(size)
        dx9.DrawString({w2s.x,w2s.y+13},{255,255,255},tostring(total))
        dx9.DrawBox({w2s.x-size,w2s.y-size},{w2s.x+size,w2s.y+size},{255,255,255})
        if closest == nil then
            closest = {position=w2s,total=total}
        else
            if closest.total > total and (dist < 80) then
                closest = {position=w2s,total=total}
            end
        end
    end
end
dx9.FirstPersonAim({closest.position.x,closest.position.y},1,15)
dx9.DrawString({closest.position.x,closest.position.y},{255,255,255},"close")