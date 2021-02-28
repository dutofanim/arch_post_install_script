echo
echo "Enabling bluetooth daemon and setting it to auto-start"
echo 
sudo sed -i 's|#AutoEnable=false|AutoEnable=true|g' /etc/bluetooth/main.conf
sudo systemctl enable --now bluetooth.service

# ------------------------------------------------------------------------

echo
echo "Enabling the cups service daemon so we can print"
echo
systemctl enable --now cups.service

# ------------------------------------------------------------------------

echo
echo "Enabling SDDM"
echo
sudo systemctl enable --now sddm.service

# ------------------------------------------------------------------------

echo
echo "NETWORK SETUP"
echo
sudo systemctl enable --now NetworkManager.service
