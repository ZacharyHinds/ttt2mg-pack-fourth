if SERVER then
  AddCSLuaFile()
end

--CONCEPT: Random fake ads will occasionally appear on players' screens

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "You're on your own"
    },
    desc = {
      en = "Or are you?"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("TTT2SpecialRoleSyncing", "MinigameNoTeamsSync", function(ply, tbl)
      if GetRoundState() ~= ROUND_ACTIVE then
        hook.Remove("TTT2SpecialRoleSyncing", "MinigameNoTeamsSync")
        return
      end

      for pl in pairs(tbl) do
        if pl == ply then continue end
        tbl[pl] = {ROLE_INNOCENT, TEAM_INNOCENT}
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTT2SpecialRoleSyncing", "MinigameNoTeamsSync")
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
