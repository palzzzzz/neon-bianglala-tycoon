-- Kiosk bootstraps only after the server publishes its shared context.
local Server=script.Parent
local Economy=require(Server.EconomyService)
local Catalog=require(game.ReplicatedStorage.Shared.Catalog)
local Models=require(game.ReplicatedStorage.Shared.BrainrotModels)
local Stalls=require(Server.StallService)
local World=require(Server.World)
local Kiosk=require(Server.LuckyKioskService)
local context=require(Server.Runtime).wait()
Kiosk.create(context,Economy,Catalog,Models,Stalls,World)
