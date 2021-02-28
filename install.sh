echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

	# NETWORK ------------------------------------------------------------------
	'wpa_supplicant'            # Key negotiation for WPA wireless networks
	'dialog'                    # Enables shell scripts to trigger dialog boxex
	'networkmanager'            # Network connection manager
	'network-manager-applet'    # System tray icon/utility for network connectivity
	'libsecret'                 # Library for storing passwords

	# BLUETOOTH ---------------------------------------------------------

	'bluez'                 # Daemons for the bluetooth protocol stack
	'bluez-utils'           # Bluetooth development and debugging utilities
	'bluez-firmware'        # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
	'blueberry'             # Bluetooth configuration tool
	'pulseaudio-bluetooth'  # Bluetooth support for PulseAudio

	# Deprecated ibraries for the bluetooth protocol stack.
	# I believe the blues package above is all that is necessary now,
	# but I havn't tested this out, so for now I install this too.
	'bluez-libs' 

	# AUDIO --------------------------------------------------------------------
	'alsa-utils'        # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
	'alsa-plugins'      # ALSA plugins
	'pulseaudio'        # Pulse Audio sound components
	'pulseaudio-alsa'   # ALSA configuration for pulse audio
	'pavucontrol'       # Pulse Audio volume control

	# Printers ----------------------------------------------------------------
	'cups'                  # Open source printer drivers
	'cups-pdf'              # PDF support for cups
	'ghostscript'           # PostScript interpreter
	'gsfonts'               # Adobe Postscript replacement fonts
	'hplip'                 # HP Drivers
	'system-config-printer' # Printer setup  utility


	# TERMINAL UTILITIES --------------------------------------------------

	'bash-completion'       # Tab completion for Bash
	'bleachbit'             # File deletion utility
	'cronie'                # cron jobs
	'curl'                  # Remote content retrieval
	'file-roller'           # Archive utility
	'gtop'                  # System monitoring via terminal
	'gufw'                  # Firewall manager
	'hardinfo'              # Hardware info app
	'htop'                  # Process viewer
	'neofetch'              # Shows system info when you launch terminal
	'ntp'                   # Network Time Protocol to set time via network.
	'numlockx'              # Turns on numlock in X11
	'openssh'               # SSH connectivity tools
	'rsync'                 # Remote file sync utility
	'speedtest-cli'         # Internet speed via terminal
	'terminus-font'         # Font package with some bigger fonts for login terminal
	'tlp'                   # Advanced laptop power management
	'unrar'                 # RAR compression program
	'unzip'                 # Zip compression program
	'wget'                  # Remote content retrieval
	'zenity'                # Display graphical dialog boxes via shell scripts
	'zip'                   # Zip compression program
	'zsh'                   # ZSH shell
	'zsh-completions'       # Tab completion for ZSH

	# DISK UTILITIES ------------------------------------------------------

	'autofs'                # Auto-mounter
	'exfat-utils'           # Mount exFat drives
	'ntfs-3g'               # Open source implementation of NTFS file system
	'parted'                # Disk utility

	# GENERAL UTILITIES ---------------------------------------------------

	'catfish'               # Filesystem search
	'conky'                 # System information viewer
	'nitrogen'               # Wallpaper changer
	'xfburn'                # CD burning application

	# DEVELOPMENT ---------------------------------------------------------

	'clang'                 # C Lang compiler
	'cmake'                 # Cross-platform open-source make system
	'electron'              # Cross-platform development using Javascript
	'git'                   # Version control system
	'gcc'                   # C/C++ compiler
	'glibc'                 # C libraries
	'meld'                  # File/directory comparison
	'nodejs'                # Javascript runtime environment
	'npm'                   # Node package manager
	'python'                # Scripting language
	'qtcreator'             # C++ cross platform IDE
	'qt5-examples'          # Project demos for Qt
	'yarn'                  # Dependency management (Hyper needs this)

	# WEB TOOLS -----------------------------------------------------------

	'filezilla'             # FTP Client

	# COMMUNICATIONS ------------------------------------------------------

	'hexchat'               # Multi format chat

	# MEDIA ---------------------------------------------------------------

	#'kdenlive'              # Movie Render
	'obs-studio'            # Record your screen
	'vlc'                   # Video player

	# GRAPHICS AND DESIGN -------------------------------------------------

	#'gcolor2'               # Colorpicker
	#'gimp'                  # GNU Image Manipulation Program
	#'ristretto'             # Multi image viewer

	# PRODUCTIVITY --------------------------------------------------------

	'hunspell'              # Spellcheck libraries
	'hunspell-en'           # English spellcheck library
	'libreoffice-fresh'     # Libre office with extra features
	'xpdf'                  # PDF viewer

)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo
