# screen_saviour.nvim

Screen saver based on cellular automata

WIP!

https://user-images.githubusercontent.com/37074839/204104990-6ebd7767-92e9-43b9-878a-3493a08a3308.mov

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
Result:

https://user-images.githubusercontent.com/37074839/204161376-3b10aadd-90e1-4059-b701-ce318085622c.mov

## Inspiration and references
- Basen on https://github.com/Eandrju/cellular-automaton.nvim



