# Markmap.nvim
Visualize your Markdown as mindmaps with markmap

![screenshot_2023-05-25_02-51-13_907564300](https://github.com/Zeioth/markmap.nvim/assets/3357792/e05a5050-622c-47b9-bc96-6e9ffd266b10)

## Requirements

* yarn

## How to install using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
--  [markdown markmap]
--  https://github.com/Zeioth/markmap.nvim
{
  "Zeioth/markmap.nvim",
  build = "yarn global add markmap-cli",
   cmd = {"MarkmapOpen"},
  config = function()
    require("markmap").setup()
  end
},
```

## Troubleshooting

* Run
```
yarn global add markmap-cli
```    
* Now try to run
```    
markmap
```
If you the terminal cannot find the executable, that means you need to add yarn to your PATH. This is normally done in your .profile, bashrc, or zshrc file like this:

``` Example
# PATH
export PATH="$HOME/.local/bin:\
$HOME/.cargo/bin:\
$HOME/.yarn/bin:\
$HOME/.config/yarn/global/node_modules/.bin:\
$HOME/.local/share/gem/ruby/3.0.0/bin:\
$HOME/.cargo/env\
/root/.local/share/gem/ruby/3.0.0/bin:\
/usr/local/bin:\
/usr/share/nvm/init-nvm.sh \
$PATH"
```
