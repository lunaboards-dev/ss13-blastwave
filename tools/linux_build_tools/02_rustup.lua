if not os.execute("rustup --version > /dev/null") then
    download("https://sh.rustup.rs", "buildtmp/rustup-init.sh")
    os.execute("chmod +x buildtmp/rustup-init.sh")
    os.execute("cd buildtmp; ./rustup-init.sh")
    panic("Follow the above instructions and rerun the tool.")
else
    print("Rustup already installed, no need to reinstall.")
end
os.execute("rustup target add i686-unknown-linux-gnu")

function rust(name, deps, _repo, binary)
	add_native_target(name)
    return repo(name, deps, _repo, function(path)
        os.execute("cd "..path.."; PKG_CONFIG_ALLOW_CROSS=1 cargo build --release --target i686-unknown-linux-gnu")
        artifact(path.."/target/i686-unknown-linux-gnu/release/"..binary)
    end)
end
