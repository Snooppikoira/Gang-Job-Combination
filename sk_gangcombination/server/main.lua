if Config.Main.ESXVersion == "new" then ESX = exports['es_extended']:getSharedObject() else TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
local function debugPrint(msg) if Config.Main.DebugMode then print(("[sk_gangcombination] [DEBUG] %s"):format(msg)) end end
local function notify(playerId, message) debugPrint(("notify -> playerId: %s, message: %s"):format(playerId, message)) TriggerClientEvent('esx:showNotification', playerId, message) end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    debugPrint(("esx:playerLoaded -> playerId: %s"):format(playerId))
    local identifier = xPlayer.getIdentifier()
    debugPrint(("Player identifier: %s"):format(identifier or "nil"))

    if not identifier then
        print((Config.Locales.MissingIdentifier):format(playerId))
        return
    end

    MySQL.Async.fetchScalar('SELECT gang FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(gang)
        debugPrint(("MySQL fetchScalar gang -> playerId: %s, gang: %s"):format(playerId, gang or "nil"))
        if gang then
            xPlayer.set('gang', gang)
            debugPrint(("Player ID %s gang set to: %s"):format(playerId, gang))
        else
            xPlayer.set('gang', 'none')
            debugPrint(("Player ID %s gang set to: none"):format(playerId))
        end
    end)

    MySQL.Async.fetchScalar('SELECT gang_grade FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(gangGrade)
        debugPrint(("MySQL fetchScalar gang_grade -> playerId: %s, gang_grade: %s"):format(playerId, gangGrade or "nil"))
        if gangGrade then
            xPlayer.set('gang_grade', gangGrade)
            debugPrint(("Player ID %s gang_grade set to: %s"):format(playerId, gangGrade))
        else
            xPlayer.set('gang_grade', 0)
            debugPrint(("Player ID %s gang_grade set to: 0"):format(playerId))
        end
    end)
end)

local function isAdminGroup(group)
    debugPrint(("isAdminGroup -> group: %s"):format(group))
    for _, g in ipairs(Config.Main.adminGroups) do
        if g == group then
            return true
        end
    end
    return false
end

local function SetGang(playerId, gangName, gangGrade)
    debugPrint(("SetGang -> playerId: %s, gangName: %s, gangGrade: %s"):format(playerId, gangName, gangGrade))
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        print(("[ERROR] Attempted to assign a gang to a player who is not online. ID: %s"):format(playerId))
        return
    end

    local identifier = xPlayer.getIdentifier()
    if not identifier then
        print(("[ERROR] Player with ID %s does not have an identifier!"):format(playerId))
        return
    end

    xPlayer.set('gang', gangName)
    xPlayer.set('gang_grade', gangGrade)

    MySQL.Async.execute('UPDATE users SET gang = @gang, gang_grade = @grade WHERE identifier = @identifier', {
        ['@gang']       = gangName,
        ['@grade']      = gangGrade,
        ['@identifier'] = identifier
    }, function(rowsChanged)
        debugPrint(("SetGang -> saved gang=%s, grade=%s, rowsChanged=%s"):format(gangName, gangGrade, rowsChanged))
    end)
end

RegisterCommand('setgang', function(source, args)
    debugPrint(("setgang komento -> source: %s, args: %s"):format(source, table.concat(args, ", ")))
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        print(Config.Locales.CMDNoPlayer)
        return
    end

    local group = xPlayer.getGroup()
    if not isAdminGroup(group) then
        notify(source, Config.Locales.NoPerms)
        return
    end

    if #args < 3 then
        notify(source, Config.Locales.UsageSetGang)
        return
    end

    local targetId  = tonumber(args[1])
    local gangName  = args[2]
    local gangGrade = tonumber(args[3])

    debugPrint(("setgang parsed -> targetId: %s, gangName: %s, gangGrade: %s"):format(targetId or "nil", gangName or "nil", gangGrade or "nil"))

    if not targetId or not gangName or gangName == '' or gangGrade == nil then
        notify(source, Config.Locales.InvalidArgs)
        return
    end

    if gangName == 'none' and gangGrade == 0 then
        SetGang(targetId, 'none', 0)
        notify(source, (Config.Locales.GangSetSuccessSource):format(targetId, 'none', 0))
        notify(targetId, (Config.Locales.GangSetSuccessTarget):format('none', 0))
        return
    end

    MySQL.Async.fetchScalar('SELECT name FROM gangs WHERE name = @g', {
        ['@g'] = gangName
    }, function(foundGang)
        debugPrint(("MySQL fetchScalar -> gang check, foundGang: %s"):format(foundGang or "nil"))
        if not foundGang then
            notify(source, (Config.Locales.GangNotFound):format(gangName))
            return
        end

        MySQL.Async.fetchScalar('SELECT id FROM gang_grades WHERE gang_name = @gn AND grade = @gr', {
            ['@gn'] = gangName,
            ['@gr'] = gangGrade
        }, function(gradeRow)
            debugPrint(("MySQL fetchScalar -> grade check, gradeRow: %s"):format(gradeRow or "nil"))
            if not gradeRow then
                notify(source, ("[ERROR] Grade %s ei ole olemassa jengille %s."):format(gangGrade, gangName))
                return
            end

            SetGang(targetId, gangName, gangGrade)
            notify(source, (Config.Locales.GangSetSuccessSource):format(targetId, gangName, gangGrade))
            notify(targetId, (Config.Locales.GangSetSuccessTarget):format(gangName, gangGrade))
        end)
    end)
end, false)

lib.callback.register('sk_gangcombination:getPlayerGangName', function(source)
    debugPrint(("getPlayerGangName -> source: %s"):format(source))
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return 'none'
    end
    return xPlayer.get('gang') or 'none'
end)

lib.callback.register('sk_gangcombination:getPlayerGangNameLabel', function(source)
    debugPrint(("getPlayerGangLabel -> source: %s"):format(source))
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return 'none'
    end

    local gangName = xPlayer.get('gang') or 'none'
    if gangName == 'none' then
        return 'none'
    end

    local label = MySQL.Sync.fetchScalar('SELECT label FROM gangs WHERE name = ?', { gangName })
    debugPrint(("getPlayerGangLabel -> label: %s"):format(label or "none"))
    return label or 'none'
end)

lib.callback.register('sk_gangcombination:getPlayerGangGrade', function(source)
    debugPrint(("getPlayerGangGrade -> source: %s"):format(source))
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return 'none'
    end

    local gangName     = xPlayer.get('gang') or 'none'
    local gangGradeNum = xPlayer.get('gang_grade') or 0
    debugPrint(("getPlayerGangGrade -> gangName: %s, gangGradeNum: %s"):format(gangName, gangGradeNum))
    if gangName == 'none' then
        return 'none'
    end

    local gradeName = MySQL.Sync.fetchScalar('SELECT name FROM gang_grades WHERE gang_name = ? AND grade = ?', { gangName, gangGradeNum })
    debugPrint(("getPlayerGangGrade -> gradeName: %s"):format(gradeName or "none"))
    return gradeName or 'none'
end)

lib.callback.register('sk_gangcombination:getPlayerGangGradeLabel', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return 'none'
    end

    local gangName     = xPlayer.get('gang') or 'none'
    local gangGradeNum = xPlayer.get('gang_grade') or 0
    
    if gangName == 'none' then
        return 'none'
    end

    local gradeLabel = MySQL.Sync.fetchScalar(
        'SELECT label FROM gang_grades WHERE gang_name = ? AND grade = ?',
        { gangName, gangGradeNum }
    )

    return gradeLabel or 'none'
end)

lib.callback.register('sk_gangcombination:getPlayerGangGradeNum', function(source)
    debugPrint(("getPlayerGangGradeNum -> source: %s"):format(source))
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return 0
    end
    local gradeNum = xPlayer.get('gang_grade') or 0
    debugPrint(("getPlayerGangGradeNum -> gradeNum: %s"):format(gradeNum))
    return gradeNum
end)