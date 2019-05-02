
display.setDefault( "background", 100/255, 100/255, 200/255 )



-- Gravity



local physics = require( "physics" )



physics.start()

physics.setGravity( 0, 25 ) -- ( x, y )

--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only



local playerBullets = {} -- Table that holds the players Bullets



--leftwall

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )

-- myRectangle.strokeWidth = 3

-- myRectangle:setFillColor( 0.5 )

-- myRectangle:setStrokeColor( 1, 0, 0 )

leftWall.alpha = 0.0

leftWall.id = "left wall"

physics.addBody( leftWall, "static", { 

    friction = 0.5, 

    bounce = 0.3 

    } )

--local rightWall = display.newRect( 400, 0, display.contentHeight / 3 , display.contentHeight + 400 )





--ground

local theGround = display.newImage( "land.png" )

theGround.x = - 190

theGround.y = 480

theGround.id = "the ground"

physics.addBody( theGround, "static", { 

    friction = 0.5, 

    bounce = 0.3 

    } )





--charater

local Man = display.newImageRect( "Bullet.png", 175, 175 )

Man.x = display.contentCenterX

Man.y = 200

Man.id = "the character"

physics.addBody( Man, "dynamic", { 

    density = 3.0, 

    friction = 0.5, 

    bounce = 0.3 

    } )

Man.isFixedRotation = true



-- Character move

local dPad = display.newImageRect( "d-pad.png", 125, 125 )

dPad.x = 80

dPad.y = 440

dPad.id = "d-pad"





local upArrow = display.newImageRect( "upArrow.png", 30, 22 )

upArrow.x = 80

upArrow.y = 393

upArrow.id = "up arrow"



local downArrow = display.newImageRect( "downArrow.png", 30, 22 )

downArrow.x = 80

downArrow.y = 486

downArrow.id = "down arrow"



local leftArrow = display.newImageRect( "leftArrow.png", 22, 30 )

leftArrow.x = 34

leftArrow.y = 440

leftArrow.id = "left arrow"



local rightArrow = display.newImageRect( "rightArrow.png", 22, 30 )

rightArrow.x = 126

rightArrow.y = 440

rightArrow.id = "right arrow"



local jumpButton = display.newImageRect( "jumpButton.png", 30, 30 )

jumpButton.x = 80

jumpButton.y = 440

jumpButton.id = "right arrow"



local shootButton = display.newImageRect( "jumpButton.png", 60, 60 )

shootButton.x = 245

shootButton.y = 440

shootButton.id = "shootButton"

shootButton.alpha = 1





--functions 

function upArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character up

        transition.moveBy( Man, { 

            x = 0, -- move 0 in the x direction 

            y = -50, -- move up 50 pixels

            time = 100 -- move in a 1/10 of a second

            } )

    end



    return true

end



function downArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character up

        transition.moveBy( Man, { 

            x = 0, -- move 0 in the x direction 

            y = 50, -- move up 50 pixels

            time = 100 -- move in a 1/10 of a second

            } )

    end



    return true

end



function leftArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character up

        transition.moveBy( Man, { 

            x = -50, -- move 0 in the x direction 

            y = 0, -- move up 50 pixels

            time = 100 -- move in a 1/10 of a second

            } )

    end



    return true

end



function rightArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character up

        transition.moveBy( Man, { 

            x = 50, -- move 0 in the x direction 

            y = 0, -- move up 50 pixels

            time = 100 -- move in a 1/10 of a second

            } )

    end



    return true

end



function jumpButton:touch( event )

    if ( event.phase == "ended" ) then

        -- make the character jump

        Man:setLinearVelocity( 0, -750 )

    end



    return true

end



function shootButton:touch( event )

    if ( event.phase == "began" ) then

        -- make a bullet appear

        local aSingleBullet = display.newImageRect( "M4.png", 80, 80)

        aSingleBullet.x = Man.x

        aSingleBullet.y = Man.y - 75

        physics.addBody( aSingleBullet, 'dynamic' )

        -- Make the object a "bullet" type object

        aSingleBullet.isBullet = true

        aSingleBullet.gravityScale = 0

        aSingleBullet.id = "bullet"

        aSingleBullet:setLinearVelocity(  0, 250 )



        table.insert(playerBullets,aSingleBullet)

        print("# of bullet: " .. tostring(#playerBullets))

    end



    return true

end



local function characterCollision( self, event )

 

    if ( event.phase == "began" ) then

        print( self.id .. ": collision began with " .. event.other.id )

        if event.other.id == "dynamite" then

            print("yeet")

        end

 

    elseif ( event.phase == "ended" ) then

        print( self.id .. ": collision ended with " .. event.other.id )

    end

end



function checkPlayerBulletsOutOfBounds()

    -- check if any bullets have gone off the screen

    local bulletCounter



    if #playerBullets > 0 then

        for bulletCounter = #playerBullets, 1 ,-1 do

            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then

                playerBullets[bulletCounter]:removeSelf()

                playerBullets[bulletCounter] = nil

                table.remove(playerBullets, bulletCounter)

                print("remove bullet")

            end

        end

    end

end



function checkCharacterPosition( event )

    -- check every frame to see if character has fallen

    if Man.y > display.contentHeight + 500 then

        Man.x = display.contentCenterX

        Man.y = display.contentCenterY

    end

end



upArrow:addEventListener( "touch", upArrow )

downArrow:addEventListener( "touch", downArrow )

leftArrow:addEventListener( "touch", leftArrow )

rightArrow:addEventListener( "touch", rightArrow )

jumpButton:addEventListener( "touch", jumpButton )

shootButton:addEventListener( "touch", shootButton )



Runtime:addEventListener( "enterFrame", checkCharacterPosition )

Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )



Man.collision = characterCollision

Man:addEventListener( "collision" )
