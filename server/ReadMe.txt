Логика работы:
 
Сервер хранит последовательности в ets [ordered_set] (Tab), 
текущая последовательность (возрастание которой ещё не оборвалось) хранится в списке (SEQ)
Также я храню число последовательностей в Tab (ETS_SIZE) и длину SEQ (SEQ_SIZE)

структура Tab ключ-значение: {Seq_Size, ID} - Seq,
где Seq последовательность, Seq_Size - её длина, ID - значение от 1 до N.

При обрыве возрастания текущей последовательности SEQ, 
при условии что самая короткая последовательность ShortInTab в Tab не длиннее SEQ 
из Tab удаляется ShortInTab
(ets:first, так как {SeqSize1, ID1} < {SeqSize2, ID2}, если SeqSize1 < SeqSize2) 
и на "её место" (ID) заносится текущая
( ets:insert(Tab, {{SEQ_SIZE, ID}, SEQ) )

Т.е. в памяти храниться ets из не более чем N пар вида {{Seq_Size, ID}, Seq}
и ещё один список SEQ.

При задании нового N (test_server:config() ) 
если OldN < NewN меняется только максимальный размер Tab (MAX_ETS_SIZE) 
если OldN > NewN, то Tab переформатируется: удаляются OldN - NewN самых коротких последовательностей и
изменяются значения ID оставшихся последовательностей так чтобы ID < NewN.

Описание модулей:

test_app        - OTP application behaviour.
test_supervisor - OTP supervisor behaviour.
test_server     - OTP gen_server behaviour.
test_settings   - читает файл конфигурации settings.ini
test_utils      - здесь происходит основная обработка Tab и SEQ
test_yaws       - прием запросов (GЕT/PUT), вызов функций test_server, 
                  вывод отчета и отклик на получении очередного числа 



  