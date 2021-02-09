if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Recruitment Drive"
    },
    desc = {
      English = "It's not a pyramid scheme!"
    }
  }
end

if SERVER then
  -- hook.Add("ScalePlayerDamage", "RecruitDeagleHitReg", function(ply, hitgroup, dmginfo)
  --   local attacker = dmginfo:GetAttacker()
  --
  --   if GetRoundState() ~= ROUND_ACTIVE or not attacker or not IsValid(attacker) or not attacker:IsPlayer() or not IsValid(attacker:GetActiveWeapon()) then return end
  --
  --   if not ply or not ply:IsPlayer() then return end
  --
  --   local gun = attacker:GetActiveWeapon()
  --
  --   if gun:GetClass() ~= "weapon_ttt2mg_recruitdeagle" then return end
  --
  --   ply:SetRole(attacker:GetSubRole(), attacker:GetTeam())
  --   SendFullStateUpdate()
  --   attacker:StripWeapon("weapon_ttt2mg_recruitdeagle")
  --
  --   dmginfo:SetDamage(0)
  --   return true
  -- end)

  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      plys[i]:GiveEquipmentWeapon("weapon_ttt2mg_recruitdeagle")
    end
  end

  function MINIGAME:OnDeactivation()
    local plys = player.GetAll()
    for i = 1, #plys do
      plys[i]:StripWeapon("weapon_ttt2mg_recruitdeagle")
    end
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
