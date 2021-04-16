if SERVER then
  AddCSLuaFile()
end

--Concept: Players receive occasional random inputs

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_hyper_speedmult = {
    slider = true,
    min = 1,
    max = 100,
    desc = "ttt2mg_hyper_speedmult (Def. 5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Hyperspeed!"
    },
    desc = {
      en = "Movement speed waaaaay up!!!"
    }
  }
end

if SERVER then
  local ttt2mg_hyper_speedmult = CreateConVar("ttt2mg_hyper_speedmult", "5", {FCVAR_ARCHIVE}, "Speed multiplier")
  function MINIGAME:OnActivation()
    hook.Add("TTTPlayerSpeedModifier", "HyperSpeedMG", function(ply, _, _, speedMultiplierMod)
      if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("TTTPlayerSpeedModifier", "HyperSpeedMG") return end
      if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then return end
      speedMultiplierMod[1] = speedMultiplierMod[1] * ttt2mg_hyper_speedmult:GetFloat()
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTTPlayerSpeedModifier", "HyperSpeedMG")
  end

  -- function MINIGAME:IsSelectable()
  --   return true
  -- end
end
