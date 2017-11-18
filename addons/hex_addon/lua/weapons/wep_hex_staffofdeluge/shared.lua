if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Staff of Deluge"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee"
SWEP.PrintName          = "Staff of Deluge"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/mercy/spear/w_mercy_spear.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/FrostBoltLaunch1.wav")
SWEP.Primary.Delay          = 1
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 3

SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

-- Staff of Deluge -- Elements: Frost / Mana Drain --
-- Primary Low: Ice Bolt
-- Primary Norm: Frost Shard
-- Primary High: Shatter Missile
-- Hidden Power: Frostbite ( Frost Nova + Frost Missile )

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Magesoul") == 1 then
        self:MagesoulAbility()
        self:EmitSound("wc3sound/exp/FreezingBreathTarget1.wav",85,math.random(75,85))
        if self.Owner:GetNWInt("Overpowered") == 0 then
            if SERVER then
                self.Owner:SubtractMana(self.Primary.ManaCost)
            end
        end
        return
    end

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/exp/FrostBoltLaunch1.wav",85,math.random(75,85))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/exp/FrostBoltLaunch1.wav",85,math.random(75,85))
            self:DoPrimaryAttack("high")
        else
            self:EmitSound(self.Primary.Sound,85,math.random(115,125))
            self:DoPrimaryAttack("normal")
        end
    else
        self:EmitSound(self.Primary.Sound,55,math.random(145,155))
        self:DoPrimaryAttack("low")
    end
end

function SWEP:MagesoulAbility()
    local projent = "ent_hex_aura_manadrain"
    local atkspeeddelay = 2

    if SERVER then
        local ent = ents.Create(projent)
        ent:SetPos(self.Owner:GetPos())
        ent:SetOwner(self.Owner)
        ent:Spawn()

        ent.Weapon = "a "..self.PrintName
    end

    for _, v in ipairs(ents.FindInSphere(self:GetPos(),175)) do
        if v != self:GetOwner() then
            local dmginfo = DamageInfo()
            dmginfo:SetAttacker(self:GetOwner())
            dmginfo:SetInflictor(self)
            dmginfo:SetDamage(math.random(17,22))
            dmginfo:SetDamageElement("frost")
            v:TakeDamageInfo(dmginfo)
        end
    end

    for i=1,3 do
        local proj = ents.Create("ent_hex_projectile_frostbolt")
        proj:SetPos(self:GetPos())
        proj:SetOwner(self:GetOwner())
        proj:Spawn()

        proj:SetPower("normal")

        local phys = proj:GetPhysicsObject()
        phys:ApplyForceCenter(Vector(math.random(-255,255), math.random(-255,255), 255) * 10)
        phys:EnableGravity(true)
    end

    local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(3)  
    util.Effect("fx_hex_frostblast02",fx)
    local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(2.5)
    fx2:SetAngles(Angle(155,215,255))
    util.Effect("fx_hex_model_blast",fx2)

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin(self.Owner:GetShootPos())
        effect:SetEntity(self.Weapon)
        effect:SetAttachment(1)
    util.Effect("MuzzleStaff001",effect)

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod+atkspeeddelay))
end

function SWEP:DoPrimaryAttack(output)
    local projent = "ent_hex_projectile_frostbolt"
    local gravity = false

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if HEX.MOD.WeaponPowerLock == true then
        output = HEX.MOD.WeaponPowerLockMode
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
        phys:ApplyForceCenter(self.Owner:GetAimVector()+self.Owner:GetForward(Vector(math.random(-255,255),math.random(-255,255),0))*10000)
        phys:SetVelocity(phys:GetVelocity()+self.Owner:GetAimVector()+(VectorRand()*projrec))
        phys:EnableGravity(gravity)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin(self.Owner:GetShootPos())
        effect:SetEntity(self.Weapon)
        effect:SetAttachment(1)
    util.Effect("MuzzleStaff001",effect)

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
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
        light.R                 = 115
        light.G                 = 155
        light.B                 = 255
        light.Brightness        = 2
        light.DieTime           = CurTime()+0.35
    end
    function EFFECT:Think()
        return IsValid(self.Weapon) && self.DieTime >= CurTime()
    end
    function EFFECT:Render() end
    effects.Register(EFFECT,"MuzzleStaff001")
end