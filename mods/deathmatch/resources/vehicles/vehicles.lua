
function createVehicleForPlayer(player, Command, model)
    local db = exports.db.getConnection()
    local x, y, z = getElementPosition(player)
    local rotX, rotY, rotZ = getElementRotation(player)
    y= y + 5
    rotZ = rotZ + 90

    dbExec(db, 'INSERT INTO vehicles (model, x, y, z, rotation_x, rotation_y, rotation_z) VALUES (?, ?, ?, ?, ?, ?, ?)', model, x, y, z , rotX, rotY, rotZ)

    local vehicleObject = createVehicle(model, x, y, z, rotX, rotY, rotZ)

    dbQuery(function (queryHandle)
        local results = dbPoll(queryHandle, 0)
        local vehicle = results[1]

        setElementData(vehicleObject, 'id', vehicle.id)

     end, db, 'select id FROM vehicles ORDER BY id DESC LIMIT 1')
end
addCommandHandler('createVehicle', createVehicleForPlayer, false ,false)
addCommandHandler('createVeh', createVehicleForPlayer, false ,false)
addCommandHandler('make', createVehicleForPlayer, false ,false)

function loadAllVehicles(queryHandle)
    local results = dbPoll(queryHandle, 0)

    for index, vehicle in pairs(results) do
        local vehicleObject = createVehicle(vehicle.model, vehicle.x, vehicle.y, vehicle.z, vehicle.rotation_x, vehicle.rotation_y, vehicle.rotation_z)

        setElementData(vehicleObject, "id", vehicle.id)
    end
end


addEventHandler('onResourceStart', resourceRoot, function()
    local db = exports.db.getConnection()

    dbQuery(loadAllVehicles, db, 'SELECT * FROM vehicles')

end)

addEventHandler('onResourceStop', resourceRoot, function ()
    local db = exports.db:getConnection()
    local vehicles = getElementsByType('vehicle')

    for index, vehicle in pairs(vehicles) do
        local id = getElementData(vehicle, 'id')
        local x, y, z = getElementPosition(vehicle)
        local rotX, rotY, rotZ = getElementRotation(vehicle)

        dbExec(db, 'UPDATE vehicles SET x = ?, y = ?, z = ?, rotation_x = ?, rotation_y = ?, rotation_z = ? WHERE id = ?', x, y, z, rotX, rotY, rotZ, id)
    end
end)