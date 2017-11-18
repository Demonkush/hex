if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Trapper Bow"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "shotgun"
SWEP.PrintName          = "Trapper Bow"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/steel/crossbow/w_steel_crossbow.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/KeeperOfTheGroveMissileLaunch3.wav")
SWEP.Primary.Delay          = 0.8
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 3

SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

-- Trapper Bow -- Elements: Slow / Poison --
-- Primary Low: Venom Arrow
-- Primary Norm: Poison Bolt
-- Primary High: Venom Boltbomb
-- Hidden Power: Plague Bomb

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Magesoul") == 1 then
        self:MagesoulAbility()
        self:EmitSound("wc3sound/exp/TrollBatriderMissile2.wav",85,math.random(100,110))
        if self.Owner:GetNWInt("Overpowered") == 0 then
            if SERVER then
                self.Owner:SubtractMana(self.Primary.ManaCost)
            end
        end
        return
    end

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/exp/TrollBatriderMissile2.wav",85,math.random(100,110))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/exp/TrollBatriderMissile2.wav",85,math.random(100,110))
            self:DoPrimaryAttack("high")
        else
            self:EmitSound(self.Primary.Sound,85,math.random(85,115))
            self:DoPrimaryAttack("normal")
        end
    else
        self:EmitSound(self.Primary.Sound,55,math.random(145,155))
        self:DoPrimaryAttack("low")
    end
end

function SWEP:MagesoulAbility()
    local projent = "ent_hex_projectile_poisonboltmine"
    local gravity = false
    local atkspeeddelay = 1
    local output = "high"

    if SERVER then
        local tr,projrec = self.Owner:GetEyeTrace(),1
        local ent = ents.Create(projent)
        ent:SetPos(self.Owner:GetShootPos())
        ent:SetOwner(self.Owner)
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()

        ent.Weapon = "a "..self.PrintName

        ent:SetPower(output)

        ent.ToggleGas = true

        local phys = ent:GetPhysicsObject()
        phys:ApplyForceCenter(self.Owner:GetAimVector()+self.Owner:GetForward(Vector(math.random(-255,255),math.random(-255,255),0))*50000)
        phys:SetVelocity(phys:GetVelocity()+self.Owner:GetAimVector()+(VectorRand()*projrec))
        phys:EnableGravity(gravity)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin(self.Owner:GetShootPos())
        effect:SetEntity(self.Weapon)
        effect:SetAttachment(1)
    util.Effect("MuzzleBow001",effect)

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod+atkspeeddelay))
end

function SWEP:DoPrimaryAttack(output)
    local projent = "ent_hex_projectile_poisonbolt"
    local gravity = false
    local atkspeeddelay = 0

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if HEX.MOD.WeaponPowerLock == true then
        output = HEX.MOD.WeaponPowerLockMode
    end

    if output == "high" then
        projent = "ent_hex_projectile_poisonboltmine"
        atkspeeddelay = 0.5
        gravity = true
    end

    if SERVER then
        local tr,projrec = self.Owner:GetEyeTrace(),1
        local ent = ents.Create(projent)
        ent:SetPos(self.Owner:GetShootPos())
        ent:SetOwner(self.Owner)
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()

        ent.Weapon = "a "..self.PrintName

        ent:SetPower(output)

        local phys = ent:GetPhysicsObject()
        phys:ApplyForceCenter(self.Owner:GetAimVector()+self.Owner:GetForward(Vector(math.random(-255,255),math.random(-255,255),0))*50000)
        phys:SetVelocity(phys:GetVelocity()+self.Owner:GetAimVector()+(VectorRand()*projrec))
        phys:EnableGravity(gravity)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin(self.Owner:GetShootPos())
        effect:SetEntity(self.Weapon)
        effect:SetAttachment(1)
    util.Effect("MuzzleBow001",effect)

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod+atkspeeddelay))
end

if CLIENT then
    local EFFECT = {}
    function EFFECT:Init(data)
        self.Weapon = data:GetEntity()
        self.Entity:SetRenderBounds(Vector(-16,-16,-16),Vector(16,16,16))
        self.Entity:SetParent(self.Weapon)
        self.DieTime = CurTime()+math.Rand(0.25,0.35)
        
        local pos,ang = GetMuzzlePosition(self.Weapon)
        local light = DynamicLight(self.Weapon:EntIndex())
        light.Pos               = pos
        light.Size              = 256
        light.Decay             = 400
        light.R                 = 215
        light.G                 = 255
        light.B                 = 155
        light.Brightness        = 2
        light.DieTime           = CurTime()+0.35
    end
    function EFFECT:Think()
        return IsValid(self.Weapon) && self.DieTime >= CurTime()
    end
    function EFFECT:Render() end
    effects.Register(EFFECT,"MuzzleBow001")
end