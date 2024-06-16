local opt = vim.opt

opt.spelllang:append("cjk") -- Disable spellchecking for asian characters `VIM algorithm does not support it`

-- Disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end
