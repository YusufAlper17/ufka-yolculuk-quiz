import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/question_model.dart';

enum QuizStatus {
  notStarted,
  inProgress,
  completed,
}

class QuizProvider extends ChangeNotifier {
  List<QuestionModel> _questions = [];
  int _currentQuestionIndex = 0;
  List<int?> _userAnswers = [];
  int? _selectedAnswer;
  bool _isCompleted = false;
  Map<String, QuizStatus> _quizStatuses = {};
  String? _currentCategory;
  int? _currentLevel;
  int? _currentExamNumber;
  DateTime? _startTime;
  Duration? _completionTime;
  SharedPreferences? _prefs;
  bool _isInitialized = false;
  
  // Aktif süre için yeni değişkenler
  Duration _activeTime = Duration.zero;
  DateTime? _lastPauseTime;
  DateTime? _lastResumeTime;

  bool get isInitialized => _isInitialized;

  List<QuestionModel> get questions => _questions;
  QuestionModel? get currentQuestion => 
    _questions.isNotEmpty && _currentQuestionIndex < _questions.length 
      ? _questions[_currentQuestionIndex] 
      : null;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<int?> get userAnswers => 
    _userAnswers.isEmpty ? [] : List.unmodifiable(_userAnswers);
  int? get selectedAnswer => _selectedAnswer;
  bool get isCompleted => _isCompleted;
  String get progress => 
    _questions.isEmpty ? '0/0' : '${_currentQuestionIndex + 1}/${_questions.length}';
  Duration? get completionTime => _completionTime;
  String? get category => _currentCategory;

  QuizStatus getQuizStatus(String quizId) {
    return _quizStatuses[quizId] ?? QuizStatus.notStarted;
  }

  void setQuizStatus(String quizId, QuizStatus status) {
    _quizStatuses[quizId] = status;
    _saveQuizStatuses();
    _saveUnlockedLevels();
    notifyListeners();
  }

  void selectAnswer(int answerIndex) {
    if (_userAnswers[_currentQuestionIndex] != null) return;
    
    if (_selectedAnswer == answerIndex) {
      _userAnswers[_currentQuestionIndex] = answerIndex;
      _selectedAnswer = null;
      saveUserAnswers('${_currentCategory}_${_currentLevel}_${_currentExamNumber}');
    } else {
      _selectedAnswer = answerIndex;
    }
    notifyListeners();
  }

  Future<void> loadQuestions(String category, int level, int examNumber) async {
    try {
      if (!_isInitialized) {
        debugPrint('QuizProvider not initialized. Initializing...');
        await init();
      }

      debugPrint('Loading questions for category: $category, level: $level, exam: $examNumber');
      
      _currentCategory = category;
      _currentLevel = level;
      _currentExamNumber = examNumber;
      String quizId = '${category}_${level}_$examNumber';
      
      debugPrint('Quiz ID: $quizId');

      // JSON dosyasını yükle
      String jsonFile = 'assets/data/processed_questions.json';
      debugPrint('Attempting to load JSON from: $jsonFile');
      
      String jsonString;
      try {
        // Asset'ten JSON dosyasını yükle
        final ByteData data = await rootBundle.load(jsonFile);
        jsonString = utf8.decode(data.buffer.asUint8List());
        
        if (jsonString.isEmpty) {
          debugPrint('JSON file is empty');
          throw Exception('Soru dosyası boş');
        }
        debugPrint('JSON file loaded successfully, length: ${jsonString.length}');
      } catch (e) {
        debugPrint('Error loading JSON file: $e');
        throw Exception('Sorular yüklenirken bir hata oluştu. Lütfen uygulamayı yeniden başlatın.');
      }

      // JSON'ı parse et ve soruları yükle
      await _loadQuestionsFromJson(jsonString);

      // Quiz durumunu kontrol et
      final quizStatus = getQuizStatus(quizId);
      if (quizStatus == QuizStatus.completed) {
        // Quiz tamamlanmışsa, önceki sonuçları yükle
        await loadQuizProgress(quizId);
        _isCompleted = true;
      } else if (quizStatus == QuizStatus.inProgress) {
        // Quiz yarım kalmışsa, kaldığı yerden devam et
        await loadInProgressQuiz(quizId);
        _isCompleted = false;
      } else {
        // Yeni quiz başlat
        _isCompleted = false;
        _startTime = DateTime.now();
        _lastResumeTime = DateTime.now();
        _completionTime = null;
        _currentQuestionIndex = 0;
        _userAnswers = List.filled(_questions.length, null);
        _activeTime = Duration.zero;
      }
      
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error in loadQuestions: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // JSON'dan soruları yükleyen yardımcı metod
  Future<void> _loadQuestionsFromJson(String jsonString) async {
    try {
      final jsonData = json.decode(jsonString);
      if (jsonData == null || jsonData.isEmpty) {
        debugPrint('JSON data is null or empty');
        throw Exception('Soru verisi boş veya geçersiz');
      }

      var categories = jsonData['categories'];
      if (categories == null) {
        debugPrint('Categories data is null');
        throw Exception('Kategori bilgisi bulunamadı');
      }

      String mappedCategory = _mapCategory(_currentCategory ?? '');
      debugPrint('Mapped category: $mappedCategory');
      
      var categoryData = categories[mappedCategory];
      if (categoryData == null) {
        debugPrint('Category data not found for: $mappedCategory');
        throw Exception('$mappedCategory kategorisi bulunamadı');
      }

      var levels = categoryData['levels'];
      if (levels == null) {
        debugPrint('Levels data is null');
        throw Exception('Seviye bilgisi bulunamadı');
      }

      var levelData = levels[_currentLevel.toString()];
      if (levelData == null) {
        debugPrint('Level data not found for level: $_currentLevel');
        throw Exception('Seviye $_currentLevel bulunamadı');
      }

      var exams = levelData['exams'];
      if (exams == null) {
        debugPrint('Exams data is null');
        throw Exception('Sınav bilgisi bulunamadı');
      }

      var examData = exams[_currentExamNumber.toString()];
      if (examData == null) {
        debugPrint('Exam data not found for exam: $_currentExamNumber');
        throw Exception('Sınav $_currentExamNumber bulunamadı');
      }

      var questionsData = examData['questions'];
      if (questionsData == null || !(questionsData is List) || questionsData.isEmpty) {
        debugPrint('Questions data is invalid or empty');
        throw Exception('Bu sınav için soru bulunamadı');
      }

      _questions = [];
      for (var q in questionsData) {
        if (q == null) {
          debugPrint('Question data is null');
          continue;
        }

        try {
          _questions.add(QuestionModel(
            id: (q['id'] ?? '').toString(),
            question: q['text'] ?? '',
            options: List<String>.from(q['options'] ?? []),
            correctOptionIndex: q['correctIndex'] ?? 0,
            explanation: q['explanation'] ?? '',
          ));
        } catch (e) {
          debugPrint('Error creating question model: $e');
          continue;
        }
      }

      if (_questions.isEmpty) {
        throw Exception('Hiç soru yüklenemedi');
      }

      debugPrint('Successfully loaded ${_questions.length} questions');
      _userAnswers = List.filled(_questions.length, null);

    } catch (e) {
      debugPrint('Error in _loadQuestionsFromJson: $e');
      rethrow;
    }
  }

  String _mapCategory(String category) {
    switch (category.toLowerCase()) {
      case 'elementary':
      case 'ilkokul':
        return 'ilkokul';
      case 'middle_school':
      case 'ortaokul':
        return 'ortaokul';
      case 'high_school':
      case 'lise':
        return 'lise';
      default:
        return category.toLowerCase();
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      saveUserAnswers('${_currentCategory}_${_currentLevel}_${_currentExamNumber}');
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _selectedAnswer = null;
      saveUserAnswers('${_currentCategory}_${_currentLevel}_${_currentExamNumber}');
      notifyListeners();
    }
  }

  int getCorrectAnswersCount() {
    int count = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] != null && _userAnswers[i] == _questions[i].correctOptionIndex) {
        count++;
      }
    }
    return count;
  }

  int getIncorrectAnswersCount() {
    int count = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] != null && _userAnswers[i] != _questions[i].correctOptionIndex) {
        count++;
      }
    }
    return count;
  }

  int getEmptyAnswersCount() {
    return _questions.length - getCorrectAnswersCount() - getIncorrectAnswersCount();
  }

  double getScore() {
    return getCorrectAnswersCount() * 10.0;
  }

  bool isAnswerCorrect(int questionIndex) {
    return _userAnswers[questionIndex] == _questions[questionIndex].correctOptionIndex;
  }

  void reset() {
    String quizId = '${_currentCategory}_${_currentLevel}_${_currentExamNumber}';
    _quizStatuses[quizId] = QuizStatus.notStarted;
    _currentQuestionIndex = 0;
    _userAnswers = List.filled(_questions.length, null);
    _selectedAnswer = null;
    _isCompleted = false;
    
    // Süre değerlerini sıfırla
    _startTime = DateTime.now();
    _lastResumeTime = DateTime.now();
    _activeTime = Duration.zero;
    _completionTime = null;
    _lastPauseTime = null;
    
    // Sıfırlanan testin verilerini sil
    _prefs?.remove('${quizId}_data');
    
    // Quiz durumlarını ve seviye kilitlerini kaydet
    _saveQuizStatuses();
    _saveUnlockedLevels();
    
    notifyListeners();
  }

  void completeQuiz() {
    String quizId = '${_currentCategory}_${_currentLevel}_${_currentExamNumber}';
    _quizStatuses[quizId] = QuizStatus.completed;
    _isCompleted = true;
    
    // Son aktif süreyi hesapla
    if (_lastResumeTime != null) {
      _activeTime += DateTime.now().difference(_lastResumeTime!);
      _lastResumeTime = null;
    }
    _completionTime = _activeTime;
    
    // Quiz durumlarını ve seviye kilitlerini kaydet
    _saveQuizStatuses();
    _saveUnlockedLevels();
    
    notifyListeners();
  }

  bool isLevelCompleted(String category, int level) {
    // Bir seviyedeki tüm denemelerin tamamlanıp tamamlanmadığını kontrol et
    for (int examNumber = 1; examNumber <= 10; examNumber++) {
      String quizId = '${category}_${level}_$examNumber';
      if (getQuizStatus(quizId) != QuizStatus.completed) {
        return false;
      }
    }
    return true;
  }

  void unlockNextLevel(String category, int level) {
    // Eğer mevcut seviye tamamlandıysa, bir sonraki seviyenin kilidini aç
    if (isLevelCompleted(category, level)) {
      String nextLevelKey = '${category}_${level + 1}_unlocked';
      _quizStatuses[nextLevelKey] = QuizStatus.notStarted;
      _saveUnlockedLevels();
      notifyListeners();
    }
  }

  bool isLevelUnlocked(String category, int level) {
    if (level == 1) return true; // İlk seviye her zaman açık
    String levelKey = '${category}_${level}_unlocked';
    return _quizStatuses[levelKey] != null;
  }

  // SharedPreferences'ı başlat
  Future<void> init() async {
    if (_isInitialized) {
      debugPrint('QuizProvider already initialized');
      return;
    }
    
    try {
      // SharedPreferences'ı başlat
      _prefs = await SharedPreferences.getInstance();
      debugPrint('SharedPreferences initialized successfully');
      
      // Kaydedilmiş ilerlemeyi yükle
      await _loadSavedProgress();
      
      // İlk seviyeyi her zaman aç (eğer hiç ilerleme yoksa)
      if (_quizStatuses.isEmpty) {
        _quizStatuses['ilkokul_1_unlocked'] = QuizStatus.notStarted;
        _quizStatuses['ortaokul_1_unlocked'] = QuizStatus.notStarted;
        _quizStatuses['lise_1_unlocked'] = QuizStatus.notStarted;
        await _saveQuizStatuses();
      }
      
      _isInitialized = true;
      notifyListeners();
      debugPrint('QuizProvider initialization completed');
    } catch (e) {
      debugPrint('Error initializing QuizProvider: $e');
      _resetProgress();
      _isInitialized = false;
      notifyListeners();
    }
  }

  // Kaydedilmiş ilerlemeyi yükle
  Future<void> _loadSavedProgress() async {
    try {
      // Quiz durumlarını yükle
      final statusesString = _prefs!.getString('quiz_statuses');
      if (statusesString != null) {
        final statusesMap = json.decode(statusesString) as Map<String, dynamic>;
        _quizStatuses = statusesMap.map(
          (key, value) => MapEntry(key, QuizStatus.values.firstWhere(
            (status) => status.toString() == value,
            orElse: () => QuizStatus.notStarted,
          )),
        );
      }

      // Seviye kilitlerini yükle
      final unlockedLevels = _prefs!.getStringList('unlocked_levels');
      if (unlockedLevels != null) {
        for (final key in unlockedLevels) {
          _quizStatuses[key] = QuizStatus.notStarted;
        }
      }

      debugPrint('Saved progress loaded successfully');
    } catch (e) {
      debugPrint('Error loading saved progress: $e');
      _resetProgress();
    }
  }

  // Quiz durumlarını kaydet
  Future<void> _saveQuizStatuses() async {
    if (_prefs == null) return;
    
    try {
      final statusesMap = _quizStatuses.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      await _prefs!.setString('quiz_statuses', json.encode(statusesMap));
      
      // Açık olan seviyeleri kaydet
      final unlockedLevels = _quizStatuses.entries
          .where((entry) => entry.key.endsWith('_unlocked'))
          .map((entry) => entry.key)
          .toList();
      await _prefs!.setStringList('unlocked_levels', unlockedLevels);
      
      debugPrint('Quiz statuses and unlocked levels saved successfully');
    } catch (e) {
      debugPrint('Error saving quiz statuses: $e');
    }
  }

  // İlerleme durumunu sıfırla
  void _resetProgress() {
    _questions = [];
    _userAnswers = [];
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _isCompleted = false;
    _quizStatuses = {
      'ilkokul_1_unlocked': QuizStatus.notStarted,
      'ortaokul_1_unlocked': QuizStatus.notStarted,
      'lise_1_unlocked': QuizStatus.notStarted
    };
    _currentCategory = null;
    _currentLevel = null;
    _currentExamNumber = null;
    _startTime = null;
    _completionTime = null;
    _activeTime = Duration.zero;
    _lastPauseTime = null;
    _lastResumeTime = null;
  }

  // Tüm ilerlemeyi temizle
  Future<void> clearAllProgress() async {
    if (_prefs == null) return;

    try {
      // Tüm ilerleme verilerini temizle
      final allKeys = _prefs!.getKeys().toList();
      for (final key in allKeys) {
        if (key.contains('_status') || 
            key.contains('_data') || 
            key.contains('_answers') ||
            key == 'quiz_statuses' ||
            key == 'unlocked_levels') {
          await _prefs!.remove(key);
        }
      }

      // İlerleme durumunu sıfırla
      _resetProgress();
      
      // İlk seviyeleri tekrar aç
      await _saveQuizStatuses();

      notifyListeners();
      debugPrint('All progress cleared successfully');
    } catch (e) {
      debugPrint('Error clearing progress: $e');
    }
  }

  // Quiz durumlarını yükle
  Future<void> _loadQuizStatuses() async {
    if (_prefs == null) {
      debugPrint('SharedPreferences is null, skipping loading quiz statuses');
      return;
    }
    
    try {
      final statusesString = _prefs!.getString('quiz_statuses');
      if (statusesString != null) {
        final statusesMap = json.decode(statusesString) as Map<String, dynamic>;
        _quizStatuses = statusesMap.map(
          (key, value) => MapEntry(key, QuizStatus.values.firstWhere(
            (status) => status.toString() == value,
            orElse: () => QuizStatus.notStarted,
          )),
        );
        debugPrint('Loaded ${_quizStatuses.length} quiz statuses');
        notifyListeners();
      } else {
        debugPrint('No saved quiz statuses found');
      }
    } catch (e) {
      debugPrint('Error loading quiz statuses: $e');
      _quizStatuses = {};
    }
  }

  // Kayıtlı seviye kilitlerini yükle
  Future<void> _loadUnlockedLevels() async {
    if (_prefs == null) return;
    
    try {
      final unlockedLevels = _prefs!.getStringList('unlocked_levels');
      if (unlockedLevels != null) {
        for (final key in unlockedLevels) {
          _quizStatuses[key] = QuizStatus.notStarted;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading unlocked levels: $e');
    }
  }

  // Seviye kilidini kaydet
  Future<void> _saveUnlockedLevels() async {
    if (_prefs == null) return;
    
    try {
      final unlockedLevels = <String>[];
      for (final key in _quizStatuses.keys) {
        if (key.endsWith('_unlocked')) {
          unlockedLevels.add(key);
        }
      }
      await _prefs!.setStringList('unlocked_levels', unlockedLevels);
      debugPrint('Unlocked levels saved successfully');
    } catch (e) {
      debugPrint('Error saving unlocked levels: $e');
    }
  }

  // Kullanıcı cevaplarını kaydet
  Future<void> saveUserAnswers(String quizId) async {
    if (_prefs == null) {
      debugPrint('SharedPreferences is null, skipping saving user answers');
      return;
    }
    
    try {
      final answersMap = {
        'answers': _userAnswers.map((answer) => answer?.toString()).toList(),
        'currentIndex': _currentQuestionIndex,
        'startTime': _startTime?.millisecondsSinceEpoch,
        'category': _currentCategory,
        'level': _currentLevel,
        'examNumber': _currentExamNumber,
      };
      
      final jsonString = json.encode(answersMap);
      await _prefs!.setString('answers_$quizId', jsonString);
      debugPrint('Saved user answers for quiz: $quizId');
    } catch (e) {
      debugPrint('Error saving user answers: $e');
    }
  }

  // Kullanıcı cevaplarını yükle
  Future<void> _loadUserAnswers(String quizId) async {
    if (_prefs == null) {
      debugPrint('SharedPreferences is null, skipping loading user answers');
      return;
    }
    
    try {
      final answersString = _prefs!.getString('answers_$quizId');
      if (answersString != null) {
        final answersMap = json.decode(answersString) as Map<String, dynamic>;
        
        // Cevapları string'den int'e dönüştür
        final answersList = (answersMap['answers'] as List).map((answer) {
          if (answer == null || answer == 'null') return null;
          return int.tryParse(answer.toString());
        }).toList();
        
        _userAnswers = answersList;
        _currentQuestionIndex = answersMap['currentIndex'] as int;
        
        final startTimeMillis = answersMap['startTime'] as int?;
        if (startTimeMillis != null) {
          _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
        }
        
        debugPrint('Loaded user answers for quiz: $quizId');
        notifyListeners();
      } else {
        debugPrint('No saved answers found for quiz: $quizId');
      }
    } catch (e) {
      debugPrint('Error loading user answers: $e');
      _userAnswers = [];
      _currentQuestionIndex = 0;
    }
  }

  int calculateScore() {
    return getScore().round();
  }

  String getCompletionTime() {
    Duration totalTime = _activeTime;
    if (_lastResumeTime != null && !_isCompleted) {
      totalTime += DateTime.now().difference(_lastResumeTime!);
    }
    
    int minutes = totalTime.inMinutes;
    int seconds = totalTime.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Aktif süreyi durduran metod
  void pauseTimer() {
    if (_lastResumeTime != null) {
      _lastPauseTime = DateTime.now();
      _activeTime += _lastPauseTime!.difference(_lastResumeTime!);
      _lastResumeTime = null;
      debugPrint('Timer paused. Active time: ${_activeTime.inSeconds} seconds');
    }
  }

  // Aktif süreyi devam ettiren metod
  void resumeTimer() {
    if (!_isCompleted) {
      _lastResumeTime = DateTime.now();
      debugPrint('Timer resumed');
    }
  }

  // Quiz ilerlemesini kaydetmek için yeni metodlar
  Future<void> saveQuizProgress(String quizId) async {
    if (_prefs == null) return;

    // Quiz durumunu kaydet
    await _prefs!.setString('${quizId}_status', QuizStatus.completed.toString());
    
    // Kullanıcının cevaplarını kaydet
    final quizData = {
      'answers': _userAnswers,
      'score': calculateScore(),
      'completion_time': _completionTime?.inSeconds,
      'correct_count': getCorrectAnswersCount(),
      'incorrect_count': getIncorrectAnswersCount(),
      'empty_count': getEmptyAnswersCount()
    };
    
    await _prefs!.setString('${quizId}_data', json.encode(quizData));
  }

  // Quiz ilerlemesini yüklemek için yeni metod
  Future<void> loadQuizProgress(String quizId) async {
    if (_prefs == null) return;

    // Quiz verilerini yükle
    final savedData = _prefs!.getString('${quizId}_data');
    if (savedData != null) {
      final quizData = json.decode(savedData) as Map<String, dynamic>;
      
      // Cevapları yükle
      _userAnswers = List<int?>.from(quizData['answers'].map((answer) {
        if (answer == null) return null;
        return int.tryParse(answer.toString());
      }));

      // Tamamlanma süresini yükle
      final savedCompletionTime = quizData['completion_time'];
      if (savedCompletionTime != null) {
        _completionTime = Duration(seconds: savedCompletionTime);
      }
    }
  }

  // Yarım kalan quiz'i kaydet
  Future<void> saveInProgressQuiz(String quizId) async {
    if (_prefs == null) return;

    try {
      // Quiz durumunu kaydet
      await _prefs!.setString('${quizId}_status', QuizStatus.inProgress.toString());
      
      // Mevcut ilerlemeyi kaydet
      final progressData = {
        'answers': _userAnswers,
        'currentIndex': _currentQuestionIndex,
        'active_time': _activeTime.inSeconds,
        'start_time': _startTime?.millisecondsSinceEpoch
      };
      
      await _prefs!.setString('${quizId}_progress', json.encode(progressData));
      debugPrint('Quiz progress saved successfully');
    } catch (e) {
      debugPrint('Error saving quiz progress: $e');
    }
  }

  // Yarım kalan quiz'i yükle
  Future<void> loadInProgressQuiz(String quizId) async {
    if (_prefs == null) return;

    try {
      final savedProgress = _prefs!.getString('${quizId}_progress');
      if (savedProgress != null) {
        final progressData = json.decode(savedProgress) as Map<String, dynamic>;
        
        // Cevapları yükle
        _userAnswers = List<int?>.from(progressData['answers'].map((answer) {
          if (answer == null) return null;
          return int.tryParse(answer.toString());
        }));
        
        // Mevcut soruyu yükle
        _currentQuestionIndex = progressData['currentIndex'] as int;
        
        // Süreyi yükle
        _activeTime = Duration(seconds: progressData['active_time'] as int);
        
        // Başlangıç zamanını yükle
        final startTimeMillis = progressData['start_time'] as int?;
        if (startTimeMillis != null) {
          _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
        }
        
        // Süreyi başlat
        _lastResumeTime = DateTime.now();
        
        debugPrint('Quiz progress loaded successfully');
      }
    } catch (e) {
      debugPrint('Error loading quiz progress: $e');
    }
  }

  @override
  void dispose() {
    // Provider dispose edildiğinde süreyi durdur ve ilerlemeyi kaydet
    if (!_isCompleted && _currentCategory != null) {
      pauseTimer();
      String quizId = '${_currentCategory}_${_currentLevel}_${_currentExamNumber}';
      saveInProgressQuiz(quizId);
    }
    super.dispose();
  }
} 