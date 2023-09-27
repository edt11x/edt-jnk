import dbus

session_bus = dbus.SessionBus()

service_name = 'org.freedesktop.systemd1'
object_path = '/org/freedesktop/systemd1'

proxy = session_bus.get_object(service_name, object_path)

interface = dbus.Interface(proxy, 'org.freedesktop.DBus.Peer')

machine_id = interface.GetMachineId()
print(f'Current MachineId: {machine_id}')

