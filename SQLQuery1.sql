use master
create database mypro
on primary
(name = mypro,
filename = "D:\mypro.mdf",
size = 5,
maxsize = unlimited,
filegrowth = 2
)
log on
(name = myprolog,
filename = "D:\myprolog.ldf",
size = 5,
maxsize = unlimited,
filegrowth = 2
)
use mypro
create table Apps
(
APP_ID int primary key not null,
APP_Name_ varchar(1000),
APP_description varchar(8000),
APP_primary_category_ID int,
APP_category varchar(1000)
)
create table Reviews
(
APP_ID int not null,
Reviewer_Name varchar(2000),
Rating int,
Review_Title varchar(2000),
Review_Content varchar(max)
)

/*对原表进行备份*/
select * into cpy_Apps from Apps;
select * into cpy_Reviews from Reviews;

select * from Apps;/*筛选前7214条记录*/
select * from Reviews;/*筛选前164670条记录*/

/*删除cpy_Apps表中非英文的元组*/
/*没有英文字母：262条记录*/
select * from cpy_Apps where cpy_Apps.APP_description not like '%[a-zA-Z]%' or cpy_Apps.APP_Name_ not like '%[a-zA-Z]%'
delete from cpy_Apps where cpy_Apps.APP_description not like '%[a-zA-Z]%' or cpy_Apps.APP_Name_ not like '%[a-zA-Z]%'
/*中文乱码：550条记录*/
select * from cpy_Apps where patindex('%[吖-座]%',cpy_Apps.APP_Name_) > 0 or patindex('%[吖-座]%',cpy_Apps.APP_description) > 0
delete from cpy_Apps where patindex('%[吖-座]%',cpy_Apps.APP_Name_) > 0 or patindex('%[吖-座]%',cpy_Apps.APP_description) > 0 
/*大量文字不能识别：162条记录*/
select * from cpy_Apps where cpy_Apps.APP_description like '%?????%';
delete from cpy_Apps where cpy_Apps.APP_description like '%?????%';
/*含常见音标的字母：331条记录*/
select * from cpy_Apps where cpy_Apps.APP_description like '%à%' or cpy_Apps.APP_description like '%ó%' or cpy_Apps.APP_description like '%ú%'or cpy_Apps.APP_description like '%é%';
delete from cpy_Apps where cpy_Apps.APP_description like '%à%' or cpy_Apps.APP_description like '%ó%' or cpy_Apps.APP_description like '%ú%'or cpy_Apps.APP_description like '%é%';
select * from cpy_Apps;/*筛选后有5909条记录*/

/*删除cpy_Reviews表中非英文的元组*/
/*没有英文字母：4445条记录*/
select * from cpy_Reviews where cpy_Reviews.Review_Content not like '%[a-zA-Z]%' or cpy_Reviews.Reviewer_Name not like '%[a-zA-Z]%'
delete from cpy_Reviews where cpy_Reviews.Review_Content not like '%[a-zA-Z]%' or cpy_Reviews.Reviewer_Name not like '%[a-zA-Z]%'
/*中文乱码：158条记录*/
select * from cpy_Reviews where patindex('%[吖-座]%',cpy_Reviews.Review_Content) > 0 or patindex('%[吖-座]%',cpy_Reviews.Reviewer_Name) > 0
delete from cpy_Reviews where patindex('%[吖-座]%',cpy_Reviews.Review_Content) > 0 or patindex('%[吖-座]%',cpy_Reviews.Reviewer_Name) > 0 
/*大量文字不能识别：1069条记录*/
select * from cpy_Reviews where cpy_Reviews.Review_Content like '%?????%';
delete from cpy_Reviews where cpy_Reviews.Review_Content like '%?????%';
/*含常见音标的字母：1470条记录*/
select * from cpy_Reviews where cpy_Reviews.Review_Content like '%à%' or cpy_Reviews.Review_Content like '%ó%' or cpy_Reviews.Review_Content like '%ú%' or cpy_Reviews.Review_Content like '%é%';
delete from cpy_Reviews where cpy_Reviews.Review_Content like '%à%' or cpy_Reviews.Review_Content like '%ó%' or cpy_Reviews.Review_Content like '%ú%' or cpy_Reviews.Review_Content like '%é%';
select * from cpy_Reviews;/*筛选后有157528条记录*/


/*统计有多少个APP有用户评论*/
select count (distinct cpy_Reviews.APP_ID) from cpy_Reviews /*共1616条记录*/

/*筛选有用户评论的app*/
select count(distinct cpy_Apps.APP_ID) from cpy_Apps,cpy_Reviews where cpy_Reviews.APP_ID = cpy_Apps.APP_ID/*共1507条记录*/

/*对筛选表进行备份*/
select * into cpy_Apps_1 from cpy_Apps;
select * into cpy_Reviews_1 from cpy_Reviews;

/*在Reviews表中删除 ‘Reviews表中有用户评论，但在APP表中没有对应的app’ 的记录*/
select count (distinct cpy_Reviews_1.APP_ID) from cpy_Reviews_1 where cpy_Reviews_1.APP_ID not in (select cpy_Apps_1.APP_ID from cpy_Apps_1)/*109个app无效*/
select count (cpy_Reviews_1.APP_ID) from cpy_Reviews_1 where cpy_Reviews_1.APP_ID not in (select cpy_Apps_1.APP_ID from cpy_Apps_1)/*3827条评论无效*/
delete from cpy_Reviews_1 where cpy_Reviews_1.APP_ID not in (select cpy_Apps_1.APP_ID from cpy_Apps_1)/*删除了3827条无效评论记录*/
select * from cpy_Reviews_1;/*153701*/

/*在APP表中删除 ‘Apps表中有app，但在Review表中没有对应的评论’ 的记录*/
select count (cpy_Apps_1.APP_ID) from cpy_Apps_1 where cpy_Apps_1.APP_ID not in (select cpy_Reviews_1.APP_ID from cpy_Reviews_1)/*4402个app无效*/
delete from cpy_Apps_1 where cpy_Apps_1.APP_ID not in (select cpy_Reviews_1.APP_ID from cpy_Reviews_1)/*删除了4402个无效app*/
select * from cpy_Apps_1;/*1507*/

/*对处理完成的表进行备份，app和评论相对应*/
select * into new_Apps from cpy_Apps_1;
select * into new_Reviews from cpy_Reviews_1;

/*每个app的评论数量为*/
select count(new_Reviews.APP_ID) as a from new_Reviews group by new_Reviews.APP_ID order by a desc

/*随机抽取记录进行分类*/
select top 500 * from new_Reviews order by newid()


use mypro
create table test
(
APP_ID int not null,
Reviewer_Name varchar(2000),
Rating int,
Review_Title varchar(2000),
Review_Content varchar(max),
classes varchar(100)
)
select * from test

Bulk  insert  test
From  'C:\Users\dell-pc\Desktop\feedback.txt'
With
(   fieldterminator='	',
	rowterminator='\n'
)

ALTER TABLE test ADD old_ast int null; /*增加ast标记列*/