/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

#include <stdlib.h> // malloc, free
#include <string.h> // memset, memcpy
#include <libplatform/libplatform.h>
#include <v8.h>
#include "c_v8_platform.h"

using namespace v8;

class ArrayBufferAllocator : public v8::ArrayBuffer::Allocator {
public:
    virtual void *Allocate(size_t length){
        void *data = AllocateUninitialized(length);
        return data == NULL ? data : memset(data, 0, length);
    }
    virtual void *AllocateUninitialized(size_t length) { return malloc(length); }
    virtual void Free(void *data, size_t) { free(data); }
};

extern "C" {
    ArrayBufferAllocator bufferAllocator;

    void* initialize() {
        V8::InitializeICU();
        auto platform = platform::CreateDefaultPlatform();
        V8::InitializePlatform(platform);
        V8::Initialize();
        return platform;
    }

    void dispose(void* platform) {
        V8::Dispose();
        V8::ShutdownPlatform();
        delete reinterpret_cast<Platform*>(platform);;
    }

    void* createIsolate() {
        Isolate::CreateParams create_params;
        create_params.array_buffer_allocator = &bufferAllocator;
        return Isolate::New(create_params);
    }

    void disposeIsolate(void* isolate) {
        reinterpret_cast<Isolate*>(isolate)->Dispose();
    }
}
