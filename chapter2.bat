@echo off
chcp 65001 > nul
set correct=0
set points=0
set total=4

echo ===================================================
echo   МОДУЛЬ 2: ИНСПЕКЦИЯ КОДА (API ТАСК-ТРЕКЕРОВ)
echo ===================================================
echo.

echo Фрагмент 1 (Расчёт скорости спринта в Taiga):
echo 10: def calculate_sprint_velocity(tasks):
echo 11:     for task in tasks:
echo 12:         if task.status == "Done":
echo 13:             velocity += task.story_points
echo 14:     return velocity
echo.
echo Какой дефект здесь скрыт?
echo 1. Неинициализированная переменная (velocity)
echo 2. Утечка ресурса
echo 3. Магическое число
choice /c 123 /n
if errorlevel 3 goto wrong1
if errorlevel 2 goto wrong1
if errorlevel 1 (
    echo Верно! Переменная velocity не объявлена до цикла. (+10 очков)
    set /a correct+=1
    set /a points+=10
    goto frag2
)
:wrong1
echo Неверно. Правильный ответ: 1 (Неинициализированная переменная). (-5 очков)
set /a points-=5

:frag2
echo.
echo Фрагмент 2 (Экспорт отчёта по задачам Redmine):
echo 20: def export_issues_to_csv(issues, filename):
echo 21:     f = open(filename, "w")
echo 22:     for issue in issues:
echo 23:         f.write(f"{issue.id},{issue.subject}\n")
echo 24:     return True
echo.
echo Какой дефект здесь скрыт?
echo 1. Мёртвое присваивание
echo 2. Утечка ресурса (файл не закрывается)
echo 3. Магическое число
choice /c 123 /n
if errorlevel 3 goto wrong2
if errorlevel 2 (
    echo Верно! Файл открыт без контекстного менеджера with и не закрыт. (+10 очков)
    set /a correct+=1
    set /a points+=10
    goto frag3
)
:wrong2
echo Неверно. Правильный ответ: 2 (Утечка ресурса). (-5 очков)
set /a points-=5

:frag3
echo.
echo Фрагмент 3 (Автоматическое закрытие задач в YouTrack):
echo 30: def archive_old_issues(issues):
echo 31:     for issue in issues:
echo 32:         if issue.days_inactive ^> 90:
echo 33:             issue.state = "Archived"
echo.
echo Какой дефект здесь скрыт?
echo 1. Неинициализированная переменная
echo 2. Мёртвое присваивание
echo 3. Магическое число (90)
choice /c 123 /n
if errorlevel 3 (
    echo Верно! Порог в 90 дней лучше вынести в именованную константу. (+10 очков)
    set /a correct+=1
    set /a points+=10
    goto frag4
)
:wrong3
echo Неверно. Правильный ответ: 3 (Магическое число). (-5 очков)
set /a points-=5

:frag4
echo.
echo Фрагмент 4 (Синхронизация бэклога по REST API):
echo 40: def sync_backlog(api_url, payload):
echo 41:     response = requests.post(api_url, json=payload)
echo 42:     sync_status = "COMPLETED"
echo 43:     return response.status_code
echo.
echo Какой дефект здесь скрыт?
echo 1. Отсутствие обработки ошибок и мёртвое присваивание
echo 2. Утечка ресурса
echo 3. Неинициализированная переменная
choice /c 123 /n
if errorlevel 3 goto wrong4
if errorlevel 2 goto wrong4
if errorlevel 1 (
    echo Верно! Переменная sync_status нигде не используется, а запрос не обернут в try/except. (+10 очков)
    set /a correct+=1
    set /a points+=10
    goto summary2
)
:wrong4
echo Неверно. Правильный ответ: 1 (Отсутствие обработки ошибок / мёртвое присваивание). (-5 очков)
set /a points-=5

:summary2
echo.
echo ===================================================
echo   ИТОГОВЫЙ ОТЧЁТ МОДУЛЯ 2
echo ===================================================
echo Просмотрено фрагментов: %total%
echo Правильных ответов:     %correct% из %total%
echo Набрано баллов:         %points%
set /a percentage=correct*100/total
echo Точность ревью:         %percentage%%%

if %percentage% geq 75 (
    set "MOD2_RESULT=Senior Reviewer"
) else if %percentage% geq 50 (
    set "MOD2_RESULT=Middle Reviewer"
) else (
    set "MOD2_RESULT=Junior Reviewer"
)
echo Уровень ревьюера:       %MOD2_RESULT%
echo.
pause
