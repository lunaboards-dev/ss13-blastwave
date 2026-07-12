local function copy(from, to)
	print(string.format("%s -> %s", from, to))
	os.execute(string.format("cp -a %q %q", from, to))
end

local function copy_dir(from, to)
	print(string.format("%s/ -> %s", from, to))
	os.execute(string.format("cp -ar %q/. %q", from, to))
end

for i=1, #ARTIFACTS do
    local art = ARTIFACTS[i]
    if art.dir then
        copy_dir(art.src, art.dst)
    else
        copy(art.src, art.dst)
    end
end
