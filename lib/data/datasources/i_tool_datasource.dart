import '../models/tool_model.dart';

abstract class IToolDataSource {
  Future<void> addTool(ToolModel toolModel);
  Future<void> updateTool(ToolModel toolModel);
  Future<void> deleteTool(String id);
  Future<ToolModel?> getToolById(String id);
  Future<ToolModel?> getToolByName(String name);
  Future<List<ToolModel>> getAllTools();
  Future<List<ToolModel>> getToolsByGiver(String giver);
  Future<List<ToolModel>> getToolsByHolder(String holder);
  Future<List<ToolModel>> getToolsByReceiver(String receiver);
  Future<List<ToolModel>> getToolsInStockByUser(String username);
  Future<List<ToolModel>> getPendingTools();
  Future<List<ToolModel>> searchToolsByName(String name);
  Future<int> countToolsInStockByUser(String username);
  Future<int> countTransferredToolsByUser(String username);
  Future<int> countReceivedToolsByUser(String username);
  Future<int> countPendingTools();
}
