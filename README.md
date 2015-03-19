# RTcpIp

A convenience library for using FFI::Pcap and FFI::Packets

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'r_tcp_ip'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install r_tcp_ip

## Usage

```ruby
require 'r_tcp_ip'
require 'ffi/pcap'
cap = FFI::Pcap::Offline.new("dump.pcap")
cap.loop do |this,pkt|
  packet = RTcpIp::Packet.new(pkt.body_ptr)
  puts "source_ip=#{packet.src} dest_ip=#{packet.dst} source_port=#{packet.sport} dest_port=#{packet.dport}"
end
```


## Contributing

1. Fork it ( https://github.com/nemski/r_tcp_ip/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
