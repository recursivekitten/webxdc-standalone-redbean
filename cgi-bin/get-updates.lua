db = sqlite3.open(database_path)
db:busy_timeout(1000)

min_serial = tonumber(GetParam("serial") or 0)

max_serial = 0
for serial in db:urows[[SELECT max(serial) FROM updates]] do
	max_serial = serial
end

fetch_stmt = db:prepare[[
	SELECT serial, object
	FROM updates
	WHERE serial > ?
	ORDER BY serial
]]

fetch_stmt:reset()
fetch_stmt:bind(1, min_serial)

updates = {}
for serial, object in fetch_stmt:urows() do
	update = DecodeJson(object)
	update.serial = serial
	update.max_serial = max_serial
	table.insert(updates, update)
end

fetch_stmt:finalize()
db:close()

EncodeJson(updates, {useoutput=true})

