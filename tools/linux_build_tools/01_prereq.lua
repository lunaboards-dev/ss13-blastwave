local has_curl = os.execute("curl --version > /dev/null")
local has_wget = os.execute("wget --version > /dev/null")

function pcapture(cmd)
    local h = io.popen(cmd, "r")
    local r = h:read("*a"):gsub("^%s+", ""):gsub("%s+$", "")
    return r, h:close()
end

if not has_curl or not has_wget then
    panic("Neither curl nor wget are installed. Cannot continue!")
end

if has_curl then
    print("Using cURL for downloads.")
    function download(file, dst)
        return os.execute(string.format("curl %q -o %q", file, dst))
    end
else
    print("Using wget for downloads.")
    function download(file, dst)
        return os.execute(string.format("wget %q -o %q", file, dst))
    end
end

if not os.execute("git --version > /dev/null") then
    panic("Git not installed! (how did we get here?)")
end

TARGETS = {}
ARTIFACTS = {}

local function _return_true() return true end
function virtual_target() end

function target(name, deps, run, check)
    if not check then check = _return_true end
    if TARGETS[name] then
        panic("Target "..name.." already added!")
    end
    local t = {
        name = name,
        deps = deps or {},
        run = run,
        check = check
    }
    TARGETS[name] = t
    table.insert(TARGETS, t)
    return t
end

local up_to_date = "Already up to date."

local lfs = require("lfs")

function git_sync(url, dir)
    if not lfs.attributes("buildtmp/"..dir) then
        os.execute("git clone "..url.." buildtmp/"..dir)
        return true
    else
        local text, ok = pcapture("cd buildtmp/"..dir.."; git pull")
        if not ok then
            print(text)
            panic("Error syncing git repo!")
        end
        if text ~= up_to_date then
            return true
        end
    end
end

function artifact(src, dst, dir)
    if not dst then
        dst = src:match("[^/]+$")
    end
    table.insert(ARTIFACTS, {src=src, dst=dst, dir=dir})
end

local sync = target("gitsync", {}, virtual_target)

function repo(name, deps, repo, run)
    local should_compile
    local st = target("sync:"..name, {}, function()
        should_compile = git_sync(repo, name)
    end)
    table.insert(sync.deps, st.name)
    return target(name, deps, function()
        run("buildtmp/"..name)
    end, function() return should_compile end)
end

function explicit(...)
    local t = table.pack(...)
    for i=1, #t do
        t[i].explicit = true
    end
    return ...
end

function deps_if_exist(...)
    local t = table.pack(...)
    local r = {}
    for i=1, #t do
        if type(t[i]) == "table" then
            local k, v = next(t)
            if k and v then
                table.insert(r, k)
            end
        elseif type(t[i]) == "string" then
            if TARGETS[t[i]] then
                table.insert(r, t[i])
            end
        end
    end
    return r
end

local natives = target("natives", {}, virtual_target)

function add_native_target(target)
	table.insert(natives.deps, target)
end
