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

#if os(Linux)
import CJavaScriptCore
#else
import JavaScriptCore
#endif

public struct JSError: Error, CustomStringConvertible {
    public var description: String

    init(context: JSContextRef, pointer: JSValueRef) {
        let value = JSValue(context: context, pointer: pointer)
        do {
            guard value.isObject else {
                description = "not an object"
                return
            }
            guard let message = value["message"] else {
                self.description = "failed to access error.message"
                return
            }
            self.description = try message.toString()
        } catch {
            self.description = "failed to convert JSError"
        }
    }
}
