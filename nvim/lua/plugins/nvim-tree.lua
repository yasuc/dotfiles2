return {
	"nvim-tree/nvim-tree.lua",
	requires = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
	config = function()
		require("nvim-tree").setup({
			view = {
				width = "20%",
				signcolumn = "no",
			},

			renderer = {
				highlight_git = true,
				highlight_opened_files = "name",
				icons = {
					glyphs = {
						git = {
							unstaged = "!",
							renamed = "»",
							untracked = "?",
							deleted = "✘",
							staged = "✓",
							unmerged = "",
							ignored = "◌",
						},
					},
				},
			},

			actions = {
				expand_all = {
					max_folder_discovery = 100,
					exclude = { ".git", "target", "build" },
				},
			},
			on_attach = require("config.nvim-tree-actions").on_attach,
		})

		vim.api.nvim_create_user_command("Ex", function()
			vim.cmd.NvimTreeToggle()
		end, {})
	end,
}
