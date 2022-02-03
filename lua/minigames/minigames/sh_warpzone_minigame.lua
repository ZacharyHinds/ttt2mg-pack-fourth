if SERVER then
  AddCSLuaFile()
end

--Concept: Shots have a chance to teleport the shooter (and swap with target if they hit)

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_warpzone_warpchance = {
    slider = true,
    min = 0,
    max = 100,
    desc = "ttt2mg_warpzone_warpchance (Def. 50)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Welcome to the Warp Zone"
    },
    desc = {
      en = "You've been issued special teleguns"
    }
  }
end

if SERVER then
  local ttt2mg_warpzone_warpchance = CreateConVar("ttt2mg_warpzone_warpchance", "50", {FCVAR_ARCHIVE}, "Chance for each shot to warp player")
  function MINIGAME:OnActivation()
    hook.Add("EntityFireBullets", "MinigameWarpZoneFire", function(ply, data)
      if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

      local trace = ply:GetEyeTrace(MASK_SHOT_HULL)
      if trace.HitSky then return end
      local hit_pos = trace.HitPos
      local distance = trace.StartPos:Distance(hit_pos)
      print(distance)
      local tgt = trace.Entity
      print(tgt)
      local rnd = math.random(1, 100)

      if IsValid(tgt) and tgt:IsPlayer() and rnd <= ttt2mg_warpzone_warpchance:GetInt() then
        local pos = ply:GetPos()
        ply:SetPos(tgt:GetPos())
        tgt:SetPos(pos)
      elseif (not IsValid(tgt) or trace.HitWorld) and rnd <= ttt2mg_warpzone_warpchance:GetInt() then
        local pos = ply:GetPos()
        pos.x = (pos.x + hit_pos.x) / 4 + hit_pos.x / 2
        pos.y = (pos.y + hit_pos.y) / 4 + hit_pos.y / 2
        pos.z = (pos.z + hit_pos.z) / 4 + hit_pos.z / 2
        ply:SetPos(pos)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityFireBullets", "MinigameWarpZoneFire")
  end
end
