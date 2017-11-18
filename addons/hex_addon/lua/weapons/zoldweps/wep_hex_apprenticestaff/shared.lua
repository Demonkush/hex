if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Apprentice Staff"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee"
SWEP.PrintName          = "Apprentice Staff"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/wooden/staff/w_wooden_staff.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/NecromancerMissileHit3.wav")
SWEP.Primary.Delay          = 0.3
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 2

SWEP.Secondary.Sound          = Sound("wc3sound/exp/GryphonRiderMissileLaunch1.wav")
SWEP.Secondary.Delay          = 1.5
SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"
SWEP.Secondary.ManaCost = 5

-- This is a rough copy of the main staff weapon in Heretic.
-- Apprentice Staff -- Elements: Magic, Fire --
-- Primary Low: Spark
-- Primary Norm: Spark Bolt
-- Primary High: Spark Bolt Shot
-- Secondary Norm: Fire Spark
-- Secondary High: Sun Spark ( Ricochet )

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/NecromancerMissileHit3.wav",85,math.random(100,110))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/NecromancerMissileHit3.wav",85,math.random(100,110))
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

function SWEP:SecondaryAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound(self.Secondary.Sound,85,math.random(85,115))
        self:DoSecondaryAttack("high")
        return
    end

    if mana >= self.Secondary.ManaCost then
        if SERVER then
            self.Owner:SubtractMana(self.Secondary.ManaCost)
        end
        self:EmitSound(self.Secondary.Sound,85,math.random(85,115))
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:DoSecondaryAttack("high")
        else
            self:DoSecondaryAttack("normal")
        end
    else
        -- Do nothing
    end
end

function SWEP:DoPrimaryAttack(output)
    local damage = math.random(13,18)

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end
    local bullet = {}
    bullet.Num      = 1
    bullet.Src      = self.Owner:GetShootPos()
    bullet.Dir      = self.Owner:GetAimVector()
    bullet.Spread   = Vector(0.01, 0.01, 0)
    bullet.Tracer   = 1
    bullet.TracerName = "fx_hex_tracergun"
    bullet.Force    = damage * 0.5
    bullet.Damage   = damage
    bullet.Callback = function(ent,tr,dmg)
        self:ImpactEffect(tr,output,"fx_hex_gunpoof01")
        if SERVER then
            if output != "low" then
                self:AoEBoom(tr,output,"normal")
            end
        end
    end

    self:FireBullets(bullet)

    --self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    --self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end

function SWEP:DoSecondaryAttack(output)
    local damage = math.random(13,18)

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end
    local bullet = {}
    bullet.Num      = 1
    bullet.Src      = self.Owner:GetShootPos()
    bullet.Dir      = self.Owner:GetAimVector()
    bullet.Spread   = Vector(0.01, 0.01, 0)
    bullet.Tracer   = 1
    bullet.TracerName = "fx_hex_tracergun"
    bullet.Force    = damage * 0.5
    bullet.Damage   = damage
    bullet.Callback = function(ent,tr,dmg)
        self:ImpactEffect(tr,output,"fx_hex_gunpoof01")
        if SERVER then
            self:AoEBoom(tr,output,"fire")
            if output == "high" then
                self:Ricochet(math.Round(damage/1.5),tr)
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
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
end

function SWEP:Ricochet(damage,trace)
    local bullet = {}
    bullet.Num      = 1
    bullet.Src      = trace.HitPos
    bullet.Dir      = AngleRand()
    bullet.Spread   = Vector(0.01, 0.01, 0)
    bullet.Tracer   = 1
    bullet.TracerName = "fx_hex_tracergun"
    bullet.Force    = damage * 0.5
    bullet.Damage   = damage
    bullet.Callback = function(ent,tr,dmg)
        self:ImpactEffect(tr,output,"fx_hex_gunpoof01")
        if SERVER then
            if output != "low" then
                self:AoEBoom(tr,output,"fire")
            end
        end
    end

    self:FireBullets(bullet)
end

function SWEP:ImpactEffect(trace,output,efx)
    local hitpos = trace.HitPos
    local scale = 0.5

    if output == "low" then
        scale = 0.3
    end
    if output == "high" then
        scale = 1
        local fx2 = EffectData()
        fx2:SetOrigin( hitpos )
        fx2:SetScale( 0.8 )
        util.Effect( "fx_hex_fireblast01", fx2 )
    end

    local fx = EffectData()
    fx:SetOrigin( hitpos )
    fx:SetScale( scale )
    util.Effect( efx, fx )
end

function SWEP:AoEBoom(trace,op,element)
    local range = 85
    local damage = math.random(10,15)
    if op == "high" then
        range = 95
        damage = damage * 1.2
    end
    for _, v in ipairs(ents.FindInSphere(trace.HitPos,range)) do
        if v != self:GetOwner() then
            local dmginfo = DamageInfo()
            dmginfo:SetAttacker( self:GetOwner() )
            dmginfo:SetInflictor( self )
            dmginfo:SetDamage( damage )
            dmginfo:SetDamageElement(element)
            v:TakeDamageInfo( dmginfo )
        end
    end
end


if( CLIENT ) then
-- Effect taken from the Nomad laser smg weapon. Workshop id: 104516493
    local EFFECT = {}
    function EFFECT:Init( data )
        self.Weapon = data:GetEntity()
        self.Entity:SetRenderBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
        self.Entity:SetParent( self.Weapon )
        self.LifeTime = math.Rand( 0.25, 0.35 )
        self.DieTime = CurTime() + self.LifeTime
        self.Size = math.Rand( 25, 45 )
        
        local pos, ang = GetMuzzlePosition( self.Weapon )
        local light = DynamicLight( self.Weapon:EntIndex() )
        light.Pos               = pos
        light.Size              = 256
        light.Decay             = 400
        light.R                 = 155
        light.G                 = 85
        light.B                 = 255
        light.Brightness        = 2
        light.DieTime           = CurTime() + 0.35
    end
    function EFFECT:Think()
        return IsValid( self.Weapon ) && self.DieTime >= CurTime()
    end
    function EFFECT:Render()
    end
    effects.Register( EFFECT, "MuzzleWand001" )
end