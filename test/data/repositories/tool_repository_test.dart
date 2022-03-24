import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/datasources/i_tool_datasource.dart';
import 'package:tools_manager/data/models/tool_model.dart';
import 'package:tools_manager/data/repositories/tool_repository.dart';
import 'package:tools_manager/domain/entities/tool.dart';

import 'tool_repository_test.mocks.dart';

@GenerateMocks([IToolDataSource])
void main() {
  late ToolRepository sut;
  late MockIToolDataSource mockToolDataSource;

  setUp(() {
    mockToolDataSource = MockIToolDataSource();
    sut = ToolRepository(mockToolDataSource);
  });

  //================================================================================================
  group('ToolRepository.add', () {
    Tool tool = Tool(
      name: 'hammer',
      date: '02-01-2022',
      holder: 'user',
    );
    test('should add a tool when successful', () async {
      // act
      await sut.add(tool);
      // assert
      verify(mockToolDataSource.addTool(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.update', () {
    Tool tool = Tool(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'user',
      receiver: 'user2',
    );
    test('should update a tool when successful', () async {
      // act
      await sut.update(tool);
      // assert
      verify(mockToolDataSource.updateTool(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.delete', () {
    test('should delete a tool when successful', () async {
      // act
      await sut.delete('id');
      // assert
      verify(mockToolDataSource.deleteTool(any)).called(1);
    });
  });

  //================================================================================================
  group('ToolRepository.getById', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'user',
      receiver: 'user2',
    );
    test('should return a tool when successful', () async {
      // arrange
      when(mockToolDataSource.getToolById(any)).thenAnswer((_) async => toolModel);
      // act
      var result = await sut.getById('id');
      // assert
      expect(result, isNotNull);
      expect(result, toolModel);
      verify(mockToolDataSource.getToolById(any)).called(1);
    });
    test('should return null when tool not found', () async {
      // arrange
      when(mockToolDataSource.getToolById(any)).thenAnswer((_) async => null);
      // act
      var result = await sut.getById('wrongId');
      // assert
      expect(result, isNull);
      verify(mockToolDataSource.getToolById(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.getByName', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'user',
      receiver: 'user2',
    );
    test('should return a tool when successful', () async {
      // arrange
      when(mockToolDataSource.getToolByName(any)).thenAnswer((_) async => toolModel);
      // act
      var result = await sut.getByName('hammer');
      // assert
      expect(result, isNotNull);
      expect(result, toolModel);
      verify(mockToolDataSource.getToolByName(any)).called(1);
    });
    test('should return null when tool not found', () async {
      // arrange
      when(mockToolDataSource.getToolByName(any)).thenAnswer((_) async => null);
      // act
      var result = await sut.getByName('wrongName');
      // assert
      expect(result, isNull);
      verify(mockToolDataSource.getToolByName(any)).called(1);
    });
  });

  //================================================================================================
  group('ToolRepository.getAll', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'user',
      receiver: 'user2',
    );
    test('should return list of tools when successful', () async {
      // arrange
      when(mockToolDataSource.getAllTools()).thenAnswer((_) async => [toolModel]);
      // act
      var result = await sut.getAll();
      // assert
      expect(result, isNotEmpty);
      expect(result, [toolModel]);
      verify(mockToolDataSource.getAllTools()).called(1);
    });
    test('should return empty list when no tools found', () async {
      // arrange
      when(mockToolDataSource.getAllTools()).thenAnswer((_) async => []);
      // act
      var result = await sut.getAll();
      // assert
      expect(result, isEmpty);
      verify(mockToolDataSource.getAllTools()).called(1);
    });
  });
  //================================================================================================

  group('ToolRepository.getByGiver', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'holder',
      receiver: 'receiver',
    );
    test('should return list of tools when successful', () async {
      // arrange
      when(mockToolDataSource.getToolsByGiver(any)).thenAnswer((_) async => [toolModel]);
      // act
      var result = await sut.getByGiver('giver');
      // assert
      expect(result, isNotEmpty);
      expect(result, [toolModel]);
      verify(mockToolDataSource.getToolsByGiver(any)).called(1);
    });
    test('should return empty list when no tools found', () async {
      // arrange
      when(mockToolDataSource.getToolsByGiver(any)).thenAnswer((_) async => []);
      // act
      var result = await sut.getByGiver('unknown');
      // assert
      expect(result, isEmpty);
      verify(mockToolDataSource.getToolsByGiver(any)).called(1);
    });
  });

  //================================================================================================

  group('ToolRepository.getByHolder', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'holder',
      receiver: 'receiver',
    );
    test('should return list of tools when successful', () async {
      // arrange
      when(mockToolDataSource.getToolsByHolder(any)).thenAnswer((_) async => [toolModel]);
      // act
      var result = await sut.getByHolder('holder');
      // assert
      expect(result, isNotEmpty);
      expect(result, [toolModel]);
      verify(mockToolDataSource.getToolsByHolder(any)).called(1);
    });
    test('should return empty list when no tools found', () async {
      // arrange
      when(mockToolDataSource.getToolsByHolder(any)).thenAnswer((_) async => []);
      // act
      var result = await sut.getByHolder('unknown');
      // assert
      expect(result, isEmpty);
      verify(mockToolDataSource.getToolsByHolder(any)).called(1);
    });
  });

  //================================================================================================
  group('ToolRepository.getByReceiver', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'holder',
      receiver: 'receiver',
    );
    test('should return list of tools when successful', () async {
      // arrange
      when(mockToolDataSource.getToolsByReceiver(any)).thenAnswer((_) async => [toolModel]);
      // act
      var result = await sut.getByReceiver('receiver');
      // assert
      expect(result, isNotEmpty);
      expect(result, [toolModel]);
      verify(mockToolDataSource.getToolsByReceiver(any)).called(1);
    });
    test('should return empty list when no tools found', () async {
      // arrange
      when(mockToolDataSource.getToolsByReceiver(any)).thenAnswer((_) async => []);
      // act
      var result = await sut.getByReceiver('unknown');
      // assert
      expect(result, isEmpty);
      verify(mockToolDataSource.getToolsByReceiver(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.getPending', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'user',
      receiver: 'user2',
    );
    test('should return list of tools when successful', () async {
      // arrange
      when(mockToolDataSource.getPendingTools()).thenAnswer((_) async => [toolModel]);
      // act
      var result = await sut.getPending();
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 1);
      verify(mockToolDataSource.getPendingTools()).called(1);
    });
    test('should return empty list when no tools found', () async {
      // arrange
      when(mockToolDataSource.getPendingTools()).thenAnswer((_) async => []);
      // act
      var result = await sut.getPending();
      // assert
      expect(result, isEmpty);
      verify(mockToolDataSource.getPendingTools()).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.getInStockByUser', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'user',
      receiver: null,
    );
    test('should return list of tools when successful', () async {
      // arrange
      when(mockToolDataSource.getToolsInStockByUser(any)).thenAnswer((_) async => [toolModel]);
      // act
      var result = await sut.getInStockByUser('user');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 1);
      verify(mockToolDataSource.getToolsInStockByUser(any)).called(1);
    });
    test('should return empty list when no tools found', () async {
      // arrange
      when(mockToolDataSource.getToolsInStockByUser(any)).thenAnswer((_) async => []);
      // act
      var result = await sut.getInStockByUser('unknownUser');
      // assert
      expect(result, isEmpty);
      verify(mockToolDataSource.getToolsInStockByUser(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.searchByName', () {
    ToolModel toolModel = ToolModel(
      id: 'id',
      name: 'hammer',
      date: '02-01-2022',
      giver: 'giver',
      holder: 'user',
      receiver: null,
    );
    test('should return list of tools when successful', () async {
      // arrange
      when(mockToolDataSource.searchToolsByName(any)).thenAnswer((_) async => [toolModel]);
      // act
      var result = await sut.searchByName('ham');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 1);
      verify(mockToolDataSource.searchToolsByName(any)).called(1);
    });
    test('should return empty list when no tools found', () async {
      // arrange
      when(mockToolDataSource.searchToolsByName(any)).thenAnswer((_) async => []);
      // act
      var result = await sut.searchByName('unknownName');
      // assert
      expect(result, isEmpty);
      verify(mockToolDataSource.searchToolsByName(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.countInStockByUser', () {
    test('should return number of tools when successful', () async {
      // arrange
      when(mockToolDataSource.countToolsInStockByUser('username')).thenAnswer((_) async => 1);
      // act
      var result = await sut.countInStockByUser('username');
      // assert
      expect(result, 1);
      verify(mockToolDataSource.countToolsInStockByUser(any)).called(1);
    });
    test('should return 0 when no tools found', () async {
      // arrange
      when(mockToolDataSource.countToolsInStockByUser('unknown')).thenAnswer((_) async => 0);
      // act
      var result = await sut.countInStockByUser('unknown');
      // assert
      expect(result, 0);
      verify(mockToolDataSource.countToolsInStockByUser(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.countTransferredByUser', () {
    test('should return number of tools when successful', () async {
      // arrange
      when(mockToolDataSource.countTransferredToolsByUser('username')).thenAnswer((_) async => 1);
      // act
      var result = await sut.countTransferredByUser('username');
      // assert
      expect(result, 1);
      verify(mockToolDataSource.countTransferredToolsByUser(any)).called(1);
    });
    test('should return 0 when no tools found', () async {
      // arrange
      when(mockToolDataSource.countTransferredToolsByUser('unknown')).thenAnswer((_) async => 0);
      // act
      var result = await sut.countTransferredByUser('unknown');
      // assert
      expect(result, 0);
      verify(mockToolDataSource.countTransferredToolsByUser(any)).called(1);
    });
  });
  //================================================================================================
  group('ToolRepository.countReceivedByUser', () {
    test('should return number of tools when successful', () async {
      // arrange
      when(mockToolDataSource.countReceivedToolsByUser('username')).thenAnswer((_) async => 1);
      // act
      var result = await sut.countReceivedByUser('username');
      // assert
      expect(result, 1);
      verify(mockToolDataSource.countReceivedToolsByUser(any)).called(1);
    });
    test('should return 0 when no tools found', () async {
      // arrange
      when(mockToolDataSource.countReceivedToolsByUser('unknown')).thenAnswer((_) async => 0);
      // act
      var result = await sut.countReceivedByUser('unknown');
      // assert
      expect(result, 0);
      verify(mockToolDataSource.countReceivedToolsByUser(any)).called(1);
    });
  });
  //================================================================================================

  group('ToolRepository.countPending', () {
    test('should return number of tools when successful', () async {
      // arrange
      when(mockToolDataSource.countPendingTools()).thenAnswer((_) async => 1);
      // act
      var result = await sut.countPending();
      // assert
      expect(result, 1);
      verify(mockToolDataSource.countPendingTools()).called(1);
    });
    test('should return 0 when no tools found', () async {
      // arrange
      when(mockToolDataSource.countPendingTools()).thenAnswer((_) async => 0);
      // act
      var result = await sut.countPending();
      // assert
      expect(result, 0);
      verify(mockToolDataSource.countPendingTools()).called(1);
    });
  });
  //================================================================================================
}
