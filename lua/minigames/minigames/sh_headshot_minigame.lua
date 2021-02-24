if SERVER then
  AddCSLuaFile()
end

--CONCEPT: Only headshots count

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_headshot_scale = {
    slider = true,
    decimal = 2,
    min = 0,
    max = 1,
    desc = "ttt2mg_headshot_scale (Def. 0)"
  }
}

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

  local ttt2mg_headshot_scale = CreateConVar("ttt2mg_headshot_scale", "0", {FCVAR_ARCHIVE}, "Damage Scaler for non-headshots")
  function MINIGAME:OnActivation()
    local activeMgs = minigames.GetActiveList()
    for i = 1, #activeMgs do
      if activeMgs[i].name == "sh_headshot_minigame" then return end
    end
    hook.Add("ScalePlayerDamage", "HeadshotMinigameScale", function(ply, hitgroup, dmginfo)
      if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("ScalePlayerDamage", "HeadshotMinigameScale") return end
      local atk = dmginfo:GetAttacker()
      if not atk or not IsValid(atk) or not atk:IsPlayer() then return end
      if hitgroup ~= HITGROUP_HEAD then
        dmginfo:ScaleDamage(ttt2mg_headshot_scale:GetFloat())
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("ScalePlayerDamage", "HeadshotMinigameScale")
  end

  function MINIGAME:IsSelectable()
    local activeMgs = minigames.GetActiveList()
    for i = 1, #activeMgs do
      if activeMgs[i].name == "sh_noheadshot_minigames" then return false end
    end
  end
end
