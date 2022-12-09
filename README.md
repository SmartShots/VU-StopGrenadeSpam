#Forked from gitlab.com/maybeken/vu-mod-stopgrenadespam/-/tree/master
Credit for the original mod goes to Maybe Ken (gitlab.com/maybeken)

I forked this as it was erroring when used alongside the Fun-bots Mod. I have fixed the error and have also added my own choice of personal customization.

# Description

You can throw grenades, but if you spam it you will be kicked. You will get warning if you are reaching a configurable limit per life, limit reset every time you respawn.

# Configuration

```lua
-- Maximum grenade a player resupply before getting warned
self.MaxGrenadeBeforeWarn = 2

-- Maximum grenade a player resupply before getting kicked
self.MaxGrenadePerLife = 4
```
