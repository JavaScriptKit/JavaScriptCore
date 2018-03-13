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

class GlobalValue {
public:
    explicit GlobalValue(Isolate* isolate, Global<Value>* value):
        isolate_locker(isolate), isolate_scope(isolate), handle_scope(isolate),
        isolate(isolate), value(value) {
    }

    explicit GlobalValue(void* isolate, void* value)
    : GlobalValue(reinterpret_cast<Isolate*>(isolate), reinterpret_cast<Global<Value>*>(value)) {
    }

    ~GlobalValue() { }

    V8_INLINE Local<Value> operator*() const {
        return value->Get(isolate);
    }

    V8_INLINE Local<Value> operator->() const {
        return value->Get(isolate);
    }

private:
    Locker isolate_locker;
    Isolate::Scope isolate_scope;
    HandleScope handle_scope;

    Isolate* isolate;
    Global<Value>* value;

    // Prevent copying of GlobalValue objects.
    GlobalValue(const GlobalValue&);
    GlobalValue& operator=(const GlobalValue&);
};

extern "C" {
    ArrayBufferAllocator bufferAllocator;

    const void* initialize() {
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

    const void* createIsolate() {
        Isolate::CreateParams create_params;
        create_params.array_buffer_allocator = &bufferAllocator;
        return Isolate::New(create_params);
    }

    void disposeIsolate(void* isolate) {
        reinterpret_cast<Isolate*>(isolate)->Dispose();
    }

    void* createContext(void* isolatePtr) {
        auto isolate = reinterpret_cast<Isolate*>(isolatePtr);
        Locker isolateLocker(isolate);
        Isolate::Scope isolate_scope(isolate);
        HandleScope handle_scope(isolate);
        Local<Context> context = Context::New(isolate);
        return new Global<Context>(isolate, context);
    }

    void disposeContext(void* context) {
        delete reinterpret_cast<Global<Context>*>(context);
    }

    void* evaluate(void* isolatePtr, void* contextPtr, const char* scriptPtr, void** exception) {
        auto isolate = reinterpret_cast<Isolate*>(isolatePtr);
        auto globalContext = reinterpret_cast<Global<Context>*>(contextPtr);

        Locker isolateLocker(isolate);
        TryCatch trycatch(isolate);
        Isolate::Scope isolate_scope(isolate);
        HandleScope handle_scope(isolate);
        Local<Context> context = globalContext->Get(isolate);
        Context::Scope context_scope(context);
        Local<String> source = String::NewFromUtf8(isolate, scriptPtr);
        Local<Script> script = Script::Compile(source);
        MaybeLocal<Value> result = script->Run(context);

        if (result.IsEmpty()) {
            *exception = new Global<Value>(isolate, trycatch.Exception());
            return nullptr;
        }
        auto local = result.ToLocalChecked();
        return new Global<Value>(isolate, local);
    }

    void disposeValue(void* pointer) {
        delete reinterpret_cast<Global<Value>*>(pointer);
    }

    int64_t valueToInt(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        return scoped->ToInteger()->IntegerValue();
    }

    int getUtf8StringLength(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        String::Utf8Value utf8(*scoped);
        return utf8.length();
    }

    void copyUtf8String(void* isolate, void* value, void* buffer, int count) {
        GlobalValue scoped(isolate, value);
        String::Utf8Value utf8(*scoped);
        memcpy(buffer, *utf8, count);
    }

    // MARK: type checks

    bool isNull(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        return scoped->IsNull();
    }

    bool isUndefined(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        return scoped->IsUndefined();
    }

    bool isBoolean(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        return scoped->IsBoolean();
    }

    bool isNumber(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        return scoped->IsNumber();
    }

    bool isString(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        return scoped->IsString();
    }

    bool isObject(void* isolate, void* value) {
        GlobalValue scoped(isolate, value);
        return scoped->IsObject();
    }
}
