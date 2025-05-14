import 'dart:io';

import 'board.dart';
// السلام عليكم
// لا  اعرف ان كان هذا المطلوب في الاختبار ام المطلوب هو تطبيق فلاتر

// الكلاس الرئيسي للعبة
class TicTacToeGame {
  // متغير اللاعب الحالي
  String currentPlayer = 'X';

  // هل اللعب ضد الكمبيوتر ام لا
  bool vsAI = false;

  // رمز الكمبيوتر
  String? aiSymbol;

  // رمز اللاعب الاخر
  String? playerSymbol;

  // ليست اللوحة
  List<List<String>> board = List.generate(
    3,
    (_) => List.generate(3, (_) => ' '),
  );

  // -------------------------------------------------------------
  // دالة سؤال المستخدم عن نوع الخصم
  Future<void> _chooseMode() async {
    stdout.write('Play vs AI? (y/n): ');
    String input = stdin.readLineSync()!;
    vsAI = input.toLowerCase() == 'y';
  }

  // دالة اختيار المستخدم للرمز الذي سيلعب به
  Future<void> _chooseSymbol() async {
    stdout.write('Choose your symbol (X/O): ');
    String input = stdin.readLineSync()!.toUpperCase();
    playerSymbol = input;
    // اذا اختار يلعب مع الكمبيوتر يحدد الرمز للكمبيوتر (عكس الرمز اللي اختاره المستخدم)
    if (vsAI) aiSymbol = (input == 'X' ? 'O' : 'X');
  }

  // دالة بدء اللعبة (الدالة الرئيسية)
  Future<void> startGame() async {
    print("🎮 Welcome to Tic-Tac-Toe!");
    await _chooseMode();
    await _chooseSymbol();
    // دالة طباعة لوحة اللعب
    printBoard(board);

    while (true) {
      // --------- بدء الحركات ----------
      if (vsAI && currentPlayer == aiSymbol) {
        await _aiMove();
      } else {
        await _playerMove();
      }
      // -------------------
      // طباعة اللوحة بعد الحركة وتخزين القيمة التي تمت اضفتها بعد الحركة الاخيرة
      printBoard(board);
      // بعد كل حركة يتم فحص هل يوجد فائز
      if (_checkWinner()) {
        print("🏆 Player $currentPlayer wins!");
        break;
      }
      // بعد كل حركة يتم فحص هل يوجد خانات فارغة
      // لانه اذا لم توجد يتم الاعلان عن التعادل والخروج من الدالة (اللعبة)
      if (_isDraw()) {
        print("🤝 It's a draw!");
        break;
      }

      // اذا وصل الى هنا يعني انه لا يوجد فائز ولم يتم التعادل
      // لذلك يتم التبديل بين اللعبين وتغيير (currentPlayer) لاضافة حركات جديدة
      _switchPlayer();
    }

    // اذا وصل الى هنا يعني انه خرج من كل while لذلك يتم سؤال المستخدم عن اعادة اللعبة مرة اخرى
    await _restartOption();
  }

  // -------------------------------------------------------------
  // لوجك حركة المستخدم
  Future<void> _playerMove() async {
    var colorPlayerSymbol = (currentPlayer == 'X') ? red : blue;
    while (true) {
      stdout.write(
        "Player $colorPlayerSymbol $currentPlayer $reset, enter your move (1-9): ",
      );

      String? input = stdin.readLineSync();

      if (input == null || int.tryParse(input) == null) {
        print("❌ Invalid input. Please enter a number between 1 and 9.");
        continue;
      }

      int move = int.parse(input);
      if (move < 1 || move > 9) {
        print("❌ Move out of range. Try again.");
        continue;
      }

      // تحديد موقع الرقم من المصفوفة
      // في اي row واي column
      int row = (move - 1) ~/ 3;
      int col = (move - 1) % 3;

      // بعد تحديد موقع رقم الرمز الذي ادخله المستخدم
      // نقوم بفحص هل الموقع فارغ ام لا
      if (board[row][col] != ' ') {
        print("❌ Cell already taken. Choose another.");
        continue;
      }
      // اذا وصل الى هنا يعني ان الادخال صحيح ولا توجد مشاكل
      // فيتم حفظ  قيمة الادخال في الليست ويتم حفظها
      board[row][col] = currentPlayer;
      break;
    }
  }

  // خوارزمية عمل الدالة تعتمد على اختيار اي خانة فارغة
  // ويتم اختيارها لاضافة الرمز
  Future<void> _aiMove() async {
    print("🤖 AI is making a move...");
    await Future.delayed(Duration(milliseconds: 1000));
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          board[i][j] = currentPlayer;
          return;
        }
      }
    }
  }

  // -------------------------------------------------------------
  // التبديل بين اللاعبين بعد كل حركة صحيحة
  void _switchPlayer() {
    currentPlayer = (currentPlayer == 'X' ? 'O' : 'X');
  }

  // خوارزمية اختبار الفوز
  // يختبر 3 طرق للفوز

  bool _checkWinner() {
    // يتم فحص الخطوط الافقية
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == currentPlayer &&
          board[i][1] == currentPlayer &&
          board[i][2] == currentPlayer)
        return true;
      // يتم فحص الخطوط العمودية
      if (board[0][i] == currentPlayer &&
          board[1][i] == currentPlayer &&
          board[2][i] == currentPlayer)
        return true;
    }

    // الخط المائل الاول (يبدا من اليسار)
    if (board[0][0] == currentPlayer &&
        board[1][1] == currentPlayer &&
        board[2][2] == currentPlayer)
      return true;

    // الخط المائل الثاني (يبدا من اليمين)
    if (board[0][2] == currentPlayer &&
        board[1][1] == currentPlayer &&
        board[2][0] == currentPlayer)
      return true;
    return false;
  }

  bool _isDraw() {
    for (var row in board) {
      if (row.contains(' ')) return false;
    }
    return true;
  }

  // -------------------------------------------------------------

  // اعادة اللعبة مرة اخرى بعد سؤال المستخدم هل يريد الاعادة
  Future<void> _restartOption() async {
    stdout.write("🔁 Do you want to play again? (y/n): ");
    String? input = stdin.readLineSync()?.toLowerCase();
    if (input == 'y') {
      // board.clear();
      board = List.generate(3, (_) => List.generate(3, (_) => ' '));
      currentPlayer = 'X';
      await startGame();
    } else {
      print("👋 Thanks for playing!");
    }
  }
}
