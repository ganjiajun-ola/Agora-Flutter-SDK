import 'dart:convert';

import 'package:iris_method_channel/iris_method_channel.dart';
import 'package:iris_method_channel/iris_method_channel_bindings_web.dart' as js;

// ignore_for_file: public_member_api_docs



class NativeIrisApiEngineBindingsDelegate
    extends PlatformBindingsDelegateInterface {
  

  @override
  void initialize() {
    // _binding = bindings.NativeIrisApiEngineBinding(_loadLib());
    // _binding.enableUseJsonArray(1);
  }

  @override
  CreateApiEngineResult createApiEngine(List<Object> args) {
    


    // ffi.Pointer<ffi.Void> enginePtr = ffi.nullptr;
    // assert(() {
    //   if (args.isNotEmpty) {
    //     assert(args.length == 1);
    //     enginePtr = args[0] as ffi.Pointer<ffi.Void>;
    //   }
    //   return true;
    // }());

    // final apiEnginePtr = _binding.CreateIrisApiEngine(enginePtr);
    final apiEnginePtr = js.CreateIrisApiEngine();

    return CreateApiEngineResult(apiEnginePtr);
  }

  // void _response(
  //     ffi.Pointer<iris_bindings.ApiParam> param, Map<String, Object> result) {
  //   using<void>((Arena arena) {
  //     final ffi.Pointer<Utf8> resultMapPointerUtf8 =
  //         jsonEncode(result).toNativeUtf8(allocator: arena);
  //     final ffi.Pointer<ffi.Int8> resultMapPointerInt8 =
  //         resultMapPointerUtf8.cast();

  //     for (int i = 0; i < kBasicResultLength; i++) {
  //       if (i >= resultMapPointerUtf8.length) {
  //         break;
  //       }

  //       param.ref.result[i] = resultMapPointerInt8[i];
  //     }
  //   });
  // }

  /// The value of `methoCall.funcName` should be same as the C function name
  // int _interceptCall(
  //   IrisMethodCall methodCall,
  //   ffi.Pointer<ffi.Void> apiEnginePtr,
  //   ffi.Pointer<iris_bindings.ApiParam> param,
  // ) {
  //   switch (methodCall.funcName) {
  //     case 'StartDumpVideo':
  //       {
  //         final data = jsonDecode(methodCall.params);
  //         final videoFrameBufferManagerIntPtr = data['nativeHandle'];
  //         final type = data['type'];
  //         final dir = data['dir'];
  //         return _binding.StartDumpVideo(
  //             ffi.Pointer<ffi.Void>.fromAddress(videoFrameBufferManagerIntPtr),
  //             type,
  //             dir);
  //       }

  //     case 'StopDumpVideo':
  //       {
  //         final data = jsonDecode(methodCall.params);
  //         final videoFrameBufferManagerIntPtr = data['nativeHandle'];
  //         return _binding.StopDumpVideo(
  //             ffi.Pointer<ffi.Void>.fromAddress(videoFrameBufferManagerIntPtr));
  //       }
  //     case 'CreateIrisRtcRendering':
  //       {
  //         final data = jsonDecode(methodCall.params);
  //         assert(data.containsKey('irisRtcEngineNativeHandle'));
  //         final irisRtcEngineNativeHandle =
  //             data['irisRtcEngineNativeHandle'] as int;

  //         final bufferManager = _binding.CreateIrisRtcRendering(
  //             ffi.Pointer<ffi.Void>.fromAddress(irisRtcEngineNativeHandle));

  //         final result = {'irisRtcRenderingHandle': bufferManager.address};
  //         _response(param, result);

  //         return 0;
  //       }
  //     case 'FreeIrisRtcRendering':
  //       {
  //         final data = jsonDecode(methodCall.params);
  //         final videoFrameBufferManagerIntPtr =
  //             data['irisRtcRenderingHandle'] as int;
  //         _binding.FreeIrisRtcRendering(
  //             ffi.Pointer<ffi.Void>.fromAddress(videoFrameBufferManagerIntPtr));

  //         _response(param, {});

  //         return 0;
  //       }
  //     default:
  //       break;
  //   }
  //   return _doNotInterceptCall;
  // }

  //   ffi.Pointer<ffi.Void> apiEnginePtr,
  // ffi.Pointer<ApiParam> param,

  @override
  int callApi(
    IrisMethodCall methodCall,
    ApiEngineHandle apiEnginePtr,
    ApiParamHandle param,
  ) {
    // final nApiEnginePtr = apiEnginePtr as ffi.Pointer<ffi.Void>;
    // final nParam = param as ffi.Pointer<iris_bindings.ApiParam>;
    // final interceptRet = _interceptCall(methodCall, nApiEnginePtr, nParam);
    // if (interceptRet != _doNotInterceptCall) {
    //   return interceptRet;
    // }

    // return _binding.CallIrisApi(nApiEnginePtr, nParam.cast());

        final nApiEnginePtr = apiEnginePtr as js.IrisApiEngine;
    final nParam = param as js.ApiParam;
    // final interceptRet = _interceptCall(methodCall, nApiEnginePtr, nParam);
    // if (interceptRet != _doNotInterceptCall) {
    //   return interceptRet;
    // }

    // return _binding.CallIrisApi(nApiEnginePtr, nParam.cast());

    return js.CallIrisApi(nApiEnginePtr, nParam);
  }

  // @override
  // ffi.Pointer<ffi.Void> createIrisEventHandler(
  //   ffi.Pointer<IrisCEventHandler> eventHandler,
  // ) {
  //   return _binding.CreateIrisEventHandler(eventHandler.cast());
  // }

  @override
  IrisEventHandlerHandle createIrisEventHandler(
    IrisCEventHandlerHandle eventHandler,
  ) {
    // return _binding.CreateIrisEventHandler(
    //     (eventHandler as ffi.Pointer<iris_bindings.IrisCEventHandler>).cast());

    return js.CreateIrisEventHandler(eventHandler as js.IrisCEventHandler);
  }

  // @override
  // void destroyIrisEventHandler(
  //   ffi.Pointer<ffi.Void> handler,
  // ) {
  //   _binding.DestroyIrisEventHandler(handler);
  // }

  @override
  void destroyIrisEventHandler(
    IrisEventHandlerHandle handler,
  ) {
    // _binding.DestroyIrisEventHandler(handler as ffi.Pointer<ffi.Void>);

  }

  // @override
  // void destroyNativeApiEngine(ffi.Pointer<ffi.Void> apiEnginePtr) {
  //   _binding.DestroyIrisApiEngine(apiEnginePtr);
  // }

  @override
  void destroyNativeApiEngine(ApiEngineHandle apiEnginePtr) {
    // _binding.DestroyIrisApiEngine(apiEnginePtr as ffi.Pointer<ffi.Void>);
    js.DestroyIrisApiEngine(apiEnginePtr as js.IrisApiEngine);
  }
}

class IrisApiEngineNativeBindingDelegateProvider
    extends PlatformBindingsProvider {
  // @override
  // NativeBindingDelegate provideNativeBindingDelegate() {
  //   return NativeIrisApiEngineBindingsDelegate();
  // }

  @override
  PlatformBindingsDelegateInterface provideNativeBindingDelegate() {
    return NativeIrisApiEngineBindingsDelegate();
  }
}
