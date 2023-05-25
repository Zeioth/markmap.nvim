# Markmap.nvim
Visualize your Markdown as mindmaps with markmap

![screenshot_2023-05-25_02-51-13_907564300](https://github.com/Zeioth/markmap.nvim/assets/3357792/6d2e2494-5240-4def-adf2-03a89c993a19)

## How to install using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
--  [markdown markmap]
--  https://github.com/markmap/markmap
--  Note: If you change the build command, wipe ~/.local/data/nvim/lazy
{
  "Zeioth/markmap.nvim",
  build = "yarn global add markmap-cli",
   cmd = {"MarkmapOpen"},
  config = function()
    require("markmap").setup()
  end
},
```
