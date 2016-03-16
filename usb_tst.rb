# osx lsusb 'ioreg -p IOUSB -l -w 0'
require "libusb"


class Controller
  def initialize
    @usb_context = LIBUSB::Context.new
    @device = @usb_context.devices(
      idVendor: 121,
      idProduct: 6
    ).first
    reset_device_access
    @handle = @device.open
  end

  def reset_device_access
    h = @device.open
    h.detach_kernel_driver(0)
    h.close
  rescue => er
    puts er.message
  end

  def raw_data
    data = @handle.interrupt_transfer(
      endpoint: 129,
      dataIn: 7,
      timeout: 10
    )
    data.bytes
  end
end

# For this we need the endpoint data from back in our lsusb data, specifically the attributes named bEndpointAddress, bLength and bInterval.
# out => address: 1, interval: 10, length: 7
# in => address: 129, interval: 10, length: 7

c = Controller.new

loop do
  begin
    puts c.raw_data.inspect
  rescue => e
    # p e
  end
  sleep 0.01
end
