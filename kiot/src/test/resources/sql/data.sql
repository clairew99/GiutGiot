insert into member (member_id, nickname, work_start_time, work_end_time, email) values
                                                                             (1, '닉네임', '09:00:00', '18:00:00', 'test@test.com'),
                                                                             (2, '닉네임2', '10:00:00', '19:00:00', 'test2@test.com');

INSERT INTO clothes (clothes_id, is_top, member_id, category, color, pattern, type, weight)
VALUES
    (10001, true, 1, 'SHIRT', 'BLACK', 'STRIPE', 'LONG', 0.05),
    (10002, true, 1, 'BLOUSE', 'WHITE', 'CHECK', 'SHORT', 0.05),
    (10003, true, 1, 'HOODIE', 'GRAY', 'SOLID', 'LONG', 0.05),
    (10004, true, 1, 'SKIRT', 'NAVY', 'FLOWER', 'SHORT', 0.05),
    (10005, true, 1, 'CARGO', 'RED', 'PRINTING', 'LONG', 0.05),
    (10006, true, 1, 'DRESS', 'GREEN', 'DOT', 'SHORT', 0.05),
    (10007, true, 1, 'JEANS', 'YELLOW', 'CHECK', 'LONG', 0.05),
    (10008, true, 1, 'TRAINING', 'BROWN', 'SOLID', 'SHORT', 0.05),
    (10009, true, 1, 'SLACKS', 'IVORY', 'FLOWER', 'LONG', 0.05),
    (10010, true, 1, 'COTTON', 'PURPLE', 'STRIPE', 'SHORT', 0.05),
    (11001, false, 1, 'CARGO', 'RED', 'CHECK', 'SHORT', 0.05),
    (11002, false, 1, 'SLACKS', 'BLACK', 'STRIPE', 'LONG', 0.05),
    (11003, false, 1, 'CARGO', 'BLACK', 'CHECK', 'SHORT', 0.05);




insert into coordinate (member_id, date, top_id, bottom_id, pose)
VALUES
    (1, '2024-06-24', 10006, 11001, 'STANDING'),
    (1, '2024-06-25', 10007, 11002, 'STANDING'),
    (1, '2024-06-26', 10008, 11001, 'STANDING'),
    (1, '2024-06-27', 10007, 11002, 'STANDING'),
    (1, '2024-06-28', 10001, 11003, 'STANDING'),
    -- 세 번째 주
    (1, '2024-07-01', 10002, 11001, 'STANDING'),
    (1, '2024-07-02', 10003, 11002, 'STANDING'),
    (1, '2024-07-03', 10004, 11001, 'STANDING'),
    (1, '2024-07-04', 10005, 11002, 'STANDING'),
    (1, '2024-07-05', 10006, 11003, 'STANDING'),
    -- 네 번째 주
    (1, '2024-07-08', 10007, 11001, 'STANDING'),
    (1, '2024-07-09', 10008, 11002, 'STANDING'),
    (1, '2024-07-10', 10002, 11001, 'STANDING'),
    (1, '2024-07-11', 10001, 11002, 'STANDING'),
    (1, '2024-07-12', 10002, 11003, 'STANDING'),
    -- 다섯 번째 주
    (1, '2024-07-15', 10003, 11001, 'STANDING'),
    (1, '2024-07-16', 10004, 11002, 'STANDING'),
    (1, '2024-07-17', 10005, 11001, 'STANDING'),
    (1, '2024-07-18', 10006, 11002, 'STANDING'),
    (1, '2024-07-19', 10007, 11003, 'STANDING'),
    -- 여섯 번째 주
    (1, '2024-07-22', 10008, 11001, 'STANDING'),
    (1, '2024-07-23', 10004, 11002, 'STANDING'),
    (1, '2024-07-24', 10001, 11001, 'STANDING'),
    (1, '2024-07-25', 10002, 11002, 'STANDING'),
    (1, '2024-07-26', 10003, 11003, 'STANDING'),
    -- 일곱 번째 주
    (1, '2024-07-29', 10004, 11001, 'STANDING'),
    (1, '2024-07-30', 10005, 11002, 'STANDING'),
    (1, '2024-07-31', 10006, 11001, 'STANDING'),
    (1, '2024-08-01', 10001, 11001, 'STANDING'),
    (1, '2024-08-02', 10002, 11002, 'STANDING'),
    -- 마지막 주
    (1, '2024-08-05', 10003, 11001, 'STANDING'),
    (1, '2024-08-06', 10004, 11002, 'STANDING'),
    (1, '2024-08-07', 10005, 11003, 'STANDING'),
    (1, '2024-08-08', 10006, 11001, 'STANDING');

INSERT INTO voice (seq, date, member_id,time)
VALUES
    (1, '2024-08-01', 1, 30),
    (2, '2024-08-01', 1, 15),
    (3, '2024-08-01', 1, 20),
    (1, '2024-08-02', 1, 25),
    (1, '2024-08-01', 2, 40);

INSERT INTO activity (date, member_id, time)
VALUES
    ('2024-08-01', 1, 150),
    ('2024-08-02', 1, 120),
    ('2024-08-01', 2, 180);


