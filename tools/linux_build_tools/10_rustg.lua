git_sync(RUSTG_URL, "rust-g")
rust_compile("rust-g")
artifact("buildtmp/rust-g/target/i686-unknown-linux-gnu/release/librust_g.so")
