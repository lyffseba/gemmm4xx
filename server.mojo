import config
import os
import http

from lightbug_http import *
from lightbug_http.sys.server import SysServer

# Note: Mojo web frameworks are actively evolving. 
# We are using lightbug_http for a minimalist web server.
# For production use with MAX, integrating with C++ or Python 
# fastAPI via Python interop is also common, but here we keep it native Mojo.

@value
struct HTMXChatHandler(HTTPRequestHandler):
    fn __init__(inout self):
        pass

    fn __call__(self, req: HTTPRequest) raises -> HTTPResponse:
        var path = req.uri.path
        
        # Serve the main HTML interface
        if path == "/" or path == "":
            var html = String(
                "<!DOCTYPE html>"
                "<html>"
                "<head>"
                "    <title>Gemma 4 + MAX + Mojo</title>"
                "    <script src=\"https://unpkg.com/htmx.org@1.9.10\"></script>"
                "    <script src=\"https://cdn.tailwindcss.com\"></script>"
                "    <style>"
                "        body { background-color: #0f172a; color: #f8fafc; font-family: system-ui, sans-serif; }"
                "        .loader { border-top-color: #3b82f6; -webkit-animation: spinner 1.5s linear infinite; animation: spinner 1.5s linear infinite; }"
                "        @keyframes spinner { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }"
                "    </style>"
                "</head>"
                "<body class=\"min-h-screen flex flex-col items-center justify-center p-4\">"
                "    <div class=\"max-w-2xl w-full bg-slate-800 rounded-xl shadow-2xl overflow-hidden border border-slate-700\">"
                "        <div class=\"bg-slate-900 p-4 border-b border-slate-700 flex items-center justify-between\">"
                "            <h1 class=\"text-xl font-bold text-blue-400 flex items-center gap-2\">"
                "                <svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-6 w-6\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M13 10V3L4 14h7v7l9-11h-7z\" /></svg>"
                "                Gemma 4 MAX Engine"
                "            </h1>"
                "            <span class=\"text-xs bg-slate-700 px-2 py-1 rounded text-slate-300\">Powered by Mojo 🔥</span>"
                "        </div>"
                "        <div id=\"chat-container\" class=\"p-6 h-96 overflow-y-auto flex flex-col gap-4\">"
                "            <div class=\"bg-slate-700/50 p-4 rounded-lg self-start max-w-[85%]\">"
                "                <p class=\"text-sm\">Hello! I am running Gemma 4 via the Modular MAX Engine. How can I help you today?</p>"
                "            </div>"
                "        </div>"
                "        <form class=\"p-4 bg-slate-900 border-t border-slate-700 flex gap-2\""
                "              hx-post=\"/chat\" "
                "              hx-target=\"#chat-container\" "
                "              hx-swap=\"beforeend\""
                "              hx-on::after-request=\"this.reset()\">"
                "            <input type=\"text\" name=\"prompt\" placeholder=\"Type your message...\" required"
                "                   class=\"flex-1 bg-slate-800 text-white rounded-lg px-4 py-2 border border-slate-600 focus:outline-none focus:border-blue-500\">"
                "            <button type=\"submit\" class=\"bg-blue-600 hover:bg-blue-500 text-white px-6 py-2 rounded-lg font-medium transition-colors flex items-center gap-2\">"
                "                Send"
                "                <svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-4 w-4\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M12 19l9 2-9-18-9 18 9-2zm0 0v-8\" /></svg>"
                "            </button>"
                "        </form>"
                "    </div>"
                "</body>"
                "</html>"
            )
            return OK(html, "text/html")
            
        # Handle HTMX Chat requests
        elif path == "/chat" and req.method == "POST":
            # In a real app, we would parse the form data from req.body
            # and pass the prompt to the MAX Engine. 
            # For this prototype, we simulate the interaction.
            
            # Using Python interoperability to interface with MAX Engine 
            # is currently the most robust way to interact with max-serve in Mojo
            # until the native Mojo MAX APIs are fully stabilized for LLMs.
            
            var user_msg = String(
                "<div class=\"bg-blue-600/20 p-4 rounded-lg self-end max-w-[85%] border border-blue-500/30\">"
                "    <p class=\"text-sm text-blue-100\">[User Prompt Received]</p>"
                "</div>"
            )
            
            # Simulated MAX Engine response
            var ai_msg = String(
                "<div class=\"bg-slate-700/50 p-4 rounded-lg self-start max-w-[85%]\">"
                "    <p class=\"text-sm\"><em>[Gemma 4 MAX Engine Response]</em><br/> This is a placeholder. In the RunPod deployment, this endpoint connects to `max-serve` running the Gemma 4 GGUF model to stream real inference results.</p>"
                "</div>"
            )
            
            var combined = user_msg + ai_msg
            return OK(combined, "text/html")
            
        return NotFound(req.uri.path)

fn main() raises:
    var server = SysServer()
    var handler = HTMXChatHandler()
    
    print("🔥 Starting Mojo server for Gemma 4 MAX Engine on http://localhost:8080")
    server.listen_and_serve("0.0.0.0", 8080, handler)
