echo 8 > /proc/sys/kernel/printk
echo "file drivers/net/mdio/*" +p > /proc/dynamic_debug/control
echo "file drivers/net/phy/*"  +p > /proc/dynamic_debug/control
echo "file drivers/phy/*"      +p > /proc/dynamic_debug/control
