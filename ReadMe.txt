---------------------------------------------------------------------------------------------

Сборка в MS Window XP, MS Windows 7:

Для сборки и запуска проекта необходимо, чтобы папки _INSTALL_PATH_ERLANG_/bin _INSTALL_PATH_YAWS_/bin и были указаны в системной переменной среды PATH.

(1) Запустить build.bat
(2) Результат сборки папка build

   - build\server: Сервер 

       - build\server\ebin: beam-файлы 
       - build\server\priv: yaws-файлы
       - build\server\include: конфигурационные файлы 

   - build\generators: Тестовые генераторы
       - build\generators\ebin: beam-файлы 
       - build\generators\include: конфигурационный файл

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Запуск:

Запуск сервера:
(1) В дериктории  build\server выполнить run.bat
(2) В открывшемся терминале запустить тестовый сервер: erl> application:start(test).

Остановка и настройка тестового сервера:
(3) Для остановки тестового сервера необходимо выполнить: erl> application:stop(test).
(4) Для задания новой конфигурации (N - число выводимых последовательностей) необходимо отредактировать файл  build\generators\include\settings.ini 
    и выполнить: erl> test_server:config().  
	
Запуск генераторов:
(1) В дериктории  build\generators выполнить run.bat
(2) В открывшемся терминале запустить генераторы erl> Pids = generators:start( "http://localhost:8080/number/", CountGenerators ) . 
(3) Для остановки - generators:stop(Pid).
 
Ответы тестового сервера будут сохраняться в файлах build\generators\logs\GenXXX.log отдельно для каждого генератора
   
---------------------------------------------------------------------------------------------------
Ручное тестирование:

(1) curl.exe -X GET http://localhost:8080/numbers/ - запрос на получение отчета (список последовательностей)
(1) curl.exe -X PUT -d "value=_IntegerValue_" http://localhost:8080/number/ - отправка числа IntegerValue   
(Например, 
    curl.exe -X GET http://localhost:8080/numbers/ 
  или 
    curl.exe -X PUT -d "value=15" http://localhost:8080/number/ 	 
)

----------------------------------------------------------------------------------------------------

Используемые инструметы:

(1) Erlang ( otp_win32_R14B01 )
(2) Yaws ( Yaws-1.89-windows )


   
   
   
      


	  