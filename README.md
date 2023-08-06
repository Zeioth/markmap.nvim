# Markmap.nvim
Visualize your Markdown as mindmaps with markmap

![screenshot_2023-05-25_02-51-13_907564300](https://github.com/Zeioth/markmap.nvim/assets/3357792/e05a5050-622c-47b9-bc96-6e9ffd266b10)

<div align="center">
  <a href="https://discord.gg/ymcMaSnq7d" rel="nofollow">
      <img src="https://img.shields.io/discord/1121138836525813760?color=azure&labelColor=6DC2A4&logo=discord&logoColor=black&label=Join the discord server&style=for-the-badge" data-canonical-src="https://img.shields.io/discord/1121138836525813760">
    </a>
</div>

## Motivation
This plugin is based on vim's [coc-markmap](https://github.com/markmap/coc-markmap), which I missed when moving to Neovim. If you wanna know more about mindmap check their [website](https://markmap.js.org/), [docs](https://markmap.js.org/docs/markmap) and GitHub [repository](https://github.com/markmap/markmap/tree/master/packages/markmap-cli). This plugin is compatible with Linux, MacOS, Windows, and Android Termux.

## Requirements

* yarn

## How to install using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
--  [markdown markmap]
--  https://github.com/Zeioth/markmap.nvim
{
  "Zeioth/markmap.nvim",
  build = "yarn global add markmap-cli",
  cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
  opts = {
    html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
    hide_toolbar = false, -- (default)
    grace_period = 3600000 -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
  },
  config = function(_, opts) require("markmap").setup(opts) end
},
```

## How to use
Markmap.nvim provide the next commands:

|  Command            | Description                             |
|---------------------|-----------------------------------------|
| **:MarkmapOpen**    | Open markmap                            |
| **:MarkmapSave**    | Save markmap without opening it         |
| **:MarkmapWatch**   | Open markmap and watch for changes      |
| **:MarkmapWatchStop** | The watch server ends automatically after a grace period, or when closing nvim. But it can also be stopped manually with this command. |

Note that all these commands will always generate a `.html` file in `html_output`. Take adventage of this if you want to keep the graph.

## Troubleshooting
Run `:healthcheck markmap`. This command will tell you the depencencies you are missing. If the command do not exist, it means you are using an async package manager, so double check the package is beign loaded. These are the most common issues you will find:

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
$HOME/.npm-global/bin:\
$HOME/.yarn/bin:\
$HOME/.config/yarn/global/node_modules/.bin:\
$HOME/.local/share/gem/ruby/3.0.0/bin:\
$HOME/.cargo/env:\
/root/.local/share/gem/ruby/3.0.0/bin:\
/usr/local/bin:\
/usr/share/nvm/init-nvm.sh: \
$PATH"
```
If you prefer using npm over yarn, you can, but double check that you have the user space correctly configured  as in some systems this is not enabled by default ([see here](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)).

If you are on windows, the process is the same. But the place to set PATH may change from one windows version to another.

## 🌟 Support the project
If you want to help me, please star this repository to increase the visibility of the project.

[![Stargazers over time](https://starchart.cc/Zeioth/markmap.nvim.svg)](https://starchart.cc/Zeioth/markmap.nvim)
