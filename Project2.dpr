program Fairy_tale_Game;
uses  System.SysUtils, Windows;
const
  QuestionsAmount = 10;  MaxAnswers = 6;
  MaxSen = 3;
type  TAnswers = array [1 .. QuestionsAmount, 1 .. MaxAnswers] of string;
  TQuestions = array [1 .. QuestionsAmount] of string;  TSentences = array [1 .. QuestionsAmount, 1 .. 2] of string;
  TTales = array [1 .. MaxAnswers] of string;  Tmas = array [1 .. QuestionsAmount] of integer;
var
  n, i, j, QuestionNum, QuestionsAmountAnswered: integer;  ArrayOfAnswers: TAnswers;
  RandomArrayOfQuestions: TQuestions;  RandomArrayOfAnswers: TAnswers;
  ArrayOfQuestions: TQuestions =
    ('Какой ваш любимый герои из мультика или фильма?',    'Чего не хватает в вашем холодильнике?', 'Ваш любимый напиток?',
    'Ваш рабочий день обычно какой?',    'Как вы описали бы полет на Луну?Назовите прилагательное',
    'Чего не хватает в вашем доме?', 'Как вы проводите выходные?',    'Что бывает красным?', 'Чего тебе хочется прямо сейчас?',
    'Нехороший человек-');  ArrayOfSentences: TSentences = (('Тебе пишет ', '.'),
    ('Я отлично провожу время вместе с друзьями,наш стол ломится от ', '.'),    ('В бокалах плещется ', '.'), ('Мы водим ', ' хоровод.'),
    ('А также танцуем ', ' танец.'),    ('Но для полного счастья нам не хватает найти под елочкой ', '.'),
    ('Целый год я вел(а) себя ', '.'), ('Дорогой Дедушка Мороз - красный ',    '.'), ('Исполни мое желание или хотя бы вышли денег на ', '.'),
    ('Помни, что я верю в тебя,твой ', '.'));  QuestionIndex: Tmas;
  ArrayOfTales: TTales;  stopWord: string = 'стоп';
procedure PlayersAmount(var n: integer); // Ввод кол-во игроков
var
  IsInt: boolean;
begin
repeat
    IsInt := True;
    try
    write('Введите количество игроков(от 2 до 6):');
      readln(n);
    except
      Writeln('Некорректный ввод данных, повторите ввод:');
      IsInt := False;
    end;
  until (n >= 2) and (n <= 6) and isInt;
end;

function lowerCase2(s: string): string;
var  i: integer;
begin  for i := 1 to length(s) do
    if (s[i] >= 'А') and (s[i] <= 'Я') then      s[i] := chr(Ord(s[i]) + Ord('а') - Ord('А'));
  result := s;end;
procedure ShuffleQuestions(var QuestionIndex: Tmas);
var  i, j, temp: integer;
begin  //Randomize;
  for i := QuestionsAmount downto 2 do  begin
    j := random(i) + 1;    temp := QuestionIndex[i];
    QuestionIndex[i] := QuestionIndex[j];    QuestionIndex[j] := temp;
  end;
end;

procedure ClearScreen;
var
  hConsole: THandle;
  consoleInfo: CONSOLE_SCREEN_BUFFER_INFO;
  consoleSize: DWORD;
  cursorPosition: COORD;
  charsWritten: DWORD;
  begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(hConsole, consoleInfo);
  consoleSize := consoleInfo.dwSize.X * consoleInfo.dwSize.Y;
  cursorPosition.X := 0;
  cursorPosition.Y := 0;
  FillConsoleOutputCharacter(hConsole, ' ', consoleSize, cursorPosition, charsWritten);
  FillConsoleOutputAttribute(hConsole, consoleInfo.wAttributes, consoleSize, cursorPosition, charsWritten);  SetConsoleCursorPosition(hConsole, cursorPosition);
end;
procedure firstPlayerTurn(var ArrayOfQuestions: TQuestions;  var QuestionIndex: Tmas; var ArrayOfAnswers: TAnswers);
var  i: integer;
  Answer: string;begin
  i := 1;  Writeln('Вопросы для ', i, ' игрока:');
  while (lowerCase2(Answer) <> stopWord) and (i <= QuestionsAmount) do  begin
    repeat      Writeln(ArrayOfQuestions[QuestionIndex[i]]);
      readln(Answer);    until Answer <> '';
    if Answer <> stopWord then    begin
      ArrayOfAnswers[QuestionIndex[i], 1] := Answer;      Inc(i);
    end;  end;
  QuestionsAmountAnswered := i - 1;end;
procedure GetAnswers(var ArrayOfQuestions: TQuestions; var QuestionIndex: Tmas;
  var ArrayOfAnswers: TAnswers; QuestionsAmount: integer);var
  i, j: integer;  Answer: string;
begin  for j := 2 to n do
  begin    ClearScreen;
    Writeln('Вопросы для ', j, ' игрока:');    for i := 1 to QuestionsAmount do
    begin      repeat
        Writeln(ArrayOfQuestions[QuestionIndex[i]]);        readln(Answer);
      until Answer <> '';      ArrayOfAnswers[QuestionIndex[i], j] := Answer;
    end;  end;
end;
procedure RandomAnswers(var ArrayOfAnswers: TAnswers; n: integer);// Тасование Фишера — Йетса ответов в пределах
var
  j, i, k: integer;  Answer: string;
begin
  Randomize;
  for i := 1 to QuestionsAmount do  begin
    for k := n downto 2 do    begin
      j := random(k) + 1;      Answer := ArrayOfAnswers[i, j];
      ArrayOfAnswers[i, j] := ArrayOfAnswers[i, k];      ArrayOfAnswers[i, k] := Answer;
    end;  end;
end;
procedure MakeTales(var ArrayOfTales: TTales; var ArrayOfAnswers: TAnswers;  var ArrayOfSentences: TSentences);
var  i, j: integer;
begin  for i := 1 to n do
    for j := 1 to QuestionsAmount do      if ArrayOfAnswers[j][i] <> '' then
        ArrayOfTales[i] := ArrayOfTales[i] + ArrayOfSentences[j][1] +          ArrayOfAnswers[j][i] + ArrayOfSentences[j][2];
end;
begin
PlayersAmount(n);
  for i := 1 to QuestionsAmount do
    QuestionIndex[i] := i;
  ShuffleQuestions(QuestionIndex);
  ClearScreen;  firstPlayerTurn(ArrayOfQuestions, QuestionIndex, ArrayOfAnswers);
  GetAnswers(ArrayOfQuestions, QuestionIndex, ArrayOfAnswers,
    QuestionsAmountAnswered);  RandomAnswers(ArrayOfAnswers, n);
  for i := 1 to n do    ArrayOfTales[i] := '';
  MakeTales(ArrayOfTales, ArrayOfAnswers, ArrayOfSentences);  ClearScreen;
  for i := 1 to n do  begin
    Writeln(i, '-я сказка:');    Writeln('Дорогой Дедушка Мороз!');
    Writeln(ArrayOfTales[i]);  end;
  readln;
end.

