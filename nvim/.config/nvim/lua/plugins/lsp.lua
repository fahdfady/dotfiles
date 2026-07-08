return {

  {
    "mrcjkb/rustaceanvim",
    optional = true,
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            check = {
              allTargets = true,
              targets = {
                "x86_64-unknown-linux-gnu",
                "x86_64-pc-windows-gnu",
              },
            },
          },
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          gopls = {},
          biome = {},
        },
      },
    },
  },
}
