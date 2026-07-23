@echo off
setlocal

if not exist ".dotter\local.toml" (
  if not exist ".dotter" mkdir ".dotter"
  > ".dotter\local.toml" echo includes = [".dotter/windows.toml"]
  >> ".dotter\local.toml" echo packages = ["default"]
  >> ".dotter\local.toml" echo.
  >> ".dotter\local.toml" echo [files]
  >> ".dotter\local.toml" echo.
  >> ".dotter\local.toml" echo [variables]
)

mise exec -- dotter deploy
