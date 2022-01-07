import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tv_app/models/tabbar.dart';
import 'package:tv_app/toast/toast_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'life_cycle_event_handler.dart';

class WebController extends GetxController
    with ToastUtils, SingleGetTickerProviderMixin {
  TextEditingController urlTextController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isPlaying = true.obs;
  RxBool isShowing = true.obs;
  RxInt selectedIndex = 0.obs;
  PageController? pageController;
  late WebViewController webviewController;
  RxInt _currentPage = 0.obs;
  RxList<TabbarWeb> listTabbar = RxList();
  RxBool end = false.obs;

  Future getTabbars() async {
    Box box;
    try {
      box = Hive.box('tabbar');
    } catch (error) {
      box = await Hive.openBox('tabbar');
      print(error);
    }

    var tabbar = box.get('tabbar');
    print("tabbar $tabbar");
    if (tabbar != null) {
      isLoading.value = false;
      isPlaying.value = true;
      listTabbar.clear();
      for (TabbarWeb arr in tabbar) {
        listTabbar.add(arr);
      }
    } else {
      isLoading.value = true;
      isPlaying.value = false;
    }
  }

  Future delteDB() async {
    Hive.deleteBoxFromDisk('tabbar');
    listTabbar.clear();
    isLoading.value = true;
    isPlaying.value = false;
    selectedIndex.value = 0;
  }

  Future<void> initTabbar() async {
    pageController = PageController(initialPage: 999);
  }

  Future addTabbar() async {
    if (urlTextController.text.isEmpty) {
      errorToast('Không được bỏ trống URL');
    } else {
      var box = await Hive.openBox('tabbar');
      listTabbar.add(
        TabbarWeb(
          tabUrl: urlTextController.text,
        ),
      );
      box.put('tabbar', listTabbar.toList());
      update();
      urlTextController.clear();
      isPlaying.value = false;
      getTabbars();
      successToast('Thêm thành công');
      Get.back();
    }
  }

  Future deleteTabbar(int index) async {
    if (listTabbar.length == 1) {
      errorToast('Không thể xóa');
    } else {
      if(index == 0){
        listTabbar.removeAt(index);
        var box = await Hive.openBox('tabbar');
        box.put('tabbar', listTabbar.toList());
        pageController!.animateToPage(0, duration: Duration(microseconds: 250), curve: Curves.bounceInOut);
        Get.offAllNamed('/');
      }else{
        listTabbar.removeAt(index);
        var box = await Hive.openBox('tabbar');
        box.put('tabbar', listTabbar.toList());
        pageController!.animateToPage(0, duration: Duration(microseconds: 250), curve: Curves.bounceInOut);
        //await Get.offAllNamed('/');
        getTabbars();
      }

    }
  }

  Future showBar() async {
    isShowing.value = !isShowing.value;
  }

  //Reload lại web
  Future reloadPage() async {
    if (listTabbar.isNotEmpty) {
      await webviewController
          .loadUrl(listTabbar[pageController!.page!.floor()].tabUrl);
    }
  }

  Future timeDuration() async {
    DateTime nowTime;
    String formattedDate;
    Timer.periodic(
        const Duration(seconds: 15),
        (_) => {
              nowTime = DateTime.now(),
              formattedDate = DateFormat('kk:mm').format(nowTime),
              print('${formattedDate.toString()}'),
              if (formattedDate.toString() == '07:00')
                {
                  print(formattedDate.toString()),
                  successToast('Chào buổi sáng'),
                  Get.offAllNamed('/'),
                  print('reloaddddd'),
                },
            });
  }

  Future buttonPlaySlide() async {
    if (isPlaying.value == true) {
      isPlaying.value = false;
      successToast('Tạm dừng slide');
      changeTabbar();
    } else {
      isPlaying.value = true;
      successToast('Tiếp tục');
      changeTabbar();
    }
  }

  //Chuyển sang tab mới
  Future changeTabbar() async {
    Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      if (isPlaying.value == false) {
        timer.cancel();
      } else {
        //Nếu trang hiện tại bằng với trang max (trang 4/4) thì trang = 0
        if (selectedIndex.value == listTabbar.length - 1) {
          selectedIndex.value = 0;
          pageController!.animateToPage(selectedIndex.value,
              duration: const Duration(microseconds: 500),
              curve: Curves.bounceInOut);
        } else {
          selectedIndex.value += 1;
          pageController!.animateToPage(selectedIndex.value,
              duration: const Duration(microseconds: 500),
              curve: Curves.bounceInOut);
        }
      }
    });
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    initTabbar();
    isPlaying.value = true;
    getTabbars();
    timeDuration();
    changeTabbar();
    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      Get.offAllNamed('/');
    }));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
