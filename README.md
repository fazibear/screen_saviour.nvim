# screen_saviour.nvim

Screen saver based on cellular automata

## Wip (TODO)
- [ ] configuration
- [ ] cleanups
- [ ] readme.md
- [ ] more animations!

## Examples

<details>
<summary>scramble</summary>
<script async id="asciicast-628917" src="https://asciinema.org/a/628917.js"></script>
</details>

<details>
<summary>matrix</summary>
<script async id="asciicast-628916" src="https://asciinema.org/a/628916.js"></script>
</details>

<details>
<summary>random_case</summary>
<a href="https://asciinema.org/a/628918" target="_blank"><img src="https://asciinema.org/a/628918.svg" /></a>
</details>

## What is cellular automata
From the [Wiki](https://en.wikipedia.org/wiki/Cellular_automaton):

> A cellular automaton is a model used in computer science and mathematics. The idea is to model a dynamic system by using a number of cells. 
> Each cell has one of several possible states. With each "turn" or iteration the state of the current cell is determined by two things: 
> its current state, and the states of the neighbouring cells.

## Requirements
- neovim >= 0.8
- nvim-treesitter plugin

## Installation
```
use 'fazibear/screen_saviour.nvim' 
```

## Usage
You can trigger it using simple command to run a random registered animation:
``` 
:ScreenSaviour
```
or specifying the animation name like:
```
:ScreenSaviour make_it_rain
```
or
```
:ScreenSaviour game_of_life
```

## Known issues
- folding and wrapping is not supported ATM

## Implementing your own cellular automaton logic
Using a simple interface you can implement your own cellular automaton animation. You need to provide a configuration table with an `update` function, which takes a 2D grid of cells and modifies it in place. Each cell by default consist of two fields: 
- `char` - single string character
- `hl_group` - treesitter's highlight group

Example sliding animation:
```lua
local config = {
    fps = 50,
    name = 'slide',
}

-- init function is invoked only once at the start
-- config.init = function (grid)
--
-- end

-- update function
config.update = function (grid)
    for i = 1, #grid do
        local prev = grid[i][#(grid[i])]
        for j = 1, #(grid[i]) do
            grid[i][j], prev = prev, grid[i][j]
        end
    end
    return true
end

require("screen_saviour").register_animation(config)
```

## Inspiration and references
- Basen on https://github.com/Eandrju/cellular-automaton.nvim



