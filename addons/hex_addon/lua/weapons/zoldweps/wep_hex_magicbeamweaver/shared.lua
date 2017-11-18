if (SERVER) then
    AddCSLuaFile("shared.lua")
end

if (CLIENT) then
    SWEP.PrintName      = "Magic Beamweaver"
    SWEP.Slot           = 1
    SWEP.SlotPos        = 1
    SWEP.ViewModelFlip  = false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "ar2"
SWEP.PrintName          = "Magic Beamweaver"
SWEP.Spawnable          = true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_rif_draenei_rifle.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/NecromancerMissileHit3.wav")
SWEP.Primary.Delay          = 0.15
SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ManaCost = 2

SWEP.Secondary.Sound          = Sound("wc3sound/exp/GryphonRiderMissileLaunch1.wav")
SWEP.Secondary.Delay          = 1.5
SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"
SWEP.Secondary.ManaCost = 6

-- Magic Beamweaver -- Elements: Magic / Storm --
-- Primary Low: Arcane Shot
-- Primary Norm: Arcane Beam
-- Primary High: Arcane Hyperbeam
-- Secondary Norm: Static Ball
-- Secondary High: Black Static Ball

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound(self.Primary.Sound,65,math.random(75,85))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound(self.Primary.Sound,65,math.random(75,85))
            self:DoPrimaryAttack("high")
        else
            self:EmitSound(self.Primary.Sound,45,math.random(145,155))
            self:DoPrimaryAttack("normal")
        end
    else
        self:EmitSound(self.Primary.Sound,45,math.random(155,165))
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
    local gravity = true
    local damage = math.random(8,10)
    local tracer = "fx_hex_tracermagic"
    local atkspddown = 0

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if output == "normal" then
        tracer = "fx_hex_lasermagic"
    end

    if output == "high" then
        tracer = "fx_hex_lasermagicsuper"
        atkspddown = 1
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
            if output == "high" then
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

function SWEP:DoSecondaryAttack(output)
    local projent = "ent_hex_proj_staticorb"
    local gravity = false

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if SERVER then
        local tr, projrec = self.Owner:GetEyeTrace(), 1
        local ent = ents.Create( projent )
        ent:SetPos(self.Owner:GetShootPos()+(self.Owner:GetForward()*55))
        ent:SetOwner( self.Owner )
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()

        ent.Weapon = "a "..self.PrintName

        ent:SetPower(output)

        local phys = ent:GetPhysicsObject()
        phys:ApplyForceCenter(self.Owner:GetAimVector() + self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 20000)
        phys:SetVelocity(phys:GetVelocity() + self.Owner:GetAimVector()+(VectorRand()*projrec))
        phys:EnableGravity(gravity)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleWand002", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
end

function SWEP:ImpactEffect(trace,output)
    local hitpos = trace.HitPos
    local scale = 0.5
    local efx = "fx_hex_arcaneblast01"

    if output == "low" then
        scale = 0.3
    end
    if output == "high" then
        scale = 1.5
        efx = "fx_hex_arcaneblast02"
        sound.Play( "blackpowder.Boom", hitpos, 75, 135 )
    end

    local fx = EffectData()
    fx:SetOrigin( hitpos )
    fx:SetScale( scale )
    util.Effect( efx, fx )
    if output == "low" then return end
    local fx2 = EffectData() fx2:SetOrigin( hitpos ) fx2:SetScale(scale)
    fx2:SetAngles(Angle(125,50,150))
    util.Effect( "fx_hex_model_blast", fx2 )
end

function SWEP:AoEBoom(trace,op)
    local range = 85
    local damage = math.random(10,15)
    local element = "magic"
    if op == "high" then
        range = 125
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
        if v:IsPlayer() then
            v:SetVelocity((v:GetPos()-trace.HitPos)*4)
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
        light.G                 = 55
        light.B                 = 255
        light.Brightness        = 2
        light.DieTime           = CurTime() + 0.35
    end
    function EFFECT:Think()
        return IsValid( self.Weapon ) && self.DieTime >= CurTime()
    end
    function EFFECT:Render()
    end
    effects.Register( EFFECT, "MuzzleGun002" )
end