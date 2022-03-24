import '../../domain/entities/tool.dart';
import '../../domain/repositories/i_tool_repository.dart';
import '../datasources/i_tool_datasource.dart';
import '../models/tool_model.dart';

class ToolRepository implements IToolRepository {
  final IToolDataSource _toolDataSource;

  ToolRepository(this._toolDataSource);
  //================================================================================================
  @override
  Future<void> add(Tool tool) async {
    ToolModel toolModel = ToolModel(
      name: tool.name,
      date: tool.date,
      holder: tool.holder,
    );
    return await _toolDataSource.addTool(toolModel);
  }

  //================================================================================================
  @override
  Future<void> update(Tool tool) async {
    ToolModel toolModel = ToolModel(
      id: tool.id,
      name: tool.name,
      date: tool.date,
      giver: tool.giver,
      holder: tool.holder,
      receiver: tool.receiver,
    );
    return await _toolDataSource.updateTool(toolModel);
  }

  //================================================================================================
  @override
  Future<void> delete(String id) async {
    return await _toolDataSource.deleteTool(id);
  }

  //================================================================================================
  @override
  Future<Tool?> getById(String id) async {
    return await _toolDataSource.getToolById(id);
  }

  //================================================================================================
  @override
  Future<Tool?> getByName(String name) async {
    return await _toolDataSource.getToolByName(name);
  }

  //================================================================================================
  @override
  Future<List<Tool>> getAll() async {
    return await _toolDataSource.getAllTools();
  }

//================================================================================================
  @override
  Future<List<Tool>> getByGiver(String giver) async {
    return await _toolDataSource.getToolsByGiver(giver);
  }

  //================================================================================================
  @override
  Future<List<Tool>> getByHolder(String holder) async {
    return await _toolDataSource.getToolsByHolder(holder);
  }

  //================================================================================================
  @override
  Future<List<Tool>> getByReceiver(String receiver) async {
    return await _toolDataSource.getToolsByReceiver(receiver);
  }

  //================================================================================================

  @override
  Future<List<Tool>> getInStockByUser(String username) async {
    return await _toolDataSource.getToolsInStockByUser(username);
  }

  //================================================================================================
  @override
  Future<List<Tool>> getPending() async {
    return await _toolDataSource.getPendingTools();
  }

  //================================================================================================
  @override
  Future<List<Tool>> searchByName(String name) async {
    return await _toolDataSource.searchToolsByName(name);
  }

  //================================================================================================

  @override
  Future<int> countInStockByUser(String username) async {
    return await _toolDataSource.countToolsInStockByUser(username);
  }

  //================================================================================================
  @override
  Future<int> countTransferredByUser(String username) async {
    return await _toolDataSource.countTransferredToolsByUser(username);
  }

  //================================================================================================
  @override
  Future<int> countReceivedByUser(String username) async {
    return await _toolDataSource.countReceivedToolsByUser(username);
  }

  //================================================================================================
  @override
  Future<int> countPending() async {
    return await _toolDataSource.countPendingTools();
  }

  //================================================================================================

}
