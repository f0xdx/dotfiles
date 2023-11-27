version = '0.21.2'

-- enable plugins
local home = os.getenv("HOME")
package.path = home
.. "/.config/xplr/plugins/?/init.lua;"
.. home
.. "/.config/xplr/plugins/?.lua;"
.. package.path

-- plugins setup
require"icons".setup()
