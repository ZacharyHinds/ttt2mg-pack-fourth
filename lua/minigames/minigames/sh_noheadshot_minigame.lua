if SERVER then
  AddCSLuaFile()
end

--Concept: Disable headshots

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_noheadshot_scale = {
    slider = true,
    decimal = 2,
    min = 0,
    max = 1,
    desc = "ttt2mg_noheadshot_scale (Def. 0.01)"
  }
}

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
  local ttt2mg_noheadshot_scale = CreateConVar("ttt2mg_noheadshot_scale", "0.01", {FCVAR_ARCHIVE}, "Damage scaler for headshots")
  function MINIGAME:OnActivation()
    local activeMgs = minigames.GetActiveList()
    for i = 1, #activeMgs do
      if activeMgs[i].name == "sh_headshot_minigame" then return end
    end
    hook.Add("ScalePlayerDamage", "NoHeadshotMinigame", function(ply, hitgroup, dmginfo)
      if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("ScalePlayerDamage", "NoHeadshotMinigame") return end
      local atk = dmginfo:GetAttacker()
      if not atk or not IsValid(atk) or not atk:IsPlayer() then return end
      if hitgroup == HITGROUP_HEAD then
        dmginfo:ScaleDamage(ttt2mg_noheadshot_scale:GetFloat())
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("ScalePlayerDamage", "NoHeadshotMinigame")
  end
  --
  function MINIGAME:IsSelectable()
    local activeMgs = minigames.GetActiveList()
    for i = 1, #activeMgs do
      if activeMgs[i].name == "sh_headshot_minigame" then return false end
    end
  end
end
