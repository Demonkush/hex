-- 2D Lua Particles by Crashlemon ---
--- -- --- -- --- -- --- -- --- -- --
-- Please do not redistribute!!! - --

-- PERSISTENT DATA
og_2DParticles = og_2DParticles or {}
 
-- METATABLE
 
local og_2DP = {}
og_2DP.__index = og_2DP
local op = og_2DP
 
function op:Create( pos, w, h, param )
 
        param = param or {}
 
        local p = {}
        p.pos                           = pos or Vector( ScrW() * 0.5, ScrH() * 0.5, 0 )                        -- Position
 
        p.w                             = w or 10                                                                                                       -- Width
        p.h                             = h or 10                                                                                                       -- Height
        p.startW                        = p.w
        p.startH                        = p.h
        p.dieW                          = p.w
        p.dieH                          = p.h
 
        p.gravity                       = param.gravity or Vector( 0, 0, 0 )                                            -- Particle Gravity
 
        p.startColor            = param.startColor or Color( 255, 255, 255, 255 )                       -- Start Color
        p.dieColor          = param.dieColor or Color( 255, 255, 255, 0 )                               -- Die Color
        p.drawColor             = p.startColor
 
        p.angle                         = math.NormalizeAngle( param.angle or 0 )                                       -- Starting angle
        p.rotation                      = param.rotation or 0                                                                           -- Rotation speed
        p.velocity                      = param.velocity or Vector( 0, 0, 0 )                                           -- Velocity
 
        p.texture                       = 0                                                                                                             -- Sets the texture                                                                    
 
        p.birth                         = CurTime()                                                                                                     -- Time of birth.
        p.lifetime                      = 2                                                                                                                     -- LifeTime
        p.dietime                       = p.birth + p.lifetime                                                                          -- Death Time
 
        setmetatable( p, og_2DP )
 
        p.index = table.insert( og_2DParticles, p ) -- Insert into persistent table.
 
        return p
 
end
 
-- Pos
function op:SetPos( x, y )                              self.pos = Vector( x, y, 0 ) end
function op:GetPos()                                    return self.pos end
 
-- Size
function op:SetSize( w, h )
        self.w = w
        self.h = h
end
function op:GetSize()                                   return self.w,self.h end
 
-- Start Size
function op:SetStartSize( w, h )
        self.startW = w
        self.startH = h
end
function op:GetStartSize()                              return self.startW,self.startH end
 
-- Die Size
function op:SetDieSize( w, h )
        self.dieW = w
        self.dieH = h
end
function op:GetDieSize()                                return self.dieW,self.dieH end
 
-- Width
function op:SetWidth( w )                               self.w = w end
function op:GetWidth()                                  return self.w end
 
-- Height
function op:SetHeight( h )                              self.h = h end
function op:GetHeight()                                 return self.h end
 
-- Gravity
function op:SetGravity( grav )                  self.gravity = grav end
function op:GetGravity()                                return self.gravity end
 
-- Start Color
function op:SetStartColor( col )                self.startColor = col end
function op:GetStartColor()                             return self.startColor end
 
-- Die Color
function op:SetDieColor( col )                  self.dieColor = col end
function op:GetDieColor()                               return self.dieColor end
 
-- Actual Color
function op:SetDrawColor( col )                 self.drawColor = col end
function op:GetDrawColor()                              return self.drawColor end
 
-- Return the angle
function op:SetAngle( num )                             self.angle = math.NormalizeAngle( num ) end
function op:GetAngle()                                  return self.angle end
 
-- Rotation
function op:SetRotation( num )                  self.rotation = num end
function op:GetRotation()                               return self.rotation end
 
-- Velocity
function op:SetVelocity( vel )                  self.velocity = vel end
function op:GetVelocity()                               return self.velocity end
 
-- Material
function op:SetTexture( tex )                   self.texture = surface.GetTextureID( tex ) end
function op:GetTexture()                                return self.texture end
 
-- Lifetime
function op:SetLifeTime( time )                
        self.lifetime = time
        self:SetDieTime( self.birth + time )
end
function op:GetLifeTime()                               return  self.lifetime end
 
-- Deathtime
function op:SetDieTime( time )                  self.dietime = time end
function op:GetDieTime()                                return self.dietime or CurTime() end
 
-- Lerp Num (0 to 1)
function op:GetLerpNum()                                return math.Clamp( 1 - ( self:GetDieTime() - CurTime() ) / self:GetLifeTime(), 0, 1 ) end
 
 
-- Animate the particle.
function op:Think()
 
        -- Check if we should exist.
        if ( self:GetDieTime() <= CurTime() ) then
                self:Die()
                return
        end
 
        local lerp = self:GetLerpNum()
 
        -- Color
        local scol = self:GetStartColor()
        local dcol = self:GetDieColor()
 
        -- Set the lerped color.
        self:SetDrawColor( Color( Lerp( lerp, scol.r, dcol.r ), Lerp( lerp, scol.g, dcol.g ), Lerp( lerp, scol.b, dcol.b ), Lerp( lerp, scol.a, dcol.a )) )
 
 
        -- Size
        local sW = self.startW
        local sH = self.startH
        local dW = self.dieW
        local dH = self.dieH
 
       
        self:SetSize( Lerp( lerp, sW, dW ), Lerp( lerp, sH, dH ) )
 
        -- Angle rotation.
        self:SetAngle( self:GetAngle() + self:GetRotation() * FrameTime() )
 
        self:SetVelocity( self:GetVelocity() + self:GetGravity() * FrameTime() )
 
        -- Velocity.
        self.pos.x = self.pos.x + self.velocity.x * FrameTime()
        self.pos.y = self.pos.y + self.velocity.y * FrameTime()
 
end
 
-- Draw the particle.
function op:Draw()
 
        if ( !self ) then return end
 
        surface.SetTexture(self:GetTexture() or 0)
        surface.SetDrawColor( self:GetDrawColor() )
        surface.DrawTexturedRectRotated( self.pos.x, self.pos.y, self:GetWidth(), self:GetHeight(), self:GetAngle() )
 
end
 
function op:Die()
        og_2DParticles[self.index] = nil
end
 
--
-- PARTICLE FUNCTIONS
--
 
function OG_Create2DParticle( num )
 
        for i=1,num or 10 do
                local p = op:Create()
                p:SetPos( gui.MouseX(), gui.MouseY() )
                p:SetStartSize( math.random( 0, 10), math.random( 0, 10 ))
                p:SetDieSize( math.random( 30, 50), math.random( 30,50 ))
                p:SetLifeTime( 4 )
                p:SetRotation( math.random( -1000, 1000 ) )
                p:SetPos( p:GetPos().x + math.random( -30, 30 ), p:GetPos().y + math.random( -30, 30 ))
                p:SetStartColor( Color( math.random( 0,255 ), math.random( 0,255 ), math.random( 0,255 ), 255 ))
                p:SetDieColor( Color( math.random( 0,255 ), math.random( 0,255 ), math.random( 0,255 ), 0 ))
                p:SetVelocity( Vector( math.random( -100, 100 ), math.random( -500, -400 ), 0 ))
                p:SetGravity( Vector( math.random( -20, 20 ), 300, 0 ) )
        end
end


-- Morbus Particles
function MOR_2DMSGSysEffect1( num, x, x2, y, col, texture )
        for i=1,num or 10 do
                local p = op:Create()
                p:SetTexture(texture)
                p:SetPos( ScrW()/2-math.random(98,302), ScrH()-math.random(90,100) )
                p:SetStartSize( math.random( 165, 175), math.random( 55, 65 ))
                p:SetDieSize( math.random( 0, 5), math.random( 0,5 ))
                p:SetLifeTime( 2 )
                p:SetRotation( 0 )
                p:SetPos( x + math.random(-5,x2), 25 + math.random(-y,y) )
                p:SetStartColor( col )
                p:SetDieColor( col )
                p:SetVelocity( Vector( 0, 0, 0 ))
                p:SetGravity( Vector( math.random(-100,0), 0, 0 ) )
        end
end
function MOR_2DMSGSysEffect2( num, x, x2, y, col, texture )
        for i=1,num or 10 do
                local p = op:Create()
                p:SetTexture(texture)
                p:SetPos( ScrW()/2-math.random(98,302), ScrH()-math.random(90,100) )
                p:SetStartSize( math.random( 25, 35), math.random( 5, 10 ))
                p:SetDieSize( math.random( 0, 5), math.random( 0,5 ))
                p:SetLifeTime( 1 )
                p:SetRotation( math.random( -10, 10 ) )
                p:SetPos( x + math.random(-5,x2), 25 + math.random(-y,y) )
                p:SetStartColor( col )
                p:SetDieColor( col )
                p:SetVelocity( Vector( 0, 0, 0 ))
                p:SetGravity( Vector( math.random(-512,0), 0, 0 ) )
        end
end
function MOR_2DWepSwitchEffect( num, x, x2, y, col, texture )
        for i=1,num or 2 do
                local p = op:Create()
                p:SetTexture(texture)
                p:SetPos( ScrW()/2-math.random(98,302), ScrH()-math.random(90,100) )
                p:SetStartSize( math.random( 25, 45), math.random( 5, 15 ))
                p:SetDieSize( math.random( 0, 1), math.random( 0,2 ))
                p:SetLifeTime( 0.5 )
                p:SetRotation( math.random( -10, 10 ) )
                p:SetPos( x + math.random(5,x2), y + math.random(-15,15) )
                p:SetStartColor( col )
                p:SetDieColor( col )
                p:SetVelocity( Vector( 0, 0, 0 ))
                p:SetGravity( Vector( math.random(-250,0), 0, 0 ) )
        end
end

function HEX_TestHealthParticles( num )

        for i=1,num or 10 do
                local p = op:Create()
                p:SetPos( ScrW()/2-math.random(98,302), ScrH()-math.random(90,100) )
                p:SetStartSize( math.random( 0, 10), math.random( 0, 10 ))
                p:SetDieSize( math.random( 0, 5), math.random( 0,5 ))
                p:SetLifeTime( 1 )
                p:SetRotation( math.random( -10, 10 ) )
                p:SetPos( p:GetPos().x + math.random( -30, 30 ), p:GetPos().y + math.random( -30, 30 ))
                p:SetStartColor( Color( math.random( 215,255 ), math.random( 125,155 ), math.random( 125,155 ), 25 ))
                p:SetDieColor( Color( math.random( 155,255 ), math.random( 0,55 ), math.random( 0,55 ), 0 ))
                p:SetVelocity( Vector( 0, 0, 0 ))
                p:SetGravity( Vector( math.random(-100,0), 0, 0 ) )
        end
end

function HEX_TestManaParticles( num )

        for i=1,num or 10 do
                local p = op:Create()
                p:SetPos( ScrW()/2+math.random(98,302), ScrH()-math.random(90,100) )
                p:SetStartSize( math.random( 0, 10), math.random( 0, 10 ))
                p:SetDieSize( math.random( 0, 5), math.random( 0,5 ))
                p:SetLifeTime( 1 )
                p:SetRotation( math.random( -10, 10 ) )
                p:SetPos( p:GetPos().x + math.random( -30, 30 ), p:GetPos().y + math.random( -30, 30 ))
                p:SetStartColor( Color( math.random( 125,155 ), math.random( 125,155 ), math.random( 215,255 ), 25 ))
                p:SetDieColor( Color( math.random( 0,55 ), math.random( 0,55 ), math.random( 155,255 ), 0 ))
                p:SetVelocity( Vector( 0, 0, 0 ))
                p:SetGravity( Vector( math.random(0,100), 0, 0 ) )
        end
end
 
-- Creates a number of particle squares at pos.
-- w: Total Width
-- h: Total Height
-- nW: Number per width.
-- nH: Number per height.
function Create2DParticles( pos, w, h, numW, numH )
 
        -- Basic variables.
        pos             = pos or { x = 0, y = 0 }
        w                       = w or 10
        h                       = h or 10
        numW            = numW or 1
        numH            = numH or 1
 
        local pW        = w / nW                -- Single particle width
        local pH        = h / nH                -- Single particle height
 
        local particles = {}            -- Table that holds the temporary particles.
 
end
 
-- This animates the square particles.
function Think2DParticles()
 
        --OG_Create2DParticle( 2 )
 
        if ( !og_2DParticles ) then return end
 
        -- Iterate through all the particles and either animate
        -- or remove them if they are expired.
        for k,p in pairs( og_2DParticles ) do
 
                p:Think()
 
        end
 
end
hook.Add( "Think", "OG_2DParticle_Think", Think2DParticles )
 
-- This animates the square particles.
function Draw2DParticles()
 
        if ( !og_2DParticles ) then return end
 
        -- Iterate through all the particles and either animate
        -- or remove them if they are expired.
        for k,p in pairs( og_2DParticles ) do
 
                p:Draw()
 
        end
 
end
hook.Add( "HUDPaint", "OG_2DParticle_Draw", Draw2DParticles )