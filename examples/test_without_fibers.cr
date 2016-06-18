require "../src/fiber_http_segfault"

client = FiberHttpSegfault::Client.new(use_fibers: false)
client.crawl