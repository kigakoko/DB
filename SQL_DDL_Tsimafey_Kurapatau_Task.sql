drop table if exists mountaindifficulty cascade;
drop table if exists climbers cascade;
drop table if exists mountains cascade;
drop table if exists weather cascade;
drop table if exists climbs cascade;
drop table if exists climbingpartners cascade;
drop table if exists equipment cascade;
drop table if exists climberequipment cascade;
drop table if exists routes cascade;
drop table if exists climberoutes cascade;

create table mountaindifficulty (
  difficulty_id serial primary key,
  level text not null,
  obstacles text default 'none',
  possible_difficulties text
);

create table climbers (
  climber_id serial primary key,
  full_name text not null unique,
  gender text not null check (gender in ('male', 'female')),
  address text default 'not specified'
);

create table mountains (
  mountain_id serial primary key,
  name text not null,
  height decimal not null check (height >= 0),
  country text not null,
  area text not null,
  difficulty_id int references mountaindifficulty(difficulty_id)
);

create table weather (
  weather_id serial primary key,
  conditions text not null,
  temperature decimal not null,
  date date not null default current_date
);

create table climbs (
  climb_id serial primary key,
  climber_id int references climbers(climber_id),
  mountain_id int references mountains(mountain_id),
  start_date timestamp not null check (start_date > '2000-01-01'),
  end_date timestamp not null,
  duration interval generated always as (end_date - start_date) stored,
  weather_id int references weather(weather_id)
);

create table climbingpartners (
  climbing_partner_id serial primary key,
  climb_id int references climbs(climb_id),
  climber_id int references climbers(climber_id)
);

create table equipment (
  equipment_id serial primary key,
  name text not null,
  quantity int not null default 1,
  description text
);

create table climberequipment (
  climber_equipment_id serial primary key,
  climber_id int references climbers(climber_id),
  equipment_id int references equipment(equipment_id)
);

create table routes (
  route_id serial primary key,
  name text not null,
  difficulty_id int references mountaindifficulty(difficulty_id),
  mountain_id int references mountains(mountain_id)
);

create table climberoutes (
  climber_route_id serial primary key,
  climber_id int references climbers(climber_id),
  route_id int references routes(route_id)
);

-- Add record_ts
alter table mountaindifficulty add column record_ts date default current_date;
alter table climbers add column record_ts date default current_date;
alter table mountains add column record_ts date default current_date;
alter table weather add column record_ts date default current_date;
alter table climbs add column record_ts date default current_date;
alter table climbingpartners add column record_ts date default current_date;
alter table equipment add column record_ts date default current_date;
alter table climberequipment add column record_ts date default current_date;
alter table routes add column record_ts date default current_date;
alter table climberoutes add column record_ts date default current_date;

-- Insert data
insert into climbers (full_name, gender, address) values
  ('Oleg Super', 'male', 'Machulishchy, 2'),
  ('Sasha Puper', 'female', 'Gerosios vilties, 23');

insert into mountaindifficulty (level, obstacles, possible_difficulties) values
  ('Beginner', 'None', 'Easy, Moderate'),
  ('Intermediate', 'Ice cliffs', 'Moderate, Difficult');

insert into mountains (name, height, country, area, difficulty_id) values
  ('Mount Everest', 8848.86, 'Nepal', 'Himalayas', 1),
  ('K2', 8611, 'Pakistan', 'Karakoram', 2);

insert into weather (conditions, temperature, date) values
  ('Clear Sky', 5, '2023-01-05'),
  ('Snowing', -6, '2023-02-20');

insert into climbs (climber_id, mountain_id, start_date, end_date, weather_id) values
  (1, 1, '2000-01-01 08:00:00', '2023-01-10 14:30:00', 1),
  (2, 2, '2000-01-15 10:00:00', '2023-02-25 16:45:00', 2);

insert into climbingpartners (climb_id, climber_id) values
  (1, 2),
  (2, 1);

insert into equipment (name, quantity, description) values
  ('Climbing Rope', 5, 'Dynamic rope for safety'),
  ('Ice Axe', 10, 'Essential tool for ice climbing');

insert into climberequipment (climber_id, equipment_id) values
  (1, 1),
  (2, 2);

insert into routes (name, difficulty_id, mountain_id) values
  ('North Col Route', 1, 1),
  ('Abruzzi Spur', 2, 2);

insert into climberoutes (climber_id, route_id) values
  (1, 1),
  (2, 2);


select * from climbers;
select * from mountaindifficulty;
select * from mountains;
select * from weather;
select * from climbs;
select * from climbingpartners;
select * from equipment;
select * from climberequipment;
select * from routes;
select * from climberoutes;
