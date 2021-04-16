if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Hallelujah"
    },
    desc = {
      en = "It's raining men!"
    }
  }
end

if SERVER then
  local models_list = {}
  local rag_list = {}
  local function CreateModelList()
    local plys = util.GetAlivePlayers()
    models_list.models = {}
    models_list.skins = {}
    models_list.colors = {}
    for i = 1, #plys do
      local c = #models_list + 1
      local ply = plys[i]
      models_list.models[c] = ply:GetModel()
      models_list.skins[c] = ply:GetSkin()
      models_list.colors[c] = ply:GetColor()
    end
  end
  local function GetRandModel(models)
    models = models or models_list
    if #models <= 0 then
      CreateModelList()
      models = models_list
    end
    local mdl = {}
    mdl.model = nil
    mdl.skin = nil
    mdl.color = nil

    local rnd = math.random(#models.models)
    mdl.model = models.models[rnd]
    mdl.skin = models.skins[rnd]
    mdl.color = models.colors[rnd]

    return mdl
  end

  local function CreateRagAt(ply)
    if not IsValid(ply) then return end

    local rag = ents.Create("prop_ragdoll")
    local mdl = GetRandModel()
    local pos = ply:GetPos()
    pos.x = pos.x + math.random(1,5) * (-1 ^ math.random(1,2))
    pos.y = pos.y + math.random(1,5) * (-1 ^ math.random(1,2))
    pos.z = pos.z + math.random(100, 200)
    rag:SetPos(pos)
    rag:SetModel(mdl.model)
    rag:SetSkin(mdl.skin)
    rag:SetColor(mdl.color)
    rag:SetAngles(ply:GetAngles())

    rag:Spawn()
    rag:Activate()
    if #rag_list > 10 then
      rag_list[1]:Remove()
      table.remove(rag_list, 1)
    end
    rag_list[#rag_list + 1] = rag
  end

  function MINIGAME:OnActivation()
    CreateModelList()
    local plys = util.GetAlivePlayers()
    CreateRagAt(plys[math.random(#plys)])
    local delay = math.random(5, 30) + CurTime()
    hook.Add("Think", "MinigameRainmenThink", function()
      if delay > CurTime() then return end
      plys = util.GetAlivePlayers()
      CreateRagAt(plys[math.random(#plys)])
      delay = CurTime() + math.random(15, 60)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "MinigameRainmenThink")
    for i = 1, #rag_list do
      if not IsValid(rag_list[i]) then continue end
      rag_list[i]:Remove()
    end
    rag_list = {}
    models_list = {}
  end
end
