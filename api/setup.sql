create database plantshop;
use plantshop;

create table items (
  id int not null auto_increment,
  name varchar(255) not null,
  description varchar(255) not null,
  price int not null,
  primary key (id)
);

insert into items (name, description, price) values ("Strawberry", "A strawberry plant.", 5);
insert into items (name, description, price) values ("Raphidophora", "Also called monstera minima.", 25);
insert into items (name, description, price) values ("Aloe Vera", "Produces a medicinal gel.", 9);
insert into items (name, description, price) values ("Watermelon seeds", "A packet of watermelon seeds.", 1);
insert into items (name, description, price) values ("Iresine", "Also called bloodleaf due to its red leaves.", 9);
insert into items (name, description, price) values ("String of Pearls", "A small succulent plant.", 5);

create user 'plantshop' identified with mysql_native_password by '6qNaYDdq3pBc34';
grant select on plantshop.items to plantshop;
