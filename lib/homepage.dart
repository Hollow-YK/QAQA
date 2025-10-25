import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'qawindow.dart';
import 'questionlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedQuestionBank;
  String? dataDirPath;
  bool isPathValid = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    checkAppDataPath();
  }

  void checkAppDataPath() {
    try {
      final appDataPath = getAppDataPath();
      final dataDir = Directory('$appDataPath\\Hollow\\QAQA');
      dataDirPath = dataDir.path;
      
      setState(() {
        isPathValid = true;
      });
    } catch (e) {
      setState(() {
        isPathValid = false;
        errorMessage = '无法访问应用数据目录。$e\n你是在Windows10/11上运行的吗？';
      });
      showErrorDialog();
    }
  }

  String getAppDataPath() {
    final appData = Platform.environment['APPDATA'];
    if (appData == null) {
      throw Exception('无法找到 APPDATA 环境变量');
    }
    return appData;
  }

  void showErrorDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('初始化错误'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('退出'),
              ),
            ],
          );
        },
      );
    });
  }

  void onQuestionBankSelected(String fileName) {
    setState(() {
      selectedQuestionBank = fileName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QAQA 问答问答'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '欢迎使用 QAQA',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 显示选中的题库
            if (selectedQuestionBank != null)
              Column(
                children: [
                  const Text(
                    '当前题库:',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    selectedQuestionBank!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            
            // 开始按钮 - 只在选择了题库后启用
            ElevatedButton(
              onPressed: selectedQuestionBank != null ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QAWindow(
                      questionBank: selectedQuestionBank!,
                      dataDirPath: dataDirPath!,
                    ),
                  ),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedQuestionBank != null ? Colors.blue : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('开始答题'),
            ),
            
            const SizedBox(height: 20),
            
            // 选择题库按钮
            ElevatedButton(
              onPressed: isPathValid ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionList(
                      dataDirPath: dataDirPath!,
                      onQuestionBankSelected: onQuestionBankSelected,
                    ),
                  ),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('选择题库'),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              '版本 V0.0.1',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}