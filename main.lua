local function directory_exists(path)
    local files, err = fs.read_dir(Url(path), { limit = 0 })
    return files ~= nil
end

return {
    entry = function(self, job)
        if ya.target_family() ~= "windows" then
            ya.notify { title = "goto-drives", content = "This plugin only works on windows", timeout = 3.0, level = "error" }
            return
        end

        local abc = { "A", "B", "C", "D", "E",
            "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S",
            "T", "U", "V", "W", "X", "Y", "Z", }

        local drives = {}
        for _, d in ipairs(abc) do
            if directory_exists(d .. ":") then
                table.insert(drives, d)
            end
        end

        local permit = ya.hide()
        local child = Command("fzf"):args({ "--prompt", "Choose a drive: " }):stdout(Command.PIPED):stdin(Command.PIPED)
            :spawn()

        child:write_all(table.concat(drives, "\n"))
        child:flush()

        local output, err = child:wait_with_output()
        permit:drop()

        if output.stdout ~= "" then
            ya.manager_emit("cd", { output.stdout:gsub("%s+$", "") .. ":" })
        end
    end,
}
