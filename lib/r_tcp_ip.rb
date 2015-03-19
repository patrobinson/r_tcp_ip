require "r_tcp_ip/version"
require "r_tcp_ip/constants"
require "ffi/packets"

module RTcpIp
  class Packet
    include FFI::Packets::Constants

    attr_reader :src_mac, :dst_mac, :ip_hdr

    # Expects a FFI::MemoryPointer to a packet
    def initialize(packet)
      # Get first byte of IP header
      ip_hdr_start = packet.get_uchar(ETH_HDR_LEN).to_s(16)
      # First nibble is IP header version
      if ip_hdr_start[0].hex == 4
        # Second nibble is IP header length in words (4 bytes)
        @ip_hdr_len = ip_hdr_start[1].hex * 4
      else
        raise "IPv6 not supported"
      end

      ip_hdr_ptr = FFI::MemoryPointer.from_string(packet.get_array_of_uchar(ETH_HDR_LEN,(@ip_hdr_len)).pack('C*'))

      @ip_hdr = FFI::Packets::Ip::Hdr.new(ip_hdr_ptr)

      @tcp = @udp = false
      case @ip_hdr.proto
        when IP_PROTO_TCP
          @tcp = true
          tcp_hdr_len = packet.get_uchar(@ip_hdr_len + Constants::TCP_LEN_OFFSET + ETH_HDR_LEN).to_s(16)[0].hex * 4
          tcp_hdr_ptr = FFI::MemoryPointer.from_string(packet.get_array_of_uchar((ETH_HDR_LEN + @ip_hdr_len), tcp_hdr_len).pack('C*'))
          @l4_hdr = FFI::Packets::Tcp::Hdr.new(tcp_hdr_ptr)
        when IP_PROTO_UDP
          @udp = true
          udp_hdr_ptr = FFI::MemoryPointer.from_string(packet.get_array_of_uchar((ETH_HDR_LEN + @ip_hdr_len), UDP_HDR_LEN).pack('C*'))
          @l4_hdr = FFI::Packets::Tcp::Hdr.new(udp_hdr_ptr)
      end

      if @tcp or @udp
        class << self
          def sport
            @l4_hdr.sport
          end

          def dport
            @l4_hdr.dport
          end
        end
      end
    end

    def tcp?
      @tcp
    end

    def udp?
      @udp
    end

    def src_ip
      @ip_hdr.src
    end

    alias_method :src, :src_ip

    def dst_ip
      @ip_hdr.dst
    end

    alias_method :dst, :dst_ip
  end
end
