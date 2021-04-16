if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_blinking_min = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2mg_blinking_min (Def. 5)"
  },

  ttt2mg_blinking_max = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2mg_blinking_max"
  },

  ttt2mg_blinking_all = {
    checkbox = true,
    desc = "ttt2mg_blinking_all"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Something in my eye"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_blinking")
  local ttt2mg_blinking_max = CreateConVar("ttt2mg_blinking_max", "30", {FCVAR_ARCHIVE}, "Max Delay Between Blinks")
  local ttt2mg_blinking_min = CreateConVar("ttt2mg_blinking_min", "5", {FCVAR_ARCHIVE}, "Min delay between blinks")
  local ttt2mg_blinking_all = CreateConVar("ttt2mg_blinking_all", "0", {FCVAR_ARCHIVE}, "Should everyone blink at once")
  function MINIGAME:OnActivation()
    local delay = math.random(ttt2mg_blinking_min:GetInt(), ttt2mg_blinking_max:GetInt()) + CurTime()
    hook.Add("Think", "MinigameBlinkingThink", function()
      if GetRoundState() ~= ROUND_ACTIVE then
        hook.Remove("Think", "MinigameBlinkingThink")
        return
      end
      if delay <= CurTime() then
        local plys = util.GetAlivePlayers()
        net.Start("ttt2mg_blinking")
        net.WriteBool(true)
        if ttt2mg_blinking_all:GetBool() then
          net.Send(plys)
        else
          net.Send(plys[math.random(#plys)])
        end
        -- net.Start()
        delay = CurTime() + math.random(ttt2mg_blinking_min:GetInt(), ttt2mg_blinking_max:GetInt())
      end
    end)

  end

  function MINIGAME:OnDeactivation()
    -- timer.Remove("MinigameBlinkingTimer")
    hook.Remove("Think", "MinigameBlinkingThink")
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
elseif CLIENT then
  local function BlindPly(i)
    -- local ply = LocalPlayer()
    surface.SetDrawColor(0, 0, 0, i)
    surface.DrawRect(0, 0, ScrW(), ScrH())
  end

  function MINIGAME:OnActivation()
    local i = 0
    hook.Add("DrawOverlay", "MinigameBlinkBlind", function()
      local ply = LocalPlayer()
      if not ply.minigameBlink_blinking then i = 0 return end
      if not ply.minigameBlink_alpha then ply.minigameBlink_alpha = 0 end

      if i < 255 then
        -- print("[Blinking Minigame] Eye closing")
        i = i + 4
        BlindPly(i)
      elseif i < 510 then
        -- print("[Blinking Minigame] Eye opening")
        i = i + 5
        BlindPly(255 - (i - 255))
      else
        -- print("[Blinking Minigame] Eye reset")
        i = 0
        ply.minigameBlink_blinking = false
        BlindPly(0)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "MinigameBlinkBlind")
  end

  net.Receive("ttt2mg_blinking", function()
    local ply = LocalPlayer()
    ply.minigameBlink_blinking = net.ReadBool()
    ply.minigameBlink_alpha = 0
  end)
end
