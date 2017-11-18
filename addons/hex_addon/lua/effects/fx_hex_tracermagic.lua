TRACER_FLAG_USEATTACHMENT	= 0x0002

EFFECT.Speed				= 9000
EFFECT.Length				= 256

local MaterialGlow			= Material( "hexgm/sprites/tracers/air/airglow_1.png"  )
local MaterialMuzzle		= Material( "hexgm/sprites/tracers/demon/mor_tracer_01.png"  )

function EFFECT:GetTracerOrigin( data )
	local start = data:GetStart()
	
	if( bit.band( data:GetFlags(), TRACER_FLAG_USEATTACHMENT ) == TRACER_FLAG_USEATTACHMENT ) then

		local entity = data:GetEntity()
		
		if( not IsValid( entity ) ) then return start; end
		if( not game.SinglePlayer() and entity:IsEFlagSet( EFL_DORMANT ) ) then return start; end
		
		if( entity:IsWeapon() and entity:IsCarriedByLocalPlayer() ) then
			local pl = entity:GetOwner()
			if( IsValid( pl ) ) then
				local vm = pl:GetViewModel()
				if( IsValid( vm ) and not LocalPlayer():ShouldDrawLocalPlayer() ) then
					entity = vm
				else
					if( entity.WorldModel ) then
						entity:SetModel( entity.WorldModel )
					end
				end
			end
		end

		local attachment = entity:GetAttachment( data:GetAttachment() )
		if( attachment ) then
			start = attachment.Pos
		end

	end
	
	return start
end

function EFFECT:Init( data )
	self.StartPos = self:GetTracerOrigin( data )
	self.EndPos = data:GetOrigin()

	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )

	local diff = ( self.EndPos - self.StartPos )
	
	self.Normal = diff:GetNormal()
	self.StartTime = 0
	self.LifeTime = ( diff:Length() + self.Length ) / self.Speed
end

function EFFECT:Think()
	self.LifeTime = self.LifeTime - FrameTime()
	self.StartTime = self.StartTime + FrameTime();

	return self.LifeTime > 0
end

function EFFECT:Render()
	local endDistance = self.Speed * self.StartTime
	local startDistance = endDistance - self.Length
	
	startDistance = math.max( 0, startDistance )
	endDistance = math.max( 0, endDistance )

	local startPos = self.StartPos + self.Normal * startDistance
	local endPos = self.StartPos + self.Normal * endDistance
	
	--render.SetMaterial( MaterialGlow )
	--render.DrawSprite( endPos, 4, 4, Color( 55, 155, 255, 255 ) )

	render.SetMaterial( MaterialMuzzle )
	render.DrawBeam( startPos, endPos, 10, 0, 1, Color( 235, 155, 255, 255 ) )

	render.SetMaterial( MaterialMuzzle )
	render.DrawBeam( startPos, endPos, 2, 0, 1, Color( 235, 185, 255, 155 ) )
end