import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tv_app/theme/colors.dart';
import 'package:tv_app/theme/textstyle.dart';
import 'package:tv_app/webview/webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'keep_alive_wrapper.dart';

class WebviewPage extends GetView<WebController> {
  final WebController _controller = Get.put(WebController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: const Size(360, 690),
      orientation: Orientation.landscape,
    );
    return Obx(
      () => (Scaffold(
        appBar:
            _controller.isShowing.value ? _appbar(context, _controller) : null,
        body: InkWell(
          focusColor: AppColor.blue,
          onTap: () {
            _controller.showBar();
          },
          child: Container(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                Visibility(
                  visible: _controller.isLoading.value ? true : false,
                  child: Container(
                    child: Center(
                      child: Text(
                        'Thêm vào URL mới',
                        style: AppTextStyle.regular24(
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _controller.isLoading.value ? false : true,
                  child: Obx(
                    () => PageView.builder(
                      onPageChanged: (pos) {
                        print(pos);
                        //_controller.currentPageValue = _controller.pageController!.page;
                        _controller.selectedIndex.value = pos;
                      },
                      itemCount: _controller.listTabbar.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          child: _tabbarView(
                            _controller.listTabbar[index].tabUrl,
                          ),
                        );
                      },
                      controller: _controller.pageController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  AppBar _appbar(BuildContext context, WebController _) {
    return AppBar(
      elevation: 0.0,
      title: Obx(
        () => Container(
          width: 120.w,
          child: Text(
            _controller.listTabbar.isEmpty
                ? ''
                : _controller
                    .listTabbar[_controller.selectedIndex.value].tabUrl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.regular16(color: AppColor.gray),
          ),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 50,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: AppColor.backgroundColor),
      ),
      leading: IconButton(
        focusColor: AppColor.blue,
        icon: Icon(
          Icons.fullscreen,
          color: AppColor.gray,
        ),
        onPressed: () {
          _.showBar();
        },
      ),
      actions: [
        IconButton(
          focusColor: AppColor.blue,
          onPressed: () {
            _controller.listTabbar.isEmpty
                ? null
                : _.pageController!.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.gray,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            '${_controller.listTabbar.isEmpty ? _controller.selectedIndex.value = 0 : _controller.selectedIndex.value + 1}/${_controller.listTabbar.length}',
            style: AppTextStyle.regular18(
              color: AppColor.white,
            ),
          ),
        ),
        IconButton(
          focusColor: AppColor.blue,
          onPressed: () {
            _controller.listTabbar.isEmpty
                ? null
                : _.pageController!.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: AppColor.gray,
          ),
        ),
        IconButton(
          focusColor: AppColor.blue,
          onPressed: () async {
            _.reloadPage();
          },
          icon: Icon(
            Icons.refresh_rounded,
            color: AppColor.gray,
          ),
        ),
        IconButton(
          focusColor: AppColor.blue,
          onPressed: () {
            print('setting');
            _.deleteTabbar(_controller.selectedIndex.value);
          },
          icon: Icon(
            Icons.restore_from_trash_rounded,
            color: AppColor.gray,
          ),
        ),
        Obx(
          () => IconButton(
            focusColor: AppColor.blue,
            onPressed: () async {
              _.buttonPlaySlide();
              //_controller.arrTitle.clear();
            },
            icon: Icon(
              _.isPlaying.value
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_outline,
              color: AppColor.gray,
            ),
          ),
        ),
        IconButton(
          focusColor: AppColor.blue,
          onPressed: () {
            _showDialogAdd(context, '');
            //_controller.arrTitle.clear();
          },
          icon: Icon(
            Icons.add,
            color: AppColor.gray,
          ),
        ),
      ],
    );
  }

  Widget _tabbarView(String url) {
    return KeepAliveWrapper(
      child: WebView(
        onWebViewCreated: (controller) {
          _controller.webviewController = controller;
        },
        debuggingEnabled: false,
        initialUrl: url.toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  void _showDialogAdd(BuildContext context, String title) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      title.isEmpty
                          ? 'Thêm một web mới'.toUpperCase()
                          : 'Sửa URL'.toUpperCase(),
                      style: AppTextStyle.bold16(
                        color: AppColor.gray,
                      ),
                    ),
                  ),
                  Container(
                    height: 80.h,
                    padding: EdgeInsets.only(
                      top: 20.h,
                    ),
                    //alignment: Alignment.center,
                    child: TextField(
                      controller: _controller.urlTextController,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        _controller.addTabbar();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              15.r,
                            ),
                          ),
                        ),
                        hintText: title.isEmpty ? 'Nhập vào url' : title,
                        hintStyle: AppTextStyle.regular14(
                          color: AppColor.gray,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          focusColor: AppColor.blue,
                          onTap: () => Get.back(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            child: Text(
                              'Hủy',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                                  AppTextStyle.regular14(color: AppColor.gray),
                            ),
                          ),
                        ),
                        InkWell(
                          focusColor: AppColor.blue,
                          onTap: () async {
                            //_controller.urlTextController.value;
                            _controller.addTabbar();
                            //Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.r,
                              vertical: 10.r,
                            ),
                            child: Text(
                              'Thêm'.tr,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                                  AppTextStyle.regular14(color: AppColor.red),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
}
