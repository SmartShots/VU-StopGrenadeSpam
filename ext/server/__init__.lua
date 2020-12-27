local StopGranadeSpam = class('StopGranadeSpam')

function StopGranadeSpam:__init()
    print("Initializing StopGranadeSpam")
    self:RegisterEvens()
    self:RegisterVars()
end

function StopGranadeSpam:RegisterVars()
    -- Maximum granade a player resupply before getting warned
    self.MaxGranadeBeforeWarn = 2

    -- Maximum granade a player resupply before getting kicked
    self.MaxGranadePerLife = 4

    -- DO NOT CHANGE
    self.GranadeResupplied = {}
end

function StopGranadeSpam:RegisterEvens()
    Events:Subscribe('Player:Resupply', function(player, givenMagsCount, supplier)
        local weapons = player.soldier.weaponsComponent.weapons
        
        for key, value in pairs(weapons) do
            if value ~= nil then
                if value.name == 'Weapons/M67/M67' and value.primaryAmmo == 0 then
                    guid = player.guid:ToString('D')

                    if self.GranadeResupplied[guid] ~= nil then
                        self.GranadeResupplied[guid] = self.GranadeResupplied[guid] + 1
                    else
                        self.GranadeResupplied[guid] = 1
                    end
        
                    -- print(player.name .. ' resupplied ' .. self.GranadeResupplied[guid] .. ' granades')
                    
                    if self.GranadeResupplied[guid] > self.MaxGranadePerLife then
                        player:Kick('Granade spamming')
                    elseif self.GranadeResupplied[guid] > self.MaxGranadeBeforeWarn then
                        if self.GranadeResupplied[guid] > self.MaxGranadePerLife - 1 then
                            ChatManager:SendMessage(player.name .. ' please stop spamming granades.')
                        end
                        
                        ChatManager:Yell('Warning: Stop spamming granades or you will be kicked.', 5, player)
                    end
                end
            end
        end
    end)

    Events:Subscribe('Player:Respawn', function(player)
        guid = player.guid:ToString('D')

        self.GranadeResupplied[guid] = 0
    end)
end

g_StopGranadeSpam = StopGranadeSpam()