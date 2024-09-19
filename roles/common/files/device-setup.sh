#!/bin/bash

# Check running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# check if overlay is enabled

get_overlay_now() {
  grep -q "overlayroot=tmpfs" /proc/cmdline
  echo $?
}

#overlay check, tell use to use raspi-config to disable
overlay_status=$(get_overlay_now)
if [[ overlay_status -eq 0 ]]; then     # when overlay is enabled
    if whiptail --title "OVERLAY" --yesno "Read only file system overlay is enable\n\nNO CHANGES CAN BE MADE WHILE ENABLED\n\nTo disable 'Filesystem Overlay' please use raspi-config tool\n\nDo you want to do that now?" 0 0; then
      echo "entering raspi-config"
      raspi-config
    else
      echo "No do not go to overlay settings"
      echo "EXIT"
      exit
    fi
fi




# Resolution list
# example resolution
# res_1=("Width" "Height" "cmdline_framerate" "gstreamer_framerate_fraction")

res_1=("720" "576" "50" "50/1")
res_2=("720" "576" "60" "60/1")
res_3=("1280" "720" "30" "30/1")
res_4=("1280" "720" "50" "50/1")
res_5=("1280" "720" "60" "60/1")
res_6=("1920" "1080" "30" "30/1")
res_7=("1920" "1080" "50" "50/1")
res_8=("1920" "1080" "60" "60/1")



##### Main Menu

advancedMenu() {
    ADVSEL=$(whiptail --title "Device Setup" --menu "Choose an option" 0 0 0 \
        "1" "Set HDMI Resolution" \
        "2" "Configure NTP Server address" \
        "3" "Enable Overlay Readonly File System" --cancel-button Finish --ok-button Select 3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_finish
    else
        case $ADVSEL in
        1)
            set_resolution
            advancedMenu
            ;;
        2)
            set_ntp
            advancedMenu
            ;;
        3)
            enable_overlay
            advancedMenu
            ;;
        esac
    fi
}



do_finish() {
    if whiptail --title "REBOOT" --yesno "Reboot is required for changes to take effect\n\n   Do you want to reboot now or later?" 0 0 --yes-button NOW --no-button LATER --defaultno; then
        echo "Rebooting"
        reboot
    fi
}







set_resolution() {
    CHOICE=$(whiptail --title "HDMI Output Resolution" --menu "Make your choice" 16 100 10 \
    "1" "${res_1[0]}x${res_1[1]}@${res_1[2]}p" \
    "2" "${res_2[0]}x${res_2[1]}@${res_2[2]}p" \
    "3" "${res_3[0]}x${res_3[1]}@${res_3[2]}p" \
    "4" "${res_4[0]}x${res_4[1]}@${res_4[2]}p" \
    "5" "${res_5[0]}x${res_5[1]}@${res_5[2]}p" \
    "6" "${res_6[0]}x${res_6[1]}@${res_6[2]}p" \
    "7" "${res_7[0]}x${res_7[1]}@${res_7[2]}p" \
    "8" "${res_8[0]}x${res_8[1]}@${res_8[2]}p" --cancel-button Finish --ok-button Select 3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        return
    else
        case $CHOICE in
            1)
                res_name=("${res_1[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            2)
                res_name=("${res_2[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            3)
                res_name=("${res_3[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            4)
                res_name=("${res_4[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            5)
                res_name=("${res_5[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            6)
                res_name=("${res_6[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            7)
                res_name=("${res_7[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            8)
                res_name=("${res_8[@]}")
                gstreamer_width=${res_name[0]}
                gstreamer_height=${res_name[1]}
                gstreamer_fraction=${res_name[3]}
                cmdline_res="HDMI-A-1:${res_name[0]}x${res_name[1]}@${res_name[2]}p"
                echo $cmdline_res
                ;;
            *) echo "invalid input"
        esac

        #edit cmdline to change hdmi output
        sed -i "s%\(video=\)[^[:space:]]\+%\1$cmdline_res%g" /boot/firmware/cmdline.txt

        #edit gstreamer output to match hdmi output
        sed -i "s%\(width=\)[^[,]\+%\1$gstreamer_width%g" /opt/osu/gstreamer.sh
        sed -i "s%\(height=\)[^[,]\+%\1$gstreamer_height%g" /opt/osu/gstreamer.sh
        sed -i "s%\(framerate=\)[^[:space:]]\+%\1$gstreamer_fraction%g" /opt/osu/gstreamer.sh
    fi
}






set_ntp() {
    CURRENT_NTP=$(grep -m 1 "NTP=" /etc/systemd/timesyncd.conf)     # get current NTP server details
    CURRENT_NTP=$(echo "${CURRENT_NTP##*=}")                        # cut address form varibleget address only
    NTP_ADDRESS=$(whiptail --inputbox "Enter NTP server Address\n\n Current server = $CURRENT_NTP" 0 0 "$CURRENT_NTP" 3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        return
    else
        echo $NTP_ADDRESS
        sed -i "1,/.*NTP/s/.*NTP.*/NTP=$NTP_ADDRESS/" /etc/systemd/timesyncd.conf
        systemctl restart systemd-timesyncd.service
        timedatectl set-ntp true
    fi
}





enable_overlay() {
    if whiptail --title "OVERLAY" --yesno "Files System Overlay protects SD cards from corruption\n\nOverlay should be enabled for production units\n\nWould you like to enable it now via the raspi-config tool?" 0 0; then
        echo "entering raspi-config"
        raspi-config
    else
        echo "No do not configure overlay"
    fi
}


# Run Menu
advancedMenu