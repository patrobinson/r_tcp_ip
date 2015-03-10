require "r_tcp_ip/version"
require "r_tcp_ip/constants"

module RTcpIp
  class Packet
    attr_reader :src_mac, :dst_mac
    # Expects an array of bytes
    def initialize(data)
      @dst_mac = data[0..5].collect { |byte| byte.to_s(16).rjust(2, '0') + ":" }.join.chop
      @src_mac = data[6..11].collect { |byte| byte.to_s(16).rjust(2, '0') + ":" }.join.chop

      if data[12..13] == [8, 0]
        @ip = true

        class << self
          attr_reader :ip_version, :proto
        end

        @ip_version = data[14].to_s(16)[0]
        @ip_header_length = data[14].to_s(16)[1].hex * 4
        @ip_header = data[14..(14 + @ip_header_length - 1)]
        @proto = PROTOCOLS[@ip_header[9]] || nil

        case @proto
          when :tcp
            @tcp_offset = 14 + @ip_header_length
            # We only care about the header, which is the first 20 bytes
            @tcp_header = data[@tcp_offset..(@tcp_offset + 19)]
          when :udp
            @udp_offset = 14 + @ip_header_length
            # Header is 8 bytes
            @udp_header = data[@tcp_offset..(@tcp_offset + 7)]
        end
      else
        @ip = false
      end
    end

    def ip?
      @ip
    end

    def ip_flags
      @ip_header[6].to_s(16)[0]
    end

    def tcp?
      @proto == :tcp
    end

    def udp?
      @proto == :udp
    end

    def src_ip
      if @ip
        @ip_header[12..15].collect { |oct| oct.to_s + "." }.join.chop
      end
    end

    def dst_ip
      if @ip
        @ip_header[16..19].collect { |oct| oct.to_s + "." }.join.chop
      end
    end

    def sport
      if tcp? or udp?
        @tcp_header[0..1].collect { |oct| oct.to_s(16) }.join.hex
      end
    end

    def dport
      if tcp? or udp?
        @tcp_header[2..3].collect { |oct| oct.to_s(16) }.join.hex
      end
    end
  end
end
