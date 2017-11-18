if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Gale Staff"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee2"
SWEP.PrintName          = "Gale Staff"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/wooden/staff/w_wooden_staff.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/SearingArrowTarget3.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.003
SWEP.Primary.Delay          = 1.5
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 3

SWEP.Secondary.Sound          = Sound("wc3sound/SearingArrowTarget3.wav")
SWEP.Secondary.Delay          = 3
SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = false
SWEP.Secondary.Ammo             = "none"
SWEP.Secondary.ManaCost = 10
SWEP.Secondary.AttackRange = 1000
SWEP.Secondary.AttackPrepared = false

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end

    if self.Owner:GetNWInt("Mana") >= self.Primary.ManaCost then
        if SERVER then
            self.Owner:SubtractMana(self.Primary.ManaCost)
        end
        self:EmitSound(self.Primary.Sound)
        self:ShootGust()
        self:PrepareAttack(false)
    else
        self:PrepareAttack(false)
        return
    end
end

function SWEP:SecondaryAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end

    if self.Owner:GetNWString("PreparingAttack")==false then
        self:PrepareAttack(true)
        self:SetNextPrimaryFire(CurTime()+1)
        return
    end

    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos()+(self.Owner:GetAimVector()*self.Secondary.AttackRange)
    tr.filter = self.Owner
    local trace = util.TraceLine(tr)

    if trace.Hit then

        if self.Owner:GetNWInt("Mana") >= self.Secondary.ManaCost then
            if SERVER then
                self.Owner:SubtractMana(self.Secondary.ManaCost)
            end
            self:EmitSound(self.Secondary.Sound)
            self:SpawnWindTunnel()
            self:PrepareAttack(false)
        else
            self:PrepareAttack(false)
            return
        end

    end
end

function SWEP:ShootGust()

    local fx = EffectData()
    fx:SetOrigin( self.Owner:GetPos() + Vector(0,0,32) )
    fx:SetNormal( self.Owner:GetAimVector() )
    util.Effect( "fx_hex_windgust", fx )

    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos()+(self.Owner:GetAimVector()*200)
    tr.filter = self.Owner
    local trace = util.TraceLine(tr)

    if trace.Hit == true then
        self.Owner:SetVelocity((self.Owner:GetPos()-trace.HitPos)*2+Vector(0,0,255))
    end

    local tr2 = {}
    tr2.start = self.Owner:GetShootPos()
    tr2.endpos = self.Owner:GetShootPos()+(self.Owner:GetAimVector()*450)
    tr2.filter = self.Owner
    local trace2 = util.TraceLine(tr2)

    if SERVER then
            for _, v in ipairs(ents.FindInSphere(self.Owner:GetPos()+(self.Owner:GetAimVector()*150),125)) do
                self:DoGust(v,10)
            end
        if !trace.Hit then
            for _, v in ipairs(ents.FindInSphere(self.Owner:GetPos()+(self.Owner:GetAimVector()*450),125)) do
                self:DoGust(v,5)
            end
        end 
        if !trace2.Hit then
            for _, v in ipairs(ents.FindInSphere(self.Owner:GetPos()+(self.Owner:GetAimVector()*700),125)) do
                self:DoGust(v,2)
            end
        end
    end
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end

function SWEP:DoGust(vic,power)
    if vic:IsPlayer() then
        local vel = ( ( vic:GetPos() - self.Owner:GetPos() ) * (power/2) )
        vel = Vector(math.Clamp(vel.x,-700,700),math.Clamp(vel.y,-700,700),math.Clamp(vel.z,-700,700))

        if vic != self.Owner then

            local dmginfo = DamageInfo()
            dmginfo:SetAttacker( self.Owner )
            dmginfo:SetInflictor( self )
            dmginfo:SetDamage( math.random(3,5+power) )
            vic:TakeDamageInfo( dmginfo )

            vic:SetVelocity(vel+Vector(0,0,255))
        end
    else
        vic:TakeDamage(15)
    end
end

function SWEP:SpawnWindTunnel()

    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos()+(self.Owner:GetAimVector()*self.Secondary.AttackRange)
    tr.filter = self.Owner
    local trace = util.TraceLine(tr)

    if trace.Hit == true then

        if SERVER then
            local ent = ents.Create( "ent_hex_windtunnel" )
            ent:SetPos(trace.HitPos)
            ent:SetOwner( self.Owner )
            ent:Spawn()
        end

    end

    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    self:SetNextPrimaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
    self:SetNextSecondaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
end
