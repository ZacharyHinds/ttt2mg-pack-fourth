if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Seething Rage"
    },
    desc = {
      en = "Anger compels me"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetFilteredPlayers(function(ply)
      return ply:Alive() and ply:IsPlayer() and not ply:IsSpec() and ply:GetTeam() == TEAM_INNOCENT and not ply:GetSubRoleData().isPublicRole == true
    end)

    for i = 1, #plys do
      plys[i]:SetRole(ROLE_WRATH)
    end
    SendFullStateUpdate()
  end

  function MINIGAME:OnDeactivation()

  end

  function MINIGAME:IsSelectable()
    return WRATH
  end
end
