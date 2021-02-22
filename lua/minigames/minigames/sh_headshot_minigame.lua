if SERVER then
  AddCSLuaFile()
end

--CONCEPT: Only headshots count

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Headshots Only!"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then


  function MINIGAME:OnActivation()
    hook.Add("ScalePlayerDamage", "HeadshotMinigameScale", function(ply, hitgroup, dmginfo)
      if hitgroup ~= HITGROUP_HEAD then
        dmginfo:ScaleDamage(0)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("ScalePlayerDamage", "HeadshotMinigameScale")
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
