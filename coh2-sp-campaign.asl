/*
 * The state section is required for every script. It defines which process to
 * connect to (without the .exe).
 *
 * Optionally, you can also define one or several states that should be read
 * from the game's memory, which you can then access in other places in the
 * script. This is commonly the way to go for simple scripts.
 *
 * https://github.com/LiveSplit/LiveSplit/blob/master/Documentation/Auto-Splitters.md
 */
state("RelicCoH2")
{

}

/*
 * This is an Action, which is sort of like a function that is automatically
 * called by the ASL Component. It can interact with other Actions and LiveSplit
 * only by special variables that the environment provides. Inside the function
 * you can write C# code.
 *
 * The "startup" Action is run when the script is first loaded. This is a good
 * place to define things you need in the whole script. This is the only place
 * where you can define settings.
 */
startup
{
	vars.DebugOutput = (Action<string>)((text) => {
		print("[CoH2 Autosplitter] " + text);
	});
    
	Action<string, string, string, string> AddLevelSplit = (key, name, description, parent) => {
		settings.Add(key, true, name, parent);
		settings.SetToolTip(key, description);
	};

	settings.Add("campaign", true, "Campaign");
    AddLevelSplit("m_01", "M.01 Stalingrad Rail Station", "", "campaign");
    AddLevelSplit("m_02", "M.02 Scorched Earth", "", "campaign");
    AddLevelSplit("m_03", "M.03 Support is on the way", "", "campaign");
    AddLevelSplit("m_04", "M.04 The Miraculous Winter", "", "campaign");
    AddLevelSplit("m_05", "M.05 Stalingrad", "", "campaign");
    AddLevelSplit("m_06", "M.06 Stalingrad Aftermath", "", "campaign");
    AddLevelSplit("m_07", "M.07 The Land Bridge to Leningrad", "", "campaign");
    AddLevelSplit("m_08", "M.08 Panzer Hunting", "", "campaign");
    AddLevelSplit("m_09", "M.09 Radio Silence", "", "campaign");
    AddLevelSplit("m_10", "M.10 Lublin", "", "campaign");
    AddLevelSplit("m_11", "M.11 Behind Enemy Lines", "", "campaign");
    AddLevelSplit("m_12", "M.12 Poznan Citadel", "", "campaign");
    AddLevelSplit("m_13", "M.13 Halbe", "", "campaign");
    AddLevelSplit("m_14", "M.14 The Reichstag", "", "campaign");

	vars.missionScenarioPaths = new Dictionary<int, string> {
        { 0, "" },
		{ 1,  @"DATA:scenarios\sp\coh2_campaign\m01-stalingrad_rail_station\stalingrad_rail_station" },
		{ 2,  @"DATA:scenarios\sp\coh2_campaign\m02-scorched_earth\scorched_earth" },
		{ 3,  @"DATA:scenarios\sp\coh2_campaign\m03-moscow_outskirts\moscow_outskirts" },
		{ 4,  @"DATA:scenarios\sp\coh2_campaign\m04-kaluga\kaluga" },
		{ 5,  @"DATA:scenarios\sp\coh2_campaign\m05-stalingrad\stalingrad" },
		{ 6,  @"DATA:scenarios\sp\coh2_campaign\m06-stalingrad_injury\stalingrad_injury" },
		{ 7,  @"DATA:scenarios\sp\coh2_campaign\m07-shlisselburg\shlisselburg" },
		{ 8,  @"DATA:scenarios\sp\coh2_campaign\m08-tiger_hunting\tiger_hunting" },
		{ 9,  @"DATA:scenarios\sp\coh2_campaign\m09-bagration\orsha" },
		{ 10, @"DATA:scenarios\sp\coh2_campaign\m10-lublin\lublin" },
		{ 11, @"DATA:scenarios\sp\coh2_campaign\m11-behind_enemy_lines\german_lines" },
		{ 12, @"DATA:scenarios\sp\coh2_campaign\m12-poznan\poznan" },
		{ 13, @"DATA:scenarios\sp\coh2_campaign\m13-halbe\halbe" },
		{ 14, @"DATA:scenarios\sp\coh2_campaign\m14-the_reichstag\the_reichstag" },
	};
    vars.maxLevelID = System.Linq.Enumerable.Max(vars.missionScenarioPaths.Keys);

    vars.STATUS_WAIT_START = "wait_start";
    vars.STATUS_WAIT_MISSION_BEGIN = "wait_begin";
    vars.STATUS_WAIT_MISSION_END = "wait_end";
    vars.STATUS_PAUSED = "game_paused";
    vars.PREVIOUS_STATUS = "";
    vars.STATUS = "";

    vars.TrySetStatus = (Action<string>)((string status) => {
        if (vars.STATUS != status)
        {
            vars.PREVIOUS_STATUS = vars.STATUS;
            vars.STATUS = status;
            vars.DebugOutput("STATUS: " + status);
        }
    });
    vars.TrySetStatus(vars.STATUS_WAIT_START);

    vars.CreateFileReader = (Func<string, System.IO.StreamReader>)((string filename) => {
    	var stream = System.IO.File.Open(filename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
    	return new System.IO.StreamReader(stream, System.Text.Encoding.UTF8);
    });

    vars.DebugOutput("Configured " + vars.missionScenarioPaths.Count + " missions");
    // C:\<USER>\documents\my games\company of heroes 2\warnings.log
    vars.logFilename = System.IO.Path.Combine(Environment.GetEnvironmentVariable("USERPROFILE"), "documents", "my games", "company of heroes 2", "warnings.log");
    // vars.logFilename = @"E:\dev\livesplit\coh2-sp-campaign\test\warnings.log";

    // Mission progression
    vars.currentMissionID = 0;

    // Log file variables
	vars.logFileReader = vars.CreateFileReader(vars.logFilename);
    vars.logFileReaderForResetDetection = vars.CreateFileReader(vars.logFilename);
    vars.logFileLineQueue = new Queue<string>();
    vars.logLinesReadCount = 0;

    vars.ReadStreamLines = (Func<System.IO.StreamReader, string[]>)((System.IO.StreamReader reader) => {
    	var line = String.Empty;
    	var lines = new List<string>();
    	while ((line = reader.ReadLine()) != null)
        {
    		lines.Add(line);
        }
        return lines.ToArray();
    });

    vars.GetNextLogLines = (Func<string[]>)(() => {
    	return vars.ReadStreamLines(vars.logFileReader);
    });

    vars.IsMissionBegin = (Func<string, string, bool>)((string line, string path) => {
        return line.Contains("GAME -- Starting mission: " + path);
    });

    vars.IsMissionEnd = (Func<string, bool>)((string line) => {
        return line.Contains("MOD -- Game Over at frame ");
    });

    vars.ShouldAdvance = (Func<bool>)(() => {
        // No more missions to play
        if (vars.currentMissionID > vars.maxLevelID)
            return false;

        while (true)
        {
            if (vars.logFileLineQueue.Count == 0)
                return false;

            var line = vars.logFileLineQueue.Dequeue();
            vars.logLinesReadCount++;

            if (line.Contains("GAME -- SimulationController::Pause 0"))
            {
                vars.TrySetStatus(vars.STATUS_PAUSED);
                return false;
            }
            else if (line.Contains("GAME -- SimulationController::Pause 1"))
            {
                vars.TrySetStatus(vars.PREVIOUS_STATUS);
                return false;
            }
            
            // Check mission status
            // Pausing the game does not block checking statues, as the user might pause the game to access the menu
            // and load a savegame or restart the mission

            // Check for mission start
            else if (vars.STATUS == vars.STATUS_PAUSED || vars.STATUS == vars.STATUS_WAIT_START || vars.STATUS == vars.STATUS_WAIT_MISSION_BEGIN)
            {
                var currentMissionScenarioPath = vars.missionScenarioPaths[vars.currentMissionID];
                var nextMissionScenarioPath = vars.missionScenarioPaths[vars.currentMissionID + 1];
                // Looking for a line that indicates the beginning of a mission, e.g.
                // 20:11:46.91   GAME -- Starting mission: DATA:scenarios\sp\coh2_campaign\m03-moscow_outskirts\moscow_outskirts
                if (vars.IsMissionBegin(line, nextMissionScenarioPath))
                {
                    vars.currentMissionID += 1;
                    vars.DebugOutput("!! START " + nextMissionScenarioPath);
                    vars.TrySetStatus(vars.STATUS_WAIT_MISSION_END);
                    return true;
                }
                // Detect restarting of a mission
                else if (vars.IsMissionBegin(line, currentMissionScenarioPath))
                {
                    vars.DebugOutput("!! RESTART " + currentMissionScenarioPath);
                    vars.TrySetStatus(vars.STATUS_WAIT_MISSION_END);
                    return false;
                }
            }
            // Check for an end of a mission
            else if (vars.STATUS == vars.STATUS_PAUSED || vars.STATUS == vars.STATUS_WAIT_MISSION_END)
            {
                if (vars.IsMissionEnd(line))
                {
                    vars.DebugOutput("!! END " + vars.missionScenarioPaths[vars.currentMissionID]);
                    vars.TrySetStatus(vars.STATUS_WAIT_MISSION_BEGIN);
                    // Split if last mission ended, otherwise wait for the next one to start
                    return vars.currentMissionID == vars.maxLevelID;
                }
            }
        }
    });
}

/*
 * The "init" Action is called when the script connects to a game process. This
 * is where you can do game-specific initialization like dectecting the game
 * version.
 */
init
{

}

reset
{
    return false;
}

/*
 * The "exit" Action is called when the process the script is connected to exits.
 *
 * In this example the Game Time is paused while the process is closed, for example
 * in case of a game crash.
 */
exit
{
	timer.IsGameTimePaused = true;
}

/*
 * The "update" Action is called as long as the script is connected to a process.
 * It is a general update Action which can be used to do stuff that should always
 * run independant of the current Timer state.
 */
update
{
    var countBefore = vars.logFileLineQueue.Count;
    foreach (var line in vars.GetNextLogLines())
    {
        vars.logFileLineQueue.Enqueue(line);
    }

    if (countBefore < vars.logFileLineQueue.Count)
    {
        vars.DebugOutput((vars.logFileLineQueue.Count - countBefore) + " lines added to queue");
    }
	/*
	 * This Action is special, because if you explicitly return false from it
	 * the other Timer Control Actions (start, reset, split, ..) won't be run.
	 *
	 * In this case this is used to disable the Autosplitter for unknown game
	 * versions.
	 */
	return true;
}

start
{
    if (vars.STATUS == vars.STATUS_WAIT_START)
    {
	    return vars.ShouldAdvance();
    }
}

split
{
	/*
	 * Never split in the first few seconds, since starting an episode could
	 * immediately split under the right circumstan1ces.
	 */
	if (timer.CurrentTime.RealTime < TimeSpan.FromSeconds(4))
	{
		return;
	}


    return vars.ShouldAdvance();
}

isLoading
{
	return vars.STATUS == vars.STATUS_WAIT_MISSION_BEGIN || vars.STATUS == vars.STATUS_PAUSED;
}

