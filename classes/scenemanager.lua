--[[
SceneManager v1.0.5

changelog:
----------

v1.0.5 - 11.04.2012
Refactoring ...

v1.0.4 - 08.04.2012
Added option to filter a list of events during transitions
Moved increment of time to end of onEnterFrame so that time goes from 0 to 1
Added additional "real time" argument to dispatched transitions 
Added option to pass user data to a scene when it gets created

v1.0.3 - 19.11.2011
Fixed incorrect calculation of width/height in landscape modes

v1.0.2 - 17.11.2011
Change event names

v1.0.1 - 06.11.2011
Add collectgarbage() to the end of transition

v1.0 - 06.11.2011
Initial release


This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2012 Gideros Mobile 
]]

Transition = {}

function Transition.interval(t, interval, default, transition)
	if t >= interval[1] and t<=interval[2] then
           transition((t - interval[1])/(interval[2]-interval[1])) -- linear mapping of interval to 0,1
        else
           transition(default)
	end
end

function Transition.outToRight(scene, t, width)
	scene:setX(   t  * width)
end

function Transition.inFromRight(scene, t, width)
	scene:setX((1-t) * width)
end

function Transition.outToLeft(scene, t, width)
	scene:setX(  -t  * width)
end

function Transition.inFromLeft(scene, t, width)
	scene:setX((t-1) * width)
end

function Transition.outToBottom(scene, t, height)
	scene:setY(   t  * height)
end

function Transition.inFromBottom(scene, t, height)
	scene:setY((1-t) * height)
end

function Transition.outToTop(scene, t, height)
	scene:setY(  -t  * height)
end

function Transition.inFromTop(scene, t, height)
	scene:setY((t-1) * height)
end

function Transition.fadeIn(scene, t)
	scene:setAlpha(t)
end

function Transition.fadeOut(scene, t)
	scene:setAlpha(1-t)
end

function Transition.shade(scene, t)
	scene:setColorTransform(1-t, 1-t, 1-t)
end

function Transition.unshade(scene, t)
	scene:setColorTransform(t, t, t)
end

function Transition.horizontalShrink(scene, t, width)
	scene:setScaleX(1-t)
        scene:setX(t * width/2)
end

function Transition.horizontalExpand(scene, t, width)
	scene:setScaleX(t)
        scene:setX((1-t) * width/2)
end

function Transition.verticalShrink(scene, t, height)
	scene:setScaleY(1-t)
        scene:setY(t * height/2)
end

function Transition.verticalExpand(scene, t, height)
	scene:setScaleY(t)
	scene:setY((1-t) * height/2)
end

function Transition.rotate(scene, t, startAngle, stopAngle)
	scene:setRotation((stopAngle - startAngle) * t + startAngle)
end


SceneManager = Core.class(Sprite)

function SceneManager.moveFromRight(scene1, scene2, t)
	local width = application:getContentWidth()
	Transition.outToLeft(scene1, t, width)
	Transition.inFromRight(scene2, t, width)
end

function SceneManager.moveFromLeft(scene1, scene2, t)
	local width = application:getContentWidth()
	Transition.outToRight(scene1, t, width)
	Transition.inFromLeft(scene2, t, width)
end

function SceneManager.overFromRight(scene1, scene2, t)
	local width = application:getContentWidth()
	Transition.inFromRight(scene2, t, width)
end

function SceneManager.overFromLeft(scene1, scene2, t)
	local width = application:getContentWidth()
	Transition.inFromLeft(scene2, t, width)
end

function SceneManager.moveFromRightWithFade(scene1, scene2, t)
	local width = application:getContentWidth()
        SceneManager.moveFromRight(scene1, scene2, t)
        Transition.fadeOut(scene1, t)
end

function SceneManager.moveFromLeftWithFade(scene1, scene2, t)
	local width = application:getContentWidth()
        SceneManager.moveFromLeft(scene1, scene2, t)
        Transition.fadeOut(scene1, t)
end

function SceneManager.overFromRightWithFade(scene1, scene2, t)
	local width = application:getContentWidth()
        Transition.fadeOut(scene1, t)
	Transition.inFromRight(scene2, t, width)
end

function SceneManager.overFromLeftWithFade(scene1, scene2, t)
	local width = application:getContentWidth()
        Transition.fadeOut(scene1, t)
	Transition.inFromLeft(scene2, t, width)
end

function SceneManager.moveFromBottom(scene1, scene2, t)
	local height = application:getContentHeight()
	Transition.outToTop(scene1, t, height)
	Transition.inFromBottom(scene2, t, height)
end

function SceneManager.moveFromTop(scene1, scene2, t)
	local height = application:getContentHeight()
	Transition.outToBottom(scene1, t, height)
	Transition.inFromTop(scene2, t, height)
end

function SceneManager.overFromBottom(scene1, scene2, t)
	local height = application:getContentHeight()
	Transition.inFromBottom(scene2, t, height)
end

function SceneManager.overFromTop(scene1, scene2, t)
	local height = application:getContentHeight()
	Transition.inFromTop(scene2, t, height)
end

function SceneManager.moveFromBottomWithFade(scene1, scene2, t)
	local height = application:getContentHeight()
        SceneManager.moveFromBottom(scene1, scene2, t)
        Transition.fadeOut(scene1, t)
end

function SceneManager.moveFromTopWithFade(scene1, scene2, t)
	local height = application:getContentHeight()
        SceneManager.moveFromTop(scene1, scene2, t)
        Transition.fadeOut(scene1, t)
end

function SceneManager.overFromBottomWithFade(scene1, scene2, t)
	local height = application:getContentHeight()
	Transition.fadeOut(scene1, t)
	Transition.inFromBottom(scene2, t, height)
end

function SceneManager.overFromTopWithFade(scene1, scene2, t)
	local height = application:getContentHeight()
	Transition.fadeOut(scene1, t)
	Transition.inFromTop(scene2, t, height)
end

function SceneManager.fade(scene1, scene2, t)
	Transition.interval(t, { 0.0, 0.5 }, 1, function(t) Transition.fadeOut(scene1, t) end)
	Transition.interval(t, { 0.5, 1.0 }, 0, function(t) Transition.fadeIn (scene2, t) end)
end

function SceneManager.crossfade(scene1, scene2, t)
	Transition.fadeOut(scene1, t)
	Transition.fadeIn(scene2, t)
end

function SceneManager.flip(scene1, scene2, t)
	local width = application:getContentWidth()
	Transition.interval(t, { 0.0, 0.5 }, 1, function(t) Transition.horizontalShrink(scene1, t, width) end)
	Transition.interval(t, { 0.5, 1.0 }, 0, function(t) Transition.horizontalExpand(scene2, t, width) end)
end

function SceneManager.flipWithFade(scene1, scene2, t)
	local width = application:getContentWidth()
	Transition.interval(t, { 0.0, 0.5 }, 1, function(t) Transition.horizontalShrink(scene1, t, width) end)
	Transition.interval(t, { 0.5, 1.0 }, 0, function(t) Transition.horizontalExpand(scene2, t, width) end)
        SceneManager.fade(scene1, scene2, t)
end

function SceneManager.flipWithShade(scene1, scene2, t)
	local width = application:getContentWidth()
        SceneManager.flip(scene1, scene2, t)
	Transition.interval(t, { 0.0, 0.5 }, 1, function(t) Transition.shade(scene1, t) end)
	Transition.interval(t, { 0.5, 1.0 }, 0, function(t) Transition.unshade(scene2, t) end)
end

function SceneManager.zoomOutZoomIn(scene1, scene2, t)
	local width  = application:getContentWidth()
	Transition.interval(t, { 0.0, 0.5 }, 1, function(t) Transition.horizontalShrink(scene1, t, width) end)
	Transition.interval(t, { 0.5, 1.0 }, 0, function(t) Transition.horizontalExpand(scene2, t, width) end)

	local height = application:getContentHeight()
	Transition.interval(t, { 0.0, 0.5 }, 1, function(t) Transition.verticalShrink(scene1, t, height) end)
	Transition.interval(t, { 0.5, 1.0 }, 0, function(t) Transition.verticalExpand(scene2, t, height) end)
end

function SceneManager.rotatingZoomOutZoomIn(scene1, scene2, t)
	SceneManager.zoomOutZoomIn(scene1, scene2, t)
	Transition.rotate(scene1, t, 0, 720)
	Transition.rotate(scene2, t, 0, 720)
end

local function dispatchEvent(dispatcher, name)
	if dispatcher:hasEventListener(name) then
		dispatcher:dispatchEvent(Event.new(name))
	end
end

local function defaultEase(ratio)
	return ratio
end

function SceneManager:init(scenes)
	self.scenes = scenes
	self.tweening = false
	self.transitionEventCatcher = Sprite.new()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function SceneManager:changeScene(scene, duration, transition, ease, options)
	self.eventFilter = options and options.eventFilter

	if self.tweening then
		return
	end
	
	if self.scene1 == nil then
		self.scene1 = self.scenes[scene].new(options and options.userData)
		self:addChild(self.scene1)
		dispatchEvent(self, "transitionBegin")
		dispatchEvent(self.scene1, "enterBegin")
		dispatchEvent(self, "transitionEnd")
		dispatchEvent(self.scene1, "enterEnd")
		return
	end

	self.duration = duration
	self.transition = transition
	self.ease = ease or defaultEase

	self.scene2 = self.scenes[scene].new(options and options.userData)
	self.scene2:setVisible(false)
	self:addChild(self.scene2)
		
	self.time = 0
	self.currentTimer = os.timer()
	self.tweening = true
end

function SceneManager:filterTransitionEvents(event)
	event:stopPropagation()
end

function SceneManager:onTransitionBegin()
	if self.eventFilter then
		stage:addChild(self.transitionEventCatcher)
		for i,event in ipairs(self.eventFilter) do
			self.transitionEventCatcher:addEventListener(event, self.filterTransitionEvents, self)
		end
	end
end

function SceneManager:onTransitionEnd()
	if self.eventFilter then
        	for i,event in ipairs(self.eventFilter) do
			self.transitionEventCatcher:removeEventListener(event, self.filterTransitionEvents, self)
		end
		self.transitionEventCatcher:removeFromParent()
	end
end

function SceneManager:onEnterFrame(event)
	if not self.tweening then
		return
	end

	if self.time == 0 then
		self:onTransitionBegin()
		self.scene2:setVisible(true)
		dispatchEvent(self, "transitionBegin")
		dispatchEvent(self.scene1, "exitBegin")
		dispatchEvent(self.scene2, "enterBegin")
	end
		
	local timer = os.timer()
	local deltaTime = timer - self.currentTimer
	self.currentTimer = timer

	local t = (self.duration == 0) and 1 or (self.time / self.duration)

	self.transition(self.scene1, self.scene2, self.ease(t), t)

	if self.time == self.duration then
		dispatchEvent(self, "transitionEnd")
		dispatchEvent(self.scene1, "exitEnd")
		dispatchEvent(self.scene2, "enterEnd")
		self:onTransitionEnd()

		self:removeChild(self.scene1)
		self.scene1 = self.scene2
		self.scene2 = nil
		self.tweening = false

		collectgarbage()
	end

	self.time = self.time + deltaTime
	
	if self.time > self.duration then
		self.time = self.duration
	end

end

