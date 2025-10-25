import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

class QAWindow extends StatefulWidget {
  final String questionBank;
  final String dataDirPath;

  const QAWindow({
    super.key,
    required this.questionBank,
    required this.dataDirPath,
  });

  @override
  State<QAWindow> createState() => QAWindowState();
}

class QAWindowState extends State<QAWindow> {
  List<List<String>> questions = [];
  int currentQuestionIndex = 0;
  bool showAnswer = false;
  int timerSeconds = 180;
  Timer? timer;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadQuestions();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timerSeconds > 0) {
            timerSeconds--;
          } else {
            timer.cancel();
            showTimeUpDialog();
          }
        });
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      timerSeconds = 180;
    });
    startTimer();
  }

  void showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('时间到！',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          content: const Text('计时结束。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  bool isImageAnswer(String answer) {
    final regex = RegExp(r'^\d{3}\.png$');
    return regex.hasMatch(answer);
  }

  Future<void> loadQuestions() async {
    try {
      final csvFile = File('${widget.dataDirPath}\\${widget.questionBank}.csv');
      print('加载题库文件: ${csvFile.path}');
      
      if (!await csvFile.exists()) {
        throw Exception('题库文件不存在: ${widget.questionBank}.csv');
      }

      final csvString = await csvFile.readAsString();
      final csvTable = const CsvToListConverter().convert(csvString);
      
      setState(() {
        questions = csvTable.map((row) => row.map((cell) => cell.toString()).toList()).toList();
        isLoading = false;
        
        print('解析到的问题数量: ${questions.length}');
        
        if (questions.isEmpty) {
          errorMessage = '题库文件为空，请添加问题数据。';
        }
      });
    } catch (e) {
      print('加载数据时出错: $e');
      setState(() {
        isLoading = false;
        errorMessage = '加载题库失败: $e';
      });
    }
  }

  void toggleAnswerDisplay() {
    setState(() {// 切换问题/答案显示状态
      if (showAnswer) {
        // 当前显示答案，点击后切换为显示问题
        showAnswer = false;
      } else {
        // 当前显示问题，点击后切换为显示答案并停止计时
        showAnswer = true;
        stopTimer();//不用担心计时器被停了以后再被停一次吧（？）没报错就当能用了
      }
    });
  }

  void doNextQuestion() {
    setState(() {
      if (questions.isNotEmpty) {
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
        showAnswer = false;
        resetTimer();
      }
    });
  }

  void previousQuestion() {
    setState(() {
      if (questions.isNotEmpty) {
        currentQuestionIndex = (currentQuestionIndex - 1) % questions.length;
        showAnswer = false;
        resetTimer();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color getTimerColor() {
    if (timerSeconds < 10) {
      return Colors.red;
    }
    return Colors.black;
  }

  Widget buildAnswerWidget(String answer) {
    if (isImageAnswer(answer)) {
      final imagePath = '${widget.dataDirPath}\\${widget.questionBank}\\$answer';
      final imageFile = File(imagePath);
      
      if (imageFile.existsSync()) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '答案图片:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 64),
                        const SizedBox(height: 8),
                        Text(
                          '图片加载失败\n$answer',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            const Icon(Icons.warning, color: Colors.orange, size: 64),
            const SizedBox(height: 8),
            Text(
              '图片文件不存在: $answer',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }
    } else {
      return Text(
        answer,
        style: const TextStyle(
          fontSize: 64,
          color: Colors.green,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QA问答：${widget.questionBank}'),
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
              : questions.isEmpty
                  ? const Center(child: Text('没有找到问题数据'))
                  : Column(
                      children: [
                        // 计时器部分
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[100],
                          child: Column(
                            children: [
                              const Text(
                                '倒计时',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatTime(timerSeconds),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: getTimerColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // 问题和答案部分
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 问题显示
                                  if (!showAnswer)
                                    Flexible(
                                      flex: 2,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          questions[currentQuestionIndex][0],
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // 答案显示
                                  if (showAnswer)
                                    Flexible(
                                      flex: 3,
                                      child: buildAnswerWidget(questions[currentQuestionIndex][1]),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // 按钮部分
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: toggleAnswerDisplay,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: Text(
                                      showAnswer ? '显示问题' : '显示答案',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: doNextQuestion,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text(
                                      '下一题',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}