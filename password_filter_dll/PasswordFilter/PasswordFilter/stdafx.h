// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <stdio.h>
#include <windows.h>
#include <tchar.h>
#include <winnt.h>
#include <NTSecAPI.h>
#include <sqlext.h>
#include <rpc.h>
#include <iostream>
#include <curl/curl.h>

// TODO: reference additional headers your program requires here

#pragma comment(lib, "rpcrt4.lib")