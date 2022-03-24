import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/datasources/firestore/firestore_tool_datasource.dart';
import 'package:tools_manager/data/models/tool_model.dart';

void main() {
  late FirestoreToolDataSource sut;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late CollectionReference tools;

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    tools = fakeFirebaseFirestore.collection('tools');
    sut = FirestoreToolDataSource(tools);
  });

  //================================================================================================
  group('addTool', () {
    ToolModel toolModel = ToolModel(name: 'toolName', date: '2022', holder: 'user1');
    test('should add a tool when successful', () async {
      // act
      await sut.addTool(toolModel);
      // assert
      expect(await tools.get().then((snapshot) => snapshot.docs), isNotEmpty);
      expect(await tools.get().then((snapshot) => snapshot.docs.length), 1);
    });
  });
  //================================================================================================
  group('updateTool', () {
    ToolModel toolModel = ToolModel(name: 'toolName', date: '2022', holder: 'user1');
    test('should update a tool when successful', () async {
      // arrange
      var ref = await tools.add(toolModel.toMap());
      // act
      await sut.updateTool(ToolModel(
        id: ref.id,
        name: 'toolNameUpdated',
        date: toolModel.date,
        holder: toolModel.holder,
      ));
      // assert
      expect(await tools.get().then((snapshot) => snapshot.docs), isNotEmpty);
      expect(await tools.get().then((snapshot) => snapshot.docs.length), 1);
      expect(
          await tools.get().then((snapshot) => ToolModel.fromMap(
                  snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>)
              .name),
          'toolNameUpdated');
      expect(
          await tools.get().then((snapshot) => ToolModel.fromMap(
                  snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>)
              .holder),
          toolModel.holder);
    });
  });
  //================================================================================================
  group('deleteTool', () {
    ToolModel toolModel = ToolModel(name: 'toolName', date: '2022', holder: 'user1');
    test('should delete a tool when successful', () async {
      // arrange
      var ref = await tools.add(toolModel.toMap());
      // act
      await sut.deleteTool(ref.id);
      // assert
      expect(await tools.get().then((snapshot) => snapshot.docs), isEmpty);
      expect(await tools.get().then((snapshot) => snapshot.docs.length), 0);
    });
  });
  //================================================================================================

  group('getToolById', () {
    ToolModel toolModel = ToolModel(name: 'toolName', date: '2022', holder: 'user1');
    test('should return tool when successful', () async {
      // arrange
      var ref = await tools.add(toolModel.toMap());
      // act
      var result = await sut.getToolById(ref.id);
      // assert
      expect(result, isNotNull);
      expect(result!.name, 'toolName');
    });
    test('should return null when tool not found', () async {
      // act
      var result = await sut.getToolById('wrongId');
      // assert
      expect(result, isNull);
    });
  });
  //================================================================================================
  group('getToolByName', () {
    ToolModel toolModel = ToolModel(name: 'toolName', date: '2022', holder: 'user1');
    test('should return tool when successful', () async {
      // arrange
      await tools.add(toolModel.toMap());
      // act
      var result = await sut.getToolByName(toolModel.name);
      // assert
      expect(result, isNotNull);
      expect(result!.name, 'toolName');
    });
    test('should return null when tool not found', () async {
      // act
      var result = await sut.getToolByName('wrongName');
      // assert
      expect(result, isNull);
    });
  });
  //================================================================================================
  group('getAllTools', () {
    ToolModel toolModel = ToolModel(name: 'toolName', date: '2022', holder: 'user1');
    test('should return list of tools when successful', () async {
      // arrange
      await tools.add(toolModel.toMap());
      // act
      var result = await sut.getAllTools();
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 1);
    });
    test('should return empty list when no tools found', () async {
      // act
      var result = await sut.getAllTools();
      // assert
      expect(result, isEmpty);
    });
  });
  //================================================================================================

  group('getToolsByGiver', () {
    ToolModel toolModel1 =
        ToolModel(name: 'toolName1', date: '2022', giver: 'giver1', holder: 'holder1');
    ToolModel toolModel2 =
        ToolModel(name: 'toolName2', date: '2022', giver: 'giver1', holder: 'holder1');
    ToolModel toolModel3 =
        ToolModel(name: 'toolName3', date: '2022', giver: 'giver2', holder: 'holder2');
    test('should return list of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.getToolsByGiver('giver1');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 2);
    });
    test('should return empty list when no tools found', () async {
      // act
      var result = await sut.getToolsByGiver('wrongGiver');
      // assert
      expect(result, isEmpty);
    });
  });

  //================================================================================================
  group('getToolsByHolder', () {
    ToolModel toolModel1 = ToolModel(name: 'toolName1', date: '2022', holder: 'holder1');
    ToolModel toolModel2 = ToolModel(name: 'toolName2', date: '2022', holder: 'holder1');
    ToolModel toolModel3 = ToolModel(name: 'toolName3', date: '2022', holder: 'holder2');
    test('should return list of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.getToolsByHolder('holder1');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 2);
    });
    test('should return empty list when no tools found', () async {
      // act
      var result = await sut.getToolsByHolder('wrongHolder');
      // assert
      expect(result, isEmpty);
    });
  });

  //================================================================================================
  group('getToolsByReceiver', () {
    ToolModel toolModel1 =
        ToolModel(name: 'toolName1', date: '2022', holder: 'holder1', receiver: 'receiver1');
    ToolModel toolModel2 =
        ToolModel(name: 'toolName2', date: '2022', holder: 'holder2', receiver: 'receiver1');
    ToolModel toolModel3 =
        ToolModel(name: 'toolName3', date: '2022', holder: 'holder2', receiver: 'receiver2');
    test('should return list of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.getToolsByReceiver('receiver1');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 2);
    });
    test('should return empty list when no tools found', () async {
      // act
      var result = await sut.getToolsByReceiver('wrongReceiver');
      // assert
      expect(result, isEmpty);
    });
  });

  //================================================================================================
  group('getPendingTools', () {
    ToolModel toolModel1 =
        ToolModel(name: 'toolName1', date: '2022', holder: 'holder1', receiver: 'receiver1');
    ToolModel toolModel2 =
        ToolModel(name: 'toolName2', date: '2022', holder: 'holder1', receiver: 'receiver2');
    ToolModel toolModel3 = ToolModel(name: 'toolName3', date: '2022', holder: 'holder2');
    test('should return list of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.getPendingTools();
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 2);
    });
    test('should return empty list when no tools found', () async {
      // act
      var result = await sut.getPendingTools();
      // assert
      expect(result, isEmpty);
    });
  });

  //================================================================================================
  group('getToolsInStockByUser', () {
    ToolModel toolModel1 = ToolModel(name: 'toolName1', date: '2022', holder: 'user1');
    ToolModel toolModel2 = ToolModel(name: 'toolName2', date: '2022', holder: 'user1');
    ToolModel toolModel3 = ToolModel(name: 'toolName3', date: '2022', holder: 'user2');
    test('should return list of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.getToolsInStockByUser('user1');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 2);
    });
    test('should return empty list when no tools found', () async {
      // act
      var result = await sut.getToolsInStockByUser('wrongUsername');
      // assert
      expect(result, isEmpty);
    });
  });

  //================================================================================================
  group('searchToolsByName', () {
    ToolModel toolModel1 = ToolModel(name: 'toolName1', date: '2022', holder: 'user1');
    ToolModel toolModel2 = ToolModel(name: 'toolName2', date: '2022', holder: 'user1');
    ToolModel toolModel3 = ToolModel(name: 'name3', date: '2022', holder: 'user2');
    test('should return list of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.searchToolsByName('tool');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 2);
    });
    test('should return empty list when no tools found', () async {
      // act
      var result = await sut.searchToolsByName('wrongName');
      // assert
      expect(result, isEmpty);
    });
  });

  //================================================================================================
  group('countToolsInStockByUser', () {
    ToolModel toolModel1 = ToolModel(name: 'toolName1', date: '2022', holder: 'user1');
    ToolModel toolModel2 = ToolModel(name: 'toolName2', date: '2022', holder: 'user1');
    ToolModel toolModel3 =
        ToolModel(name: 'toolName3', date: '2022', holder: 'user1', receiver: 'user2');
    test('should return number of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.countToolsInStockByUser('user1');
      // assert
      expect(result, isNotNull);
      expect(result, 2);
    });
    test('should return 0 when no tools found', () async {
      // act
      var result = await sut.countToolsInStockByUser('wrongUsername');
      // assert
      expect(result, 0);
    });
  });
  //================================================================================================
  group('countTransferredToolsByUser', () {
    ToolModel toolModel1 =
        ToolModel(name: 'toolName1', date: '2022', holder: 'user1', receiver: 'user2');
    ToolModel toolModel2 =
        ToolModel(name: 'toolName2', date: '2022', holder: 'user1', receiver: 'user3');
    ToolModel toolModel3 =
        ToolModel(name: 'toolName3', date: '2022', holder: 'user2', receiver: 'user4');
    test('should return number of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.countTransferredToolsByUser('user1');
      // assert
      expect(result, isNotNull);
      expect(result, 2);
    });
    test('should return 0 when no tools found', () async {
      // act
      var result = await sut.countTransferredToolsByUser('wrongUsername');
      // assert
      expect(result, 0);
    });
  });
  //================================================================================================
  group('countReceivedToolsByUser', () {
    ToolModel toolModel1 =
        ToolModel(name: 'toolName1', date: '2022', holder: 'user2', receiver: 'user1');
    ToolModel toolModel2 =
        ToolModel(name: 'toolName2', date: '2022', holder: 'user3', receiver: 'user1');
    ToolModel toolModel3 =
        ToolModel(name: 'toolName3', date: '2022', holder: 'user3', receiver: 'user4');
    test('should return number of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.countReceivedToolsByUser('user1');
      // assert
      expect(result, isNotNull);
      expect(result, 2);
    });
    test('should return 0 when no tools found', () async {
      // act
      var result = await sut.countReceivedToolsByUser('wrongUsername');
      // assert
      expect(result, 0);
    });
  });
  //================================================================================================

  group('countPendingTools', () {
    ToolModel toolModel1 =
        ToolModel(name: 'toolName1', date: '2022', holder: 'user1', receiver: 'user2');
    ToolModel toolModel2 =
        ToolModel(name: 'toolName2', date: '2022', holder: 'user2', receiver: 'user1');
    ToolModel toolModel3 = ToolModel(name: 'toolName3', date: '2022', holder: 'holder2');
    test('should return number of tools when successful', () async {
      // arrange
      await tools.add(toolModel1.toMap());
      await tools.add(toolModel2.toMap());
      await tools.add(toolModel3.toMap());
      // act
      var result = await sut.countPendingTools();
      // assert
      expect(result, 2);
    });
    test('should return 0 when no tools found', () async {
      // act
      var result = await sut.countPendingTools();
      // assert
      expect(result, 0);
    });
  });

  //================================================================================================
}
