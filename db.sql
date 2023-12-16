SELECT
    row_number() OVER () as id,
    name_first_male as first_name,
    concat(last_name_part1) as second_name,
    last_name_part2 as last_name,
    birth_date,
    (random() * (12 - 0.4) + 0.4, 2) as weight,
    SUM(weight) OVER (PARTITION BY EXTRACT(MONTH FROM birth_date)) AS all_in_month,
    md5(concat(name_first_male, ' ', last_name_part1, ' ', last_name_part2)) as birth_date_hash
FROM (
    SELECT
        (
            SELECT concat('', string_agg(y,'')) as name_first_male
            FROM (
                SELECT start_arr[1 + ((random() * 100)::int) % 33]
                FROM (
                    SELECT '{Александр,Иван,Михаил,Дмитрий,Андрей,Сергей,Николай,Владимир,Павел,Алексей,Егор,Григорий,Василий,Ярослав,Тимофей,Кирилл,Федор,Даниил,Роман,Олег,Виктор,Артем,Виталий,Евгений,Максим,Никита,Игорь,Олександр,Игор,Антон,Валентин,Валерий,Степан,Леонид,Арсений,Глеб,Денис,Захар,Лев,Руслан,Станислав,Тарас,Филипп,Эдуард,Юрий,Давид,Семен,Вадим,Георгий,Назарий}'::text[] as start_arr
                ) syllarr,
                generate_series(1, 1 + ((generator::int % 3) * (random() * 0.5))::int % 3)
            ) AS con_name_male(y)
        ) as name_first_male,
        (
            SELECT concat(last_name_part1a, last_char) as last_name_part1
            FROM (
                SELECT initcap(concat(string_agg(z1,''))) as last_name_part1a
                FROM (
                    SELECT last_arr[1 + ((random() * 100 + (generator * 0))::int) % 35]
                    FROM (
                        SELECT '{Смирнов,Иванов,Кузнецов,Попов,Соколов,Лебедев,Козлов,Новиков,Морозов,Петров,Волков,Соловьев,Васильев,Зайцев,Павлов,Семенов,Голубев,Виноградов,Богданов,Воробьев,Федоров,Михайлов,Беляев,Тарасов,Белов,Комаров,Орлов,Киселев,Макаров,Андреев,Ковалев,Ильин,Гусев,Титов,Кузьмин,Кудрявцев,Баранов,Куликов,Алексеев,Степанов,Яковлев,Сорокин,Сергеев,Романов,Захаров,Борисов,Королев,Герасимов,Пономарев}'::text[] as last_arr
                    ) sub1,
                    generate_series(1, 1 + (generator * 0))
                ) AS con_name_first(z1)
            ) sub2,
            (
                SELECT last_last[1 + ((random() * 10 + (generator * 0))::int) % 6] as last_char
                FROM (
                    SELECT '{ов,ев,ин,ын,их,ый}'::text[] as last_last
                ) sub3
            ) sub4
        ) as last_name_part1,
        (
            SELECT part_arr[1 + ((random() * 100 + (generator * 0))::int) % 50] as last_name_part2
            FROM (
                SELECT '{Иванович,Петрович,Сергеевич,Александрович,Дмитриевич,Алексеевич,Андреевич,Аркадьевич,Борисович,Валентинович,Валерьевич,Васильевич,Викторович,Владимирович,Владиславович,Всеволодович,Геннадьевич,Георгиевич,Григорьевич,Давидович,Данилович,Денисович,Евгеньевич,Егорович,Ефимович,Захарович,Игнатьевич,Игоревич,Ильич,Иосифович,Константинович,Леонидович,Львович,Макарович,Максимович,Маркович,Матвеевич,Михайлович,Николаевич,Олегович,Павлович,Робертович,Романович,Семенович,Сергеевич,Станиславович,Степанович,Тарасович,Тимофеевич,Федорович,Юрьевич}'::text[] as part_arr
            ) sub
        ) as last_name_part2,
        DATE_TRUNC('year', CURRENT_DATE) + RANDOM() * (CURRENT_DATE - DATE_TRUNC('year', CURRENT_DATE)) as birth_date,
        RANDOM() * (12 - 0.4) + 0.4 as weight
    FROM generate_series(1, 500) as generator
) as main_sub
ORDER BY first_name DESC, second_name DESC, last_name DESC
LIMIT 500;
