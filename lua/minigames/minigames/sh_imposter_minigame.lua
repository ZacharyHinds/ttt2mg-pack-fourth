if SERVER then
  AddCSLuaFile()
end

--Concept: A Random player switches to the Doppelganger team

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Imposter"
    },
    desc = {
      en = "They're among us!"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    local ply = plys[math.random(#plys)]
    ply:UpdateTeam(TEAM_DOPPELGANGER)
    ply:SetNWBool("isDormantDoppelganger", true)
  end

  function MINIGAME:OnDeactivation()

  end

  function MINIGAME:IsSelectable()
    if not DOPPELGANGER then
      return false
    else
      return true
    end
  end
end
