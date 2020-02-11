Write-Output "preparing environment"


# setup alacritty
Write-Output ".. configuring alacritty"

$alacritty_config = "$home\AppData\Roaming\alacritty"

if (!(Test-Path -Path $nvim_config -PathType Container)) {
    New-Item -Path $alacritty_config -ItemType Directory -Force *> $null
}
if (Test-Path -Path "$alacritty_config\alacritty.yml" -PathType Leaf) {
    Rename-Item -Path "$alacritty_config\alacritty.yml" -NewName "alacritty.yml.bak" *> $null
} 
New-Item -ItemType SymbolicLink -Path "$alacritty_config\alacritty.yml" -Target "$(Get-Location)\alacritty\alacritty.yml" *> $null


# setup neovim
Write-Output ".. configuring neovim"

$nvim_config = "$home\AppData\Local\nvim"
$nvim_autoload = "$nvim_config\autoload"

# install init.vim (from dotfiles directory)

if (!(Test-Path -Path $nvim_config -PathType Container)) {
    New-Item -Path $nvim_config -ItemType Directory -Force *> $null
}
if (Test-Path -Path "$nvim_config\init.vim" -PathType Leaf) {
    Rename-Item -Path "$nvim_config\init.vim" -NewName "init.vim.bak" *> $null
} 
New-Item -ItemType SymbolicLink -Path "$nvim_config\init.vim" -Target "$(Get-Location)\nvim\init.vim" *> $null

# install/update vim-plug
if (!(Test-Path -Path $nvim_autoload -PathType Container)) {
    New-Item -Path $nvim_autoload -ItemType Directory -Force *> $null
}

if (!(Test-Path -Path "$nvim_autoload\plug.vim" -PathType Leaf)) {
    (New-Object Net.WebClient).DownloadFile(
      "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
      $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        "$nvim_autoload\plug.vim"
      )
    )
}

# execute installation in nvim
Write-Output ".. installing neovim plugins"
nvim --headless +PlugInstall +qa *> $null