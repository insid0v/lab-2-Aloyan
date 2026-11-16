@echo off
chcp 65001 > nul
set score_youtrack=0
set score_redmine=0
set score_taiga=0

echo ===================================================
echo   МОДУЛЬ 1: ВЫБОР СИСТЕМЫ ОТСЛЕЖИВАНИЯ ЗАДАЧ
echo ===================================================
echo.

echo Вопрос 1: Какой бюджет выделен на трекер для команды из 12 человек?
echo 1. Готовы платить за коммерческий продукт или расширенные лицензии
echo 2. Нужен строго бесплатный инструмент с открытым исходным кодом (Open Source)
echo 3. Есть небольшой бюджет, но важен бесплатный базовый тариф (до 10-15 юзеров)
choice /c 123 /n
if errorlevel 3 set /a score_youtrack+=10 & set /a score_taiga+=10
if errorlevel 2 set /a score_redmine+=15 & set /a score_taiga+=15
if errorlevel 1 set /a score_youtrack+=15
echo.

echo Вопрос 2: Насколько важна встроенная поддержка Scrum (бэклог, спринты, диаграммы сгорания)?
echo 1. Критически важна (нужны готовые Agile-доски из коробки)
echo 2. Достаточно базового канбана и списка задач (гибкая настройка под себя)
echo 3. Нужен строгий учет времени и диаграммы Ганта важнее Scrum
choice /c 123 /n
if errorlevel 3 set /a score_redmine+=15
if errorlevel 2 set /a score_redmine+=10 & set /a score_youtrack+=5
if errorlevel 1 set /a score_taiga+=15 & set /a score_youtrack+=15
echo.

echo Вопрос 3: Какая инфраструктура и администрирование предпочтительнее?
echo 1. Облачное решение (SaaS), чтобы не тратить время на поддержку сервера
echo 2. Собственный сервер (Self-hosted), есть администратор для настройки Ruby/DB
echo 3. Нужна быстрая установка в Docker или готовый облачный вариант
choice /c 123 /n
if errorlevel 3 set /a score_taiga+=15 & set /a score_youtrack+=10
if errorlevel 2 set /a score_redmine+=15
if errorlevel 1 set /a score_youtrack+=15 & set /a score_taiga+=10
echo.

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
