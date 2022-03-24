import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/tool_model.dart';
import '../i_tool_datasource.dart';

class FirestoreToolDataSource implements IToolDataSource {
  final CollectionReference _tools;

  FirestoreToolDataSource(this._tools);

  //================================================================================================
  @override
  Future<void> addTool(ToolModel toolModel) async {
    await _tools.add(toolModel.toMap());
  }

  //================================================================================================
  @override
  Future<void> updateTool(ToolModel toolModel) async {
    return await _tools.doc(toolModel.id).update(toolModel.toMap());
  }

  //================================================================================================
  @override
  Future<void> deleteTool(String id) async {
    return await _tools.doc(id).delete();
  }

  //================================================================================================
  @override
  Future<ToolModel?> getToolById(String id) async {
    return await _tools.doc(id).get().then((snapshot) {
      if (snapshot.exists) {
        return ToolModel.fromMap(id, snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  //================================================================================================
  @override
  Future<ToolModel?> getToolByName(String name) async {
    return await _tools.where('name', isEqualTo: name).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      } else {
        return snapshot.docs
            .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList()
            .first;
      }
    });
  }

  //================================================================================================
  @override
  Future<List<ToolModel>> getAllTools() async {
    return await _tools.get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<List<ToolModel>> getToolsByGiver(String giver) async {
    return await _tools.where('giver', isEqualTo: giver).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<List<ToolModel>> getToolsByHolder(String holder) async {
    return await _tools.where('holder', isEqualTo: holder).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<List<ToolModel>> getToolsByReceiver(String receiver) async {
    return await _tools.where('receiver', isEqualTo: receiver).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<List<ToolModel>> getToolsInStockByUser(String username) async {
    return await _tools
        .where('holder', isEqualTo: username)
        .where('receiver', isNull: true)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<List<ToolModel>> getPendingTools() async {
    return await _tools.where('receiver', isNull: false).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<List<ToolModel>> searchToolsByName(String name) async {
    return await _tools
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: name + "\uf8ff")
        .get()
        .then(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          return [];
        } else {
          return snapshot.docs
              .map((qds) => ToolModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
              .toList();
        }
      },
    );
  }
  //================================================================================================

  @override
  Future<int> countToolsInStockByUser(String username) async {
    return await _tools
        .where('holder', isEqualTo: username)
        .where('receiver', isNull: true)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0;
      } else {
        return snapshot.docs.length;
      }
    });
  }

  //================================================================================================
  @override
  Future<int> countTransferredToolsByUser(String username) async {
    return await _tools
        .where('holder', isEqualTo: username)
        .where('receiver', isNull: false)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0;
      } else {
        return snapshot.docs.length;
      }
    });
  }

  //================================================================================================
  @override
  Future<int> countReceivedToolsByUser(String username) async {
    return await _tools
        .where('receiver', isEqualTo: username)
        .where('holder', isNull: false)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0;
      } else {
        return snapshot.docs.length;
      }
    });
  }

  //================================================================================================
  @override
  Future<int> countPendingTools() async {
    return await _tools.where('receiver', isNull: false).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0;
      } else {
        return snapshot.docs.length;
      }
    });
  }

  //================================================================================================
}
