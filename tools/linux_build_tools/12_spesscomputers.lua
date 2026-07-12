-- sync repo
git_sync(SPESSCOMPUTERS_URL, "spesscomputers")

-- build
os.execute("cd buildtmp/spesscomputers/spesscore; dotnet publish")
os.execute("cd buildtmp/spesscomputers/libspesscomputers; make -j4")

artifact("buildtmp/spesscomputers/spesscore/spesscore/bin/Release/net10.0/publish", "spesscore", true)
artifact("buildtmp/spesscomputers/libspesscomputers/libspesscomputers.so")

