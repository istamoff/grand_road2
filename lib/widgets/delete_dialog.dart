
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/bloc/parents_main_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/styles.dart';
import 'package:unikids_uz/utils/words.dart';

class DialogUtils{

  static void onDeleteDialog(BuildContext context, ParentsMainBloc bloc, int rId, int id) {
  //  ParentsMainBloc bloc = BlocProvider.of<ParentsMainBloc>(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            height: 120,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(MyWords.delete.tr(), style: MyStyles.txtBlackBold),
                SizedBox(height: 8),
                Text(MyWords.delete_wanna.tr()),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text(MyWords.cancel.tr(), style: TextStyle(color: MyColors.baseOrangeColor),)),
                    SizedBox(width: 16),
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          bloc.add(Delete(id: rId, childId: id));
                          bloc.add(HistoryEvent(isConnect: true, id: id));
                        },
                        child: Text(MyWords.delete_btn.tr(), style: TextStyle(color: MyColors.baseOrangeColor),))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

}