local QUERY_CLASS = {}
QUERY_CLASS.__index = QUERY_CLASS

-- Added functionality for SQL ALTER statement
function QUERY_CLASS:AlterTable(tableName)
    self.tableName = tableName
    self.alterColumns = {}

    function self:AddColumn(columnName, columnType, defaultValue)
        local column = {
            name = columnName,
            type = columnType,
            default = defaultValue
        }

        table.insert(self.alterColumns, column)
        return self
    end

    function self:ColumnExists(columnName, callback)
        if not Clockwork.database then
            error("Database object not set.\n")
            return false
        end

        local query = "SELECT * FROM information_schema.columns WHERE table_name = '" .. self.tableName .. "' AND column_name = '" .. columnName .. "';"
        local result = Clockwork.database:Queue(query, function(data)
            if callback then
                callback(data and data[1] ~= nil)
            end
        end)
    end

    function self:Execute(bQueueQuery)
        if not Clockwork.database then
            error("Database object not set.\n")
            return
        end

        for _, column in pairs(self.alterColumns) do
            if not self:ColumnExists(column.name) then
                local sql = "ALTER TABLE `" .. self.tableName .. "` ADD COLUMN `" .. column.name .. "` " .. column.type

                if column.default then
                    sql = sql .. " DEFAULT '" .. Clockwork.database:Escape(column.default) .. "'"
                end

                if not bQueueQuery then
                    Clockwork.database:RawQuery(sql)
                else
                    Clockwork.database:Queue(sql)
                end
            end
        end
    end

    return self
end

-- Hook DatabaseConnected to append new tables/columns
hook.Add("DatabaseConnected", "", function()
    local databaseMod = Clockwork.database.Module
    if (databaseMod == "sqlite") then
        -- Create clans table
        local clansQueryObj = Clockwork.database:Create("clans")
        clansQueryObj:Create("_ID", "INTEGER AUTOINCREMENT")
        clansQueryObj:Create("_Name", "TEXT")
        clansQueryObj:Create("_Characters", "TEXT")
        clansQueryObj:PrimaryKey("_ID")
        clansQueryObj:Execute()

        -- Alter characters table to add _ClanName column
        local charactersQueryObj = QUERY_CLASS:AlterTable(config.Get("mysql_characters_table"):Get())
        charactersQueryObj:AddColumn("_ClanName", "TEXT DEFAULT ''")
        -- Use the callback to execute the query after checking if the column exists
        charactersQueryObj:ColumnExists("_ClanName", function(exists)
            if not exists then
                charactersQueryObj:Execute()
            end
        end)
    else
        -- Create clans table
        local clansQueryObj = Clockwork.database:Create("clans")
        clansQueryObj:Create("_ID", "int(11) NOT NULL AUTO_INCREMENT")
        clansQueryObj:Create("_Name", "varchar(150) NOT NULL")
        clansQueryObj:Create("_Characters", "text NOT NULL")
        clansQueryObj:PrimaryKey("_ID")
        clansQueryObj:Execute()

        -- Alter characters table to add _ClanName column
        local charactersQueryObj = QUERY_CLASS:AlterTable(config.Get("mysql_characters_table"):Get())
        charactersQueryObj:AddColumn("_ClanName", "varchar(150) DEFAULT ''")
        -- Use the callback to execute the query after checking if the column exists
        charactersQueryObj:ColumnExists("_ClanName", function(exists)
            if not exists then
                charactersQueryObj:Execute()
            end
        end)
    end
end)
