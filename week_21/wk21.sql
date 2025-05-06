create or replace temporary table hero_powers (
hero_name VARCHAR(50),
flight VARCHAR(50),
laser_eyes VARCHAR(50),
invisibility VARCHAR(50),
invincibility VARCHAR(50),
psychic VARCHAR(50),
magic VARCHAR(50),
super_speed VARCHAR(50),
super_strength VARCHAR(50)
);
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Impossible Guard', '++', '-', '-', '-', '-', '-', '-', '+');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Clever Daggers', '-', '+', '-', '-', '-', '-', '-', '++');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Quick Jackal', '+', '-', '++', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Steel Spy', '-', '++', '-', '-', '+', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Agent Thundering Sage', '++', '+', '-', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Mister Unarmed Genius', '-', '-', '-', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Doctor Galactic Spectacle', '-', '-', '-', '++', '-', '-', '-', '+');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Master Rapid Illusionist', '-', '-', '-', '-', '++', '-', '+', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Galactic Gargoyle', '+', '-', '-', '-', '-', '-', '++', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Alley Cat', '-', '++', '-', '-', '-', '-', '-', '+');


-- -- desired schema:
-- hero_name
-- main_superpower (++)
-- secondary_superpower (+)

with hero_powers_clean as (
    select hero_name
    , case
        when flight = '++' then 'flight' 
        when laser_eyes = '++' then 'laser_eyes'
        when invisibility = '++' then 'invisibillity'
        when invincibility = '++' then 'invincibility'
        when psychic = '++' then 'psychic'
        when magic = '++' then 'magic'
        when super_speed = '++' then 'super_speed'
        when super_strength = '++' then 'super_strength'
        else null
        end as main_superpower
    , case
        when flight = '+' then 'flight' 
        when laser_eyes = '+' then 'laser_eyes'
        when invisibility = '+' then 'invisibility'
        when invincibility = '+' then 'invincibility'
        when psychic = '+' then 'psychic'
        when magic = '+' then 'magic'
        when super_speed = '+' then 'super_speed'
        when super_strength = '+' then 'super_strength'
        else null
        end as secondary_superpower
    from hero_powers
)
select hero_name, upper(main_superpower) as main_superpower, upper(secondary_superpower)
from hero_powers_clean;