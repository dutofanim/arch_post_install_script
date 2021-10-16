# Script for install programs after Arch linux installation

This script aims to install the packages I use in my installation in an automated way.
To use it you must clone this repository using the following command:

```bash
git clone https://github.com/dutofanim/arch_post_install_script.git
```

 Go to the new directory where the script is located using the command:

```bash
cd arch_post_install_script
```

 Give the execution permission to the `install.sh` file using the command:

```bash
chmod +x install.sh
```

With the execute permission, run the script with:

```bash
./install.sh
```

You will see the following menu:

```text
Applications: what do you want to install?

Main App         (Hit ENTER to see options again.)

1) "Gnome and AUR"
2) "KDE and AUR"
3) "Back"
```

Choose your favorite **Desktop environment** and all the applications will be installed. ***You can modify the applications list to include or exclude any package*** in the correspondent file. This script needs to be run with normal user privileges. You will be warmed if try to run this script with root privileges and the script will be interrupted.

## Based on [Sudorook script](https://github.com/sudorook/archlinux)