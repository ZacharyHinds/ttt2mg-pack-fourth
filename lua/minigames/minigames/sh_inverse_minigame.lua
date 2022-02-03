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
      en = "Inverted Mouse"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then
  util.AddNetworkString("invertMinigame_inverted")
  function MINIGAME:OnActivation()
    net.Start("invertMinigame_inverted")
    net.WriteBool(true)
    net.Broadcast()
  end

  function MINIGAME:OnDeactivation()
    net.Start("invertMinigame_inverted")
    net.WriteBool(false)
    net.Broadcast()
  end
end

if CLIENT then
  function MINIGAME:OnActivation()
    -- local delay = CurTime() + 5
    hook.Add("CreateMove", "InverseMinigameMouse", function(cmd)
      local ply = LocalPlayer()
      if not ply.invertMinigame_inverted then return end
      if not ply:Alive() or not ply:IsPlayer() then return end

      local mouseY = cmd:GetMouseY() * -1
      local mouseX = cmd:GetMouseX() * -1
      local view = cmd:GetViewAngles()

      local invert = Angle(view.p + mouseY / 30, view.y - mouseX / 30, 0)
      invert.p = math.Clamp(invert.p, -89, 89)

      cmd:SetViewAngles(invert)
      -- ply:SetEyeAngles(invert)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("CreateMove", "InverseMinigameMouse")
  end

  net.Receive("invertMinigame_inverted", function()
    if net.ReadBool() then
      LocalPlayer().invertMinigame_inverted = true
    else
      LocalPlayer().invertMinigame_inverted = nil
    end
  end)
end
