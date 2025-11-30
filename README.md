This is an attempt to make [WebXDC](https://webxdc.org) apps runnable on (almost) any platform without a chat app using [redbean](https://redbean.dev) ultra-portable web server, that runs natively on Windows, Linux, MacOS and BSDs. It tries to avoid any hard dependencies on the environment and be usable in low- or no-connectivity scenarios, with ad-hoc messaging solutions and sneakernets.

# Status

A top-of-napkin prototype. Lots of WebXDC APIs aren't implemented. This... thing has been duct-taped together in, like, two hours and wasn't not thoroughly tested. It can and probably will corrupt your data, take care and make backups etc.

- [x] serve basic (static) apps
- [x] basic sendUpdate() (save all fields)
- [x] pump already sent events on setUpdateListener()
- [ ] error handling
- [ ] selfName and selfAddr
- [ ] importFiles
- [ ] sendToChat (download the file)
- [ ] some sane page when run without any app open
- [ ] sync/merge
- [ ] sendUpdate update.notify support
- [ ] control UI

# Building

Download redbean.com from [redbean.dev](https://redbean.dev), then:

```sh
./build.sh
```

This will create a webxdc-standalone.com file.

# Running on Linux/Mac (CLI)

Unzip the .xdc file to somewhere, then:

```sh
./webxdc-standalone.com path/to/directory
```

# Running on Windows

Unzip the .xdc file to some folder (where only that app lives), then drag that folder to webxdc-standalone.com file. The browser will launch.

# Running in development mode

```
redbean.com -D path/to/repo -- path/to/app/extract
```

# Architecture

All application updates are stored in [SQLite](https://sqlite.org) database in `app-directory/.standalone.sqlite`, schema is in [.init.lua](./.init.lua). A real sync engine is Coming Soon (tm), meanwhile you can just sync the app/.standalone.sqlite file while the server is stopped (doing this while it's running may corrupt the database).

Rowid is currently used as the update serial. This may cause problems with sync. On the other hand, [the runtime can reorder updates](https://webxdc.org/docs/faq/storage.html#are-application-updates-guaranteed-to-be-delivered-to-chat-peers), so it's probably possible to just insert all rows at the end.


