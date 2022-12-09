local StopGrenadeSpam = class('StopGrenadeSpam')

function StopGrenadeSpam:__init()
    print("Initializing StopGrenadeSpam")
    self:RegisterEvens()
    self:RegisterVars()
end

function StopGrenadeSpam:RegisterVars()
    -- Maximum grenade a player resupply before getting warned
    self.MaxGrenadeBeforeWarn = 10

    -- Maximum grenade a player resupply before getting kicked
    self.MaxGrenadePerLife = 14

    -- DO NOT CHANGE
    self.GrenadeResupplied = {}
end

function StopGrenadeSpam:RegisterEvens()
    Events:Subscribe('Player:Resupply', function(player, givenMagsCount, supplier)
        local weapons = player.soldier.weaponsComponent.weapons
        
        for key, value in pairs(weapons) do
            if value ~= nil then
                if value.name == 'Weapons/M67/M67' and value.primaryAmmo == 0 then
                    guid = player.guid:ToString('D')

                    if self.GrenadeResupplied[guid] ~= nil then
                        self.GrenadeResupplied[guid] = self.GrenadeResupplied[guid] + 1
                    else
                        self.GrenadeResupplied[guid] = 1
                    end
        
                    -- print(player.name .. ' resupplied ' .. self.GrenadeResupplied[guid] .. ' grenades')
                    
                    if self.GrenadeResupplied[guid] > self.MaxGrenadePerLife then
                        player:Kick('Grenade spamming')
                    elseif self.GrenadeResupplied[guid] > self.MaxGrenadeBeforeWarn then
                        if self.GrenadeResupplied[guid] > self.MaxGrenadePerLife - 2 then
                            ChatManager:SendMessage('FINAL WARNING: ' .. player.name .. ' stop spamming grenades.')
                        end
                        
                        ChatManager:Yell('Warning: Stop spamming grenades or you will be kicked.', 5, player)
                    end
                end
            end
        end
    end)

    Events:Subscribe('Player:Respawn', function(player)
        if player.guid ~= nil then
                guid = player.guid:ToString('D')

            self.GrenadeResupplied[guid] = 0
        end
    end)
end

g_StopGrenadeSpam = StopGrenadeSpam()