import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';

class QuestionList extends StatefulWidget {
  final String dataDirPath;
  final Function(String) onQuestionBankSelected;

  const QuestionList({
    super.key,
    required this.dataDirPath,
    required this.onQuestionBankSelected,
  });

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  List<String> csvFiles = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCSVFiles();
  }

  Future<void> _loadCSVFiles() async {
    try {
      final dataDir = Directory(widget.dataDirPath);
      
      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }

      final files = await dataDir.list().toList();
      final csvFileList = files
          .where((file) => file is File && file.path.toLowerCase().endsWith('.csv'))
          .map((file) => File(file.path))
          .toList();

      setState(() {
        csvFiles = csvFileList.map((file) {
          final fileName = file.path.split(RegExp(r'[\\/]')).last;
          return fileName.substring(0, fileName.length - 4); // 移除 .csv 后缀
        }).toList();
        isLoading = false;
      });

      // 如果没有CSV文件，创建示例文件
      if (csvFiles.isEmpty) {
        await _createSampleData();
        _loadCSVFiles(); // 重新加载文件列表
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = '加载文件列表失败: $e';
      });
    }
  }

  Future<void> _createSampleData() async {
    try {
      final sampleFile = File('${widget.dataDirPath}\\举个例子.csv');
      const sampleData = '''问题1,答案1
问题2,答案2
问题3,答案3
这是一个示例问题,这是对应的示例答案
图片示例问题,001.png''';
      
      await sampleFile.writeAsString(sampleData);
    } catch (e) {
      setState(() {
        errorMessage = '创建示例文件失败: $e';
      });
    }
  }

  void _selectQuestionBank(String fileName) {
    widget.onQuestionBankSelected(fileName);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择题库'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : csvFiles.isEmpty
                  ? const Center(child: Text('没有找到题库文件'))
                  : ListView.builder(
                      itemCount: csvFiles.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text(
                              csvFiles[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _selectQuestionBank(csvFiles[index]);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('选择'),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}