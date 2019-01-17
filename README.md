# Long live battery
Laptop's long battery life is a nice thing to have. So it is wise to save your laptop's battery while using it. The most common causes of battery drain are that discharing it completely or keeping plugged in when it is fully charged. While we are working on our laptop, we often forget to notice whether it is fully charged or discharged. I wrote and use this script on fedora to check my laptop's battery level and it notifies me at given threshold values so that I can take actions accordingly.

# Installation
ACPI (Advanced Configuration and Power Interface) module is required to get battery information and `ruby-notify` package is used to send notification to desktop. To install them on fedora/centos/rhel
```shell
sudo dnf -y install acpi.x86_64 ruby-notify
```
To install them on deb/ubuntu
```shell
sudo apt -y install acpi ruby-notify
```
Once the packages are installed, add the script in cron job list. Below is an example. It is to run every minute with lower threshold 22% and higher threshold 95% and write its log to `output.log` file.
```shell
crontab -l | { cat; echo "* * * * * check_battery_level.sh 25 95 output.log"; } | crontab -
```
