GetPlayerGangName = function()
    local gangName = lib.callback.await('sk_gangcombination:getPlayerGangName', false)
    return gangName
end

GetPlayerGangNameLabel = function()
    local gangLabel = lib.callback.await('sk_gangcombination:getPlayerGangNameLabel', false)
    return gangLabel
end

GetPlayerGangGrade = function()
    local gradeName = lib.callback.await('sk_gangcombination:getPlayerGangGrade', false)
    return gradeName
end

GetPlayerGangGradeLabel = function()
    local gradeLabel = lib.callback.await('sk_gangcombination:getPlayerGangGradeLabel', false)
    return gradeLabel
end

GetPlayerGangGradeNum = function()
    local gradeNum = lib.callback.await('sk_gangcombination:getPlayerGangGradeNum', false)
    return gradeNum
end

exports("GetPlayerGangName", GetPlayerGangName)
exports("GetPlayerGangLabel", GetPlayerGangNameLabel)
exports("GetPlayerGangGrade", GetPlayerGangGrade)
exports("GetPlayerGangGradeLabel", GetPlayerGangGradeLabel)
exports("GetPlayerGangGradeNum", GetPlayerGangGradeNum)

TriggerEvent('chat:addSuggestion', '/setgang', 'Set gang', {{ name="playerId", help="Player ID" },{ name="gang", help="Gang name" },{ name="grade", help="Gang grade" }})
