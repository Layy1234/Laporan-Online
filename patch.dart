import "dart:io";

void main() {
  var f = File("C:/Users/EGANTENG/AndroidStudioProjects/tva/lib/main.dart");
  var content = f.readAsStringSync();
  
  var syncCode = """
  bool _isSyncing = false;
  Future<void> _syncFromServer() async {
    setState(() => _isSyncing = true);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData["status"] == "success") {
          final List storesData = resData["data"];
          final db = await DatabaseHelper.instance.database;
          await db.delete("stores");
          for (var store in storesData) {
            String imagePathsStr = "";
            if (store["imagePaths"] != null) {
              if (store["imagePaths"] is List) {
                imagePathsStr = jsonEncode(store["imagePaths"]);
              } else {
                imagePathsStr = store["imagePaths"].toString();
              }
            }
            Map<String, dynamic> localStore = {
              "id": int.tryParse(store["id"].toString()) ?? 0,
              "storeName": store["storeName"] ?? "",
              "ownerName": store["ownerName"] ?? "",
              "picName": store["picName"] ?? "",
              "address": store["address"] ?? "",
              "volx": store["volx"] ?? "",
              "takis": store["takis"] ?? "",
              "tribe": store["tribe"] ?? "",
              "pod_volx": store["pod_volx"] ?? "",
              "pod_takis": store["pod_takis"] ?? "",
              "pod_tribe": store["pod_tribe"] ?? "",
              "ct": store["ct"] ?? "",
              "inside": store["inside"] ?? "",
              "reporterName": store["reporterName"] ?? "",
              "imagePaths": imagePathsStr,
              "createdAt": store["createdAt"] ?? "",
            };
            await DatabaseHelper.instance.insertStore(localStore);
          }
        }
      }
    } catch (e) {
      print("Sync error: " + e.toString());
    }
    setState(() => _isSyncing = false);
    _refreshStores();
  }
""";
  content = content.replaceFirst("List<Map<String, dynamic>> _stores = [];", "List<Map<String, dynamic>> _stores = [];\n" + syncCode);
  content = content.replaceFirst("super.initState();\n    _refreshStores();", "super.initState();\n    _syncFromServer();");
  
  var oldImg = """if (store['imagePaths'] != null && store['imagePaths'].toString().isNotEmpty)
                          ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(List<String>.from(jsonDecode(store['imagePaths'])).first), width: 50, height: 50, fit: BoxFit.cover))
                        else""";
  var newImg = """if (store['imagePaths'] != null && store['imagePaths'].toString().isNotEmpty)
                          ClipRRect(borderRadius: BorderRadius.circular(8), child: Builder(builder: (context) {
                            final path = List<String>.from(jsonDecode(store['imagePaths'])).first;
                            return path.startsWith('http') ? Image.network(path, width: 50, height: 50, fit: BoxFit.cover) : Image.file(File(path), width: 50, height: 50, fit: BoxFit.cover);
                          }))
                        else""";
  content = content.replaceFirst(oldImg, newImg);
  
  // Update processSave
  var oldSave = """      final data = await _getFormDataAsync();
      if (widget.storeData != null) {
        data['id'] = widget.storeData!['id'];
        await DatabaseHelper.instance.updateStore(data);
      } else {
        await DatabaseHelper.instance.insertStore(data);
      }
  
      await _uploadToServer(data);""";

  var newSave = """      final data = await _getFormDataAsync();
      if (widget.storeData != null) {
        data['id'] = widget.storeData!['id'];
      }
      
      await _uploadToServer(data);
      
      // Wait for the upload, then save locally using the ID returned
      if (widget.storeData != null) {
        await DatabaseHelper.instance.updateStore(data);
      } else {
        if (data['id'] != null) {
          await DatabaseHelper.instance.insertStore(data);
        }
      }""";
  content = content.replaceFirst(oldSave, newSave);

  var oldUploadMethod = """      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success') {
          print('Berhasil upload');
        }
      }""";
  
  var newUploadMethod = """      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success') {
          if (resData['id'] != null) {
            data['id'] = int.tryParse(resData['id'].toString());
          }
          if (resData['images'] != null) {
            data['imagePaths'] = jsonEncode(resData['images']);
          }
          print('Berhasil upload');
        }
      }""";
  content = content.replaceFirst(oldUploadMethod, newUploadMethod);

  f.writeAsStringSync(content);
  print("Patched");
}
