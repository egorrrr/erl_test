---------------------------------------------------------------------------------------------

������ � MS Window XP, MS Windows 7:

��� ������ � ������� ������� ����������, ����� ����� _INSTALL_PATH_ERLANG_/bin _INSTALL_PATH_YAWS_/bin � ���� ������� � ��������� ���������� ����� PATH.

(1) ��������� build.bat
(2) ��������� ������ ����� build

   - build\server: ������ 

       - build\server\ebin: beam-����� 
       - build\server\priv: yaws-�����
       - build\server\include: ���������������� ����� 

   - build\generators: �������� ����������
       - build\generators\ebin: beam-����� 
       - build\generators\include: ���������������� ����

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
������:

������ �������:
(1) � ����������  build\server ��������� run.bat
(2) � ����������� ��������� ��������� �������� ������: erl> application:start(test).

��������� � ��������� ��������� �������:
(3) ��� ��������� ��������� ������� ���������� ���������: erl> application:stop(test).
(4) ��� ������� ����� ������������ (N - ����� ��������� �������������������) ���������� ��������������� ����  build\generators\include\settings.ini 
    � ���������: erl> test_server:config().  
	
������ �����������:
(1) � ����������  build\generators ��������� run.bat
(2) � ����������� ��������� ��������� ���������� erl> Pids = generators:start( "http://localhost:8080/number/", CountGenerators ) . 
(3) ��� ��������� - generators:stop(Pid).
 
������ ��������� ������� ����� ����������� � ������ build\generators\logs\GenXXX.log �������� ��� ������� ����������
   
---------------------------------------------------------------------------------------------------
������ ������������:

(1) curl.exe -X GET http://localhost:8080/numbers/ - ������ �� ��������� ������ (������ �������������������)
(1) curl.exe -X PUT -d "value=_IntegerValue_" http://localhost:8080/number/ - �������� ����� IntegerValue   
(��������, 
    curl.exe -X GET http://localhost:8080/numbers/ 
  ��� 
    curl.exe -X PUT -d "value=15" http://localhost:8080/number/ 	 
)

----------------------------------------------------------------------------------------------------

������������ ����������:

(1) Erlang ( otp_win32_R14B01 )
(2) Yaws ( Yaws-1.89-windows )


   
   
   
      


	  