if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Umbra Ray"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "shotgun"
SWEP.PrintName          = "Umbra Ray"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_rif_draenei_rifle.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/PriestCastAttack1.wav")
SWEP.Primary.Delay          = 0.15
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 2

SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

-- Umbra Ray -- Elements: Magic --
-- Primary Low: Magic Stab
-- Primary Norm: Beam
-- Primary High: Beam Blast
-- Hidden Power: Hyper Ray ( Constant Laser Cannon )

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Magesoul") == 1 then
        self:MagesoulAbility()
        if self.Owner:GetNWInt("Overpowered") == 0 then
            if SERVER then
                self.Owner:SubtractMana(self.Primary.ManaCost)
            end
        end
        return
    end

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/exp/OrbOfCorruptionMissile.wav",85,math.random(135,145))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/exp/OrbOfCorruptionMissile.wav",85,math.random(135,145))
            self:DoPrimaryAttack("high")
        else
            self:EmitSound(self.Primary.Sound,85,math.random(125,135))
            self:DoPrimaryAttack("normal")
        end
    else
        self:EmitSound(self.Primary.Sound,40,math.random(145,155))
        self:DoPrimaryAttack("low")
    end
end

function SWEP:MagesoulAbility()
    local damage = math.random(8,10)
    local tracer = "fx_hex_lasermagicsuper"
    local atkspdup = 0.1
    local output = "high"

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
    print(dmg:GetInflictor())
        if SERVER then
            dmg:SetAttacker(self:GetOwner())
            dmg:SetDamageElement("magic")
            if output == "high" then
                self:AoEBoom(tr,output)
            end
        end
        self:ImpactEffect(tr,output)
    end

    self:FireBullets(bullet)

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod+atkspdup))
end

function SWEP:DoPrimaryAttack(output)
    local damage = math.random(2,5)
    local tracer = "fx_hex_tracermagic"
    local atkspddown = 0

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
        if SERVER then
            dmg:SetAttacker(self:GetOwner())
            dmg:SetDamageElement("magic")
            if output != "low" then
                self:AoEBoom(tr,output)
            end
        end
        self:ImpactEffect(tr,output)
    end

    self:FireBullets(bullet)

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod)+atkspddown)
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
    local range = 45
    local damage = math.random(3,6)
    local element = "magic"
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
        light.R                 = 195
        light.G                 = 215
        light.B                 = 255
        light.Brightness        = 2
        light.DieTime           = CurTime()+0.35
    end
    function EFFECT:Think()
        return IsValid(self.Weapon) && self.DieTime >= CurTime()
    end
    function EFFECT:Render() end
    effects.Register(EFFECT,"MuzzleGun001")
end