local game = dx9.GetDatamodel()
local service = dx9
local color = {255,255,255}
local workspace = service.FindFirstChild(game, "Workspace")
local ignore = service.FindFirstChild(workspace, "Ignore")
local drops = service.FindFirstChild(ignore, "GunDrop")
for _,gun in next, service.GetChildren(drops) do
    for _, gunmodel in next, service.GetChildren(gun) do
    if service.GetName(gunmodel) == "Slot1" then
      local pos = service.GetPosition(gunmodel)
      local w2s = service.WorldToScreen({pos.x, pos.y, pos.z})
      service.DrawString({w2s.x, w2s.y}, color, "Dropped Gun")
      end
    end
end 