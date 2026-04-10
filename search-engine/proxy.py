from http.server import HTTPServer, BaseHTTPRequestHandler
import urllib.request

class ProxyHandler(BaseHTTPRequestHandler):
    def do_GET(self): self.proxy()
    def do_POST(self): self.proxy()
    def do_OPTIONS(self):
        self.send_response(200)
        self.cors()
        self.end_headers()

    def cors(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET,POST,OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')

    def proxy(self):
        url = 'http://elasticsearch:9200' + self.path
        n = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(n) if n else None
        try:
            req = urllib.request.Request(url, data=body,
                  headers={'Content-Type':'application/json'}, method=self.command)
            res = urllib.request.urlopen(req)
            data = res.read()
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.cors()
            self.end_headers()
            self.wfile.write(data)
        except Exception as e:
            self.send_response(500)
            self.cors()
            self.end_headers()
            self.wfile.write(str(e).encode())

    def log_message(self, *a): pass

print("Proxy CORS demarre sur port 9201")
HTTPServer(('0.0.0.0', 9201), ProxyHandler).serve_forever()
