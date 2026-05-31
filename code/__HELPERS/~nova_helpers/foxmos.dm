// Loads the handle for the specific function from the foxmos library.
#define FOXMOS_CACHE(func) var/static/##func = load_ext("foxmos", "byond:[#func]")
// Sets up and executes an automagic library call. ONLY USE IF YOU HAVE NO OTHER CODE IN THE PROC!
#define FOXMOS_PASS_AND_CALL(handle) var/list/_temp = args.Copy(); _temp.Insert(1, src); return call_ext(handle)(arglist(_temp))
// Executes a library call and pass the correct arguments. This also doesn't have the overhead of PASS_AND_CALL, so use it for procs that always have args.
#define FOXMOS_FASTPASS(handle, args...) call_ext(handle)(src, ##args)
