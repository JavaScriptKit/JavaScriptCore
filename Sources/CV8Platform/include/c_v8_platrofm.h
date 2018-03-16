/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

#ifndef c_v8_platrofm_h
#define c_v8_platrofm_h

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

    // global
    void * _Nonnull initialize();
    void dispose(void * _Nonnull platform);
    // isolater
    void * _Nonnull createIsolate();
    void disposeIsolate(void * _Nonnull isolate);

#ifdef __cplusplus
}
#endif

#endif /* c_v8_platrofm_h */
