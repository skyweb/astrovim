---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = true,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        ignore_filetypes = {
          "php",  -- usa php-cs-fixer via none-ls, non intelephense formatter
        },
      },
      disabled = {
        "ts_ls",   -- usa prettierd + eslint_d via none-ls
        "html",    -- usa prettierd
        "cssls",   -- usa prettierd
      },
      timeout_ms = 3000,
    },
    config = {
      -- Python: strict mode per Django
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              diagnosticMode = "workspace",
            },
          },
        },
      },
      -- PHP: Laravel stubs + docblock support
      intelephense = {
        settings = {
          intelephense = {
            stubs = {
              "apache", "bcmath", "bz2", "calendar", "Core", "ctype", "curl",
              "date", "dom", "exif", "fileinfo", "filter", "gd", "hash",
              "iconv", "json", "mbstring", "meta", "mysqli", "openssl",
              "pcntl", "pcre", "PDO", "pdo_mysql", "pdo_pgsql", "pdo_sqlite",
              "pgsql", "Phar", "posix", "readline", "Reflection", "regex",
              "session", "SimpleXML", "sodium", "SPL", "sqlite3", "standard",
              "tokenizer", "xml", "xmlreader", "xmlwriter", "xsl",
              "Zend OPcache", "zip", "zlib",
              -- Laravel stubs
              "laravel",
            },
            files = { maxSize = 5000000 },
            environment = { phpVersion = "8.2" },
            -- Docblock: completion e hover per PHPDoc
            completion = {
              insertUseDeclaration = true,
              fullyQualifyGlobalConstantsAndFunctions = false,
              triggerParameterHints = true,
              maxItems = 100,
            },
            phpdoc = {
              returnVoid = true,
              useFullyQualifiedNames = false,
              textFormat = "snippet",
              functionTemplate = {
                summary = "$1",
                tags = {
                  "@param ${1:$SYMBOL_TYPE} $SYMBOL_NAME",
                  "@return ${1:$SYMBOL_TYPE}",
                },
              },
              propertyTemplate = {
                summary = "$1",
                tags = { "@var ${1:$SYMBOL_TYPE}" },
              },
              variableTemplate = {
                summary = "$1",
                tags = { "@var ${1:$SYMBOL_TYPE}" },
              },
            },
          },
        },
      },
      -- TypeScript: Next.js / React + inlay hints
      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Go to declaration",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full"
              and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
  },
}
