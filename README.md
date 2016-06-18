# fiber_http_segfault

Simple lib to reproduce segfaults using HTTP::Client to fetch HTTPS urls using fibers.

The exact same error occurs when using [[fiberpool]](https://github.com/akitaonrails/fiberpool]) or [[Sidekiq.cr]](https://github.com/mperham/sidekiq.cr])

## System / Versions
### Crystal
    $ crystal version
    Crystal 0.18.2 (2016-06-17)

Installed using:

    $ brew install crystal-lang

### OpenSSL
    $ openssl version
    OpenSSL 0.9.8zh 14 Jan 2016

#### Using OpenSSL 1.0.2:
    $ brew uninstall crystal-lang
    $ brew install openssl
    $ brew link openssl --force
    Linking /usr/local/Cellar/openssl/1.0.2h_1... 1601 symlinks created
    $ openssl version
    OpenSSL 1.0.2h  3 May 2016
    $ brew install crystal-lang
    $ crystal version
    Crystal 0.18.2 (2016-06-17)

## Usage / Reproducing segfault

    $ git clone git://github.com/Agiley/fiber-http-segfault.git
    $ cd fiber-http-segfault
    $ crystal deps

Run example using fibers:

    $ crystal examples/test_with_fibers.cr 

Run example without using fibers:

    $ crystal examples/test_without_fibers.cr 

## Stacktrace

This the resulting stacktrace when running examples/test_with_fibers.cr:

```
[4468511787] *CallStack::print_backtrace:Int32 +107
[4468485031] __crystal_sigfault_handler +55
[140735540987178] _sigtramp +26
[4468524852] *String#ends_with?<Char>:Bool +20
[4468530347] *String#chomp<Char>:String +27
[4468739127] *OpenSSL::SSL::HostnameValidation::matches_hostname?<String, String>:Bool +87
[4468738391] *OpenSSL::SSL::HostnameValidation::matches_subject_alternative_name<String, Pointer(Void)>:OpenSSL::SSL::HostnameValidation::Result +583
[4468737748] *OpenSSL::SSL::HostnameValidation::validate_hostname<String, Pointer(Void)>:OpenSSL::SSL::HostnameValidation::Result +52
[4468493127] ~procProc(LibCrypto::X509_STORE_CTX, Pointer(Void), Int32)@/usr/local/Cellar/crystal-lang/0.18.2/src/openssl/ssl/context.cr:87 +71
[140735645129828] ssl_verify_cert_chain +276
[140735645072756] ssl3_get_server_certificate +372
[140735645069244] ssl3_connect +1884
[140735645040936] ssl23_connect +3192
[4468736766] *OpenSSL::SSL::Socket::Client#initialize<TCPSocket, OpenSSL::SSL::Context::Client, Bool, String>:Nil +158
[4468736589] *OpenSSL::SSL::Socket::Client::new:context:sync_close:hostname<TCPSocket, OpenSSL::SSL::Context::Client, Bool, String>:OpenSSL::SSL::Socket::Client +141
[4468719264] *HTTP::Client#socket:(OpenSSL::SSL::Socket+ | TCPSocket+) +336
[4468718491] *HTTP::Client#exec_internal<HTTP::Request>:HTTP::Client::Response +43
[4468718198] *HTTP::Client#exec<HTTP::Request>:HTTP::Client::Response +38
[4468717496] *HTTP::Client#exec<String, String, HTTP::Headers, Nil>:HTTP::Client::Response +40
[4468717450] *HTTP::Client#get:headers<String, HTTP::Headers>:HTTP::Client::Response +58
[4468693565] *FiberHttpSegfault::Client#crawl_url<String>:(HTTP::Client::Response | Nil) +1101
[4468491504] ~procProc(String, Nil)@./src/fiber_http_segfault/client.cr:17 +16
[4468491395] ~procProc(Nil)@./libs/fiberpool/fiberpool.cr:24 +99
[4468508570] *Fiber#run:(Int64 | Nil) +170
[4468476213] ~procProc(Fiber, (Int64 | Nil))@/usr/local/Cellar/crystal-lang/0.18.2/src/fiber.cr:27 +21
```