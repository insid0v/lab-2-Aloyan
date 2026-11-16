### Модуль 1: Выбор системы отслеживания задач (`chapter1.bat`)
Модуль реализует интерактивную систему принятия решений. Пользователю последовательно задаются 4 вопроса о бюджете, поддержке Scrum, предпочтительной инфраструктуре и интеграции с IDE/Git через команду `choice`. С помощью `set /a` начисляются баллы кандидатам (`YouTrack`, `Redmine`, `Taiga`), после чего условными операторами `if` определяется и выводится рекомендуемый таск-трекер.

```bat
@echo off
chcp 65001 > nul
set score_youtrack=0
set score_redmine=0
set score_taiga=0

echo ===================================================
echo   МОДУЛЬ 1: ВЫБОР СИСТЕМЫ ОТСЛЕЖИВАНИЯ ЗАДАЧ
echo ===================================================
echo.

REM Вопрос 1: Оценка бюджета команды
echo Вопрос 1: Какой бюджет выделен на трекер для команды из 12 человек?
echo 1. Готовы платить за коммерческий продукт или расширенные лицензии
echo 2. Нужен строго бесплатный инструмент с открытым исходным кодом (Open Source)
echo 3. Есть небольшой бюджет, но важен бесплатный базовый тариф (до 10-15 юзеров)
choice /c 123 /n
if errorlevel 3 set /a score_youtrack+=10 & set /a score_taiga+=10
if errorlevel 2 set /a score_redmine+=15 & set /a score_taiga+=15
if errorlevel 1 set /a score_youtrack+=15
echo.

REM Вопрос 2: Потребность в методологии Scrum
echo Вопрос 2: Насколько важна встроенная поддержка Scrum (бэклог, спринты, диаграммы сгорания)?
echo 1. Критически важна (нужны готовые Agile-доски из коробки)
echo 2. Достаточно базового канбана и списка задач (гибкая настройка под себя)
echo 3. Нужен строгий учет времени и диаграммы Ганта важнее Scrum
choice /c 123 /n
if errorlevel 3 set /a score_redmine+=15
if errorlevel 2 set /a score_redmine+=10 & set /a score_youtrack+=5
if errorlevel 1 set /a score_taiga+=15 & set /a score_youtrack+=15
echo.

REM Вопрос 3: Выбор способа развертывания
echo Вопрос 3: Какая инфраструктура и администрирование предпочтительнее?
echo 1. Облачное решение (SaaS), чтобы не тратить время на поддержку сервера
echo 2. Собственный сервер (Self-hosted), есть администратор для настройки Ruby/DB
echo 3. Нужна быстрая установка в Docker или готовый облачный вариант
choice /c 123 /n
if errorlevel 3 set /a score_taiga+=15 & set /a score_youtrack+=10
if errorlevel 2 set /a score_redmine+=15
if errorlevel 1 set /a score_youtrack+=15 & set /a score_taiga+=10
echo.

REM Вопрос 4: Интеграция с инструментами разработки
echo Вопрос 4: Насколько важна тесная интеграция с IDE и системами контроля версий (Git)?
echo 1. Максимально важна (умный поиск, команды в коммитах, связь с JetBrains)
echo 2. Достаточно базовых вебхуков и привязки коммитов по ID задачи
choice /c 12 /n
if errorlevel 2 set /a score_redmine+=10 & set /a score_taiga+=10
if errorlevel 1 set /a score_youtrack+=20
echo.

echo --- Результаты оценки ---
echo YouTrack: %score_youtrack% баллов
echo Redmine:  %score_redmine% баллов
echo Taiga:    %score_taiga% баллов
echo.

REM Сравнение набранных баллов и сохранение результата в переменную MOD1_RESULT
if %score_youtrack% geq %score_redmine% if %score_youtrack% geq %score_taiga% (
    set "MOD1_RESULT=YouTrack"
    goto show_res1
)
if %score_redmine% geq %score_youtrack% if %score_redmine% geq %score_taiga% (
    set "MOD1_RESULT=Redmine"
    goto show_res1
)
set "MOD1_RESULT=Taiga"

:show_res1
echo Рекомендация для вашей команды: %MOD1_RESULT%
echo.
pause
```

**Результат работы Модуля 1:**  
<img width="974" height="591" alt="image" src="https://github.com/user-attachments/assets/28b2008e-7a57-4771-b235-9f66625e1ac8" />



---

### Модуль 2: Инспекция кода (`chapter2.bat`)
Модуль симулирует процесс код-ревью на примере 4 фрагментов Python-кода, связанных с работой API таск-трекеров. За каждый найденный дефект (неинициализированная переменная, утечка ресурса, магическое число, мёртвое присваивание/отсутствие обработки ошибок) начисляется `+10` очков, за ошибку снимается `-5` очков. В финале вычисляется процент точности и присваивается грейд ревьюера (`Junior`, `Middle` или `Senior Reviewer`).

```bat
@echo off
chcp 65001 > nul
set correct=0
set points=0
set total=4

echo ===================================================
echo   МОДУЛЬ 2: ИНСПЕКЦИЯ КОДА (API ТАСК-ТРЕКЕРОВ)
echo ===================================================
echo.

REM Фрагмент 1: Проверка инициализации переменной
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
REM Фрагмент 2: Проверка закрытия файлового дескриптора
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
REM Фрагмент 3: Проверка использования констант
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
REM Фрагмент 4: Проверка исключений и неиспользуемых переменных
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

REM Определение уровня ревьюера на основе процента точности
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
```

**Результат работы Модуля 2:**  
<img width="974" height="551" alt="image" src="https://github.com/user-attachments/assets/a15e8449-f9eb-4c9d-968a-ff71cff0234e" />


---

### Модуль 3: Сравнительный анализ альтернатив (`chapter3.bat`)
Модуль реализует многокритериальный анализ методом взвешенной суммы (WSM). Пользователь вводит веса для 3 критериев (программа проверяет, чтобы их сумма равнялась 100), после чего оценивает каждую систему по 5-балльной шкале. Скрипт рассчитывает итоговые баллы по формуле $S = \sum(W \times X)$, строит таблицу-матрицу решений и определяет победителя.

```bat
@echo off
chcp 65001 > nul
:start_wsm
echo ===================================================
echo   МОДУЛЬ 3: СРАВНИТЕЛЬНЫЙ АНАЛИЗ (МЕТОД WSM)
echo ===================================================
echo.
echo Назначьте веса критериям (сумма должна быть равна 100):
set /p w1="Вес критерия 1 (Удобство Scrum-досок и Agile-инструментов): "
set /p w2="Вес критерия 2 (Стоимость владения для 12 человек): "
set /p w3="Вес критерия 3 (Простота настройки и интеграции): "

REM Проверка корректности суммы весов
set /a total_weight=w1+w2+w3
if %total_weight% neq 100 (
    echo.
    echo [Ошибка] Сумма весов равна %total_weight%, а должна быть 100! Попробуйте снова.
    echo.
    goto start_wsm
)

echo.
echo Оцените каждую систему по шкале от 1 до 5:
echo --- YouTrack ---
set /p y_1="YouTrack - Scrum и Agile (1-5): "
set /p y_2="YouTrack - Стоимость (1-5): "
set /p y_3="YouTrack - Настройка и интеграции (1-5): "
echo --- Redmine ---
set /p r_1="Redmine - Scrum и Agile (1-5): "
set /p r_2="Redmine - Стоимость (1-5): "
set /p r_3="Redmine - Настройка и интеграции (1-5): "
echo --- Taiga ---
set /p t_1="Taiga - Scrum и Agile (1-5): "
set /p t_2="Taiga - Стоимость (1-5): "
set /p t_3="Taiga - Настройка и интеграции (1-5): "
REM Расчет взвешенной суммы S = sum(W * X)
set /a score_y=y_1w1+y_2w2+y_3w3
set /a score_r=r_1w1+r_2w2+r_3w3
set /a score_t=t_1w1+t_2w2+t_3*w3
echo.
echo ===================================================
echo   МАТРИЦА РЕШЕНИЙ (WSM)
echo ===================================================
echo Критерий             ^| Вес ^| YouTrack ^| Redmine ^| Taiga
echo ---------------------+-----+----------+---------+-------
echo Scrum и Agile        ^| %w1%  ^|    %y_1%     ^|    %r_1%    ^|   %t_1%
echo Стоимость владения   ^| %w2%  ^|    %y_2%     ^|    %r_2%    ^|   %t_2%
echo Настройка/Интеграции ^| %w3%  ^|    %y_3%     ^|    %r_3%    ^|   %t_3%
echo ---------------------+-----+----------+---------+-------
echo ИТОГОВЫЙ БАЛЛ        ^| 100 ^|   %score_y%    ^|   %score_r%   ^|  %score_t%
echo.
if %score_y% geq %score_r% if %score_y% geq %score_t% (
set "MOD3_RESULT=YouTrack (%score_y% баллов)"
goto win3
)
if %score_r% geq %score_y% if %score_r% geq %score_t% (
set "MOD3_RESULT=Redmine (%score_r% баллов)"
goto win3
)
set "MOD3_RESULT=Taiga (%score_t% баллов)"
:win3
echo Победитель сравнительного анализа: %MOD3_RESULT%
echo.
pause
```
Результат работы Модуля 3:
<img width="872" height="720" alt="image" src="https://github.com/user-attachments/assets/e18ff686-d4bd-4a9d-ba67-ccda3668b051" />


Главный управляющий файл (lab_system.bat)

Главный модуль объединяет все три скрипта в единую систему через меню выбора. Вызов подпрограмм реализован с помощью команды call, что позволяет сохранять переменные окружения (MOD1_RESULT, MOD2_RESULT, MOD3_RESULT) в едином пространстве и формировать сводный файл отчёта report.txt при выборе пункта 4.
```bat
@echo off
chcp 65001 > nul
set "MOD1_RESULT=Не запускался"
set "MOD2_RESULT=Не запускался"
set "MOD3_RESULT=Не запускался"
:menu
cls
echo ===================================================
echo   СИСТЕМА МОДЕЛИРОВАНИЯ ПРОЦЕССОВ РАЗРАБОТКИ ПО
echo   Вариант 5: Выбор системы отслеживания задач
echo ===================================================
echo.
echo 1. Модуль выбора технологий (chapter1.bat)
echo 2. Модуль инспекции кода (chapter2.bat)
echo 3. Модуль сравнительного анализа (chapter3.bat)
echo 4. Запустить все модули последовательно
echo 5. Выход
echo.
set /p choice="Ваш выбор (1-5): "
if "%choice%"=="1" (
cls
call chapter1.bat
)
if "%choice%"=="2" (
cls
call chapter2.bat
)
if "%choice%"=="3" (
cls
call chapter3.bat
)
if "%choice%"=="4" (
cls
call chapter1.bat
cls
call chapter2.bat
cls
call chapter3.bat
cls
echo ===================================================
echo   ИТОГОВЫЙ ОТЧЁТ СИСТЕМЫ (ВАРИАНТ 5)
echo ===================================================
echo Все модули успешно пройдены.
echo.
echo 1. Рекомендация по выбору трекера: %MOD1_RESULT%
echo 2. Уровень ревьюера кода:         %MOD2_RESULT%
echo 3. Победитель анализа WSM:         %MOD3_RESULT%
echo.
echo Результаты сохранены в файл report.txt
echo ===================================================
REM Вывод сводного отчета в текстовый файл report.txt
(
echo ===================================================
echo   ИТОГОВЫЙ ОТЧЁТ СИСТЕМЫ ПРИНЯТИЯ РЕШЕНИЙ
echo   Вариант 5: Выбор системы отслеживания задач
echo ===================================================
echo Дата формирования: %date% %time%
echo.
echo Модуль 1 ^(Выбор технологии^): %MOD1_RESULT%
echo Модуль 2 ^(Уровень ревьюера^): %MOD2_RESULT%
echo Модуль 3 ^(Победитель WSM^):   %MOD3_RESULT%
echo ===================================================
) > report.txt
pause
)
if "%choice%"=="5" exit
goto menu
```

2. Работа интегрированной системы

Главное меню программы (lab_system.bat):

<img width="471" height="219" alt="image" src="https://github.com/user-attachments/assets/c680789e-d382-4420-b601-df0b15613611" />

Последовательное прохождение всех модулей и итоговый отчёт (пункт 4):
<img width="791" height="462" alt="image" src="https://github.com/user-attachments/assets/b19cca85-d5fd-4d3a-815a-1e50900b4167" />


Описание результатов запуска:

1. Какие диалоги и вопросы задавались:
	• В первом модуле система опросила пользователя по 4 параметрам: бюджет команды из 12 человек, необходимость встроенных инструментов Scrum, предпочтительный способ хостинга (SaaS или Self-hosted) и важность глубокой интеграции с IDE/Git.
	• Во втором модуле последовательно выводились 4 фрагмента кода на Python (расчёт скорости спринта, экспорт задач в CSV, архивация старых задач и синхронизация по REST API) с предложением выбрать тип скрытого дефекта.
	• В третьем модуле запрашивались веса трёх критериев (суммарно 100 баллов) и экспертные оценки каждой из систем по шкале от 1 до 5.
2. Сформированные рекомендации:
	• По итогам первого модуля наибольшее количество баллов (80) набрал YouTrack.
	• По итогам инспекции кода точность составила 50% (2 из 4 верных ответов, 10 баллов), что соответствует уровню Middle Reviewer.
	• По итогам метода взвешенной суммы (WSM) с заданными весами (2, 50, 48) победителем также стал YouTrack с итоговым баллом 354 (против 256 у Taiga и 194 у Redmine).
3. Итоговый отчёт системы:
	• После завершения третьего модуля главный скрипт очистил экран, агрегировал результаты всех трёх подпрограмм в единую сводку на экране и автоматически записал её с текущей датой и временем в файл report.txt.
4. Впечатления от работы с системой:
	• Модульная архитектура на базе командных файлов Windows (.bat) оказалась удобной для формализации инженерных задач: каждый этап принятия решения изолирован и может тестироваться отдельно, а использование команды call позволяет легко объединить их в единый конвейер без потери данных между скриптами. Комбинация двух методов выбора (анкетирования и WSM) помогает избежать субъективности при выборе инструментов для команды.

## 3. Инструкция по запуску для пользователя


1. Скачайте все файлы репозитория (lab_system.bat, chapter1.bat, chapter2.bat, chapter3.bat) в одну общую папку на компьютере под управлением ОС Windows (например, скачав архив через кнопку Code → Download ZIP и распаковав его).
2. Убедитесь, что все четыре .bat-файла находятся в одной директории, иначе главный скрипт не сможет вызвать дочерние модули.
3. Запустите главный файл lab_system.bat двойным кликом левой кнопки мыши.
4. В открывшемся консольном меню введите цифру от 1 до 4 и нажмите Enter:
	• 1–3 — запуск любого модуля по отдельности.
	• 4 — полное последовательное прохождение всех модулей с формированием итогового отчёта в файле report.txt (появится в той же папке).
	• 5 — выход из программы.
