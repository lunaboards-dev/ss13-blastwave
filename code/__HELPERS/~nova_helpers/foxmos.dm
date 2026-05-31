#define FOXMOS_CACHE(func) var/static/##func = load_ext("foxmos", "byond:[#func]")
#define FOXMOS_PASS_AND_CALL(handle) var/list/_temp = args.Copy(); _temp.Insert(1, src); return call_ext(handle)(arglist(_temp))
