import 'package:flutter/material.dart';

import 'base_view_model.dart';

/// 提供viewModel的Widget
/// 当前属于MVVM中的 ViewModel层
class ViewModelProvider<T extends BaseViewModel> extends StatefulWidget {
  static const String path = 'utils/viewmodel/viewmodel_provider';
  final Map<String, dynamic>? parameter;

  const ViewModelProvider({
    Key? key,
    required this.parameter,
  }) : super(key: key);

  /// 获取到viewModel类实例
  static T? of<T extends BaseViewModel>(BuildContext context, T viewModel) =>
      viewModel;

  @override
  _ViewModelProviderState createState() => _ViewModelProviderState();
}

class _ViewModelProviderState extends State<ViewModelProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.parameter!['widget'];
  }
}
