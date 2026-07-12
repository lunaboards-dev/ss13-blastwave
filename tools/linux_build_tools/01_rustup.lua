if not os.execute("rustup --version > /dev/null") then
    download("https://sh.rustup.rs", "buildtmp/rustup-init.sh")
    os.execute("chmod +x buildtmp/rustup-init.sh")
    os.execute("cd buildtmp; ./rustup-init.sh")
    panic("Follow the above instructions and rerun the tool.")
else
    print("Rustup already installed, no need to reinstall.")
end
os.execute("rustup target add i686-unknown-linux-gnu")

function rust_compile(dir)
    os.execute("cd buildtmp/"..dir.."; PKG_CONFIG_ALLOW_CROSS=1 cargo build --release --target i686-unknown-linux-gnu")
end
