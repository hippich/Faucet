CREATE TABLE facebook (
  token       varchar(256) PRIMARY KEY, 
  username    varchar(256),
  ip          varchar(16),
  address     varchar(64),
  first_name  varchar(256),
  last_name   varchar(256),
  link        varchar(1024),
  id          int,
  gender      varchar(16),
  hometown    varchar(256),
  hometown_id int,
  location    varchar(256),
  location_id int,
  timezone    varchar(10),
  time        int
);

CREATE INDEX facebook_ip ON facebook (ip);
CREATE INDEX facebook_id ON facebook (id);
CREATE INDEX facebook_token_time ON facebook (token, time);