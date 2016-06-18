require "fiberpool"
require "http/client"

module FiberHttpSegfault
  class Client
    @urls : Array(String)
    
    def initialize(@use_fibers = true, @pool_size = 20)
      # Popular sites + recently tested SSL sites on https://www.ssllabs.com/ssltest/
      @urls = File.read_lines("./urls.txt").map { |url| url.strip }
    end
    
    def crawl
      output_macro_status
      
      if @use_fibers
        pool = Fiberpool.new(@urls, @pool_size)
        pool.run do |url|
          crawl_url(url)
        end
      else
        @urls.each { |url| crawl_url(url) }
      end
    end
    
    def output_macro_status
      {% if LibSSL::OPENSSL_102 %}
        puts "\n\nLibssl >= 1.0.2 was detected!\n\n\n"
      {% else %}
        puts "\n\nLibssl >= 1.0.2 wasn't detected!\n\n\n"
      {% end %}
    end
    
    def crawl_url(url)
      uri             =   URI.parse(url)
      
      http_client     =   HTTP::Client.new(uri).tap do |client|
        client.connect_timeout  =   5.seconds
        client.dns_timeout      =   5.seconds
        client.read_timeout     =   15.seconds
      end
      
      puts "Fetching #{url} #{@use_fibers ? "using" : "without using"} fibers..."
      
      path            =   uri.path.try &.empty? ? "/" : uri.path.as(String)
      
      begin
        http_client.get(path, headers: HTTP::Headers{ "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" })
      rescue
      end
    end
    
  end
end
