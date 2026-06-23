/*
	Copyright (c) 2017-2020 ByteBit

	This file is part of BetterSpades.

	BetterSpades is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	BetterSpades is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with BetterSpades.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifdef __EMSCRIPTEN__
/* Emscripten: http.h uses BSD sockets which are not available.
   Stub out http_get/http_process/http_release - the server browser
   will show an empty list, but direct connect still works. */
#include <stddef.h>

#define HTTP_STATUS_FAILED 0
#define HTTP_STATUS_COMPLETED 1
#define HTTP_STATUS_PENDING 2

struct http_t { int status; char* response_data; };

void* http_get(const char* url, const char* headers) { return NULL; }
int http_process(void* request) { return HTTP_STATUS_FAILED; }
void http_release(void* request) { }

#else /* !__EMSCRIPTEN__ */

#define HTTP_IMPLEMENTATION

#ifdef _WIN32
#define _WIN32_WINNT 0x0501
#endif

#include <stdint.h>

#include "http.h"

#endif /* __EMSCRIPTEN__ */
