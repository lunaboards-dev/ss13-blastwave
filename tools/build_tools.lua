#!/usr/bin/env lua

local lfs = require("lfs")

args = {}

for i=1, #arg do
	local k, v = arg[i]:match("([^=]+)=(.+)")
	if k then
		args[k] = v
	else
		args[arg[i]] = true
	end
end

function panic(err)
	io.stderr:write("error: ",err,"\n")
	os.exit(1)
end

function fox()
print [[
      |\/|    ____
   .__.. \   /\  /
    \_   /__/  \/
    _/  __   __/
🥒 /___/____/
]]
end

if args.clean then
	lfs.rmdir("buildtmp")

	fox()

	print("Clean complete.")

else
	--if not os.execute "[[ -e tgstation.dme ]]" then
    if not lfs.attributes("tgstation.dme") then
		panic("Script must be run from repo root.")
	end

	--os.execute("mkdir -p buildtmp")
    lfs.mkdir("buildtmp")

	local scripts = {}
	for line in lfs.dir("tools/linux_build_tools") do--io.popen("ls tools/linux_build_tools", "r"):lines() do
        if line:match("%.lua$") then
		    table.insert(scripts, line)
        end
	end

	table.sort(scripts)

	for i=1, #scripts do
		print("\27[1m:: "..scripts[i].."\27[0m")
		dofile("tools/linux_build_tools/"..scripts[i])
	end

	fox()

	print("Build complete!")
end
