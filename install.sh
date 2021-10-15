# Arch Linux post-install script
# 
# MIT License
# 
# Copyright (c) 2021 dutofanim
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

show_error() {
  echo -e $'\033[1;31m'"$*"$'\033[0m' 1>&2
}

show_info() {
  echo -e $'\033[1;32m'"$*"$'\033[0m'
}

show_warning() {
  echo -e $'\033[1;33m'"$*"$'\033[0m'
}

show_question() {
  echo -e $'\033[1;34m'"$*"$'\033[0m'
}

ask_question() {
  read -r -p $'\033[1;34m'"$* "$'\033[0m' var
  echo "${var}"
}

show_success() {
  echo -e $'\033[1;35m'"$*"$'\033[0m'
}

show_header() {
  echo -e $'\033[1;36m'"$*"$'\033[0m'
}

show_listitem() {
  echo -e $'\033[1;37m'"$*"$'\033[0m'
}

function check_user {
  show_header "Checking if user is root"
  if [ ${EUID} -eq 0 ]; then
    show_error "Root user detected. Don't run this script as root. Exiting."
    exit 1
  fi
}

function check_fail {
  local exitstatus=${1:-}
  if [[ ${exitstatus} -gt 0 ]]; then
    show_error "Error code received. Returning to main."
    sleep 3s && main
  fi
}

function check_installed {
  while read -r package; do
    local metacount
    local installcount
    metacount=$(pacman -Ss "${package}" | \
                grep -c "(.*${package}.*)" || true)
    installcount=$(pacman -Qs "${package}" | \
                    grep -c "^local.*(.*${package}.*)$" || true)

    # Check if package is installed.
    if pacman -Qi "${package}" >/dev/null 2>&1; then
      show_listitem "${package} package already installed. Skipping."

    # pacman -Qi won't work with meta packages, so check if all meta package
    # members are installed instead.
    elif [[ (${installcount} -eq ${metacount}) \
            && ! (${installcount} -eq 0) ]]; then
      show_listitem "${package} meta-package already installed. Skipping."

    # Runs if package is not installed or all members of meta-package are not
    # installed.
    else
      show_listitem "Installing ${package}."
      sudo pacman -S --noconfirm "${package}"
    fi
  done < "${1}"
}

function check_aur_installed {
  local pkgbuilddir="${HOME}/.pkgbuild"
  local aurprefix="https://aur.archlinux.org"
  local curdir
  curdir="$(pwd)"

  mkdir -p "${pkgbuilddir}"
  while read -r package; do
    local metacount
    local installcount
    metacount=$(pacman -Ss "${package}" | \
                grep -c "(.*${package}.*)" || true)
    installcount=$(pacman -Qs "${package}" | \
                    grep -c "^local.*(.*${package}.*)$" || true)

    # Check if package is installed.
    if pacman -Qi "${package}" >/dev/null 2>&1; then
      show_listitem "${package} package already installed. Skipping."

    # Runs if package is not installed or all members of meta-package are not
    # installed.
    else
      show_listitem "Installing ${package}."
      if ! [ -d "${pkgbuilddir}/${package}" ]; then
        git clone "${aurprefix}/${package}" "${pkgbuilddir}/${package}"
      else
        git -C "${pkgbuilddir}/${package}" clean -xdf
        git -C "${pkgbuilddir}/${package}" reset --hard
        git -C "${pkgbuilddir}/${package}" pull origin master
      fi
      cd "${pkgbuilddir}/${package}" || exit
      makepkg --noconfirm -si
      git clean -xdf
    fi
  done < "${1}"
  cd "${curdir}" || exit
}

function install_apps {
  if [ $gdeVar = true ] 
    then
      show_header "Installing Gnome applications."
      check_installed "${gdeApps}"
      check_fail
      show_success "Gnome applications successfully installed."
  elif [ $kdeVar = true ] 
    then
      show_header "Installing KDE applications."
      check_installed "${kdeApps}"
      check_fail
      show_success "KDE applications successfully installed."
  fi
}

function install_aur {
  show_header "Installing AUR applications."
  if [ $gdeVar = true ] 
    then
      check_aur_installed "${aurGDE}"
      check_fail
      show_success "AUR applications successfully installed."
  elif [ $kdeVar = true ] 
    then
      check_aur_installed "${aurKDE}"
      check_fail
      show_success "AUR applications successfully installed."
  fi
}

function packages {
  show_question "Applications: what do you want to install?\n"
  show_info "Main App\t\t (Hit ENTER to see options again.)\n"

  local options=(
    "Gnome and AUR"
    "KDE and AUR"
    "Back"
    )
  select option in "${options[@]}"; do
    case $option in
      "Back")
        break
        ;;
      "Gnome and AUR")
        gdeVar=true
        install_apps
        install_aur
        show_info "Main App\t\t (Hit ENTER to see options again.)\n"
        ;;
      "KDE and AUR")
        kdeVar=true
        install_apps
        install_aur
        show_info "Main App\t\t (Hit ENTER to see options again.)\n"
        ;;
      *)
        show_warning "Invalid option."
        ;;
    esac
  done
}

# Variables definition
currentDir="$(pwd)"
kdeApps="$currentDir/packages/appsKDE.list"
gdeApps="$currentDir/packages/appsGDE.list"
aurGDE="$currentDir/packages/aurGDE.list"
aurKDE="$currentDir/packages/aurKDE.list"
gdeVar=false
kdeVar=false

echo
show_header "Adding necessary keys"
echo
show_header "Add key 8BF0C93D03E44352"
gpg --recv-keys 8BF0C93D03E44352
show_header "Key successfully added."
echo
show_header "Add key E7677380F54FD8A9"
gpg --recv-keys E7677380F54FD8A9
show_header "Key successfully added."
echo
echo
show_header "Automated Package Installation - API"
echo

# Functions calls
check_user
packages