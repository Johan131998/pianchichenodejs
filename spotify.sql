create schema if not exists spotify collate utf8_general_ci;

use spotify;


create table if not exists ads
(
	ads_id int not null
		primary key,
	ads_frecuency int null
);

create table if not exists account_type
(
	account_type_id int not null
		primary key,
	account_type_name varchar(45) null,
	ads_id int null,
	constraint account_type_ibfk_1
		foreign key (ads_id) references ads (ads_id)
);

create index ads_id_idx
	on account_type (ads_id);

create table if not exists artist
(
	artist_id int not null
		primary key,
	name varchar(25) null,
	followers int null
);

create table if not exists albums
(
	album_id int not null
		primary key,
	title varchar(45) null,
	year varchar(45) null,
	artist_id int null,
	constraint albums_ibfk_1
		foreign key (artist_id) references artist (artist_id)
);

create index artist_id_idx
	on albums (artist_id);

create table if not exists genres
(
	genre_id int not null
		primary key,
	name varchar(15) null
);

create table if not exists tracks
(
	track_id int not null
		primary key,
	title varchar(15) null,
	album_id int null,
	genre_id int null,
	track_type varchar(45) null,
	constraint tracks_ibfk_1
		foreign key (album_id) references albums (album_id),
	constraint tracks_ibfk_2
		foreign key (genre_id) references genres (genre_id)
);

create index album_id_idx
	on tracks (album_id);

create index genre_id_idx
	on tracks (genre_id);

create table if not exists user_role
(
	user_role_id int not null
		primary key,
	user_role_name varchar(45) null
);

create table if not exists user
(
	user_id int not null
		primary key,
	user_name varchar(10) null,
	`e-mail` varchar(25) null,
	password varchar(15) null,
	first_name varchar(45) null,
	last_name varchar(45) null,
	birthdate date null,
	country varchar(15) null,
	user_role_id int null,
	account_type_id int null,
	constraint user_ibfk_1
		foreign key (user_role_id) references user_role (user_role_id),
	constraint user_ibfk_2
		foreign key (account_type_id) references account_type (account_type_id)
);

create table if not exists favorite_tracks
(
	favorite_id int not null
		primary key,
	user_id int null,
	constraint favorite_tracks_ibfk_1
		foreign key (user_id) references user (user_id)
);

create index user_id_idx
	on favorite_tracks (user_id);

create table if not exists favorites_tracks_list
(
	track_id int not null,
	favorite_id int not null,
	primary key (track_id, favorite_id),
	constraint favorites_tracks_list_ibfk_1
		foreign key (track_id) references tracks (track_id),
	constraint favorites_tracks_list_ibfk_2
		foreign key (favorite_id) references favorite_tracks (favorite_id)
);

create index favorite_id_idx
	on favorites_tracks_list (favorite_id);

create table if not exists log
(
	log_id int not null
		primary key,
	login_time timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
	user_id int null,
	tiempo_salida int null,
	deslogeo timestamp default '1970-01-01 00:00:01' not null,
	constraint log_ibfk_1
		foreign key (user_id) references user (user_id)
);

create index user_id_idx
	on log (user_id);

create table if not exists payment
(
	payment_id int not null
		primary key,
	user_id int null,
	payment_token varchar(45) null,
	constraint payment_ibfk_1
		foreign key (user_id) references user (user_id)
);

create index user_id_idx
	on payment (user_id);

create table if not exists played_tracks
(
	played_tracks_id int not null
		primary key,
	track_id int not null,
	user_id int not null,
	constraint played_tracks_ibfk_1
		foreign key (track_id) references tracks (track_id),
	constraint played_tracks_ibfk_2
		foreign key (user_id) references user (user_id)
);

create index track_id
	on played_tracks (track_id);

create index user_id_idx
	on played_tracks (user_id);

create table if not exists playlists
(
	playlist_id int not null
		primary key,
	name varchar(15) null,
	user_id int null,
	constraint playlists_ibfk_1
		foreign key (user_id) references user (user_id)
);

create table if not exists playlist_track
(
	playlist_id int not null,
	track_id int not null,
	primary key (track_id, playlist_id),
	constraint playlist_track_ibfk_1
		foreign key (playlist_id) references playlists (playlist_id),
	constraint playlist_track_ibfk_2
		foreign key (track_id) references tracks (track_id)
);

create index playlist_id
	on playlist_track (playlist_id);

create index track_id_idx
	on playlist_track (track_id);

create index user_id_idx
	on playlists (user_id);

create index account_type_id_idx
	on user (account_type_id);

create index user_role_id_idx
	on user (user_role_id);

create or replace definer = root@`%` view vista1 as select `spotify`.`user`.`first_name`   AS `first_name`,
       `spotify`.`log`.`deslogeo`      AS `deslogeo`,
       `spotify`.`log`.`tiempo_salida` AS `tiempo_salida`
from `spotify`.`user`
         join `spotify`.`log`
where (`spotify`.`user`.`user_id` = `spotify`.`log`.`user_id`);

create or replace definer = root@`%` view vista2 as select `spotify`.`tracks`.`title`                          AS `Cancion`,
       `spotify`.`albums`.`title`                          AS `Album`,
       `spotify`.`artist`.`name`                           AS `Artista`,
       count(`spotify`.`played_tracks`.`track_id`)         AS `Reproducciones_totales`,
       count(distinct `spotify`.`played_tracks`.`user_id`) AS `Reproducciones_usuarios_diferentes`
from `spotify`.`tracks`
         join `spotify`.`played_tracks`
         join `spotify`.`albums`
         join `spotify`.`artist`
         join `spotify`.`user`
where ((`spotify`.`artist`.`artist_id` = `spotify`.`albums`.`artist_id`) and
       (`spotify`.`albums`.`album_id` = `spotify`.`tracks`.`album_id`) and
       (`spotify`.`tracks`.`track_id` = `spotify`.`played_tracks`.`track_id`) and
       (`spotify`.`user`.`user_id` = `spotify`.`played_tracks`.`user_id`))
group by `spotify`.`played_tracks`.`track_id`
order by `Reproducciones_totales` desc;

create or replace definer = root@`%` view vista3 as select `spotify`.`user`.`user_name` AS `user_name`, `spotify`.`user`.`country` AS `country`
from `spotify`.`user`
where (`spotify`.`user`.`country` like 'a%');

