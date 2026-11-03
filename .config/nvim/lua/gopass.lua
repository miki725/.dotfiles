-- gopass edit decrypts the secret into a gopass-edit* temp dir
-- (ramdisk under $TMPDIR on macos, /dev/shm on linux) and opens it in $EDITOR.
-- nvim launched like that must not persist anything about the secret anywhere:
-- shada, swap, backup, undo, sessions or any plugin history (fundo, file-history)
local M = {}

function M.is_secret(path)
    return path:find("/gopass%-edit[^/]*/") ~= nil
end

-- checked from argv so its known in init.lua before any plugin or option loads
M.active = vim.iter(vim.v.argv):any(M.is_secret)

return M
