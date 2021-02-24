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
      en = "Peace Negotiations"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_peace_epop")
  function MINIGAME:OnActivation()
    timer.Create("CeaseFireMGTimer", 20, 0, function()
      if GetRoundState() ~= ROUND_ACTIVE then timer.Remove("CeaseFireMGTimer") return end
      net.Start("ttt2mg_peace_epop")
      net.Broadcast()
      hook.Add("ScalePlayerDamage", "CeaseFireMGScale", function(ply, hitgroup, dmginfo)
        if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("ScalePlayerDamage", "CeaseFireMGScale") return end
        local atk = dmginfo:GetAttacker()
        if not atk or not IsValid(atk) or not atk:IsPlayer() then return end
        dmginfo:ScaleDamage(0)
      end)
      timer.Simple(5, function()
        hook.Remove("ScalePlayerDamage", "CeaseFireMGScale")
      end)
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("CeaseFireMGTimer")
  end
  --
  function MINIGAME:IsSelectable()

  end

elseif CLIENT then
  net.Receive("ttt2mg_peace_epop", function()
    EPOP:AddMessage({
        text = LANG.TryTranslation("ttt2mg_peace_ceasefire"),
        color = COLOR_ORANGE
      },
      nil,
      5,
      nil,
      true
    )
  end)
end
