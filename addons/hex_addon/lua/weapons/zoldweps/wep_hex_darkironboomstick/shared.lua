if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Darkiron Boomstick"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "ar2"
SWEP.PrintName          = "Darkiron Boomstick"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_rif_blunderbuss.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/NecromancerMissileHit3.wav")
SWEP.Primary.Delay          = 0.8
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 3

SWEP.Secondary.Sound          = Sound("wc3sound/exp/GryphonRiderMissileLaunch1.wav")
SWEP.Secondary.Delay          = 1.5
SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"
SWEP.Secondary.ManaCost = 7

-- Darkiron Boomstick -- Elements: Physical / Fire --
-- Primary Low: Blank Shot
-- Primary Norm: Regular Shot
-- Primary High: Explosive Shot
-- Secondary Norm: Gun Bomb
-- Secondary High: Fragmentation

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/NecromancerMissileHit3.wav",85,math.random(75,85))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/NecromancerMissileHit3.wav",85,math.random(75,85))
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
    local br = math.random(1,2)
    local bullet = {}
    bullet.Num      = br
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
                self:AoEBoom(tr,output)
            end
        end
    end

    self:FireBullets(bullet)
    local dfc = math.random(1,3)
    if dfc == 3 then
        timer.Simple(0.2,function()
            if IsValid(self) then self:EmitSound("wc3sound/NecromancerMissileHit3.wav",65,math.random(100,125)) self:FireBullets(bullet) end
        end)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end

function SWEP:DoSecondaryAttack(output)
    local projent = "ent_hex_proj_gunbomb"
    local gravity = true

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
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
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
    if output == "high" then
        local fx2 = EffectData() fx2:SetOrigin( hitpos ) fx2:SetScale(scale)
        fx2:SetAngles(Angle(55,55,55))
        util.Effect( "fx_hex_model_blast", fx2 )
    end
end

function SWEP:AoEBoom(trace,op)
    local range = 85
    local damage = math.random(10,15)
    local element = "physical"
    if op == "high" then
        range = 125
        damage = damage * 1.2
        element = "fire"
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
        light.R                 = 255
        light.G                 = 155
        light.B                 = 55
        light.Brightness        = 2
        light.DieTime           = CurTime() + 0.35
    end
    function EFFECT:Think()
        return IsValid( self.Weapon ) && self.DieTime >= CurTime()
    end
    function EFFECT:Render()
    end
    effects.Register( EFFECT, "MuzzleGun001" )
end