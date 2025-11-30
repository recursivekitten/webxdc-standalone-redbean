db = sqlite3.open(database_path)
db:busy_timeout(1000)

update = DecodeJson(GetBody())

insert_stmt = db:prepare[[
	INSERT INTO updates(object, info, href)
	VALUES ( ?, ?, ? )
]]

insert_stmt:reset()
insert_stmt:bind(1, EncodeJson{
	payload = update.payload,
	summary = update.summary,
	info = update.info,
	notify = update.notify,
	href = update.href,
	document = update.document,
})
insert_stmt:bind(2, update.info)
insert_stmt:bind(3, update.href)

if insert_stmt:step() ~= sqlite3.DONE then
	Log(kLogError, db:error_message())
	error(db:error_message())
end

insert_stmt:finalize()

max_serial = 0
for serial in db:urows[[SELECT max(serial) FROM updates]] do
	max_serial = serial
end

EncodeJson(
	{serial = db:last_insert_rowid(), max_serial = max_serial},
	{useoutput=true}
)

db:close()


