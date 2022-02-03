if SERVER then
  AddCSLuaFile()
end

--TODO: Set credits to default for new role

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
  },

  ttt2mg_shuffle_count = {
    slider = true,
    min = 1,
    max = 5,
    desc = "ttt2mg_shuffle_count (def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Role Shuffle"
    },
    desc = {
      en = "Prepare for utter chaos!"
    }
  }
end

if SERVER then
  local ttt2mg_shuffle_min = CreateConVar("ttt2mg_shuffle_min", "15", {FCVAR_ARCHIVE}, "Minimum delay before role shuffle")
  local ttt2mg_shuffle_max = CreateConVar("ttt2mg_shuffle_max", "300", {FCVAR_ARCHIVE}, "Maximum delay before role shuffle")
  local ttt2mg_shuffle_count = CreateConVar("ttt2mg_shuffle_count", "1", {FCVAR_ARCHIVE}, "Maximum number of shuffles per round")
  util.AddNetworkString("ttt2mg_shuffle_epop")

  local function SetDefaultCredits(ply)
    ply:SetCredits(0)
    if ply:GetSubRole() == ROLE_TRAITOR then
      ply:SetCredits(GetConVar("ttt_credits_starting"):GetInt())
    else
      ply:SetCredits(GetConVar("ttt_" .. ply:GetSubRoleData().abbr .. "_credits_starting"):GetInt())
    end
  end

  function MINIGAME:OnActivation()
    local delay = math.random(ttt2mg_shuffle_min:GetInt(), ttt2mg_shuffle_max:GetInt()) + CurTime()
    local count = 0
    hook.Add("Think", "ShuffleMinigameThink", function()
      if GetRoundState() ~= ROUND_ACTIVE then
        hook.Remove("Think", "ShuffleMinigameThink")
        return
      end
      if count > ttt2mg_shuffle_count:GetInt() then return end
      if delay > CurTime() then return end

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
        SetDefaultCredits(plyA)
        plyB:SetRole(roleA, teamA)
        SetDefaultCredits(plyB)
        -- print("[Shuffle Minigame] Swapped Roles: " .. plyA:Nick() .. " and " .. plyB:Nick())
      end
      if #groupA > #groupB then
        local plyA = groupA[#groupA]
        local plyB = groupA[math.random(#groupA - 1)]
        local roleA = plyA:GetSubRole()
        local teamA = plyA:GetTeam()
        plyA:SetRole(plyB:GetSubRole(), plyB:GetTeam())
        SetDefaultCredits(plyA)
        plyB:SetRole(roleA, teamA)
        SetDefaultCredits(plyB)
        -- print("[Shuffle Minigame] Swapped Roles: " .. plyA:Nick() .. " and " .. plyB:Nick())
      end
      net.Start("ttt2mg_shuffle_epop")
      net.Broadcast()
      SendFullStateUpdate()
      delay = CurTime() + math.random(ttt2mg_shuffle_min:GetInt(), ttt2mg_shuffle_max:GetInt())
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "ShuffleMinigameThink")
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end

if CLIENT then
  net.Receive("ttt2mg_shuffle_epop", function()
    EPOP:AddMessage({
        text = LANG.TryTranslation("ttt2mg_shuffle_epop"),
        color = COLOR_ORANGE
    })
  end)
end
