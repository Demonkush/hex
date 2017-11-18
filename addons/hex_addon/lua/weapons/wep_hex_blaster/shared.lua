if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Blaster"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "shotgun"
SWEP.PrintName          = "Blaster"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_rif_outland_blaster.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/TrollBatriderMissile2.wav")
SWEP.Primary.Delay          = 0.5
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 3

SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

-- Blaster -- Elements: Fire --
-- Primary Low: Beam
-- Primary Norm: Fire Beam
-- Primary High: Incinerate ( very powerful laser fire blast )
-- Hidden Power: Fury Blaster ( automatic fire / storm laser blasts )

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Magesoul") == 1 then
        self:MagesoulAbility()
        self:EmitSound("wc3sound/exp/PriestMissileHit2.wav",85,math.random(80,90))
        if self.Owner:GetNWInt("Overpowered") == 0 then
            if SERVER then
                self.Owner:SubtractMana(self.Primary.ManaCost)
            end
        end
        return
    end

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/exp/FeralSpiritTarget1.wav",85,math.random(80,90))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/exp/FeralSpiritTarget1.wav",85,math.random(80,90))
            self:DoPrimaryAttack("high")
        else
            self:EmitSound(self.Primary.Sound,85,math.random(95,100))
            self:DoPrimaryAttack("normal")
        end
    else
        self:EmitSound(self.Primary.Sound,40,math.random(145,155))
        self:DoPrimaryAttack("low")
    end
end

SWEP.alt = 1
function SWEP:MagesoulAbility()
    local output = "normal"
    local damage = math.random(12,15)
    local tracer1 = "fx_hex_laserfire"
    local tracer2 = "fx_hex_laserstorm"
    local atkspddown = 0.1

    local bullet1 = {}
    bullet1.Num      = 1
    bullet1.Src      = self.Owner:GetShootPos()
    bullet1.Dir      = self.Owner:GetAimVector()
    bullet1.Spread   = Vector(0.01, 0.01, 0)
    bullet1.Tracer   = 1
    bullet1.TracerName = tracer1
    bullet1.Force    = math.random(12,15) * 0.5
    bullet1.Damage   = math.random(12,15)
    bullet1.Callback = function(ent,tr,dmg)
        self:MagesoulImpactEffect(tr,"fire")
        if SERVER then
            dmg:SetAttacker(self:GetOwner())
            dmg:SetDamageElement("fire")
            if output == "high" then
                self:AoEBoom(tr,"fire")
            end
        end
    end

    local bullet2 = {}
    bullet2.Num      = 1
    bullet2.Src      = self.Owner:GetShootPos()
    bullet2.Dir      = self.Owner:GetAimVector()
    bullet2.Spread   = Vector(0.01, 0.01, 0)
    bullet2.Tracer   = 1
    bullet2.TracerName = tracer2
    bullet2.Force    = math.random(10,17) * 0.5
    bullet2.Damage   = math.random(10,17)
    bullet2.Callback = function(ent,tr,dmg)
        self:MagesoulImpactEffect(tr,"storm")
        if SERVER then
            if output == "high" then
                dmg:SetAttacker(self:GetOwner())
                dmg:SetDamageElement("storm")
                self:AoEBoom(tr,"storm")
            end
        end
    end

    local bullet = 1
    if self.alt == 1 then
        self.alt = 2
        self:FireBullets(bullet1)
    elseif self.alt == 2 then
        self.alt = 1
        self:FireBullets(bullet2)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun002", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod-atkspddown))
end

function SWEP:DoPrimaryAttack(output)
    local gravity = true
    local damage = math.random(3,6)
    local tracer = "fx_hex_tracerfire"
    local atkspddown = 0
    local element = "fire"

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if HEX.MOD.WeaponPowerLock == true then
        output = HEX.MOD.WeaponPowerLockMode
    end

    if output == "normal" then
        tracer = "fx_hex_laserfire"
    end

    if output == "high" then
        tracer = "fx_hex_laserfiresuper"
        atkspddown = 1
    end

    if output == "low" then
        tracer = "fx_hex_laserred"
        element = "magic"
    end

    local bullet = {}
    bullet.Num      = 1
    bullet.Src      = self.Owner:GetShootPos()
    bullet.Dir      = self.Owner:GetAimVector()
    bullet.Spread   = Vector(0.01, 0.01, 0)
    bullet.Tracer   = 1
    bullet.TracerName = tracer
    bullet.Force    = damage * 0.5
    bullet.Damage   = damage
    bullet.Callback = function(ent,tr,dmg)
        self:ImpactEffect(tr,output)
        if SERVER then
            dmg:SetAttacker(self:GetOwner())
            dmg:SetDamageElement(element)
            if output != "low" then
                self:AoEBoom(tr,output)
            end
        end
    end

    self:FireBullets(bullet)

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun002", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod)+atkspddown)
end

function SWEP:ImpactEffect(trace,output)
    local hitpos = trace.HitPos
    local scale = 1
    local efx = "fx_hex_fireblast01"

    if output == "low" then
        scale = 0.5
    end
    if output == "normal" then
        sound.Play( "fireball.Boom", hitpos, 75, 135 )
    end
    if output == "high" then
        scale = 1.5
        efx = "fx_hex_fireblast02"
        sound.Play( "blackpowder.Boom", hitpos, 75, 135 )
    end

    if output != "low" then
        local fx = EffectData()
        fx:SetOrigin( hitpos )
        fx:SetScale( scale )
        util.Effect( efx, fx )
    end
    local fx2 = EffectData() fx2:SetOrigin( hitpos ) fx2:SetScale(scale)
    fx2:SetAngles(Angle(150,75,50))
    util.Effect( "fx_hex_model_blast", fx2 )
end

function SWEP:AoEBoom(trace,op)
    local range = 85
    local damage = math.random(7,11)
    local element = "fire"
    if op == "high" then
        range = 125
        damage = damage * 1.2
    end
    for _, v in ipairs(ents.FindInSphere(trace.HitPos,range)) do
        if v != self:GetOwner() then
            local dmginfo = DamageInfo()
            dmginfo:SetAttacker( self:GetOwner() )
            dmginfo:SetInflictor( self:GetOwner() )
            dmginfo:SetDamage( damage )
            dmginfo:SetDamageElement(element)
            v:TakeDamageInfo( dmginfo )
        end
        if v:IsPlayer() then
            v:SetVelocity((v:GetPos()-trace.HitPos)*4)

            local r = math.random(1,50)
            if r > 25 then
                if op == "normal" then
                    v:BuffFire(self:GetOwner(),0.5,3)
                end
            end
            if op == "high" then
                v:BuffFire(self:GetOwner(),0.5,3)
            end
        end
    end
end

function SWEP:MagesoulImpactEffect(trace,element)
    local hitpos = trace.HitPos
    local scale = 1
    local efx = "fx_hex_fireblast01"
    local color = Angle(255,155,55)

    if element == "fire" then
        sound.Play( "fireball.Boom", hitpos, 75, 135 )
    end
    if element == "storm" then
        color = Angle(155,215,255)
        efx = "fx_hex_stormblast01"
        sound.Play( "stormbolt.Boom", hitpos, 75, 135 )
    end

    local fx = EffectData()
    fx:SetOrigin( hitpos )
    fx:SetScale( 1.5 )
    util.Effect( efx, fx )

    local fx2 = EffectData() fx2:SetOrigin( hitpos ) fx2:SetScale(scale)
    fx2:SetAngles(color)
    util.Effect( "fx_hex_model_blast", fx2 )
end

function SWEP:MagesoulAoEBoom(trace,element)
    local damage = 20
    if element == "storm" then
        damage = math.random(5,15)
    end
    if element == "fire" then
        damage = math.random(9,13)
    end
    for _, v in ipairs(ents.FindInSphere(trace.HitPos,115)) do
        if v != self:GetOwner() then
            local dmginfo = DamageInfo()
            dmginfo:SetAttacker( self:GetOwner() )
            dmginfo:SetInflictor( self:GetOwner() )
            dmginfo:SetDamage( damage )
            dmginfo:SetDamageElement(element)
            v:TakeDamageInfo( dmginfo )
        end
        if v:IsPlayer() then
            local r = math.random(1,50)
            v:SetVelocity((v:GetPos()-trace.HitPos)*2)
            if r > 25 then
                if element == "storm" then
                    v:BuffStun(self:GetOwner(),2)
                end
                if element == "fire" then
                    v:BuffFire(self:GetOwner(),0.5,3)
                end
            end
        end
    end
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
        light.R                 = 255
        light.G                 = 155
        light.B                 = 55
        light.Brightness        = 2
        light.DieTime           = CurTime()+0.35
    end
    function EFFECT:Think()
        return IsValid(self.Weapon) && self.DieTime >= CurTime()
    end
    function EFFECT:Render() end
    effects.Register(EFFECT,"MuzzleGun002")
end