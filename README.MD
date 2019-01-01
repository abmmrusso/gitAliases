# gitAliases
Collection of simple git aliases/functions that I found useful to have on bash profile to quickly do some operations I found myself repeating over and over.

They are based on the assumption that all git projects are kept under a single folder whose absolute path is stored in the environment variable `GIT_PROJECT_FOLDER`.

## The Aliases

### gitGoTo
Navigate to the folder defined under `GIT_PROJECT_FOLDER`. It will perform some simple validation when used such as making sure `GIT_PROJECT_FOLDER` is defined and is pointing to an existing and accessible folder.

### gitUpdateAll
Runs `git pull` for all git repos that exist under the folder defined by `GIT_PROJECT_FOLDER`. It will perform the same validation as described for [gitGoTo](#gitGoTo) as it makes active use of said alias.

## Running tests for aliases
Where possible, the aliases are unit tested using `shunit2` as provided by `$(which shunit2)`.
To run them, you will need to install/set it up.
Most of the package managers allow for `shunit2` installation:
* [apt-get](https://wiki.debian.org/Apt)
```bash
sudo apt-get install shunit2
```
* [pacman](https://wiki.archlinux.org/index.php/pacman)
```bash
sudo pacman -S shunit2
```
* [yum](http://yum.baseurl.org/)
```bash
sudo yum install shunit2
```
* [dnf](https://github.com/rpm-software-management/dnf)
```bash
sudo dnf install shunit2
```
* [ZYpp](https://en.opensuse.org/Portal:Libzypp)
```bash
sudo zypper in patch shunit2
```
* [portage](https://wiki.gentoo.org/wiki/Project:Portage)
```bash
sudo emerge -pv shunit2
```
* [Homebrew](https://brew.sh/)
```bash
brew install shunit2
```

Once you have that setup, you can run all the tests for the aliases by running [tests/git_aliases_test.sh](tests/git_aliases_test.sh).
