-- Event notes hooks
function onCreate()
	makeLuaSprite('wilterBlackScreen', nil, -700, -500);
	makeGraphic('wilterBlackScreen', screenWidth * 2, screenHeight * 2, '000000');
	setScrollFactor('wilterBlackScreen', 0, 0);
	setProperty('wilterBlackScreen.alpha', 0.00001);
	addLuaSprite('wilterBlackScreen', false);
	setObjectOrder('wilterBlackScreen', getObjectOrder('gfGroup'));
end

timesCount = 0;
function onEvent(name, value1, value2)
	if name == "Wilter Camera Zoom" then
		newTargetZoom = tonumber(value1);
		setProperty('camGame.zoom', newTargetZoom * 1.05);
		doTweenZoom('wilterCamTween', 'camGame', newTargetZoom, 0.7, 'elasticOut');
		if timesCount < 3 then
			doTweenAlpha('wilterBlackAlphaTween', 'wilterBlackScreen', (timesCount + 1) * 0.22, 0.5, 'sineOut');
		end
		timesCount = timesCount + 1;
		spawnTrail('BF');
		spawnTrail('Dad');
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	cancelTween('wilterBlackAlphaTween');
	cancelTween('wilterCamTween');
	doTweenAlpha('wilterBlackAlphaTweenEnd', 'wilterBlackScreen', 0, 0.5, sineOut);
end

function onTweenCompleted(tag)
	if tag == 'wilterBlackAlphaTweenEnd' then
		removeLuaSprite('wilterBlackScreen');
	end
end

function spawnTrail(tag)
	image = '';
	frame = 'BF idle dance';
	x = 0;
	y = 0;
	offsetX = 0;
	offsetY = 0;
	alpha = 0.6;
	height = 0;

	if tag == 'BF' then
		image = getProperty('boyfriend.imageFile')
		frame = getProperty('boyfriend.animation.frameName');
		x = getProperty('boyfriend.x');
		y = getProperty('boyfriend.y');
		offsetX = getProperty('boyfriend.offset.x');
		offsetY = getProperty('boyfriend.offset.y');
		height = getProperty('boyfriend.height');
	else
		image = getProperty('dad.imageFile')
		frame = getProperty('dad.animation.frameName');
		x = getProperty('dad.x');
		y = getProperty('dad.y');
		offsetX = getProperty('dad.offset.x');
		offsetY = getProperty('dad.offset.y');
		height = getProperty('dad.height');
		alpha = 1;
	end

	trailTag = 'psychicTrail'..tag;
	makeAnimatedLuaSprite(trailTag, image, x, y);
	setProperty(trailTag..'.offset.x', offsetX);
	setProperty(trailTag..'.offset.y', offsetY);
	setProperty(trailTag..'.alpha', alpha);
	setBlendMode(trailTag, 'add');
	addAnimationByPrefix(trailTag, 'stuff', frame, 0, false);
	addLuaSprite(trailTag, false);
	setObjectOrder(trailTag, getObjectOrder('gfGroup'));

	doTweenX(trailTag..'ScaleTweenX', trailTag..'.scale', 1.35, 1, 'sineOut');
	doTweenY(trailTag..'ScaleTweenY', trailTag..'.scale', 1.35, 1, 'sineOut');
	doTweenY(trailTag..'TweenY', trailTag, y - height / 6, 1, 'sineOut');
	doTweenAlpha(trailTag..'AlphaTween', trailTag, 0, 1, 'linear');
end