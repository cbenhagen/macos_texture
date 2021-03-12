import Cocoa
import FlutterMacOS

public class MacosTexturePlugin: NSObject, FlutterPlugin {
  private var registrar: FlutterPluginRegistrar
  private var texture: SomeTexture?
  private var textureId: Int64?
  private var pixelBuffer: CVPixelBuffer

  init(registrar: FlutterPluginRegistrar) {
      self.registrar = registrar

      var buf : CVPixelBuffer? = nil

      CVPixelBufferCreate(kCFAllocatorDefault, 300, 200, kCVPixelFormatType_32BGRA, [
        kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
        kCVPixelBufferMetalCompatibilityKey: true,
        kCVPixelBufferOpenGLCompatibilityKey: true,
      ] as CFDictionary, &buf)

      pixelBuffer = buf!

      CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
      let bufferWidth = Int(CVPixelBufferGetWidth(pixelBuffer))
      let bufferHeight = Int(CVPixelBufferGetHeight(pixelBuffer))
      let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)

      let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)!

      for row in 0..<bufferHeight {
          var pixel = baseAddress + row * bytesPerRow
          for _ in 0..<bufferWidth {
              let blue = pixel
              blue.storeBytes(of: 255, as: UInt8.self)

              let red = pixel + 1
              red.storeBytes(of: 255, as: UInt8.self)

              let green = pixel + 2
              green.storeBytes(of: 0, as: UInt8.self)

              let alpha = pixel + 3
              alpha.storeBytes(of: 255, as: UInt8.self)

              pixel += 4;
          }
      }
      CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

      super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "macos_texture", binaryMessenger: registrar.messenger)
    let instance = MacosTexturePlugin(registrar: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }


  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getTextureId":
      if (texture == nil) {
        texture = SomeTexture(buffer: pixelBuffer)
        textureId = registrar.textures.register(texture!)
        print("Registered texture with id \(textureId!)")
      }
      result(textureId)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

public class SomeTexture: NSObject, FlutterTexture {
  var pixelBuffer: CVPixelBuffer

  init(buffer: CVPixelBuffer) {
    pixelBuffer = buffer
  }

  public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    return Unmanaged<CVPixelBuffer>.passRetained(pixelBuffer)
  }
}
