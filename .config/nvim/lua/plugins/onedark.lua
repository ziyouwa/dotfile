return {
	-- onedark.nvim 主题
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				style = "dark", -- 主题风格：dark、darker、cool、deep、warm、warmer、light
				-- 其他配置选项
				colors = {}, -- 覆盖默认颜色
				highlights = {}, -- 覆盖默认高亮
				-- 设置透明背景
				transparent = false,
				-- 终端颜色
				term_colors = true,
				-- 结束插件配置后加载主题
				after = function()
					require("onedark").load()
				end,
			})
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "onedark",
		},
	},
}
