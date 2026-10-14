local function copy(from, to)
	print(string.format("%s -> %s", from, to))
	os.execute(string.format("cp -a %q %q", from, to))
end

local function copy_dir(from, to)
	print(string.format("%s/ -> %s", from, to))
	os.execute(string.format("cp -ar %q/. %q", from, to))
end

--[[ copy(RUSTG_PATH, "librust_g.so")
copy(AUXTOOLS_PATH, "libauxtools.so")
 ]]

local to_run = {}
local staged = {}

local function calc_deps(target)
    if staged[target] then
        return
    end
    staged[target] = true
    for i=1, #target.deps do
        local dep = target.deps[i]
        if not to_run[dep] then
            calc_deps(TARGETS[dep])
        end
    end
    staged[target] = false
    table.insert(to_run, target)
    to_run[target.name] = true
end

local adep = {}
for i=1, #TARGETS do
    if not TARGETS[i].explicit then
        table.insert(adep, TARGETS[i].name)
    end
end

target("all", adep, virtual_target)

local ctarget = TARGETS[args.target or "all"]

if not ctarget then
    panic("No such target: "..args.target)
end

if args.targets then
	print("\27[1m:: TARGETS:\27[0m")
	for i=1, #TARGETS do
		local t = TARGETS[i]
		print(string.format("%s%s (%s)", t.explicit and "*" or " ", t.name, table.concat(t.deps, ", ")))
	end
	os.exit(0)
end

calc_deps(ctarget)

for i=1, #to_run do
    local tg = to_run[i]
    if tg.run ~= virtual_target then
        if tg.check() then
            print("\27[1m:: \27[36mTARGET:\27[39m "..tg.name.."\27[0m")
            tg.run()
        else
            print("\27[1m:: \27[36mTARGET:\27[39m "..tg.name.."\27[0m - Up to date")
        end
    end
end

for i=1, #ARTIFACTS do
    local art = ARTIFACTS[i]
    if art.dir then
        copy_dir(art.src, art.dst)
    else
        copy(art.src, art.dst)
    end
end
