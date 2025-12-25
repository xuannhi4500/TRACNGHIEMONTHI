<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TRANGBAILAM.aspx.cs" Inherits="TRACNGHIEMONTHI.TRANGBAILAM" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Trắc nghiệm</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f7fa;
            display: flex;
            justify-content: center;
            padding: 50px 0;
        }
        .quiz-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 100%;
        }
        .question {
            font-size: 1.2rem;
            margin-bottom: 20px;
        }
        .answers button {
            display: block;
            width: 100%;
            margin-bottom: 10px;
            padding: 12px;
            border: 2px solid #3498db;
            background: #fff;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            transition: 0.3s;
        }
        .answers button:hover { background: #3498db; color: #fff; }
        .answers button.correct { background: #2ecc71; border-color: #27ae60; color: #fff; }
        .answers button.wrong { background: #e74c3c; border-color: #c0392b; color: #fff; }
        .score { font-weight: bold; margin-top: 20px; font-size: 1.1rem; text-align: center; }
        .progress-container {
            background: #e0e0e0;
            border-radius: 10px;
            height: 20px;
            margin-top: 20px;
            width: 100%;
        }
        .progress-bar {
            height: 100%;
            width: 0;
            background: #3498db;
            border-radius: 10px;
            transition: 0.3s;
        }
        .question-count {
            text-align: right;
            margin-top: 5px;
            font-size: 0.9rem;
            color: #555;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="quiz-container">
            <div class="question" id="question"></div>
            <div class="answers" id="answers"></div>
            <div class="question-count" id="questionCount"></div>
            <div class="progress-container">
                <div class="progress-bar" id="progressBar"></div>
            </div>
            <div class="score" id="score">Điểm: 0</div>
        </div>
    </form>

    <script type="text/javascript">
        var quizData = [];
        var currentIndex = 0;
        var score = 0;
        var totalQuestions = 0;

        $(document).ready(function () {
            $.ajax({
                type: "POST",
                url: "TRANGBAILAM.aspx/GetQuizData",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    quizData = response.d;
                    totalQuestions = quizData.length;
                    showQuestion();
                    updateProgress();
                }
            });
        });

        function showQuestion() {
            if (currentIndex >= quizData.length) {
                // Hiển thị thông báo hoàn thành
                $('#question').html('<h2>Bạn đã hoàn thành bài kiểm tra!<br>Điểm: ' + score + ' / ' + totalQuestions + '</h2>');
                $('#answers').html('<button id="restartBtn" type="button">Làm lại</button>');
                $('#questionCount').html('');
                $('.progress-bar').css('width', '100%');

                // Bắt sự kiện nút làm lại
                $('#restartBtn').click(function () {
                    currentIndex = 0;
                    score = 0;
                    $('#score').text('Điểm: ' + score);
                    updateProgress();
                    showQuestion();
                });

                return;
            }

            var q = quizData[currentIndex];
            $('#question').text(q.NoiDung);
            var answersDiv = $('#answers');
            answersDiv.empty();

            q.DapAn.forEach(function (a) {
                var btn = $('<button type="button">' + a.NoiDung + '</button>');
                btn.click(function (e) {
                    e.preventDefault(); // chặn submit form
                    selectAnswer(btn, a.LaDung, q.DapAn);
                });
                answersDiv.append(btn);
            });

            $('#questionCount').text('Câu ' + (currentIndex + 1) + ' / ' + totalQuestions);
        }


        function selectAnswer(btn, isCorrect, allAnswers) {
            if (isCorrect) {
                $(btn).addClass('correct');
                score++;
            } else {
                $(btn).addClass('wrong');
                score; // ĐIỂM GIỮ NGUYÊN 
                // highlight đáp án đúng
                allAnswers.forEach(function (a) {
                    if (a.LaDung) {
                        $('#answers button').filter(function () { return $(this).text() === a.NoiDung; }).addClass('correct');
                    }
                });
            }
            $('#score').text('Điểm: ' + score); // ĐÚNG +1 
            updateProgress();

            // sang câu tiếp theo sau 1s
            setTimeout(function () {
                currentIndex++;
                showQuestion();
            }, 1000);
        }

        function updateProgress() {
            var percent = ((currentIndex) / totalQuestions) * 100;
            $('#progressBar').css('width', percent + '%');
        }
    </script>

</body>
</html>
