#!/bin/bash

echo "This script uninstalls CyberArms from the system."

# Remove binaries and dir
rm .

# Remove from path
rm .bashrc

# Finished message
echo "CyberArms has been uninstalled from your system!"
echo "To remove the files, run clean.sh"
echo "Thanks!"

