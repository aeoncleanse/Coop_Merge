function fillCoop()    
    local tblArmy = ListArmies()
    for iArmy, strArmy in pairs(tblArmy) do
        if iArmy >= ScenarioInfo.Coop1 then
            table.insert(ScenarioInfo.HumanPlayers, iArmy)
        end
    end
end

function CreateTimerTriggerUnlockCoop(cb, faction, seconds, displayBool)
    local tblArmy = ListArmies()
    for iArmy, strArmy in pairs(tblArmy) do
        if iArmy >= ScenarioInfo.Coop1 then
            factionIdx = GetArmyBrain(strArmy):GetFactionIndex()
            if(factionIdx == faction) then
                CreateTimerTrigger(cb, seconds, displayBool)
            end
        end
    end
end

function RemoveRestrictionCoop(faction, categories, isSilent)
    -- For coop players
    local tblArmy = ListArmies()
    for iArmy, strArmy in pairs(tblArmy) do
        if iArmy >= ScenarioInfo.Coop1 then     
            factionIdx = GetArmyBrain(strArmy):GetFactionIndex()
            if(factionIdx == faction) then
                SimUIVars.SaveTechAllowance(categories)
                if not isSilent then
                    if not Sync.NewTech then Sync.NewTech = {} end
                    table.insert(Sync.NewTech, EntityCategoryGetUnitList(categories))
                end
                RemoveBuildRestriction(iArmy, categories)
            end
        end
    end
end

-------- FakeTeleportUnitThread
-------- Run teleport effect then delete unit
function FakeTeleportUnit(unit,killUnit)
    IssueStop({unit})
    IssueClearCommands({unit})
    unit:SetCanBeKilled( false )

    unit:PlayTeleportChargeEffects(unit:GetPosition()) -- Added position call for Coop for end of mission 2
    unit:PlayUnitSound('GateCharge')
    WaitSeconds(2)

    unit:CleanupTeleportChargeEffects()
    unit:PlayTeleportOutEffects()
    unit:PlayUnitSound('GateOut')
    WaitSeconds(1)

    if killUnit then
        unit:Destroy()
    end
end