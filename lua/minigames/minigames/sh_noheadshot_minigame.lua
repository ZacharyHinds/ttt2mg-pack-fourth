if SERVER then
  AddCSLuaFile()
end

--Concept: Disable headshots

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "No Headshots!"
    },
    desc = {
      en = "Hardhat Zone!"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("ScalePlayerDamage", "NoHeadshotMinigame", function(ply, hitgroup, dmginfo)
      if hitgroup == HITGROUP_HEAD then
        dmginfo:ScaleDamage(0.01)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("ScalePlayerDamage", "NoHeadshotMinigame")
  end
  --
  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
