# config.nu
#
# Installed by:
# version = "0.112.2"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.show_banner = false
$env.config.ls.use_ls_colors = false
$env.EDITOR = 'hx'


def helix-config-dir [] {
    '{{lookup dotter.files "helix/config.toml"}}' | path dirname
}


def "dev install helix" [] {
    let repo = (
        $nu.cache-dir
        | path join "sources" "helix-steel"
    )

    let parent = ($repo | path dirname)

    if not ($parent | path exists) {
        mkdir $parent
    }

    if not ($repo | path exists) {
        print "Cloning Helix Steel..."
        ^git clone --filter=blob:none --single-branch  --branch steel-event-system  https://github.com/mattwparas/helix.git  $repo
    } else {
        print "Updating Helix Steel..."

        ^git -C $repo fetch origin steel-event-system
        ^git -C $repo checkout steel-event-system
        ^git -C $repo reset --hard origin/steel-event-system
    }

    cd $repo

    print "Building and installing Helix Steel..."
    ^cargo xtask steel

    let runtime_src = ($repo | path join "runtime")
    let runtime_dst = (helix-config-dir | path join "runtime")

    print $"Copying Helix runtime to ($runtime_dst)..."
    mkdir ($runtime_dst | path dirname)
    rm -rf $runtime_dst
    cp -r $runtime_src $runtime_dst

    print "Installing extensions"
    forge pkg install --git https://github.com/njust/streal.hx.git
    forge pkg install --git https://github.com/thomasschafer/scooter.hx.git
}
