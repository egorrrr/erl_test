������ ������:
 
������ ������ ������������������ � ets [ordered_set] (Tab), 
������� ������������������ (����������� ������� ��� �� ����������) �������� � ������ (SEQ)
����� � ����� ����� ������������������� � Tab (ETS_SIZE) � ����� SEQ (SEQ_SIZE)

��������� Tab ����-��������: {Seq_Size, ID} - Seq,
��� Seq ������������������, Seq_Size - � �����, ID - �������� �� 1 �� N.

��� ������ ����������� ������� ������������������ SEQ, 
��� ������� ��� ����� �������� ������������������ ShortInTab � Tab �� ������� SEQ 
�� Tab ��������� ShortInTab
(ets:first, ��� ��� {SeqSize1, ID1} < {SeqSize2, ID2}, ���� SeqSize1 < SeqSize2) 
� �� "� �����" (ID) ��������� �������
( ets:insert(Tab, {{SEQ_SIZE, ID}, SEQ) )

�.�. � ������ ��������� ets �� �� ����� ��� N ��� ���� {{Seq_Size, ID}, Seq}
� ��� ���� ������ SEQ.

��� ������� ������ N (test_server:config() ) 
���� OldN < NewN �������� ������ ������������ ������ Tab (MAX_ETS_SIZE) 
���� OldN > NewN, �� Tab �����������������: ��������� OldN - NewN ����� �������� ������������������� �
���������� �������� ID ���������� ������������������� ��� ����� ID < NewN.

�������� �������:

test_app        - OTP application behaviour.
test_supervisor - OTP supervisor behaviour.
test_server     - OTP gen_server behaviour.
test_settings   - ������ ���� ������������ settings.ini
test_utils      - ����� ���������� �������� ��������� Tab � SEQ
test_yaws       - ����� �������� (G�T/PUT), ����� ������� test_server, 
                  ����� ������ � ������ �� ��������� ���������� ����� 



  