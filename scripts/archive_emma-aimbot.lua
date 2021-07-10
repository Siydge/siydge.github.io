local smooth = 2

local game = dx9.GetDatamodel()
local workspace = dx9.FindFirstChild(game,"Workspace")
local emma = dx9.FindFirstChild(workspace,"emma")
local head = dx9.FindFirstChild(emma,"Head")
local hpos = dx9.GetPosition(head)
local w2s = dx9.WorldToScreen({hpos.x,hpos.y,hpos.z})
dx9.ThirdPersonAim({w2s.x,w2s.y},smooth,1)