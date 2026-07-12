local lfs = require("lfs")

function git_sync(url, dir)
    if not lfs.attributes("buildtmp/"..dir) then
        os.execute("git clone "..url.." buildtmp/"..dir)
    else
        os.execute("cd buildtmp/"..dir.."; git pull")
    end
end

ARTIFACTS = {}

function artifact(src, dst, dir)
    if not dst then
        dst = src:match("[^/]+$")
    end
    table.insert(ARTIFACTS, {src=src, dst=dst, dir=dir})
end
