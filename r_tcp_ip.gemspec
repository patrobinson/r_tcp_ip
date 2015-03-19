# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'r_tcp_ip/version'

Gem::Specification.new do |spec|
  spec.name          = "r_tcp_ip"
  spec.version       = RTcpIp::VERSION
  spec.authors       = ["nemski"]
  spec.email         = ["nemski.rabbit@gmail.com"]
  spec.summary       = %q{A convenience library for using FFI::Pcap and FFI::Packets}
  spec.description   = %q{Takes a FFI::MemoryPointer to a packet and maps IP and TCP/UDP headers to be passed to FFI::Packets::{Ip,Udp,Tcp}}
  spec.homepage      = "https://github.com/nemski/r_tcp_ip"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "ffi", ">= 1.9.6"
  spec.add_runtime_dependency "ffi-packets", "= 0.1.0"
end
