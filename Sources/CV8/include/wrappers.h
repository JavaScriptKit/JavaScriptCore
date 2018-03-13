/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

#ifndef wrappers_h
#define wrappers_h

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif


    void* initialize();
    void dispose(void* platform);
    void* createIsolate();
    void disposeIsolate(void* isolate);

    void* createContext(void* isolate);
    void disposeContext(void* context);

    void* evaluate(void* isolatePtr, void* contextPtr, const char* scriptPtr, void** exception);
    void disposeValue(void* pointer);

    int getUtf8StringLength(void* isolatePtr, void* valuePtr);
    void copyUtf8String(void* isolatePtr, void* valuePtr, void* buffer, int count);

    int64_t valueToInt(void* isolatePtr, void* valuePtr);

    bool isNull(void* isolatePtr, void* valuePtr);
    bool isUndefined(void* isolatePtr, void* valuePtr);
    bool isBoolean(void* isolatePtr, void* valuePtr);
    bool isNumber(void* isolatePtr, void* valuePtr);
    bool isString(void* isolatePtr, void* valuePtr);
    bool isObject(void* isolatePtr, void* valuePtr);


#ifdef __cplusplus
}
#endif

#endif /* wrappers_h */
