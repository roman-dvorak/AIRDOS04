## airdoscontrol - AIRDOS04 command line utility

A utility designed to control the AIRDOS04 dosimeter from the [Unix command line](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview). The  generic usage is the following

    ./airdoscontrol [command] [options]

The airdos control is tested on the Ubuntu Linux distribution. However, it should work on any Unix-like OS like MacOS for example, although the installation procedure may differ in details. 

### Installation and prerequisites 

Download and save the [airdoscontrol](https://raw.githubusercontent.com/UniversalScientificTechnologies/AIRDOS04/AIRDOS04A/sw/airdoscontrol) somewhere in your Linux computer. Then make it executable by setting the executable flag on the downloaded file.   

    chmod u+x airdoscontrol

The airdos control uses [hidapi library](https://pypi.org/project/hidapi/) to communicate with AIRDOS, therefore please check that hidapi is installed or install it by 

    sudo python3 -m pip install hidapi 

The utility needs correct [system access rights](https://linuxconfig.org/tutorial-on-how-to-write-basic-udev-rules-in-linux) to the hid device. Create the file  `/etc/udev/rules.d/99-batdatunit.rules` in your Linux system with the following content:

```
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6030", OPTIONS+="ignore_device"
KERNEL=="hidraw*", ATTRS{idVendor}=="0403", MODE="6030", GROUP="plugdev"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="7aa0", GROUP="plugdev", MODE="0660"
```
Then use `sudo udevadm control --reload-rules && sudo udevadm trigger` command to update udev access rights. 

The user also needs to be a `plugdev` system group member. e.g. `sudo usermod -a -G plugdev $USER`

### Usage

Connect the AIRDOS04 to the computer using the USB-C to USB-A cable. NOTE: The BATDATUNIT01 should be inserted in AIRDOS04 for USB communication. 

#### Shutdown the AIRDOS Device

    airdoscontrol shutdown

This command would be straightforward with no additional options required. The AIRDOS is then powered off immediately after disconnection of the USB cable. It could be powered on only by a button or plugging the USB-C cable back. Please look in the [AIRDOS manual](https://docs.dos.ust.cz/airdos/AIRDOS04) for details.

#### Set internal RTC (Real-Time Clock)

    airdoscontrol set-rtc --time "YYYY-MM-DD HH:MM:SS"

Options could include specifying the time directly.


#### Set Pressure Thresholds

    airdoscontrol set-thresholds --min-pressure [value] --max-pressure [value]

Allows users to define minimum and maximum pressure values in hPa for flight detection.
