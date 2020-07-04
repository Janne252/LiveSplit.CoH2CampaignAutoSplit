
# Configuration & Setup
### Splits
Download [templates/coh2-sp-campaign.lss](templates/coh2-sp-campaign.lss) and load it to LiveSplit:
- Right-click LiveSplit, Select `Open Splits` -> `From file...`, and choose the downloaded `coh2-sp-campaign.lss`.

### Layout
- Right-click LiveSplit and select `Edit Layout...`
    1. Set `Timer` section `Timing Method` to `Game Time`.
    1. Set `Splits` section `Timing Method` to `Game Time` for all columns.
    1. Add `Scriptable Auto Splitter`. Download [coh2-sp-campaign.asl](coh2-sp-campaign.asl) and choose the downloaded `coh2-sp-campaign.asl` as `Script Path`. 

# Instructions & Usage
**Complete these steps when: Starting a new run OR restarting an entire run**
1. Start or restart Company of Heroes 2. 
    > The running instance of the game has to be fresh. The auto splitting functionality is based on the game's log file, located in `my games\company of heroes 2\warnings.log`. The log file is cleared when the game first starts. If the game is not restarted between campaign runs, this auto splitter may go out of sync. 
1. Start or restart LiveSplit
1. Start playing the single player campaign.

# Features
- Beginning of a mission
- Restarting of a mission (either via pause menu or by loading a savegame of the same mission)
- Ending of a mission
    > Please note that the timer remains paused until the next mission starts or the last mission ends. This allows restarting the mission or loading a savegame of the same mission to try again without advancing to the next mission.
- Loading time skipping 
- "Game paused" skipping

# Known issues / limitations / "Good to know"
- The auto splitter may not react to pausing the game or any other action during the first 4 seconds after launching LiveSplit.
- In-game footage cinematic intro videos will not pause the LiveSplit timer. The user has to skip these sequences manually by pressing `Enter`.
- Full-screen intro videos (no in-game footage) will automatically pause the timer, as the game is paused for the duration of the video.

# Testing
- [x] Simulated log output test of all missions
- [x] Partial test of all missions by loading into a mission, quitting, and loading into the next mission
- [x] Restart mission and load a savegame of the same mission
- [ ] Full load & quit test of all missions
- [ ] Full load savegame & complete of all missions
- [ ] Full playthrough
- [ ] Does the AutoSplit timer pause during a campaign autosave? 
