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

    // global
    void * _Nonnull initialize();
    void dispose(void * _Nonnull platform);
    // isolate
    void * _Nonnull createIsolate();
    void disposeIsolate(void * _Nonnull isolate);
    // global template
    void * _Nonnull createTemplate(void * _Nonnull isolate);
    void disposeTemplate(void * _Nonnull context);
    // context
    void * _Nonnull createContext(void * _Nonnull isolate, void * _Nonnull globalTemplate);
    void disposeContext(void * _Nonnull context);


    // called from JSValue's destructor
    void disposeValue(void * _Nonnull pointer);

    void * _Nullable evaluate(void * _Nonnull isolatePtr, void * _Nonnull contextPtr, const char* _Nonnull scriptPtr, void * _Nullable* _Nonnull exception);

    int getUtf8StringLength(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);
    void copyUtf8String(void * _Nonnull isolatePtr, void * _Nonnull valuePtr, void * _Nonnull buffer, int count);

    int64_t valueToInt(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);


    bool isNull(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);
    bool isUndefined(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);
    bool isBoolean(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);
    bool isNumber(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);
    bool isString(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);
    bool isObject(void * _Nonnull isolatePtr, void * _Nonnull valuePtr);


    void (* _Nullable swiftCallback)(void * _Nonnull isolate, int32_t id, void * _Nullable * _Nonnull arguments, int32_t count, void * _Nonnull returnValue);
    void createFunction(void * _Nonnull  isolatePtr, void * _Nonnull contextPtr, void * _Nonnull templatePtr, const char* _Nonnull namePtr, int32_t id);

    void setReturnValueUndefined(void * _Nonnull isolatePtr, void * _Nonnull returnValuePtr);
    void setReturnValueNull(void * _Nonnull isolatePtr, void * _Nonnull returnValuePtr);
    void setReturnValueBoolean(void * _Nonnull isolatePtr, void * _Nonnull returnValuePtr, bool value);
    void setReturnValueNumber(void * _Nonnull isolatePtr, void * _Nonnull returnValuePtr, double value);
    void setReturnValueString(void * _Nonnull isolatePtr, void * _Nonnull returnValuePtr, const char* _Nonnull utf8);
    void setReturnValueEmptyString(void * _Nonnull isolatePtr, void * _Nonnull returnValuePtr);


#ifdef __cplusplus
}
#endif

#endif /* wrappers_h */
