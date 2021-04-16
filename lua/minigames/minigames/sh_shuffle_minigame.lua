if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_shuffle_min = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2mg_shuffle_min (def. 15)"
  },

  ttt2mg_shuffle_max = {
    slider = true,
    min = 0,
    max = 600,
    desc = "ttt2mg_shuffle_max (def. 300)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Role Shuffle"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then
  local ttt2mg_shuffle_min = CreateConVar("ttt2mg_shuffle_min", "15", {FCVAR_ARCHIVE}, "Minimum delay before role shuffle")
  local ttt2mg_shuffle_max = CreateConVar("ttt2mg_shuffle_max", "300", {FCVAR_ARCHIVE}, "Maximum delay before role shuffle")

  function MINIGAME:OnActivation()
    timer.Simple(math.random(ttt2mg_shuffle_min:GetInt(), ttt2mg_shuffle_max:GetInt()), function()
      if GetRoundState() ~= ROUND_ACTIVE then return end
      local plys = util.GetAlivePlayers()
      -- print("[Shuffle Minigame] " .. #plys .. " found")
      -- local count = #plys
      local groupA = {}
      local groupB = {}
      local c = 0
      repeat
        local rnd = math.random(#plys)
        ply = plys[rnd]
        if c % 2 == 0 then
          groupA[#groupA + 1] = ply
          -- print("[Shuffle Minigame] " .. ply:Nick() .. " added to group A")
        else
          groupB[#groupB + 1] = ply
          -- print("[Shuffle Minigame] " .. ply:Nick() .. " added to group B")
        end
        table.remove(plys, rnd)
        -- print("[Shuffle Minigame] Player removed from table")
        c = c + 1
      until #plys <= 0
      for i = 1, #groupB do
        local plyA = groupA[i]
        local plyB = groupB[i]
        local roleA = plyA:GetSubRole()
        local teamA = plyA:GetTeam()
        plyA:SetRole(plyB:GetSubRole(), plyB:GetTeam())
        plyB:SetRole(roleA, teamA)
        -- print("[Shuffle Minigame] Swapped Roles: " .. plyA:Nick() .. " and " .. plyB:Nick())
      end
      if #groupA > #groupB then
        local plyA = groupA[#groupA]
        local plyB = groupA[math.random(#groupA - 1)]
        local roleA = plyA:GetSubRole()
        local teamA = plyA:GetTeam()
        plyA:SetRole(plyB:GetSubRole(), plyB:GetTeam())
        plyB:SetRole(roleA, teamA)
        -- print("[Shuffle Minigame] Swapped Roles: " .. plyA:Nick() .. " and " .. plyB:Nick())
      end
      SendFullStateUpdate()
    end)
  end

  function MINIGAME:OnDeactivation()

  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
