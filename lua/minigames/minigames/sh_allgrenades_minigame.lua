if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "OOPS! All Grenades!"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then
  local grenade_list = {}

  local function GetGrenades()
    if #grenade_list <= 0 then
      local weps = weapons.GetList()
      for i = 1, #weps do
        local wep = weps[i]
        if not wep.AutoSpawnable or wep.HoldType ~= "grenade" then continue end
        grenade_list[#grenade_list + 1] = wep
      end
    end
    return grenade_list
  end

  local function SpawnGrenadePos(pos)
    local nades = GetGrenades()
    local random_nade = nades[math.random(#nades)]
    local class = random_nade.ClassName or (wep.GetClass and wep:GetClass())
    local wpn = weapons.Get(class)
    local nade = ents.Create(class)
    if not IsValid(nade) then return end
    nade:SetPos(pos)
    nade:SetModel(wpn["WorldModel"])
    nade:Spawn()
  end

  function MINIGAME:OnActivation()
    local entities = ents.GetAll()

    for i = 1, #entities do
      local ent = entities[i]
      if (ent.Base == "weapon_tttbase" and ent.AutoSpawnable) or ent.Base == "base_ammo_ttt" then
        local pos = ent:GetPos()
        ent:Remove()
        SpawnGrenadePos(pos)
      end
    end

    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]
      local hp = ply:Health()
      local maxhp = ply:GetMaxHealth()
      local new_maxhp = 50
      local new_hp = math.Clamp(hp * (new_maxhp / maxhp),1, hp)
      ply:SetMaxHealth(new_maxhp)
      ply:SetHealth(new_hp)
    end
  end

  function MINIGAME:OnDeactivation()

  end

end
