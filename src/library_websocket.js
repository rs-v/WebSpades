/*
 * WebSocket networking for BetterSpades Emscripten port.
 * Replaces enet UDP with WebSocket for browser compatibility.
 * Works with piqueserver's WebSocket support (port 32888).
 */

mergeInto(LibraryManager.library, {
    ws_init: function() {
        Module._ws_socket = null;
        Module._ws_recv_queue = [];
        Module._ws_connected = 0;
        Module._ws_connecting = 0;
    },

    ws_connect: function(urlPtr) {
        var url = UTF8ToString(urlPtr);
        if (Module._ws_socket) {
            Module._ws_socket.close();
        }
        Module._ws_connecting = 1;
        Module._ws_connected = 0;
        Module._ws_recv_queue = [];

        try {
            Module._ws_socket = new WebSocket(url);
            Module._ws_socket.binaryType = 'arraybuffer';
        } catch(e) {
            Module._ws_connecting = 0;
            return 0;
        }

        Module._ws_socket.onopen = function() {
            Module._ws_connected = 1;
            Module._ws_connecting = 0;
        };

        Module._ws_socket.onmessage = function(evt) {
            if (evt.data instanceof ArrayBuffer) {
                Module._ws_recv_queue.push(new Uint8Array(evt.data));
            }
        };

        Module._ws_socket.onclose = function() {
            Module._ws_connected = 0;
            Module._ws_connecting = 0;
        };

        Module._ws_socket.onerror = function() {
            Module._ws_connected = 0;
            Module._ws_connecting = 0;
        };

        return 1;
    },

    ws_is_connected: function() {
        return Module._ws_connected ? 1 : 0;
    },

    ws_is_connecting: function() {
        return Module._ws_connecting ? 1 : 0;
    },

    ws_send: function(dataPtr, len) {
        if (!Module._ws_socket || Module._ws_socket.readyState !== 1) return;
        var data = HEAPU8.slice(dataPtr, dataPtr + len);
        Module._ws_socket.send(data.buffer);
    },

    ws_recv: function(bufPtr, maxLen) {
        if (Module._ws_recv_queue.length === 0) return 0;
        var pkt = Module._ws_recv_queue.shift();
        var copyLen = Math.min(pkt.length, maxLen);
        HEAPU8.set(pkt.subarray(0, copyLen), bufPtr);
        return copyLen;
    },

    ws_recv_count: function() {
        return Module._ws_recv_queue.length;
    },

    ws_disconnect: function() {
        if (Module._ws_socket) {
            Module._ws_socket.close();
            Module._ws_socket = null;
        }
        Module._ws_connected = 0;
        Module._ws_connecting = 0;
        Module._ws_recv_queue = [];
    },

    ws_get_buffered_amount: function() {
        if (!Module._ws_socket) return 0;
        return Module._ws_socket.bufferedAmount;
    }
});
