-- This configuration is based on kickstart https://github.com/nvim-lua/kickstart.nvim
io.write("Loading init.lua")

-- Set <space> as the leader key (:help mapleader)
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ghostty suppors nerdfont
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
local function options()
	vim.o.colorcolumn = "80,120,200"
	vim.o.hlsearch = true
	vim.wo.number = true
	vim.o.mouse = "a"
	vim.o.showmode = false
	vim.o.breakindent = true
	vim.o.undofile = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.wo.signcolumn = "yes"
	vim.o.updatetime = 250
	vim.o.timeoutlen = 300
	vim.o.splitright = true
	vim.o.splitbelow = true
	vim.o.completeopt = "menuone,noselect"
	vim.o.wildmode = "longest:full,full"
	-- NOTE: You should make sure your terminal supports this
	vim.o.termguicolors = true
	-- :help fo-table
	vim.o.formatoptions = "tqj"
	vim.o.nrformats = "octal,hex,alpha"

	vim.o.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	vim.o.inccommand = "split"
	vim.o.cursorline = true
	vim.o.scrolloff = 10
	vim.o.confirm = true
end
options()

-- [[ Basic Keymaps ]]
local function basic_keymaps()
	-- Clear highlights on search when pressing <Esc> in normal mode
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

	-- Remap for dealing with word wrap
	vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

	-- Diagnostic keymaps
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	-- TODO(pwr): add go to next hunk again "[c"
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, { desc = "Previous diagnostic message" })

	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = -1 })
	end, { desc = "Next diagnostic message" })

	-- CTRL+<hjkl> to switch between windows (:help wincmd)
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
end
basic_keymaps()

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`
local function autocommands()
	-- Highlight when yanking (copying) text
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})
end
autocommands()

-- [[ Install `lazy.nvim` plugin manager ]]
local function install_lazy()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
		if vim.v.shell_error ~= 0 then
			error("Error cloning lazy.nvim:\n" .. out)
		end
	end
	vim.opt.runtimepath:prepend(lazypath)
end
install_lazy()

-- [[ Configure and install plugins ]]
local function install_plugins()
	-- NOTE: Here is where you install your plugins.
	require("lazy").setup({
		-- Colorscheme
		{
			"ellisonleao/gruvbox.nvim",
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("gruvbox")
			end,
		},

		-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
		"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically

		{ -- Adds git related signs to the gutter, as well as utilities for managing changes
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({
					signs = {
						add = { text = "+" },
						change = { text = "~" },
						delete = { text = "_" },
						topdelete = { text = "‾" },
						changedelete = { text = "~" },
					},
				})
			end,
		},

		{ -- Useful plugin to show you pending keybinds.
			"folke/which-key.nvim",
			event = "VimEnter",
			opts = {
				delay = 500,
				icons = {
					mappings = vim.g.have_nerd_font,
					keys = vim.g.have_nerd_font and {} or {
						Up = "<Up> ",
						Down = "<Down> ",
						Left = "<Left> ",
						Right = "<Right> ",
						C = "<C-…> ",
						M = "<M-…> ",
						D = "<D-…> ",
						S = "<S-…> ",
						CR = "<CR> ",
						Esc = "<Esc> ",
						ScrollWheelDown = "<ScrollWheelDown> ",
						ScrollWheelUp = "<ScrollWheelUp> ",
						NL = "<NL> ",
						BS = "<BS> ",
						Space = "<Space> ",
						Tab = "<Tab> ",
						F1 = "<F1>",
						F2 = "<F2>",
						F3 = "<F3>",
						F4 = "<F4>",
						F5 = "<F5>",
						F6 = "<F6>",
						F7 = "<F7>",
						F8 = "<F8>",
						F9 = "<F9>",
						F10 = "<F10>",
						F11 = "<F11>",
						F12 = "<F12>",
					},
				},
				spec = {
					{ "<leader>s", group = "[S]earch" },
					{ "<leader>t", group = "[T]oggle" },
					{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				},
			},
		},

		{ -- Fuzzy finder
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
					cond = function()
						return vim.fn.executable("make") == 1
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },
				-- Useful for getting pretty icons, but requires a Nerd Font.
				{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			},
			config = function()
				require("telescope").setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
					defaults = {
						layout_strategy = "horizontal",
						layout_config = {
							width = 0.999999,
							height = 0.999999,
						},
					},
				})

				pcall(require("telescope").load_extension, "fzf")
				pcall(require("telescope").load_extension, "ui-select")

				-- See `:help telescope.builtin`
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
				vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
				vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
				vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
				vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
				vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
				vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
				vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
				vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
				vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

				-- Slightly advanced example of overriding default behavior and theme
				vim.keymap.set("n", "<leader>/", function()
					-- You can pass additional configuration to Telescope to change the theme, layout, etc.
					builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
						layout_strategy = "horizontal",
						layout_config = {
							width = 0.999999,
							height = 0.999999,
						},
					}))
				end, { desc = "[/] Fuzzily search in current buffer" })

				vim.keymap.set("n", "<leader>s/", function()
					builtin.live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end, { desc = "[S]earch [/] in Open Files" })

				vim.keymap.set("n", "<leader>sn", function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end, { desc = "[S]earch [N]eovim files" })
			end,
		},

		{ -- LSP Plugins
			-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},

		{ -- Main LSP Configuration
			"neovim/nvim-lspconfig",
			dependencies = {
				-- Mason package manager
				{ "mason-org/mason.nvim", opts = {} },
				"mason-org/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",

				-- Useful status updates for LSP.
				{ "j-hui/fidget.nvim", opts = {} },

				-- Allows extra capabilities provided by blink.cmp
				"saghen/blink.cmp",
			},
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
					callback = function(event)
						local map = function(keys, func, desc, mode)
							mode = mode or "n"
							vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						map("<Space>rn", vim.lsp.buf.rename, "[R]e[n]ame")
						map("ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
						map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
						map("<Space>ds", require("telescope.builtin").lsp_document_symbols, "Open [D]ocument [S]ymbols")
						map(
							"<Space>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"Open [W]orkspace [S]ymbols"
						)
						map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

						vim.keymap.set("i", "<c-space>", function()
							vim.lsp.completion.get()
						end)

						-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
						---@param client vim.lsp.Client
						---@param method vim.lsp.protocol.Method
						---@param bufnr? integer some lsp support methods only in specific files
						---@return boolean
						local function client_supports_method(client, method, bufnr)
							if vim.fn.has("nvim-0.11") == 1 then
								return client:supports_method(method, bufnr)
							else
								return client.supports_method(method, { bufnr = bufnr })
							end
						end

						-- The following two autocommands are used to highlight references of the
						-- word under your cursor when your cursor rests there for a little while.
						--    See `:help CursorHold` for information about when this is executed
						--
						-- When you move your cursor, the highlights will be cleared (the second autocommand).
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if
							client
							and client_supports_method(
								client,
								vim.lsp.protocol.Methods.textDocument_documentHighlight,
								event.buf
							)
						then
							local highlight_augroup =
								vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})

							vim.api.nvim_create_autocmd("LspDetach", {
								group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
								callback = function(event2)
									vim.lsp.buf.clear_references()
									vim.api.nvim_clear_autocmds({
										group = "kickstart-lsp-highlight",
										buffer = event2.buf,
									})
								end,
							})
						end

						if
							client
							and client_supports_method(
								client,
								vim.lsp.protocol.Methods.textDocument_inlayHint,
								event.buf
							)
						then
							map("<leader>th", function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
							end, "[T]oggle Inlay [H]ints")
						end
					end,
				})

				-- Diagnostic Config
				-- See :help vim.diagnostic.Opts
				vim.diagnostic.config({
					severity_sort = true,
					float = { border = "rounded", source = "if_many" },
					underline = { severity = vim.diagnostic.severity.ERROR },
					signs = vim.g.have_nerd_font and {
						text = {
							[vim.diagnostic.severity.ERROR] = "󰅚 ",
							[vim.diagnostic.severity.WARN] = "󰀪 ",
							[vim.diagnostic.severity.INFO] = "󰋽 ",
							[vim.diagnostic.severity.HINT] = "󰌶 ",
						},
					} or {},
					-- virtual_text = {
					-- 	source = "if_many",
					-- 	spacing = 2,
					-- 	format = function(diagnostic)
					-- 		local diagnostic_message = {
					-- 			[vim.diagnostic.severity.ERROR] = diagnostic.message,
					-- 			[vim.diagnostic.severity.WARN] = diagnostic.message,
					-- 			[vim.diagnostic.severity.INFO] = diagnostic.message,
					-- 			[vim.diagnostic.severity.HINT] = diagnostic.message,
					-- 		}
					-- 		return diagnostic_message[diagnostic.severity]
					-- 	end,
					-- },
					virtual_lines = {
						source = "if_many",
						spacing = 2,
						format = function(diagnostic)
							local diagnostic_message = {
								[vim.diagnostic.severity.ERROR] = diagnostic.message,
								[vim.diagnostic.severity.WARN] = diagnostic.message,
								[vim.diagnostic.severity.INFO] = diagnostic.message,
								[vim.diagnostic.severity.HINT] = diagnostic.message,
							}
							return diagnostic_message[diagnostic.severity]
						end,
					},
				})
				vim.diagnostic.enable()

				-- LSP servers and clients are able to communicate to each other what features they support.
				--  By default, Neovim doesn't support everything that is in the LSP specification.
				--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
				local capabilities = require("blink.cmp").get_lsp_capabilities()

				-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
				local servers = {
					clangd = {},
					gopls = {},
					rust_analyzer = {},
					lua_ls = {
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					},
					zls = {
						-- Omit the following line if `zls` is in your PATH:
						-- => install via dependencies.sh script checked into dotfiles (build from source).
						cmd = { "/home/pwr/zls/zig-out/bin/zls" },
						settings = {
							-- See https://github.com/zigtools/zls/blob/master/src/Config.zig.
							zls = {
								-- Omit the following line if `zig` is in your PATH:
								-- zig_exe_path = '~/zig/master',

								enable_snippets = false,
								enable_build_on_save = true,
								enable_argument_placeholders = true,
								completion_label_details = true,
								-- enable_build_on_save: ?bool = null,
								-- build_on_save_args: []const []const u8 = &.{},
								-- semantic_tokens = "partial", -- nvim already provides basic syntax highlighting.
								inlay_hints_show_variable_type_hints = true,
								inlay_hints_show_struct_literal_field_type = true,
								inlay_hints_show_parameter_name = true,
								inlay_hints_show_builtin = true,
								inlay_hints_exclude_single_argument = true,
								inlay_hints_hide_redundant_param_names = false,
								inlay_hints_hide_redundant_param_names_last_token = false,
								force_autofix = false,
								warn_style = true,
								highlight_global_var_declarations = true,
								skip_std_references = false,
								prefer_ast_check_as_child_process = true,
								-- builtin_path: ?[]const u8 = null,
								-- zig_lib_path: ?[]const u8 = null,
								-- zig_exe_path: ?[]const u8 = null,
								-- build_runner_path: ?[]const u8 = null,
								-- global_cache_path: ?[]const u8 = null,
							},
						},
					},
				}
				-- Don't show parse errors in a separate window.
				vim.g.zig_fmt_parse_errors = 0

				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua", -- Used to format Lua code
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
					automatic_installation = false,
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},

		{ -- Autoformat
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true }
					if disable_filetypes[vim.bo[bufnr].filetype] then
						return nil
					else
						return {
							timeout_ms = 500,
							lsp_format = "fallback",
						}
					end
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use 'stop_after_first' to run the first available formatter from the list
					-- javascript = { "prettierd", "prettier", stop_after_first = true },
				},
			},
		},

		{ -- Autocompletion
			"saghen/blink.cmp",
			event = "VimEnter",
			version = "1.*",
			dependencies = {
				-- Snippet Engine
				{
					"L3MON4D3/LuaSnip",
					version = "2.*",
					build = (function()
						-- Build Step is needed for regex support in snippets.
						-- This step is not supported in many windows environments.
						-- Remove the below condition to re-enable on windows.
						if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
					dependencies = {},
					opts = {},
				},
				"folke/lazydev.nvim",
			},
			--- @module 'blink.cmp'
			--- @type blink.cmp.Config
			opts = {
				keymap = {
					-- 'default' (recommended) for mappings similar to built-in completions
					--   <c-y> to accept ([y]es) the completion.
					--    This will auto-import if your LSP supports it.
					--    This will expand snippets if the LSP sent a snippet.
					-- 'super-tab' for tab to accept
					-- 'enter' for enter to accept
					-- 'none' for no mappings
					--
					-- For an understanding of why the 'default' preset is recommended,
					-- you will need to read `:help ins-completion`
					--
					-- No, but seriously. Please read `:help ins-completion`, it is really good!
					--
					-- All presets have the following mappings:
					-- <tab>/<s-tab>: move to right/left of your snippet expansion
					-- <c-space>: Open menu or open docs if already open
					-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
					-- <c-e>: Hide menu
					-- <c-k>: Toggle signature help
					--
					-- See :h blink-cmp-config-keymap for defining your own keymap
					preset = "default",

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				},

				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},

				completion = {
					-- By default, you may press `<c-space>` to show the documentation.
					-- Optionally, set `auto_show = true` to show the documentation after a delay.
					documentation = { auto_show = false, auto_show_delay_ms = 500 },
				},

				sources = {
					default = { "lsp", "path", "snippets", "lazydev" },
					providers = {
						lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
					},
				},

				snippets = { preset = "luasnip" },

				fuzzy = { implementation = "lua" },

				signature = { enabled = true },
			},
		},

		-- Highlight todo, notes, etc in comments
		{
			"folke/todo-comments.nvim",
			event = "VimEnter",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = { signs = false },
		},

		{ -- Collection of various small independent plugins/modules, see https://github.com/echasnovski/mini.nvim
			"echasnovski/mini.nvim",
			config = function()
				-- Better Around/Inside textobjects
				require("mini.ai").setup({ n_lines = 500 })

				-- Add/delete/replace surroundings (brackets, quotes, etc.)
				require("mini.surround").setup()

				-- Simple and easy statusline.
				local statusline = require("mini.statusline")
				statusline.setup({ use_icons = vim.g.have_nerd_font })

				-- You can configure sections in the statusline by overriding their
				-- default behavior. For example, here we set the section for
				-- cursor location to LINE:COLUMN
				---@diagnostic disable-next-line: duplicate-set-field
				statusline.section_location = function()
					return "%2l:%-2v"
				end
			end,
		},

		{ -- Highlight, edit, and navigate code
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs", -- Sets main module to use for opts
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
			opts = {
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
				},
				auto_install = false,
				highlight = {
					enable = true,
					-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
					--  If you are experiencing weird indenting issues, add the language to
					--  the list of additional_vim_regex_highlighting and disabled languages for indent.
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
			},
		},

		-- require 'kickstart.plugins.debug',
		-- require 'kickstart.plugins.indent_line',
		-- require 'kickstart.plugins.lint',
		-- require 'kickstart.plugins.autopairs',
		-- require 'kickstart.plugins.neo-tree',
		-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

		-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
		--    This is the easiest way to modularize your config.
		--
		--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
		-- { import = 'custom.plugins' },
	}, {
		ui = {
			-- If you are using a Nerd Font: set icons to an empty table which will use the
			-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
			icons = vim.g.have_nerd_font and {} or {
				cmd = "⌘",
				config = "🛠",
				event = "📅",
				ft = "📂",
				init = "⚙",
				keys = "🗝",
				plugin = "🔌",
				runtime = "💻",
				require = "🌙",
				source = "📄",
				start = "🚀",
				task = "📌",
				lazy = "💤 ",
			},
		},
	})
end
install_plugins()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
