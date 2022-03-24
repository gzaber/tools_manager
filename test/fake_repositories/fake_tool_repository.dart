import 'package:tools_manager/domain/entities/tool.dart';
import 'package:tools_manager/domain/repositories/i_tool_repository.dart';

class FakeToolRepository implements IToolRepository {
  List<Tool> tools = [
    Tool(id: '11', name: 'name1', date: '2022', giver: null, holder: 'user1', receiver: null),
    Tool(id: '22', name: 'name2', date: '2022', giver: null, holder: 'user1', receiver: 'user2'),
    Tool(id: '33', name: 'name3', date: '2022', giver: null, holder: 'user2', receiver: 'user1'),
    Tool(id: '44', name: 'name4', date: '2022', giver: null, holder: 'user2', receiver: null),
  ];
  //================================================================================================
  @override
  Future<void> add(Tool tool) async {
    if (tool.name == 'exception') throw Exception('exception');

    tools.add(tool);
  }

  //================================================================================================
  @override
  Future<void> update(Tool tool) async {
    int.parse(tool.id!);
  }

  //================================================================================================
  @override
  Future<void> delete(String id) async {
    int.parse(id);
  }

  //================================================================================================
  @override
  Future<List<Tool>> getAll() async {
    if (tools.isEmpty) {
      return [];
    } else {
      return tools;
    }
  }

  //================================================================================================
  @override
  Future<Tool?> getById(String id) async {
    int.parse(id);

    var result = tools.where((tool) => tool.id == id).toList();

    if (result.isEmpty) {
      return null;
    } else {
      return result.first;
    }
  }

  //================================================================================================
  @override
  Future<Tool?> getByName(String name) async {
    if (name == 'exception') throw Exception('exception');

    var result = tools.where((tool) => tool.name == name).toList();

    if (result.isEmpty) {
      return null;
    } else {
      return result.first;
    }
  }

  //================================================================================================
  @override
  Future<List<Tool>> getByGiver(String giver) async {
    if (giver == 'exception') throw Exception('exception');

    var result = tools.where((tool) => tool.giver == giver).toList();

    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }

  //================================================================================================
  @override
  Future<List<Tool>> getByHolder(String holder) async {
    if (holder == 'exception') throw Exception('exception');

    var result = tools.where((tool) => tool.holder == holder).toList();

    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }

  //================================================================================================
  @override
  Future<List<Tool>> getByReceiver(String receiver) async {
    if (receiver == 'exception') throw Exception('exception');

    var result = tools.where((tool) => tool.receiver == receiver).toList();

    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }

  //================================================================================================
  @override
  Future<List<Tool>> searchByName(String name) async {
    if (name == 'exception') throw Exception('exception');

    var result = tools.where((tool) => tool.name.contains(name)).toList();

    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }

  //================================================================================================
  @override
  Future<int> countInStockByUser(String username) async {
    if (username == 'exception') throw Exception('exception');

    var result = tools.where((tool) => (tool.holder == username && tool.receiver == null)).toList();

    if (result.isEmpty) {
      return 0;
    } else {
      return result.length;
    }
  }

  //================================================================================================
  @override
  Future<int> countTransferredByUser(String username) async {
    if (username == 'exception') throw Exception('exception');

    var result = tools.where((tool) => (tool.holder == username && tool.receiver != null)).toList();

    if (result.isEmpty) {
      return 0;
    } else {
      return result.length;
    }
  }

  //================================================================================================
  @override
  Future<int> countReceivedByUser(String username) async {
    if (username == 'exception') throw Exception('exception');

    var result = tools.where((tool) => tool.receiver == username).toList();

    if (result.isEmpty) {
      return 0;
    } else {
      return result.length;
    }
  }

  //================================================================================================
  @override
  Future<List<Tool>> getInStockByUser(String username) async {
    if (username == 'exception') throw Exception('exception');
    var result = tools.where((tool) => tool.holder == username && tool.receiver == null).toList();

    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }

  //================================================================================================
  @override
  Future<List<Tool>> getPending() async {
    var result = tools.where((tool) => tool.receiver != null).toList();

    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }

  //================================================================================================
  @override
  Future<int> countPending() async {
    var result = tools.where((tool) => tool.receiver != null).toList();

    if (result.isEmpty) {
      return 0;
    } else {
      return result.length;
    }
  }

  //================================================================================================

}
