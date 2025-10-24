# a few alias for common actions

# build both sides of firmware
alias bld='./scripts/build.sh'

# clean the build directories
clean() {
    rm -rf build_left build_right
    echo "Build directories cleaned."
}
