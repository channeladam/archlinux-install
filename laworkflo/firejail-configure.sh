#!/bin/sh

echo "*********************************************************************************"
echo "NOTE: as per firejail requirements, you need to run this script after installing applications."
echo "*********************************************************************************"

#
# Configure firejail on everything
#
echo "Configuring firejail"
sudo firecfg

#
# Disable firejail for certain programs
#
echo
echo "*********************************"

# There is currently no configuration for barrier OOTB - but it has been merged into their github
echo "Disabling filejail for barrier"
sudo unlink /usr/local/bin/barrier
