import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/utils/function/my_function.dart'
    show throttle;

/// 自定义按钮
class MyButton extends StatelessWidget {
  final Color? defaultBgC; // 默认背景颜色
  final Color? triggerBgC; // 点击水波纹颜色
  final double? borderRadius; // 边框圆角样式
  final BoxShape? boxShape; // 水波纹形状
  final bool cuttingInkWell; // 裁切：如果控件是圆角不剪裁的话水波纹是矩形
  final double? wRRange; // 水波纹范围
  final double? vPadding; // 垂直内边距
  final double? hPadding; // 水平内边距
  final TextStyle? textStyle; // 文本样式
  final String? textContent; // 文本内容
  final Function? onTap; // 点击事件
  final bool throttleFlag; // 点击事件截流,第一次点击后，两秒内频内，不会触发相同点击事件

  const MyButton(
      {Key? key,
      this.defaultBgC = Colors.blueGrey,
      this.triggerBgC = Colors.amber,
      this.borderRadius = 0,
      this.cuttingInkWell = true,
      this.wRRange = 300,
      this.vPadding = 10,
      this.hPadding = 30,
      this.textStyle,
      this.textContent = "",
      @required this.onTap,
      this.boxShape = BoxShape.rectangle,
      this.throttleFlag = false})
      : assert(
          onTap != null,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: defaultBgC,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
        ),
        child: InkResponse(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
          highlightShape: boxShape!,
          radius: wRRange,
          splashColor: triggerBgC,
          containedInkWell: cuttingInkWell,
          onTap: () => throttle(onTap!, throttleFlag: throttleFlag),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: vPadding!, horizontal: hPadding!),
            child: Text(textContent!,
                style: textStyle ?? const TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
