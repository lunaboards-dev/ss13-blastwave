if os.execute("7z > /dev/null") then
    print("Found 7zip")
    local function mkexec(f)
        os.execute("chmod +x chmod +x ./buildtmp/byond/bin/"..f)
    end
    local files = {
        "libbyond.so",
        "libext.so",
        "DreamDaemon",
        "DreamMaker",
        "DreamDownload",
        "byondexec"
    }
    target("dm-pkg", {}, function()
        download(string.format("https://www.byond.com/download/build/%d/%d.%d_byond_linux.zip", BYOND_VER[1], BYOND_VER[1], BYOND_VER[2]), "buildtmp/byond.zip")
        os.execute("cd buildtmp; 7z x byond.zip;")
        for i=1, #files do
            mkexec(files[i])
        end
    end, function()
        return not os.execute("DreamDaemon -version > /dev/null")
    end)

    target("codebase", {"dm-pkg"}, function()
        os.execute([[PATH="$PATH:./buildtmp/bin" tools/build/build.sh]])
    end, function()
        return args.compile
    end)

    target("run", deps_if_exist("natives", "db:start", "codebase"), function()
        os.execute(string.format([[PATH="$PATH:./buildtmp/bin" DreamMaker tgstation.dmb -trusted -invisible -ports %d]], BYOND_PORT))
    end).explicit = true
end
