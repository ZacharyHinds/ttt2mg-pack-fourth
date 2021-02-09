SWEP.Base = "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.AdminSpawnable = true

SWEP.HoldType = "pistol"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

if SERVER then
  AddCSLuaFile()
elseif CLIENT then
  SWEP.PrintName = "Recruiting Deagle"
  SWEP.Author = "Wasted"

  SWEP.Slot = 8

  SWEP.ViewModelFOV = 54
  SWEP.ViewModelFlip = false

  SWEP.Category = "Deagle"
  SWEP.Icon = "vgui/ttt/icon_recruitdeagle"
  SWEP.EquipMenuData = {
    type = "item_weapon",
    desc = "ttt2mg_recruitdeagle_desc"
  }
end

SWEP.AllowDrop = false
SWEP.notBuyable = true

SWEP.Primary.Delay = 1
SWEP.Primary.Recoil = 6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.00001
SWEP.Primary.Ammo = ''
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1

SWEP.InLoadoutFor = nil
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.UseHands = true
SWEP.Kind = WEAPON_EXTRA
SWEP.CanBuy = {}
SWEP.LimitedStock = true
SWEP.globalLimited = true
SWEP.NoRandom = true

SWEP.ViewModel = 'models/weapons/cstrike/c_pist_deagle.mdl'
SWEP.WorldModel = 'models/weapons/w_pist_deagle.mdl'
SWEP.Weight = 5
SWEP.Primary.Sound = Sound('Weapon_Deagle.Single')

SWEP.IronSightsPos = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:OnDrop()
  self:Remove()
end
