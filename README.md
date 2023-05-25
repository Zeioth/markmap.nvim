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
    html_output = "/tmp/markmap.html", -- Using an empty string here means: Current file's path, but with .html extension.
    hide_toolbar = "false",
  },
  config = function(_, opts) require("markmap").setup(opts) end
},
```

## How to use
Markmap.nvim provide the next commands:

|  Command            | Description                             |
|---------------------|-----------------------------------------|
| **:MarkmapOpen**    | Open the markmap                        |
| **:MarkmapSave**    | Save without opening                    |
| **:MarkmapWatch**   | Open the markmap and watch for changes (currentlly broken)  |

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
* The watch feature is currently broken: We should call it async so we can keep working on nvim.
* We should though kill the process after a certain time. Otherwise processess may stack. It would be nice to give the user an option to decide the session time, and/or a command to kill all processess.
* The ideal solution would be to use RCP to check when the browser tab is closed, like markdown-preview.nvim does. PRs are welcome.
