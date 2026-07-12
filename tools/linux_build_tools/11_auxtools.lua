git_sync(AUXTOOLS_URL, "auxtools")
rust_compile("auxtools")
artifact("buildtmp/auxtools/target/i686-unknown-linux-gnu/release/libauxtools.so")
