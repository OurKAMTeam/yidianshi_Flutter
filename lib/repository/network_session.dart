/*
General network class. 
Copyright (C) 2022 SuperBart

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

*/

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:alice/alice.dart';

Alice alice = Alice();
late Directory supportPath;

class NetworkSession {
  @protected
  final PersistCookieJar cookieJar = PersistCookieJar(
    persistSession: true,
    storage: FileStorage("${supportPath.path}/cookie/general"),
  );

  Future<void> clearCookieJar() => cookieJar.deleteAll();

  @protected
  Dio get dio => Dio(
        BaseOptions(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            HttpHeaders.userAgentHeader:
                "Mozilla/5.0 (Linux; Android 11; KB2000 Build/RP1A.201005.001; wv)"
                    "AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/86.0.4240.99"
                    "XWEB/3263 MMWEBSDK/20211001 Mobile Safari/537.36 MMWEBID/3667"
                    "MicroMessenger/8.0.16.2040(0x28001037) Process/toolsmp WeChat/arm64"
                    "Weixin NetType/WIFI Language/zh_CN ABI/arm64",
          },
        ),
      )
        ..interceptors.add(CookieManager(cookieJar))
        ..interceptors.add(alice.getDioInterceptor())
        ..options.followRedirects = false
        ..options.validateStatus =
            (status) => status != null && status >= 200 && status < 400;

  static Future<bool> isInSchool() async {
    bool isInSchool = false;
    Dio dio = Dio()
      ..options.connectTimeout = const Duration(milliseconds: 2000);
    await dio
        .get("http://linux.xidian.edu.cn")
        .then((value) => isInSchool = true)
        .onError((error, stackTrace) => isInSchool = false);
    return isInSchool;
  }
}

class NotSchoolNetworkException implements Exception {
  final msg = "没有在校园网环境";

  @override
  String toString() => msg;
}