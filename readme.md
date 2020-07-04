> This Auto splitter is currently under development - there's still some [testing](#testing) to do. Couple of [known issues & limitations](#Known-issues--limitations) are present as well.

> Tested once on a full playthrough by [Chihuahua_Charity](url=https://www.twitch.tv/videos/669824853). 

# Configuration & Setup
### Game
Do not delete the game's cutscene video files. Deleting the video files seem to make the game behave in an unexpected way and might break this auto splitter.

### Splits
Download [templates/coh2-sp-campaign.lss](templates/coh2-sp-campaign.lss) and load it to LiveSplit:
- Right-click LiveSplit, Select `Open Splits` -> `From file...`, and choose the downloaded `coh2-sp-campaign.lss`.

### Layout
- Right-click LiveSplit and select `Edit Layout...`
    1. Set `Timer` section `Timing Method` to `Game Time`.
    1. Set `Splits` section `Timing Method` to `Game Time` for all columns.
    1. Add `Scriptable Auto Splitter` via the **`(+)`** button. Download [coh2-sp-campaign.asl](coh2-sp-campaign.asl) and choose the downloaded `coh2-sp-campaign.asl` as `Script Path`. 
    1. Set the number of visible splits to 14

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
    > Please note that the timer remains paused until the next mission starts or the last mission ends. This allows restarting the mission or loading a savegame of the same mission to try again without advancing to the next split.
- Loading time skipping 
- "Game paused" skipping

# Known issues & limitations 
- The method used to detect the ending of the last mission will also trigger when restarting or loading a savegame of the last mission after starting it. Meaning that restarting or loading a savegame after starting the last mission will end the split.
    - A fix for this issue is in progress.

# "Good to know"
- In-game footage cinematic intro videos will not pause the LiveSplit timer. The user has to skip these sequences manually by pressing `Enter`.
- Full-screen intro videos (no in-game footage) will automatically pause the timer, as the game is paused for the duration of the video.
- If the game restarts (due to user action or a crash), which resets `warnings.log` file, the auto splitter will jump to the beginning of the log file and continue normally to wait for the next trigger, i.e. mission begin or end. The timer will not pause.

# Testing
- [x] Simulated log output test of all missions
- [x] Partial test of all missions by loading into a mission, quitting, and loading into the next mission
- [x] Restart mission and load a savegame of the same mission
- [ ] Full load & quit test of all missions
- [ ] Full load savegame & complete of all missions
- [x] Full playthrough
- [ ] Does the AutoSplit timer pause during a campaign autosave? 
