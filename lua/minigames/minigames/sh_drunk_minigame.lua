if SERVER then
  AddCSLuaFile()
end

--Concept:

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Stumbling Drunk"
    },
    desc = {
      en = "Flipped controls"
    }
  }
end

if CLIENT then
  function MINIGAME:OnActivation()
    hook.Add("StartCommand", "StumblingMinigameControl", function(ply, ucmd)
      if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("StartCommand", "StumblingMinigameControl") return end
      if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then return end
      ucmd:SetForwardMove(ucmd:GetForwardMove() * -1)
      ucmd:SetSideMove(ucmd:GetSideMove() * -1)
      ucmd:SetUpMove(ucmd:GetUpMove() * -1)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("StartCommand", "StumblingMinigameControl")
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
