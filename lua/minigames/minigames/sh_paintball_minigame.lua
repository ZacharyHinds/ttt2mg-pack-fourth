if SERVER then
  AddCSLuaFile()
end

--Concept: Occasionally spawn radio items at players and have them run random sounds

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_paintball_delay = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2_minigames_paintball_delay (Def. 15)"
  },

  ttt2_minigames_paintball_worldspawn = {
    checkbox = true,
    desc = "ttt2_minigames_paintball_worldspawn (Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Paintball Practice"
    },
    desc = {
      en = "Infinite Chances"
    }
  }
end

if SERVER then
  local ttt2_minigames_paintball_delay = CreateConVar("ttt2_minigames_paintball_delay", "15", {FCVAR_ARCHIVE}, "How long it takes the marker to respawn")
  local ttt2_minigames_paintball_worldspawn = CreateConVar("ttt2_minigames_paintball_worldspawn", "1", {FCVAR_ARCHIVE}, "Should marker respawn at a spawnpoint instead of body")

  local function MarkerCheck()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]
      if ply:GetSubRole() == ROLE_MARKER then
        return ply
      end
    end
    local ply
    repeat
      if #plys <= 0 then
        plys = util.GetAlivePlayers()
        if plys <= 0 then return end
      end
      local rnd = math.random(#plys)
      ply = plys[rnd]
      table.remove(plys, rnd)
    until IsValid(ply) and ply:Alive() and not ply:IsSpec() and not ply:IsDetective() and not ply:IsTraitor() and ply:GetSubRole() ~= ROLE_SIDEKICK
    ply:SetRole(ROLE_MARKER)
    return ply
  end

  function MINIGAME:OnActivation()
    local marker = MarkerCheck()
    hook.Add("TTT2PostPlayerDeath", "PaintballMinigameDeath", function(ply, _, attacker)
      if not IsValid(marker) or marker:GetSubRole() ~= ROLE_MARKER then return end

      local spawnpoint = spawn.GetRandomPlayerSpawnEntity(marker)

      marker:Revive(
        ttt2_minigames_paintball_delay:GetInt(),
        function()
          if ttt2_minigames_paintball_worldspawn:GetBool() and spawnpoint then
            marker:SetPos(spawnpoint:GetPos())
          end
        end
      )
      marker:SendRevivalReason("ttt2_minigames_" .. self.name .. "_name")
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTT2PostPlayerDeath", "PaintballMinigameDeath")
  end

  function MINIGAME:IsSelectable()
    if MARKER then
      return true
    else
      return false
    end
  end
end
