# Raspberry Pi HDMI Pattern Generator

|  Version    | Release Date  | Notes
|-------------|--------------|-----------------------------
| V1.0.0      |  14/09/2024  | Outputs test card with clock, device-setup.sh allows for resolution change and setting \
|             |              | Can set NTP server address 
|             |              |
Built using Ansible


# Parts List
1 x Raspberry Pi 5 4GB \
1 x sandisk u2 64gb  SD card \
1 x Official Raspberry Pi 5 case \
1 x Power Over Ethernet HAT (G) For Raspberry Pi 5 802.3af/at \
1 x HDMI to Micro HDMI cable

## Prerequisites
OS: Raspberry pi os lite 64bit bookworm \
Hardware: Raspberry pi 5 \

## Getting Started
This script turns a raspberry pi into a video pattern generator, It allows you to change output resolutions and change the pattern using gstreamer pipelines \
The device could be used to play video as well if the pipeline is changed

* Time is set to UTC
* Default resolution is 1920x1080p60
* NTP needs to be set



## Production
### overlay file system
Overlay should be enabled when using in production environments to prolong the life of the SD card. Logs are not stored in this state so disable when debugging issues.

```
raspi-config
# menu - Performance option/Overlay
```
or use the device-setup.sh script 




### Resolutions
#### changing HDMI resolution
use the device-setup.sh script, Reboot is required for change to take effect.
```bash
./device-setup.sh
```

##### Checking set HDMI resolution setting manually
```bash
cat /boot/firmware/cmdline.txt
# look at video= output at end of the line
```
##### Checking current HDMI resolution
kmsprint has option to display support resolutions and current resolution.

```bash
kmsprint

# Example output
# Connector 0 (32) HDMI-A-1 (connected)
#   Encoder 0 (31) TMDS
#     Crtc 2 (88) 1280x720@60.00 74.250 1280/110/40/220/+ 720/5/5/20/+ 60 (60.00) U|D 
#       Plane 2 (78) fb-id: 301 (crtcs: 2) 0,0 1280x720 -> 0,0 1280x720 (XR24 AR24 AB24 XB24 RG16 BG16 AR15 XR15 RG24 BG24 YU16 YV16 YU24 YV24 YU12 YV12 NV12 NV21 NV16 NV61 P030 XR30 AR30 AB30 XB30 RGB8 BGR8 XR12 AR12 XB12 AB12 BX12 BA12 RX12 RA12)
#         FB 301 1280x720 RG16
# Connector 1 (42) HDMI-A-2 (disconnected)
#   Encoder 1 (41) TMDS
```

##### Testing a vidoe resolution output
kms can be used to check if a resolution works, The device should change to the selected resolution
```bash
kmstest -c HDMI-A-1 -r 720x576@50
```


##### Checking gstreamer output resolution setting manually
```bash
cat /opt/osu/gstreamer.sh
#check the height= width= and framerate=
```



### NTP
Set the NTP server using the device-setup.sh script
```bash
./device-setup.sh
```
##### Settings time zone
```
# List time zones
timedatectl list-timezones

#UTC/GMT Example
sudo timedatectl set-timezone UTC

#Europe/London Example
sudo timedatectl set-timezone Europe/London

```

##### Check NTP sync status
```bash
timedatectl show-timesync --all
```

##### checking config file manually
```bash
nano /etc/systemd/timesyncd.conf
```

##### Checking NTP server is contactable
```bash
ntpdate -q <server address>
```



## Editing the Pattern
Edit the streamer pipeline, using default pattern build in to gstreamer. \
the pipe line can be found at /opt/osu/gstreamer.sh.



## Security
Fail2ban - Installed to block ssh brute force \
UFW - Only ssh allowed in


## Trouble shootings
**No video pattern** - Check gstreamer.service is enabled and running \
**Clock is wrong** - Check systemd-timesyncd.service is enabled and running, Check NTP address is correct in config file \
**Disk is read only** - Overlay is enabled, use the device-setup script or raspi-config to disable overlay