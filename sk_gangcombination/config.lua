Config = {}

Config.Main = {
    DebugMode = false,
    adminGroups = {'admin'},
    ESXVersion = "new" -- "old" / "new"
}

Config.Locales = {
    MissingIdentifier       = "[ERROR] Could not retrieve identifier from player ID: %s",
    CMDNoPlayer             = "[ERROR] The /setgang command was attempted from the server console or an invalid source.",
    NoPerms                 = "You do not have permission to use this command!",
    UsageSetGang            = "Usage: /setgang [playerId] [gangName] [gangGrade]",
    InvalidArgs             = "Invalid arguments! /setgang [playerId] [gangName] [gangGrade]",
    GangNotFound            = "Gang %s was not found in the gangs table!",
    GangSetSuccessSource    = "You set a gang for player ID %s: %s (grade: %s)",
    GangSetSuccessTarget    = "A gang was set for you: %s (grade: %s)"
}
