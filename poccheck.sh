#!/usr/bin/env bash

SCRIPT_NAME="Level Up Ansible POC Prep Script"
SCRIPT_VERSION="1.2"
SCRIPT_RELEASE_QUARTER="2025 Q3"
echo
echo -e "################################################"
echo -e "# $SCRIPT_NAME $SCRIPT_VERSION $SCRIPT_QUARTER #"
echo -e "# Please run from the same directory where the #"
echo -e "# Red Hat AAP bundle is located.               #"
echo -e "################################################"
echo

read -p "Do you want to continue? [y/N] " answer
case "${answer:0:1}" in
    y|Y )

CONTROLLER_HOSTNAME=$(hostname)
echo -e "CHECK: Hostname: $CONTROLLER_HOSTNAME" 
if [[ $CONTROLLER_HOSTNAME != "localhost" ]]; then
  echo -e "OK: \033[32m✓\033[0m: The hostname is NOT localhost."
else
  echo -e "FLAGGED: \033[31m✗\033[0m: The hostname IS localhost, please change."
fi

CONTROLLER_RHEL_VERSION=$(cat /etc/redhat-release)
echo -e "CHECK: $CONTROLLER_RHEL_VERSION"
if [[ $CONTROLLER_RHEL_VERSION == "Red Hat Enterprise Linux release 9.6 (Plow)" ]]; then
  echo -e "OK: \033[32m✓\033[0m: The version of Red Hat Enterprise Linux is correct."
else
  echo -e "FLAGGED: \033[31m✗\033[0m: The version of Red Hat Enterprise Linux is incorrect."
fi

#!/bin/bash

echo -e "CHECK: RHSM"
if sudo subscription-manager status ; then
    echo -e "OK: \033[32m✓\033[0m: The system is registered to Red Hat Subscription Manager."
else
    echo -e "FLAGGED: \033[31m✗\033[0m: The system is not registered to Red Hat Subscription Manager."
fi


echo -e "CHECK: Ansible URL's" 
urls=("https://galaxy.ansible.com" 
      "https://www.ansible.com" 
      "https://redhat.com"
      "https://catalog.redhat.com"
      "https://quay.io")

for url in "${urls[@]}"; do
  if curl --output /dev/null --silent --head --fail --connect-timeout 5 "$url"; then
    echo -e "OK: \033[32m✓\033[0m: $url is reachable."
  else
    echo -e "FLAGGED: \033[31m✗\033[0m: $url is not reachable."
  fi
done

if mount | grep /tmp | grep -q '/dev/mapper/'; then
  size=$(df -h /tmp | awk 'NR==2{print $4}')
  if [[ $size =~ ^([0-9]+)G$ ]]; then
    if (( ${BASH_REMATCH[1]} >= 10 )); then
      echo -e "OK: \033[32m✓\033[0m: /tmp is mounted as a logical volume and has at least 10GB of space."
    else
      echo -e "FLAGGED: \033[31m✗\033[0m: /tmp is mounted as a logical volume but has less than 10GB of space."
    fi
  else
    echo -e "FLAGGED: \033[31m✗\033[0m: /tmp is mounted as a logical volume but its size is not expressed in GB."
  fi
else
  echo -e "OK: \033[32m✓\033[0m: /tmp is not mounted as a logical volume."
fi


echo -e "CHECK: fstab"
if ! cat /etc/fstab | grep /tmp | grep -q "noexec"; then
  echo -e "OK: \033[32m✓\033[0m: If mounted via /etc/fstab, the /tmp directory is mounted without the noexec option."
else
  echo -e "FLAGGED: \033[31m✗\033[0m: The /tmp directory is mounted via /etc/fstab with the noexec option. Please remove this option."
fi

AAP_SETUP_BUNDLE="ansible-automation-platform-containerized-setup-bundle-2.5-17-x86_64.tar.gz"
echo -e "CHECK: AAP Setup Bundle"
if test -f "$AAP_SETUP_BUNDLE"; then
  echo -e "OK: \033[32m✓\033[0m: The AAP Setup Bundle is found and is the correct version."
else
  echo -e "FLAGGED: \033[31m✗\033[0m: An AAP Setup Bundle was NOT found or is NOT the correct version. Expected: $AAP_SETUP_BUNDLE. Please download via https://access.redhat.com/downloads/"
fi

echo
echo -e "Thank you for running the $SCRIPT_NAME." 
echo -e "Please contact the Level Up team regarding any 'FLAGGED' results."
echo -e "https://levelupla.io/red-hat/"
SCRIPT_HASH=$(sha256sum "$0" | cut -d' ' -f1)
echo "The SHA-256 hash of $0 is: $SCRIPT_HASH"

        ;;
    * )
        echo "Aborting."
        ;;
esac
