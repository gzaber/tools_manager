import '../entities/tool.dart';

abstract class IToolRepository {
  Future<void> add(Tool tool);
  Future<void> update(Tool tool);
  Future<void> delete(String id);
  Future<Tool?> getById(String id);
  Future<Tool?> getByName(String name);
  Future<List<Tool>> getAll();
  Future<List<Tool>> getByGiver(String giver);
  Future<List<Tool>> getByHolder(String holder);
  Future<List<Tool>> getByReceiver(String receiver);
  Future<List<Tool>> getInStockByUser(String username);
  Future<List<Tool>> getPending();
  Future<List<Tool>> searchByName(String name);
  Future<int> countInStockByUser(String username);
  Future<int> countTransferredByUser(String username);
  Future<int> countReceivedByUser(String username);
  Future<int> countPending();
}
