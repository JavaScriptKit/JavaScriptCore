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

#ifndef c_v8_platform_h
#define c_v8_platform_h

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

    // global
    void * _Nonnull initialize(const char * _Nonnull exec_path);
    void dispose(void * _Nonnull platform);
    // isolater
    void * _Nonnull createIsolate();
    void disposeIsolate(void * _Nonnull isolate);

#ifdef __cplusplus
}
#endif

#endif /* c_v8_platform_h */
