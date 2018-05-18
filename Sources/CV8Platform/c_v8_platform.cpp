/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

#include "c_v8_platform.h"

#include <libplatform/libplatform.h>
#include <v8.h>

using namespace v8;

extern "C" {
    void* initialize(const char *exec_path) {
        V8::InitializeICUDefaultLocation(exec_path);
        v8::V8::InitializeExternalStartupData(exec_path);
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
        create_params.array_buffer_allocator =
            v8::ArrayBuffer::Allocator::NewDefaultAllocator();
        return Isolate::New(create_params);
    }

    void disposeIsolate(void* isolate) {
        reinterpret_cast<Isolate*>(isolate)->Dispose();
    }
}
