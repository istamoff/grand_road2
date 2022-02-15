part of 'child_info_tab1_bloc.dart';

@immutable
abstract class ChildInfoTab1State {}

class ChildInfoTab1Initial extends ChildInfoTab1State {}

class ChildInfoTab1Loading extends ChildInfoTab1State {}

class ChildInfoTab1Loaded extends ChildInfoTab1State {
  final ChildInOutModel model;
  bool isDialog;

  ChildInfoTab1Loaded({required this.model,this.isDialog = true});
}


class ChildInfoTab1Error extends ChildInfoTab1State {
  final String error;

  ChildInfoTab1Error({required this.error});
}

class BottomLoading extends ChildInfoTab1State {
  final ChildInOutModel model;

  BottomLoading({required this.model});
}

class ChildInfoTab1NoInfo extends ChildInfoTab1State {
  final String txt;

  ChildInfoTab1NoInfo({required this.txt});
}
