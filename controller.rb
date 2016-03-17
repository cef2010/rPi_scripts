# osx lsusb 'ioreg -p IOUSB -l -w 0'
#c = Controller.new(121, 6, 129, 7, 10) #n64
#c = Controller.new(0x2580, 0x0005, 130, 9, 0) #midifighter

#To collect IO data, run
# loop do
#   begin
#     puts c.raw_data.inspect
#   rescue => e
#     # p e
#   end
#   sleep 0.01
# end

require "libusb"

class Controller
  def initialize(idVendor, idProduct, endpoint, dataIn, timeout)
    @idVendor = idVendor
    @idProduct = idProduct
    @endpoint = endpoint
    @dataIn = dataIn
    @timeout = timeout
    @usb_context = LIBUSB::Context.new
    @device = @usb_context.devices(
      idVendor: @idVendor,
      idProduct: @idProduct
    ).first
    reset_device_access
    @handle = @device.open
  end

  def reset_device_access
    h = @device.open
    h.detach_kernel_driver(0) # 0 for most devices, 1 for midifighter
    h.close
  rescue => er
    puts er.message
  end

  def raw_data
    data = @handle.interrupt_transfer(
      endpoint: @endpoint,
      dataIn: @dataIn,
      timeout: @timeout
    )
    data.bytes
  end

  def button
    c = self.raw_data
    case c[6]
    when 1
      return 'l'
    when 2
      return 'r'
    when 4
      return 'a'
    when 16
      return 'b'
    when 8
      return 'z'
    when 32
      return 'start'
    case c[5]
    when 0
      return 'd-u'
    when 2
      return 'd-r'
    when 4
      return 'd-d'
    when 6
      return 'd-l'
  end
end
