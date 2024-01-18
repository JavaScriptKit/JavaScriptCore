#if os(Linux)
import CJavaScriptCore
#else
import JavaScriptCore
#endif

public struct JSError: Error, Equatable, CustomStringConvertible {
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

    // @testable
    init(_ description: String) {
        self.description = description
    }
}
