return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local opts = { noremap = true, silent = true }
    local conform = require("conform")
    local mason_registry = require("mason-registry")
    local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server"
    local function trim(s)
      return s:gsub("^%s*(.-)%s*$", "%1")
    end

    local ResolveTypescriptServer = function()
      -- Find the package.json file
      local viable = vim.fn.system("find . -name 'package.json' -maxdepth 2 | xargs dirname")
      viable = trim(viable)

      if viable == "" then
        return nil
      end

      -- Check for lock files
      local find_npm_result = trim(vim.fn.system("find . -name 'package-lock.json' -maxdepth 2 | wc -l"))
      local find_pnpm_result = trim(vim.fn.system("find . -name 'pnpm-lock.yaml' -maxdepth 2 | wc -l"))
      local find_yarn_result = trim(vim.fn.system("find . -name 'yarn.lock' -maxdepth 2 | wc -l"))

      local is_npm = find_npm_result == "1"
      local is_pnpm = find_pnpm_result == "1"
      local is_yarn = find_yarn_result == "1"

      -- if no package lock files are found, end early
      if not is_npm and not is_pnpm and not is_yarn then
        return nil
      end

      -- Determine the preferred package manager
      local ppm = "pnpm" -- Default to pnpm
      if is_npm then
        ppm = "npm"
      end
      if is_yarn then
        ppm = "yarn"
      end

      -- Resolve TypeScript server path
      local base_command = ppm .. " list typescript --dir " .. viable .. " --json"
      local base_result = trim(vim.fn.system(base_command))

      if base_result == "" then
        vim.notify("Failed to run " .. base_command, vim.log.levels.ERROR)
        return nil
      end

      local typescript_path = nil

      if ppm == "pnpm" or ppm == "npm" or ppm == "yarn" then
        local ok, parsed = pcall(vim.fn.json_decode, base_result)
        if ok and parsed and #parsed > 0 and parsed[1].path then
          typescript_path = parsed[1].path .. "/node_modules/typescript/lib"
        end
      end

      if not typescript_path or typescript_path == "" then
        vim.notify(
          "TypeScript not found. Please install TypeScript globally or in the project.",
          vim.log.levels.ERROR
        )
        return nil
      end

      return typescript_path
    end
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      -- Enable completion triggered by <c-x><c-o>
      vim.bo[opts.buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

      opts.desc = "Go to declaration"
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Go to definitions"
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Show LSP Implementation"
      vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "Get Help"
      vim.keymap.set("n", "<leader>gh", vim.lsp.buf.signature_help, opts)

      -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      -- vim.keymap.set('n', '<leaner>wr', vim.lsp.buf.remove_workspace_folder, opts)
      -- vim.keymap.set('n', '<leader>wl', function()
      --   print(vim.inspect(vim.ssp.buf.list_workspace_folders()))
      -- end, opts)

      opts.desc = "Show LSP type definitions"
      vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

      opts.desc = "Smart rename"
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "See available code actions"
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Show LSP references"
      vim.keymap.set("n", "<leader>cr", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Format File"
      vim.keymap.set("n", "<leader>f", function()
        -- vim.lsp.buf.format({ async = true })
        conform.format({
          bufnr = opts.buffer,
          async = true,
          lsp_fallback = true,
        })
      end, opts)

      opts.desc = "Restart LSP"
      vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
    end

    local signs = {
      Error = " ",
      Warn = " ",
      Hint = "󰠠 ",
      Info = " ",
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({ capabilities = capabilities })
      end,

      ["html"] = function()
        lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["ts_ls"] = function()
        lspconfig.ts_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        })
      end,

      ["cssls"] = function()
        lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["tailwindcss"] = function()
        lspconfig.tailwindcss.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "html", "svelte", "vue", "astro" },
        })
      end,

      ["svelte"] = function()
        lspconfig.svelte.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                if client.name == "svelte" then
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                end
              end,
            })
          end,
        })
      end,

      ["emmet_ls"] = function()
        lspconfig.emmet_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "astro",
            "css",
            "sass",
            "scss",
            "less",
            "svelte",
            "vue",
          },
        })
      end,

      ["pyright"] = function()
        lspconfig.pyright.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "python" },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        })
      end,

      ["dockerls"] = function()
        lspconfig.dockerls.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["jsonls"] = function()
        lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["volar"] = function()
        lspconfig.volar.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "vue" },
        })
      end,

      ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = { ["rust-analyzer"] = {} },
        })
      end,

      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        })
      end,

      ["docker_compose_language_service"] = function()
        lspconfig.docker_compose_language_service.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["eslint"] = function()
        lspconfig.eslint.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["astro"] = function()
        lspconfig.astro.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          init_options = {
            typescript = {
              tsdk = ResolveTypescriptServer(),
            },
          },
        })
      end,

      ["kotlin_language_server"] = function()
        lspconfig.kotlin_language_server.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["clangd"] = function()
        lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["arduino_language_server"] = function()
        lspconfig.arduino_language_server.setup({ capabilities = capabilities, on_attach = on_attach })
      end,

      ["biome"] = function()
        lspconfig.biome.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = {
            "javascript",
            "javascriptreact",
            "json",
            "jsonc",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
            "astro",
            "svelte",
            "vue",
          },
        })
      end,
    })
  end,
}
