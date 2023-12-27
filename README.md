# screen_saviour.nvim

Screen saver based on data from current buffer.

## Wip (TODO)
- [ ] configuration
- [ ] cleanups
- [ ] readme.md
- [X] include virtual text
- [ ] include virtual lines
- [ ] include line nums
- [ ] more animations!


## Examples

<details>
    <summary>
        scramble
    </summary>
    <a href="https://asciinema.org/a/628917" target="_blank">
        <img src="https://asciinema.org/a/628917.svg" />
    </a>
</details>

<details>
    <summary>
        matrix
    </summary>
    <a href="https://asciinema.org/a/628916" target="_blank">
        <img src="https://asciinema.org/a/628916.svg" />
    </a>
</details>

<details>
    <summary>
        random_case
    </summary>
    <a href="https://asciinema.org/a/628918" target="_blank">
        <img src="https://asciinema.org/a/628918.svg" />
    </a>
</details>

<details>
    <summary>
        game_of_live
    </summary>
    <a href="https://asciinema.org/a/628983" target="_blank">
        <img src="https://asciinema.org/a/628983.svg" />
    </a>
</details>

<details>
    <summary>
        make it rain
    </summary>
    <a href="https://asciinema.org/a/628984" target="_blank">
        <img src="https://asciinema.org/a/628984.svg" />
    </a>
</details>

## Requirements
- neovim >= 0.8
- nvim-treesitter plugin

## Installation
```
use 'fazibear/screen_saviour.nvim' 
```

## Usage
You can start screen saver with simple command:
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

require("screen_saviour.animation").register(config)
```

## Inspiration and references
- Basen on https://github.com/Eandrju/cellular-automaton.nvim



