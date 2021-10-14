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

echo
echo "Automated Package Installation - API"
echo

currentDir="$(pwd)"

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

kdeApps="$currentDir/packages/appsKDE.list"
function install_kdeApps {
  show_header "Installing applications."
  check_installed "${kdeApps}"
  check_fail
  show_success "Done!"
}

gdeApps="$currentDir/packages/appsGDE.list"
function install_gdeApps {
  show_header "Installing applications."
  check_installed "${gdeApps}"
  check_fail
  show_success "Done!"
}

aur="$currentDir/packages/aur.list"
function install_aur {
  show_header "Installing AUR applications."
  check_aur_installed "${aur}"
  check_fail
  show_success "Done!"
}

function packages {
  show_question "Applications: what do you want to install?"
  show_info "Main\n ${endbranch}      (Hit ENTER to see options again.)\n"

  local options=(
    "All" 
    "Gnome Applications"
    "KDE Applications"
    "AUR applications"
    "Back"
    )
  select option in "${options[@]}"; do
    case $option in
      "Back")
        break
        ;;
      "All")
        install_kdeApps
        install_gdeApps
        install_aur
        show_info "Main\n ${endbranch} Apps (Hit ENTER to see options again.)"
        ;;
      "AUR applications")
        install_aur
        show_info "Main\n ${endbranch} Apps (Hit ENTER to see options again.)"
        ;;
      "Gnome Applications")
        install_gdeApps
        show_info "Main\n ${endbranch} Apps (Hit ENTER to see options again.)"
        ;;
      "KDE Applications")
        install_kdeApps
        show_info "Main\n ${endbranch} Apps (Hit ENTER to see options again.)"
        ;;
      *)
        show_warning "Invalid option."
        ;;
    esac
  done
}

packages