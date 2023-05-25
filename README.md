# Markmap.nvim
Visualize your Markdown as mindmaps with markmap

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
