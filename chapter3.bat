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

set /a score_y=y_1*w1+y_2*w2+y_3*w3
set /a score_r=r_1*w1+r_2*w2+r_3*w3
set /a score_t=t_1*w1+t_2*w2+t_3*w3

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
