if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "What you have? A Knife?"
    },
    desc = {
      en = "NO!"
    }
  }
end

if SERVER then
  local function BetterWeaponStrip(ply, exclude_class)
    if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
    local weps = ply:GetWeapons()
    for i = 1, #weps do
      local wep = weps[i]
      local wep_class = wep:GetClass()
      if (wep.Kind == WEAPON_EQUIP or wep.Kind == WEAPON_EQUIP2 or wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL or wep.Kind == WEAPON_NADE) and not exclude_class[wep_class] then
        ply:StripWeapon(wep_class)
      end
    end
  end

  function MINIGAME:OnActivation()
    local entities = ents.GetAll()
    for i = 1, #entities do
      local ent = entities[i]
      if ((ent.Base == "weapon_tttbase" or ent.Base == "weapon_tttbasegrenade") and ent.AutoSpawnable) or (ent.Base == "base_ammo_ttt") then
        ent:Remove()
      end
    end
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]
      BetterWeaponStrip(ply, {weapon_ttt_knife = true})
      if not ply:HasWeapon("weapon_ttt_knife") then
        ply:GiveEquipmentWeapon("weapon_ttt_knife")
      end
    end
    timer.Create("KnifeMinigame", 5, 0, function()
      plys = util.GetAlivePlayers()
      for i = 1, #plys do
        local ply = plys[i]
        BetterWeaponStrip(ply, {weapon_ttt_knife = true})
        if not ply:HasWeapon("weapon_ttt_knife") then
          ply:GiveEquipmentWeapon("weapon_ttt_knife")
          ply:SelectWeapon("weapon_ttt_knife")
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("KnifeMinigame")
  end
end
