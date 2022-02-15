import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:unikids_uz/model/child/child_documents_model.dart';
import 'package:unikids_uz/model/child/child_in_out_model.dart';
import 'package:unikids_uz/model/child/child_parents_model.dart';
import 'package:unikids_uz/model/child/error_image_valid_model.dart';
import 'package:unikids_uz/model/child_info_model.dart';
import 'package:unikids_uz/model/hive/role_data/role_data_model.dart';
import 'package:unikids_uz/model/local_child_add_,model.dart';
import 'package:unikids_uz/model/login_model.dart';
import 'package:unikids_uz/model/nurse_model.dart';
import 'package:unikids_uz/model/picture_error_model.dart';
import 'package:unikids_uz/model/response_model.dart';
import 'package:unikids_uz/model/status_model.dart';
import 'package:unikids_uz/model/teacher_go_out_model.dart';
import 'package:unikids_uz/model/teacher_receiver_model.dart';
import 'package:unikids_uz/model/update_pupil/all_pupil_model.dart';
import 'package:unikids_uz/model/update_pupil/child_class_model.dart';
import 'package:unikids_uz/model/update_pupil/child_group_short_list_model.dart';
import 'package:unikids_uz/model/url_model.dart';
import 'package:unikids_uz/utils/constants.dart';
 const BASE_URL = 'https://zk.unikids.uz:8443';
class MyService {
  Dio dio = Dio(

  );
  static const TIMEOUT = 10000;



  Future<InfoModel> getInfoModel(
      String fileName, String filePath, String token) async {
    Response? response;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: fileName),
    });

    InfoModel model = InfoModel.empty();
    response = await dio.post(BASE_URL + "/api/v1/children/face_recognition_list/",
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
          receiveTimeout: TIMEOUT,
          sendTimeout: TIMEOUT,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          receiveDataWhenStatusError: true,
        ),
        data: formData);
    print("CODE " + response.statusCode.toString());
    print("CODE " + response.data.toString());
    if(response.statusCode == 200) {
      model = InfoModel.fromJson(response.data);
      return model;
    }
    throw response;
  }

  Future<RoleDataModel> loginFunc(String userName, String password) async {
    var params = {"username": "nurse", "password": "Qwerty159"};
 //   print("URL: " + BASE_URL + "/api/v1/users/login");
    Response response = await dio
        .post("https://zk.unikids.uz:8443" + "/api/v1/users/login",
        options: Options(
          receiveTimeout: TIMEOUT,
          sendTimeout: TIMEOUT,
          followRedirects: false,
          receiveDataWhenStatusError: true,
          // validateStatus: (status) {
          //   return status! < 500;
          // },
        ),
        data: jsonEncode(params))
        .timeout(Duration(seconds: TIMEOUT));
    dio.options.connectTimeout = 10000;
    if (response.statusCode == 200) {
      print("200--");
      LoginModel model = LoginModel.fromJson(response.data);
      var box = Hive.box('db');
      RoleDataModel _roleDataModel = RoleDataModel(id: model.userData.id, firstName:  model.userData.firstName, lastName: model.userData.lastName, fullName: model.userData.fullName, userName: model.userData.username, language: model.userData.language, roleRu: model.userData.fullRoleName.ru, roleUz: model.userData.fullRoleName.uz);
      String _permission = model.userData.permission[0];
      List<String> _role = model.userData.role;
      box.put('token', model.access);
      box.put('refresh', model.refresh);
      box.put("role", _role);
      box.put("permission", _permission);
      box.put("base_url", BASE_URL);
      box.add(_roleDataModel);
      return _roleDataModel;
    }
    throw response;
  }

  Future<MedicStatusModel> statusFunc(String token) async {
    Response response = await dio
        .get(BASE_URL + "/api/v1/children/medic-status/",
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
          receiveTimeout: TIMEOUT,
          sendTimeout: TIMEOUT,
          followRedirects: false,
          receiveDataWhenStatusError: true,
        ))
        .timeout(Duration(seconds: TIMEOUT));
    print("statusFunc ");
    if (response.statusCode == 200) {
      return MedicStatusModel.fromJson(response.data);
    }
    throw response;
  }

  Future<bool> createChildJournal(
      int child, double temperatura, int status, int come_in_person) async {
    var box = Hive.box('db');
    String token = box.get('token');

    var params = {
      "child": child,
      "temperature": temperatura,
      "status": status,
      "come_in_person": come_in_person
    };

    Response response = await dio
        .post(BASE_URL + "/api/v1/children/child-journal/",
        data: jsonEncode(params),
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
          receiveTimeout: TIMEOUT,
          sendTimeout: TIMEOUT,
          followRedirects: false,
          receiveDataWhenStatusError: true,
          validateStatus: (status) {
            return status! < 500;
          },
        ))
        .timeout(Duration(seconds: TIMEOUT));
    if (response.statusCode == 201) {
      return true;
    }
    if (response.statusCode == 400) return false;
    throw response;
  }

  Future<NurseModel> getHistoryNurseModel(String token) async {
    Response? response;

    NurseModel model;
    response = await dio.get(
      BASE_URL + "/api/v1/children/child-journal/dynamic_list/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print("CODE nursse : " + response.statusCode.toString());
    print("CODE nursxe : " + response.data.toString());
    model = NurseModel.fromJson(response.data);
    return model;
  }

  Future<NurseModel> getHistoryNurseNextModel(String token, String next) async {
    Response? response;

    NurseModel model;
    response = await dio.get(
      next,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    model = NurseModel.fromJson(response.data);
    return model;
  }

  Future<TeacherGoOutModel> getHistoryGoOutModel(String token) async {
    Response? response;
    late TeacherGoOutModel model;
    response = await dio.get(
      BASE_URL + "/api/v1/children/child-journal/dynamic_list/?page=1",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    model = TeacherGoOutModel.fromJson(response.data);
    return model;
  }

  Future<TeacherGoOutModel> getHistoryTeacherGoOutNextModel(
      String token, String next) async {
    Response? response;

    TeacherGoOutModel model;
    response = await dio.get(
      next,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    model = TeacherGoOutModel.fromJson(response.data);
    print("NNNNNNNNNNNNNNNNNext  " + model.results[0].child.firstName);
    return model;
  }

  Future<TeacherReceiverModel> getHistoryTeacherReceiverModel(
      String token) async {
    Response? response;

    TeacherReceiverModel model;
    response = await dio.get(
      BASE_URL +
          "/api/v1/children/child-journal/dynamic_list/?journal_type=receive",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print(response.data.toString());
    model = TeacherReceiverModel.fromJson(response.data);
    return model;
  }

  Future<TeacherReceiverModel> getHistoryTeacherReceiverNextModel(
      String token, String next) async {
    Response? response;

    TeacherReceiverModel model;
    response = await dio.get(
      next,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print(response.data.toString());
    model = TeacherReceiverModel.fromJson(response.data);
    print("NNNNNNNNNNNNNNNNNext  " + model.results[0].child.firstName);
    return model;
  }

  Future<int> postTeacherComeIn(
      String filePath, String fileName, String token) async {
    Response response;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: fileName),
    });
    response = await dio.post(
      BASE_URL + "/api/v1/children/face_recognition_receive/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: formData,
    );
    print("CODE: " + response.statusCode.toString());
    print("CODE: " + response.data.toString());
    return response.statusCode!;
  }

  Future<bool> postTeacherGoOut(int id, int come_in_person) async {
    var box = Hive.box('db');
    String token = box.get('token');
    print("token " + token);
    print("id: " + id.toString());
    print("come_in_person: " + come_in_person.toString());
    Response response;
    var params = {"go_out_person": come_in_person, "child": id};
    response = await dio.post(
      BASE_URL + "/api/v1/children/child_go_out/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: jsonEncode(params),
    );
    print("CODE GoOut : " + response.statusCode.toString());
    print("CODE GoOut : " + response.data.toString());
    if (response.statusCode == 200) return true;
    else if(response.statusCode == 400)
      return false;
    throw response;
  }

  Future<ChildClassModel> getChildClass(String token) async {
    Response response;
    response = await dio.get(
      BASE_URL + "/api/v1/children/class/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print("ChildClassModel: " + response.data.toString());
    if (response.statusCode == 200)
      return ChildClassModel.fromJson(response.data);
    throw response;
  }

  Future<ChildGroupModel> getChildGroup(String token, int id) async {
    String idx = id.toString();
    Response response;
    response = await dio.get(
      BASE_URL + (id == 0 ? "/api/v1/children/groups/reference/" :  "/api/v1/children/groups/reference/?class_name=$idx"),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print("ChildGroup: " + response.data.toString());
    if (response.statusCode == 200)
      return ChildGroupModel.fromJson(response.data);
    throw response;
  }

  Future<PictureErrorModel> patchPupilUpdate(
      String token, String filePath, String fileName, int id) async {
    Response response;
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(filePath, filename: fileName),
    });
    response = await dio.patch(
      BASE_URL + "/api/v1/children/child/${id}/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: formData,
    );
    if (response.statusCode == 200) return PictureErrorModel.empty();
    if (response.statusCode == 400)
      return PictureErrorModel.fromJson(response.data);
    throw response;
  }

  Future<AllPupilModel> getAllPupil(
      String token, int childClass, int childGroup) async {
    print("getAllPupil");
    String _class_url = "";
    Response response;
    String url;
    url = BASE_URL + "/api/v1/children/child/";
    String _group_Url =  childGroup != 0 ? "?child_groups=${childGroup}" : "";
    if(_group_Url == "")
      _class_url =  childClass != 0 ? "?child_class=$childClass" : "";
    else
      _class_url =  childClass != 0 ? "&child_class=$childClass" : "";
    print(_group_Url + " " + _class_url);
    response = await dio.get(
      url + _group_Url + _class_url,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        receiveDataWhenStatusError: true,
        sendTimeout: TIMEOUT,
        validateStatus: (status) {
          return status! < 500;
        },

      ),
    );
    print("CODE: " + response.statusCode.toString());
    // if (response.statusCode == 200)
    return AllPupilModel.fromJson(response.data);
    //  throw response;
  }

  Future<AllPupilModel> getNextAllPupil(
      String token, String url) async {
    Response response;
    final _baseOption = BaseOptions(

    );

    response = await dio.get(
      url,
      options:
      Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print("CODE: " + response.statusCode.toString());
    if (response.statusCode == 200)
      return AllPupilModel.fromJson(response.data);
    // if(response.statusCode == 404)
    // throw response;
    throw response;
  }




  Future<int> patchLang(
      String token, String lang, int id) async {
    Response response;
    print("token: " + token + "\n" + "lang " + lang + " id " + id.toString());
    var a = {"language": lang};
    String url;
    url = BASE_URL + "/api/v1/users/update-profile/${id}/";
    response = await dio.patch(
      url,
      options:
      Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: FormData.fromMap(a),
    );
    print("CODES: " + response.statusCode.toString());
    if (response.statusCode == 200)
      return 200;
    throw response;
  }

  Future<UrlModel> getUrl() async {
    Response response;
    String url;
    url = "http://zk.leocrm.uz:82/api/v2/project/cloud_app/?product=KINDERGARTEN";
    response = await dio.get(
      url,
      options:
      Options(
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print("CODES: " + response.statusCode.toString());
    print("CODES: " + response.data.toString());
    if (response.statusCode == 200)
    return UrlModel.fromJson(response.data);
    throw response;
  }


  Future<ErrorImageValidModel> postAddChild(LocalChildAddModel model, String token, String filePath, String fileName) async {
    Response response;
    String url;
    url = BASE_URL + "/api/v1/children/child/";
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(filePath, filename: fileName),
      "first_name": model.first_name,
      "last_name": model.last_name,
      "middle_name": model.middle_name,
      "child_group": model.child_group,
      "address": model.address,
      "birth_date": model.birth_date,
      "joined_date": model.joined_date,
      "gender_type": model.gender_type,
      "is_active": model.is_active
    });
    response = await dio.post(
      url,
      options:
      Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: formData,
    );
   if (response.statusCode == 201)
     return ErrorImageValidModel.empty();
   if(response.statusCode == 400)
     return ErrorImageValidModel.fromJson(response.data);
    throw response;
  }



  Future<bool> patchChild(LocalChildAddModel model, String token, String filePath, String fileName, int childId) async {
    Response response;
    String url;
    FormData formData;
    url = BASE_URL + "/api/v1/children/child/${childId}/";
    if(fileName == "" && filePath == "")
     formData = FormData.fromMap({
        "first_name": model.first_name,
        "last_name": model.last_name,
        "middle_name": model.middle_name,
        "child_group": model.child_group,
        "address": model.address,
        "birth_date": model.birth_date,
        "joined_date": model.joined_date,
        "gender_type": model.gender_type,
        "is_active": model.is_active
      });
    else
    formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(filePath, filename: fileName),
      "first_name": model.first_name,
      "last_name": model.last_name,
      "middle_name": model.middle_name,
      "child_group": model.child_group,
      "address": model.address,
      "birth_date": model.birth_date,
      "joined_date": model.joined_date,
      "gender_type": model.gender_type,
      "is_active": model.is_active
    });
    response = await dio.patch(
      url,
      options:
      Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: formData,
    );
    print("CODES: " + response.statusCode.toString());
    print("Data: " + response.data.toString());
    if (response.statusCode == 200)
      return true;
    throw response;
  }


  Future<ChildInfoModel> getChildInfo(String token, int id) async {
    Response response;
    response = await dio.get(
      BASE_URL + "/api/v1/children/child/${id}/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print("GetChildInfo: " + response.data.toString());
    if (response.statusCode == 200)
      return ChildInfoModel.fromJson(response.data);
    throw response;
  }


  Future<ChildInOutModel> getChildInOutModel(
      int id, String token) async {
    Response? response;
    response = await dio.get(BASE_URL + "/api/v1/children/child/${id}/journal/",
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
          receiveTimeout: TIMEOUT,
          sendTimeout: TIMEOUT,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          receiveDataWhenStatusError: true,
        ),
    );
    print(response.data.toString());
    if(response.statusCode == 200)
    return ChildInOutModel.fromJson(response.data);
    throw response;
  }

  Future<ChildInOutModel> getChildInOutNextModel(
      String token, String next) async {
    Response? response;

    response = await dio.get(
      next,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print(response.data.toString());
    if(response.statusCode == 200)
    return ChildInOutModel.fromJson(response.data);
    throw response;
  }

  Future<ChildParentsModel> getChildParentsModel(
      int id, String token) async {
    Response? response;
    response = await dio.get(BASE_URL + "/api/v1/children/human/${id}/new_list/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        receiveDataWhenStatusError: true,
      ),
    );
    if(response.statusCode == 200)
      return ChildParentsModel.fromJson(response.data);
    throw response;
  }

  Future<ChildDocumentModel> getChildDocumentModel(
      int id, String token) async {
    Response? response;
    response = await dio.get(BASE_URL + "/api/v1/children/child/${id}/files/",
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
        receiveTimeout: TIMEOUT,
        sendTimeout: TIMEOUT,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        receiveDataWhenStatusError: true,
      ),
    );
    if(response.statusCode == 200)
      return ChildDocumentModel.fromJson(response.data);
    throw response;
  }
}


