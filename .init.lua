function OnWorkerStart()
	sqlite3 = require 'lsqlite3'
end

assert(path.isdir(arg[1]))
database_path = path.join(arg[1], '.standalone.sqlite')

local sqlite3 = require 'lsqlite3'
local db = sqlite3.open(database_path)
db:exec[[
	CREATE TABLE IF NOT EXISTS [updates] (
	  [serial] INTEGER PRIMARY KEY,
	  [object] TEXT,
	  [info] TEXT,
	  [href] TEXT
	);
]]
db:close()

ProgramPort(0)
ProgramMaxPayloadSize(128*1024)
LaunchBrowser()

ProgramDirectory(arg[1])

