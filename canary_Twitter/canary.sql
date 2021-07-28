create schema canary;
create table canary.users  (
	firstname  varchar(20) not null,
    lastname varchar(20) not null,
    username varchar (20) not null,
	user_pass varchar(128) not null,
    register_date date,
    birthday date,
    biography varchar(64),
    primary key (username)
    );
    
 create table canary.ava(
		username varchar(20) not null,
        ava_con varchar (256) not null,
        send_date datetime not null DEFAULT CURRENT_TIMESTAMP,
		parrent int,
        ID int not null AUTO_INCREMENT,
        primary key(ID) ,
        foreign key (username) references users(username),
        foreign key (parrent) references ava(ID)
        );
        
  create table canary.messages(
		ID int not null auto_increment,
        type_con int not null,
		sender varchar(20) not null,
        reciever varchar(20) not null,
        pm varchar(256),
        ava_id int,
		send_date datetime not null DEFAULT CURRENT_TIMESTAMP,
        primary key(ID),
		foreign key(ava_id) references ava(ID),
        foreign key(sender) references users(username),
		foreign key(reciever) references users(username)
        );
        
        
    
        
          create table canary.hashtag(
		content char(6) not null,
        primary key (content)
        );
        create table canary.logintime(
	id int not null auto_increment, 
	username varchar(20),
    login_time datetime not null DEFAULT CURRENT_TIMESTAMP, 
    primary key(id),
    foreign key (username) references users(username)
    );
    create table canary.followings (
	follower varchar(20) not null,
    followed varchar(20)not null,
    foreign key (follower) references users(username),
	foreign key (followed) references users(username)
    );
create table canary.blocks(
blocker varchar(20) not null,
blocked varchar(20) not null,
foreign key (blocker) references users(username),
foreign key (blocked) references users(username)
);

        create table canary.ava_hash(
	ava_id int not null,
    hashtag varchar(6) not null,
    foreign key (hashtag) references hashtag(content),
    foreign key (ava_id) references ava(ID)
    );
    create table canary.likes(
username varchar(20),
ava_id int,
foreign key(username) references users(username),
foreign key(ava_id) references ava(ID)
);
create table canary.ava_username_id(
	 username varchar(20) not null,
    id int not null,
            send_date datetime not null,
foreign key (username) references users(username),
        foreign key (id) references ava(id)
            );


create table canary.log_register (
	username varchar(20) not null,
    register_date date not null,
    foreign key(username) references users(username)
    );
    
    create trigger canary.log_registerr
after insert on canary.users
for each row
	insert into canary.log_register values(new.username,new.register_date);

    create trigger canary.ava_username_idd
after insert on canary.ava
for each row
	insert into canary.ava_username_id(username,id,send_date)
    SELECT username,id,send_date FROM canary.ava
ORDER BY id DESC  
LIMIT 1; 


delimiter //
create procedure canary.register ( in firstname varchar(20),in lastname varchar(20),in username varchar(20),in user_pass varchar(128),in birthday date, in biography varchar(64))
begin
insert into canary.users values(firstname,lastname,username,sha1(user_pass) ,now(),birthday,biography);
insert into logintime (username) values (username);

end;

//

create procedure canary.login (in username3 varchar(20),in user_pass2 varchar(128))
begin
call canary.last_login(@username2);
if username3 in (select username from users)and sha1(user_pass2) in (select user_pass from users where username3=users.username) and username3 <> @username2
then
	insert into logintime (username) values (username3);
end if;
end;
//
create procedure canary.user_logins (in username2 varchar(20))
begin 
SELECT login_time FROM canary.logintime
where username=username2
order by id desc;
end;

//
create procedure canary.send_ava (in ava_con2 varchar(256))
begin
insert into ava(username,ava_con)
select username,ava_con2
from logintime
ORDER BY id DESC  
LIMIT 1; 
end;
//
create procedure canary.find_personal_ava()
begin
set @username2=(SELECT username FROM logintime
ORDER BY id DESC  
LIMIT 1 );
select id,ava_con from ava where username=@username2;

end;
//

    create procedure canary.follow_action(in tofollow varchar(20))
    begin 
    call canary.last_login(@username2);
    if tofollow not in(select followed from followings where follower=@username2)and tofollow <> @username2 and tofollow in (select username from users)
    then
    insert into followings values (@username2,tofollow);
    end if;
        end;
        //
		create procedure canary.delete_following(in todelete varchar(20))
begin
call canary.last_login(@username2);
delete from followings where follower=@username2 and followed=todelete;
end ;
//
create procedure canary.block(in blocking varchar(20))
begin
call canary.last_login(@username2);
        if blocking not in(select blocked from blocks where blocker=@username2)and blocking <> @username2 and blocking in (select username from users)
        then
            insert into blocks values (@username2,blocking);
            end if;
            end;
            //

    	create procedure canary.delete_blockings(in todelete varchar(20))
begin
call canary.last_login(@username2);
delete from blocks where blocker=@username2 and blocked=todelete;
end ;
//
	create procedure canary.find_followings_ava()
begin
call canary.last_login(@username2);
select ava_con,send_date from ava
 where ava.username in (select followed from followings where follower=@username2)
 and ava.username not in (select blocker from blocks where blocked = @username2)
 order by send_date desc;
end ;
//
	create procedure canary.find_someone_ava(in someone varchar(20))
begin
call canary.last_login(@username2);
select ava_con,send_date from ava
  where ava.username=someone and ava.username not in (select blocker from blocks where blocked = @username2)
 order by send_date desc;
end ;
//
	create procedure canary.comment_action(in comment_in varchar(256),in ava_id2 int)
begin
call canary.last_login(@username2);
set @username3=(select username from ava where ava.id=ava_id2);
insert into canary.ava(username,ava_con,send_date,parrent)
select @username2,comment_in,now(),ID
	from canary.ava
    where ava.id=ava_id2 and username=@username3 and @username2 not in (select blocked from canary.blocks where blocker=@username3);
    
end ;
//
	create procedure canary.find_comments_ava(in ava_id2 int)
begin
call canary.last_login(@username2);
set @username3=(select username from ava where ava.id=ava_id2);
	select ava_con,username from canary.ava where parrent=ava_id2 and 
     @username2 not in (select blocked from canary.blocks where blocks.blocker=@username3)and 
@username2 not in (select blocked from canary.blocks inner join (select t.username from canary.ava inner join canary.ava as t on ava.parrent=t.id and ava.parrent=ava_id2) as neww 
on blocks.blocker=neww.username);
end ;
//
	create procedure canary.find_hashtag_ava(in hashtag2 char(6))
begin
call canary.last_login(@username2);
	select ava_con,send_date,username
	from ava inner join ava_hash on ava.ID=ava_hash.ava_id
    where hashtag=hashtag2 and ava.username not in (select blocker from blocks where blocked=@username2)
		order by send_date desc;
end ;
//
delimiter //
CREATE trigger canary.hashtags
 after insert on canary.ava
 for each row
 begin
  set @ava=(SELECT ava_con FROM ava
	ORDER BY id DESC  
	LIMIT 1 );
    set @id=(SELECT id FROM ava
	ORDER BY id DESC  
	LIMIT 1 );
    set @tosearch ='#' ;
set @no=(SELECT (CHAR_LENGTH (@ava)-CHAR_LENGTH (REPLACE(@ava,@tosearch,'')))/CHAR_LENGTH (@tosearch));
  while @no > 0 do
   
    
    set @hashtag1=(SELECT SUBSTRING(@ava , locate("#",@ava), 6));
    if @hashtag1 not in (select * from hashtag) then
    insert into hashtag values (@hashtag1);
    end if;
    insert into ava_hash values (@id,@hashtag1);
  
	 set @ava=(SELECT SUBSTRING(@ava , locate("#",@ava)+1, 257));
set @tosearch ='#' ;
set @no=(SELECT (CHAR_LENGTH (@ava)-CHAR_LENGTH (REPLACE(@ava,@tosearch,'')))/CHAR_LENGTH (@tosearch));
  
  end while;
END //


 delimiter //
 
  create procedure canary.like_action(in ava_id2 int)
begin
call canary.last_login(@username2);
     if  @username2 not in(select blocked from blocks where blocker=@username3) and ava_id2 not in (select ava_id from likes where likes.username =@username2) then
			insert into likes  values(@username2,ava_id2);
		end if;		
end ;

//
		create procedure canary.likes_count(in ava_id2 int)
begin
call canary.last_login(@username2);
set @username3=(select username from ava where ava.id=ava_id2);
     if  @username2 not in(select blocked from blocks where blocker=@username3)  then
	select coalesce(count(ava_id),0)
	from likes where ava_id=ava_id2;
    else
		select "0";
        end if;
	 
end ;

//
create procedure canary.who_likes(in ava_id2 int)
begin
call canary.last_login(@username2);
set @username3=(select username from ava where ava.id=ava_id2);
     if  @username2 not in(select blocked from blocks where blocker=@username3)  then
		select likes.username from likes inner join ava on likes.ava_id=ava.ID
		where likes.ava_id=ava_id2 and @username2 not in (select blocked from blocks where blocker=@username3) and ava.username=@username3 and
		likes.username  not in (select blocker from blocks inner join likes on blocks.blocker=likes.username where blocked=@username2);
    else
		select " ";
        end if;
	 
end ;

//
     create procedure canary.trend_ava()
begin
call canary.last_login(@username2);

select ava.ava_con,count(ava_id) from likes right join ava on likes.ava_id=ava.ID
	where @username2 not in (select blocked from blocks where blocker=ava.username)
	group by id order by count(ava_id) desc; 
	 
end ;
        create procedure canary.send_pm(in typee int,in username3 varchar(20),in pm_con2 varchar(256),in ava_id2 int)
begin
call canary.last_login(@username2);
	if typee="0" and username3 <> @username2 then
    insert into messages(type_con,sender,reciever,pm,ava_id)
	select "0",@username2,username3,pm_con2,null
		where @username2 not in (select blocked from blocks where blocker=username3);
	elseif typee="1" and username3 <> @username2 then
    insert into messages(type_con,sender,reciever,pm,ava_id)
	select "1",@username2,username3,null,ava_id2
		where @username2 not in (select blocked from blocks where blocker=username3)
			and @username2 not in (select blocked from blocks inner join ava on blocks.blocker=ava.username where ava.ID=ava_id2);
            end if;
end ;

//
       create procedure canary.find_who_message()
begin
call canary.last_login(@username2);
 select sender,send_date from (
select sender,messages.send_date as send_Date from messages where type_con="0" and reciever=@username2 union
select sender,messages.send_date from messages left outer join ava on messages.ava_id=ava.ID where type_con="1" and reciever=@username2 and ava.username 
not in (select blocker from blocks inner join ava on blocks.blocker=ava.username where blocked=@username2) ) as message_new INNER JOIN
    (SELECT sender as send1, MAx(send_date) AS MaxDateTime
    FROM  (
select sender,messages.send_date as send_Date from messages where type_con="0" and reciever=@username2 union
select sender,messages.send_date from messages left outer join ava on messages.ava_id=ava.ID where type_con="1" and reciever=@username2 and ava.username 
not in (select blocker from blocks inner join ava on blocks.blocker=ava.username where blocked=@username2) ) as message_new2
    GROUP BY sender)as groupedtt 
ON message_new.sender = groupedtt.send1
AND message_new.send_date = groupedtt.MaxDateTime
	order by send_date desc;
end ;

//
 create procedure canary.find_someone_messages(in username3 varchar(20))
begin
call canary.last_login(@username2);
(select pm,messages.ava_id,messages.send_date from messages where type_con="0" and reciever=@username2 and sender=username3 union
select pm,messages.ava_id,messages.send_date from messages left outer join ava on messages.ava_id=ava.ID where type_con="1" and reciever=@username2 and sender=username3 and ava.username 
not in (select blocker from blocks inner join ava on blocks.blocker=ava.username where blocked=@username2))
order by send_date desc;
end ;

create procedure canary.last_login (out username2 varchar(20))
begin
 SELECT username into username2 FROM logintime 
ORDER BY id DESC  
LIMIT 1 ;
end;

//