
SoundManager = Core.class()

local channel

function SoundManager.setup()
	SoundManager.effects = {
							Sound.new("sounds/guitar1.mp3"),
							Sound.new("sounds/guitar2.mp3"),
							Sound.new("sounds/guitar3.mp3"),
							Sound.new("sounds/guitar4.mp3"),
							Sound.new("sounds/guitar5.mp3"),
							Sound.new("sounds/guitar6.mp3"),
							Sound.new("sounds/guitar7.mp3"),
							Sound.new("sounds/piano_a.wav"), -- index == 8
							Sound.new("sounds/piano_b.wav"),
							Sound.new("sounds/piano_c.wav"),
							}
							
	SoundManager.music_enabled = false
	SoundManager.enabled = true
end

-- Play background music
function SoundManager.play_music()
		
	if (channel) then
		channel:stop()
	end
	
	if (SoundManager.music_enabled) then
		channel = SoundManager.music:play()
		channel:setVolume(0.5)
	end
end

-- Play guitar sound
function SoundManager.play_effect(index)

	if (SoundManager.enabled and index) then
		local sound = SoundManager.effects[index]
		local channel = sound:play()
		
		return channel
	end
end

-- Play a guitar melody depending on linked number of dots
function SoundManager.play_melody(num_dots)
	
	local index = math.random(5)
	local channel = SoundManager.play_effect(index)
	
	if (num_dots > 3) then
		channel:addEventListener(Event.COMPLETE, 
	 						function(e)
														
								if (num_dots >=7) then
									SoundManager.play_effect(7)
								else
									SoundManager.play_effect(6)
								end
							end)
	end
end

--[[
function SoundManager.play_pickup()
	if not SoundManager.effects then
		SoundManager.setup()
	end
	
	local sound = SoundManager.effects["pickup"]
	sound:play()
end

function SoundManager.play_hohoho()
	if not SoundManager.effects then
		SoundManager.setup()
	end
	
	local sound = SoundManager.effects["hohoho"]
	sound:play()
end
]]--