import 'dart:convert' as cnv;
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  List<DoiTuong> doituongs = [];
  Future<List<DoiTuong>> getUserData() async {
    final response = await http.post(
        Uri.parse(
            "http://sangtaoketnoi.vn/hungthinh/api/DanhMucDoiTuong/List/"),
        body: {"IDDanhMucLoaiDoiTuong": "001.003"});
    if (response.statusCode == 200) {
      final  jsonData = cnv.jsonDecode(response.body);
     
    print(jsonData['Data']);
      return jsonData['Data'].map((e) => DoiTuong.fromJson(e)).toList();
      
          
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("User Data")),
      ),
      body: Center(
        // child: ElevatedButton(
        //   child: Text("Click me"),
        //   onPressed: getUserData,
        // ),
        child: FutureBuilder<List<DoiTuong>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                //shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].Ten.toString()),
                    subtitle: Text(snapshot.data![index].Ma.toString()),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class DoiTuong {
  String? Ten;
  String? Ma;

  DoiTuong({
    this.Ten,
    this.Ma,
  });

  DoiTuong.fromJson(Map<String, dynamic> json) {
    Ten = json['Ten'];
    Ma = json['Ma'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Ten'] = Ten;
    data['Ma'] = Ma;

    return data;
  }
}
