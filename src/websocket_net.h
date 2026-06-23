/*
	WebSocket networking wrapper for Emscripten build.
	Replaces enet UDP networking with WebSocket for browser compatibility.
*/

#ifndef WEBSOCKET_NET_H
#define WEBSOCKET_NET_H

#include <stdint.h>

/* JS-implemented functions (in library_websocket.js) */
extern void ws_init(void);
extern int  ws_connect(const char* url);
extern int  ws_is_connected(void);
extern int  ws_is_connecting(void);
extern void ws_send(const uint8_t* data, int len);
extern int  ws_recv(uint8_t* buf, int max_len);
extern int  ws_recv_count(void);
extern void ws_disconnect(void);
extern int  ws_get_buffered_amount(void);

#endif
