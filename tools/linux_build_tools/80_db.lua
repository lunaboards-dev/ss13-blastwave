local lfs = require("lfs")

if os.execute("mariadbd --version > /dev/null") then
    print("Found MariaDBd")

    local function run_script_cur_user(path)
        print("SQL: "..path)
        os.execute("mariadb --socket=$PWD/buildtmp/database/test.sock -u $USER < "..path)
    end

    local function run_script_db_user(path)
        print("SQL: "..path)
        os.execute("mariadb --socket=$PWD/buildtmp/database/test.sock -u spess --password=password feedback < "..path)
    end

    -- Add DB targets
    explicit(
        target("db:create", {}, function()
            print("Creating DB (this may take a while)")
            os.execute([[mariadb-install-db --datadir=$PWD/buildtmp/database/data --basedir=/usr]])
        end, function()
            return not lfs.attributes("./buildtmp/database")
        end),
        target("db:start", {"db:create"}, function()
            local pid, ok = pcapture([[nohup mariadbd --datadir=$PWD/buildtmp/database/data --port=3307 --socket=$PWD/buildtmp/database/test.sock --pid-file=$PWD/buildtmp/database/test.pid > ./buildtmp/mariadb.log 2>&1 & echo $!]])
            if not ok then
                panic("Failed to start MariaDBd")
            end
            print(string.format("Started MariaDBd (PID: %s) on port 3307, waiting 10 seconds...", pid))
            os.execute("sleep 10")
            MARIADB = setmetatable({pid}, {__gc = function(self)
                print("Waiting for MariaDBd to close...")
                os.execute("kill -TERM "..self[1].."; waitpid "..self[1])
            end})
        end),
        target("db:setup", {"db:start"}, function()
            run_script_cur_user("tools/linux_build_tools/setup_db.sql")
            run_script_db_user("SQL/tgstation_schema.sql")
            run_script_db_user("SQL/nova_schema.sql")
        end),
        target("db", {"db:create", "db:start", "db:setup"}, virtual_target)
    )
end
