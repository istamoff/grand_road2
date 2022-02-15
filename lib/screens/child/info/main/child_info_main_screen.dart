import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unikids_uz/model/child_info_model.dart';
import 'package:unikids_uz/screens/child/info/main/bloc/child_main_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'tabs/tab1/child_out_in_screen.dart';
import 'tabs/tab2/parents_main_screen.dart';
import 'tabs/tab3/child_document_screen.dart';


class ChildMainInfo extends StatefulWidget {
  final int id;

  static Widget screen(id) =>
      BlocProvider(
        create: (context) => ChildMainBloc(),
        child: ChildMainInfo(id: id),
      );

  ChildMainInfo({required this.id});

  @override
  _ChildMainInfoState createState() => _ChildMainInfoState();
}

class _ChildMainInfoState extends State<ChildMainInfo>
    with TickerProviderStateMixin{
  late ChildMainBloc bloc;
  late double wSize;
  late TabController _tabController;


  @override
  void initState() {
    bloc = BlocProvider.of<ChildMainBloc>(context);
    bloc.add(Load(id: widget.id));
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
   _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wSize = MediaQuery.of(context).size.width / 3 * 2 - 90;
    print("ID: " + widget.id.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }, color: Colors.white),
        backgroundColor: MyColors.baseOrangeColor,
        title: Text(MyWords.info.tr(), style: TextStyle(color: Colors.white),),
      ),
      body: BlocConsumer<ChildMainBloc, ChildMainState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          if(state is LoadedChildInfo) {
            return Container(
              padding: EdgeInsets.all(8),
            child: Column(
              children: [
                _childPersonalInfo(state.childInfoModel),
                TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.red,
                  tabs: [
                    Tab(
                      text: MyWords.journal.tr(),
                    ),
                    Tab(
                      text: MyWords.parents.tr(),
                    ),
                    Tab(
                      text: MyWords.documentation.tr(),
                    )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ChildInfoTab1.screen(widget.id),
                      ParentsMainScreen.screen(widget.id),
                      ChildDocumentScreen.screen(widget.id)
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          );
          }
          return Container(
           child: Center(
                  child:
                  CircularProgressIndicator(color: MyColors.baseOrangeColor))
          );
        },
      ),

    );
  }

  SizedBox _childPersonalInfo(ChildInfoModel model) {
    return SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: CachedNetworkImage(
                      imageUrl: model.photo,
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  8),
                              border: Border.all(
                                  color: MyColors.baseOrangeColor,
                                  width: 2),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                          Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    )
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 16, top: 8),
                            width: wSize,
                            child: Column(
                              children: [
                                AutoSizeText(
                                    model.firstName + " " + model.lastName + " " +  model.middleName,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black)),
                                Spacer(),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 8, left: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(MyWords.gender.tr(), style: TextStyle(
                                    color: Colors.grey, fontSize: 18),),
                                Text(model.genderType == "male" ? MyWords.child_male.tr() : MyWords.child_female.tr()),
                              ],
                            ),
                          ),
                        ],
                      ),

                    )
                  ],
                ),
              );
  }
}
