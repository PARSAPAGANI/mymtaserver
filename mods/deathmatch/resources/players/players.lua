--when a player joins run some code

addEventHandler("onPlayerJoin", root, function()

--spawn the player
	spawnPlayer(source, 0, 0, 5)

--fade their camera in
	fadeCamera(source, true)
--set the camera target to be spawned player
 	setCameraTarget(source, source)
end)
