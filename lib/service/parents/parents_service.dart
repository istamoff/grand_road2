import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:unikids_uz/model/local_child_add_,model.dart';
import 'package:unikids_uz/model/parents/document_type_model.dart';
import 'package:unikids_uz/model/parents/human_model.dart';
import 'package:unikids_uz/model/parents/local_parent_add_model.dart';
import 'package:unikids_uz/model/parents/parents_model.dart';
import 'package:unikids_uz/model/parents/relative_type_model.dart';
import 'package:unikids_uz/utils/constants.dart';

class ParentsService {
  Dio dio = Dio(

  );
  static const TIMEOUT = 10000;


  Future<ParentsModel> getParentsModel(
      int id, String token) async {
    print("ID child" + id.toString());
    Response? response;
    response = await dio.get(MyContants.BASE_URL + "/api/v1/children/human/${id}/new_list/",
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
      return ParentsModel.fromJson(response.data);
    throw response;
  }

  Future<ParentsModel> getParentsNextModel(
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
      return ParentsModel.fromJson(response.data);
    throw response;
  }


  Future<int> deleteParents(
      String token, int id) async {
    Response? response;

    response = await dio.delete(
      MyContants.BASE_URL + "/api/v1/children/human/${id}/",
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
    print(response.statusCode.toString());
    print(response.data.toString());
    if(response.statusCode == 204)
      return 204;
    throw response;
  }

  Future<ChildGroupModel> getRelativeParents(
      String token) async {
    Response? response;

    response = await dio.get(
      MyContants.BASE_URL + "/api/v1/children/relativity-type/short_list/",
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
    print(response.statusCode.toString());
    print(response.data.toString());
    if(response.statusCode == 200)
      return ChildGroupModel.fromJson(response.data);
    throw response;
  }



  Future<bool> postAddParents(LocalParentAddModel model, String token, String filePath, String fileName) async {
    Response response;
    String url;
    url = MyContants.BASE_URL + "/api/v1/children/human/";
    List<String> numbers = [];
    String number = model.number.text.replaceAll("-", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll(" ", "");
    numbers.add(number);
    for(int i = 0; i < model.contacts.length; i++){
       String number = model.contacts[i].text.replaceAll("-", "")
           .replaceAll("(", "")
           .replaceAll(")", "")
           .replaceAll(" ", "");
       numbers.add(number);

    }
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(filePath, filename: fileName),
      "first_name": model.first_name,
      "last_name": model.last_name,
      "middle_name": model.middle_name,
      "contacts": numbers,
      "child": model.child,
      "relativity_type": model.relativity_type
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
    print("CODES: " + response.statusCode.toString());
    print("Data: " + response.data.toString());
    if (response.statusCode == 201)
      return true;
    throw response;
  }


  Future<HumansModel> getHumansModel(
      int id, String token) async {
    Response? response;
    response = await dio.get(MyContants.BASE_URL + "/api/v1/children/human/${id}/",
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
      return HumansModel.fromJson(response.data);
    throw response;
  }


  Future<bool> patchHumansModel(
      int id, String token, LocalParentAddModel model, String filePath, String fileName) async {
    Response response;
    String url;
    url = MyContants.BASE_URL + "/api/v1/children/human/${id}/";
    List<String> numbers = [];
    for(int i = 0; i < model.contacts.length; i++){
      String number = model.contacts[i].text.replaceAll("-", "")
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll(" ", "");
      numbers.add(number);
    }
    FormData formData = FormData.fromMap({
      if(fileName != "")
      "photo": await MultipartFile.fromFile(filePath, filename: fileName),
      "first_name": model.first_name,
      "last_name": model.last_name,
      "middle_name": model.middle_name,
      "contacts": numbers,
      "relativity_type": model.relativity_type
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

  Future<DocumentTypeModel> getDocumentType(String token) async {
    Response? response;
    response = await dio.get(MyContants.BASE_URL + "/api/v1/files/required-files/",
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
      return DocumentTypeModel.fromJson(response.data);
    throw response;
  }


  Future<bool> postDocumenty(String token,  String filePath, String fileName, int object_id, int rFile) async {
    Response response;
    String url;
    // url = MyContants.BASE_URL + "/api/v1/files/attachments/";
    url = MyContants.BASE_URL + "/api/v1/files/attachments-create/";
   print(fileName + " " + object_id.toString() + " " + rFile.toString());
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: fileName),
      "title": fileName,
      "object_id": object_id,
      // "content_type": 12,
      "content_type": "children_child",
      "required_file": rFile
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
    print("CODES: " + response.statusCode.toString());
    print("Data: " + response.data.toString());
    if (response.statusCode == 201)
      return true;
    throw response;
  }


}