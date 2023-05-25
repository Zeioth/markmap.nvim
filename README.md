# Markmap.nvim
Visualize your Markdown as mindmaps with markmap

![screenshot_2023-05-25_02-51-13_907564300](https://github.com/Zeioth/markmap.nvim/assets/3357792/e05a5050-622c-47b9-bc96-6e9ffd266b10)

## Motivation
This plugin is based on vim's [coc-markmap](https://github.com/markmap/coc-markmap), which I missed when moving to Neovim. If you wanna know more about mindmap check their [website](https://markmap.js.org/), [docs](https://markmap.js.org/docs/markmap) and GitHub [repository](https://github.com/markmap/markmap/tree/master/packages/markmap-cli).

## Requirements

* yarn

## How to install using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
--  [markdown markmap]
--  https://github.com/Zeioth/markmap.nvim
{
  "Zeioth/markmap.nvim",
  build = "yarn global add markmap-cli",
  cmd = {"MarkmapOpen", "MarkmapSave", "MarkmapWatch"},
  opts = {
    html_output = "/tmp/markmap.html", -- Empty string will set the same path as the current mawkdown file, but with .html extension.
    hide_toolbar = "false,
  },
  config = function(_, opts) require("markmap").setup(opts) end
},
```

## How to use
We expose the next commands:

* :MarkmapOpen → Open the markmap
* :MarkmapSave → Save without opening
* :MarkmapWatch → Open the markmap and watch for changes

## Troubleshooting

* Run
```
yarn global add markmap-cli
```    
* Now try to run
```    
markmap
```
If the executable is not found, that means you need to add yarn to your PATH. This is normally done in your .profile, bashrc, or zshrc file like this:

``` sh
# PATH Example
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

## TODOS
Expose options for

* --output → In case the user wanna keep the generated html files for some reason. In reality it would be nicer to have :MarkmapSave for this.
* --watch → We could have the command :MarkmapWatch to open and watch for changes in real time.
* --no-toolbar → Boolead option to display or not the zoom buttons.

