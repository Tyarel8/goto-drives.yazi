local function directory_exists(path)
    local files, err = fs.read_dir(Url(path), { limit = 0 })
    return files ~= nil
end

local function get_drive_name(drive)
    local output, err = Command("cmd")
        :args({ "/c", "vol", drive })
        :output()

    if not output then
        return nil, "Failed to execute vol command"
    end
    local output = output.stdout

    -- Parse the output to extract the drive name
    local output = output:sub(1, output:find("\r\n") - 1)
    if output:match(" Volume in drive %w has no label") then
        return "-", nil
    end
    local drive_name = output:match(" Volume in drive %w is%s*([^%s].*)$")

    -- Return the drive name
    return drive_name, nil
end

return {
    entry = function(self, job)
        if ya.target_family() ~= "windows" then
            ya.notify { title = "goto-drives", content = "This plugin only works on windows", timeout = 3.0, level = "Error" }
            return
        end

        local abc = { "A", "B", "C", "D", "E",
            "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S",
            "T", "U", "V", "W", "X", "Y", "Z", }

        local drives = {}
        local keys = {}
        for _, l in ipairs(abc) do
            local drive = l .. ":"
            if directory_exists(drive) then
                local name, err = get_drive_name(drive)
                local key = string.format("%s (%s)", name or "<error>", drive)
                drives[key] = drive
                -- Insert the keys into an array to preserve the order
                table.insert(keys, key)
            end
        end

        local permit = ya.hide()
        local child = Command("fzf")
            :args({ "--prompt", "Choose a drive: ", "--preview", "" })
            :stdout(Command.PIPED):stdin(Command.PIPED)
            :spawn()

        child:write_all(table.concat(keys, "\n"))
        child:flush()

        local output, err = child:wait_with_output()
        permit:drop()

        if output.stdout ~= "" then
            ya.manager_emit("cd", { drives[output.stdout:gsub("%s+$", "")] })
        end
    end,
}
