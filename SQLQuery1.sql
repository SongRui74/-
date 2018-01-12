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

/*��ԭ����б���*/
select * into cpy_Apps from Apps;
select * into cpy_Reviews from Reviews;

select * from Apps;/*ɸѡǰ7214����¼*/
select * from Reviews;/*ɸѡǰ164670����¼*/

/*ɾ��cpy_Apps���з�Ӣ�ĵ�Ԫ��*/
/*û��Ӣ����ĸ��262����¼*/
select * from cpy_Apps where cpy_Apps.APP_description not like '%[a-zA-Z]%' or cpy_Apps.APP_Name_ not like '%[a-zA-Z]%'
delete from cpy_Apps where cpy_Apps.APP_description not like '%[a-zA-Z]%' or cpy_Apps.APP_Name_ not like '%[a-zA-Z]%'
/*�������룺550����¼*/
select * from cpy_Apps where patindex('%[߹-��]%',cpy_Apps.APP_Name_) > 0 or patindex('%[߹-��]%',cpy_Apps.APP_description) > 0
delete from cpy_Apps where patindex('%[߹-��]%',cpy_Apps.APP_Name_) > 0 or patindex('%[߹-��]%',cpy_Apps.APP_description) > 0 
/*�������ֲ���ʶ��162����¼*/
select * from cpy_Apps where cpy_Apps.APP_description like '%?????%';
delete from cpy_Apps where cpy_Apps.APP_description like '%?????%';
/*�������������ĸ��331����¼*/
select * from cpy_Apps where cpy_Apps.APP_description like '%��%' or cpy_Apps.APP_description like '%��%' or cpy_Apps.APP_description like '%��%'or cpy_Apps.APP_description like '%��%';
delete from cpy_Apps where cpy_Apps.APP_description like '%��%' or cpy_Apps.APP_description like '%��%' or cpy_Apps.APP_description like '%��%'or cpy_Apps.APP_description like '%��%';
select * from cpy_Apps;/*ɸѡ����5909����¼*/

/*ɾ��cpy_Reviews���з�Ӣ�ĵ�Ԫ��*/
/*û��Ӣ����ĸ��4445����¼*/
select * from cpy_Reviews where cpy_Reviews.Review_Content not like '%[a-zA-Z]%' or cpy_Reviews.Reviewer_Name not like '%[a-zA-Z]%'
delete from cpy_Reviews where cpy_Reviews.Review_Content not like '%[a-zA-Z]%' or cpy_Reviews.Reviewer_Name not like '%[a-zA-Z]%'
/*�������룺158����¼*/
select * from cpy_Reviews where patindex('%[߹-��]%',cpy_Reviews.Review_Content) > 0 or patindex('%[߹-��]%',cpy_Reviews.Reviewer_Name) > 0
delete from cpy_Reviews where patindex('%[߹-��]%',cpy_Reviews.Review_Content) > 0 or patindex('%[߹-��]%',cpy_Reviews.Reviewer_Name) > 0 
/*�������ֲ���ʶ��1069����¼*/
select * from cpy_Reviews where cpy_Reviews.Review_Content like '%?????%';
delete from cpy_Reviews where cpy_Reviews.Review_Content like '%?????%';
/*�������������ĸ��1470����¼*/
select * from cpy_Reviews where cpy_Reviews.Review_Content like '%��%' or cpy_Reviews.Review_Content like '%��%' or cpy_Reviews.Review_Content like '%��%' or cpy_Reviews.Review_Content like '%��%';
delete from cpy_Reviews where cpy_Reviews.Review_Content like '%��%' or cpy_Reviews.Review_Content like '%��%' or cpy_Reviews.Review_Content like '%��%' or cpy_Reviews.Review_Content like '%��%';
select * from cpy_Reviews;/*ɸѡ����157528����¼*/


/*ͳ���ж��ٸ�APP���û�����*/
select count (distinct cpy_Reviews.APP_ID) from cpy_Reviews /*��1616����¼*/

/*ɸѡ���û����۵�app*/
select count(distinct cpy_Apps.APP_ID) from cpy_Apps,cpy_Reviews where cpy_Reviews.APP_ID = cpy_Apps.APP_ID/*��1507����¼*/

/*��ɸѡ����б���*/
select * into cpy_Apps_1 from cpy_Apps;
select * into cpy_Reviews_1 from cpy_Reviews;

/*��Reviews����ɾ�� ��Reviews�������û����ۣ�����APP����û�ж�Ӧ��app�� �ļ�¼*/
select count (distinct cpy_Reviews_1.APP_ID) from cpy_Reviews_1 where cpy_Reviews_1.APP_ID not in (select cpy_Apps_1.APP_ID from cpy_Apps_1)/*109��app��Ч*/
select count (cpy_Reviews_1.APP_ID) from cpy_Reviews_1 where cpy_Reviews_1.APP_ID not in (select cpy_Apps_1.APP_ID from cpy_Apps_1)/*3827��������Ч*/
delete from cpy_Reviews_1 where cpy_Reviews_1.APP_ID not in (select cpy_Apps_1.APP_ID from cpy_Apps_1)/*ɾ����3827����Ч���ۼ�¼*/
select * from cpy_Reviews_1;/*153701*/

/*��APP����ɾ�� ��Apps������app������Review����û�ж�Ӧ�����ۡ� �ļ�¼*/
select count (cpy_Apps_1.APP_ID) from cpy_Apps_1 where cpy_Apps_1.APP_ID not in (select cpy_Reviews_1.APP_ID from cpy_Reviews_1)/*4402��app��Ч*/
delete from cpy_Apps_1 where cpy_Apps_1.APP_ID not in (select cpy_Reviews_1.APP_ID from cpy_Reviews_1)/*ɾ����4402����Чapp*/
select * from cpy_Apps_1;/*1507*/

/*�Դ�����ɵı���б��ݣ�app���������Ӧ*/
select * into new_Apps from cpy_Apps_1;
select * into new_Reviews from cpy_Reviews_1;

/*ÿ��app����������Ϊ*/
select count(new_Reviews.APP_ID) as a from new_Reviews group by new_Reviews.APP_ID order by a desc

/*�����ȡ��¼���з���*/
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

ALTER TABLE test ADD old_ast int null; /*����ast�����*/