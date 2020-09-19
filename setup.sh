
# Update all submodules
git submodule update --init --recursive

# build the ubuntu vm
( cd packer-templates && ./build.sh -f -a )

# build the windows vm
( cd packer-templates && ./build-windows.sh -f -a )