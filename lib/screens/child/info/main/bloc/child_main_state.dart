part of 'child_main_bloc.dart';

@immutable
abstract class ChildMainState {}

class ChildMainInitial extends ChildMainState {}

class Loading extends ChildMainState {}

class LoadedChildInfo extends ChildMainState {
   final ChildInfoModel childInfoModel;

   LoadedChildInfo({required this.childInfoModel});
}


class LoadedTabLoadedInfo extends ChildMainState {
   final ChildInfoModel childInfoModel;
   final ChildInOutModel childInOutModel;
   final ChildDocumentModel childDocumentModel;
   final ChildParentsModel childParentsModel;

   LoadedTabLoadedInfo({required this.childInfoModel, required this.childInOutModel, required this.childParentsModel, required this.childDocumentModel});
}




class Error extends ChildMainState {
   final String error;

   Error({required this.error});
}

