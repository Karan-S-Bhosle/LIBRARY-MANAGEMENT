create database library;
use library;

drop table if exists Books;
drop table if exists Members;
drop table if exists Rental;

-- creating master table books
create table if not exists Books (
	BookID 		int auto_increment,
    Title 		varchar(100),
    Author 		varchar(50),
    Copies_Available int not null,
    primary key (BookID)
    );
alter table Books auto_increment = 1001;

-- creating master table Members
create table if not exists Members (
	MemberID 		int auto_increment ,
    Name			varchar(50),
    Email 			varchar(150) not null unique,
    MembershipDate  date not null,
	primary key (MemberID)
    );
   alter table Members auto_increment =202401;
   select*from Members;
   
   /*creating transactions table rental. this table will contain all the transactions which will occur while rental or return  */
   create table if not exists Rental (
	RentalID 		int auto_increment,
    BookID 			int not null,
    MemberID 		int not null,
    RentalDate 		date not null,
    ReturnDate 		date ,
    foreign key(BookID) references Books(BookID),
    foreign key(MemberID) references Members(MemberID),
    primary key(RentalID),
    unique (BookID,MemberID)
    );
    
    -- inserting values in  master table Books
    INSERT INTO Books (Title, Author, Copies_Available) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 9),
('To Kill a Mockingbird', 'Harper Lee', 8),
('1984', 'George Orwell', 5),
('Pride and Prejudice', 'Jane Austen', 10),
('The Catcher in the Rye', 'J.D. Salinger', 9),
('Moby-Dick', 'Herman Melville', 5),
('War and Peace', 'Leo Tolstoy', 4),
('The Odyssey', 'Homer', 7),
('Crime and Punishment', 'Fyodor Dostoevsky', 6),
('The Brothers Karamazov', 'Fyodor Dostoevsky', 8),
('Brave New World', 'Aldous Huxley', 4),
('Ulysses', 'James Joyce', 3),
('Jane Eyre', 'Charlotte Brontë', 5),
('The Hobbit', 'J.R.R. Tolkien', 9),
('Harry Potter and the Sorcerer\'s Stone', 'J.K. Rowling', 8);

   
   
   -- verifying data in Books
   select*from Books;
   
  
   /* creating stored procedure to insert values in Members 
   it will check if the given email already exists in the table if it exists it will throw out an error
   if it doesnt exist it will add in table along with other input given*/
   delimiter //
   create procedure AddMembers (
		IN v_name 		varchar(50),
		IN v_email 		varchar(150),
		IN v_date 		date)
    begin
    declare message_text varchar(100);
    declare member_email varchar(150) default null;
    
   select Email
    into member_email
    from Members
    where Email = v_email;
    set message_text=' ';
    if (member_email is not null) then 
    signal sqlstate'45000'
    set message_text ='MEMBER ALREADY EXISTS';
    else
    insert into members (Name,Email,MembershipDate)  values(v_name,v_email,v_date);
    set message_text= ('member added sucessfully');
    select message_text;
    end if;
    end;
    //
    delimiter ;
   
  /* adding members using stored procedure*/ 
call AddMembers('sachin','sachin246@gmail.com','2025-01-25');
call AddMembers('dhoni','dhoni246@gmail.com','2025-01-29');
call AddMembers('rohit','rohit446@gmail.com','2025-01-30');
call AddMembers('kohli','kohli1818@gmail.com','2025-02-10');
call AddMembers('dravid','dravid4747@gmail.com','2025-02-20');
call AddMembers('scout','scout1414@gmail.com','2025-02-25');
call AddMembers('ravi','ravi461@gmail.com','2025-02-25');
call AddMembers('disha','disha7945@gmail.com','2025-02-27');  
call AddMembers('neha','neha256@gmail.com','2025-03-01');     
call AddMembers('raju','raju777@gmail.com','2025-02-05');  
call AddMembers('bhim','bhim256@gmail.com','2025-02-06');
 
 
 /*verifying members*/
 select *from Members;
   
   
   /* creating procedure to rent book
   first it will check if there are available copies for rental.if there are no available copies  it will throw out an error.
   next it will check if member id given is valid or not .if it is invalid it will throw out an error.
   else it will rent book sucessfully*/
   delimiter //
   create procedure RentBook
   (IN v_BookID 		int,
    IN v_MemberID		 int,
    IN v_RentalDate 	date,
	IN v_ReturnDate 	date )
    
    begin
    Declare message_text varchar(100);
    Declare copieschk int default 0;
    Declare Memchk int default null ;
    Declare v_Title varchar(50) default null;
    set message_text=' ';
    
    select 		Copies_Available
    into 		copieschk
    from 		books
    where 		Bookid = v_BookID;
    
    select 		MemberID
    into 		Memchk
    from		members
    where 		MemberID = v_MemberID;
    
    select 		Title
    into 		V_title
    from		books
    where 		BookID=v_BookID;
    
    if (copieschk <1) then
		signal sqlstate '45000'
		set message_text ='BOOK UNAVAILABLE';
    
   
   elseif (Memchk is  null) then
		signal sqlstate '45000'
		set message_text ='INVALID MEMBER';
   
   else
			insert into Rental (BookID,MemberID,RentalDate,ReturnDate) values  (v_BookID,v_MemberID,v_RentalDate,v_ReturnDate) ;
            set message_text= concat('Book with title  ',v_title,'  issued sucessfully');
            select message_text;
  end if;
   end;
   //
   delimiter ;
   
/*creating trigger to reduce quantity of books by 1 after each rental ie after each sucessful insert on rental table this trigger will activate and update the book value 
by -1*/
   
   drop trigger if exists Book_Decrement_counter;
   delimiter //
   create trigger Book_Decrement_counter
   after insert on Rental
   for each row
   begin
   update 	Books
   set 		Copies_Available= Copies_Available - 1
   where 	BookID= new.BookID;
  
   end;
   //
   delimiter ;
   
   
     /*renting books using stored procedure*/ 
call RentBook('1001','202401','2025-02-25' , null);
call RentBook('1001','202402','2025-02-27' , null);
call RentBook('1002','202403','2025-03-01' , null);
call RentBook('1003','202404','2025-03-02' , null);
call RentBook('1004','202405','2025-03-03' , null);
call RentBook('1005','202406','2025-03-04' , null);
call RentBook('1006','202407','2025-03-05' , null);
call RentBook('1007','202408','2025-03-07' , null);
call RentBook('1008','202409','2025-03-08' , null);
call RentBook('1009','202410','2025-03-09' , null);
call RentBook('1010','202401','2025-03-10' , null);

/*veryfying data*/
 select * from Rental;
   
   
   /*creating store procedure for returning of book
   first it will check if the rentalID is valid or not.if it is invalid it will throw out an error
   next it will check whether the returndate is after rental date.or else  it will throw out an error .
   next it will check whether the returnDate is before than current date. or else  it will throw out an error
   if above conditions are fulfilled it will return the book sucessfully*/
   drop procedure if exists ReturnBook;
   delimiter //
   create procedure ReturnBook
   ( IN 	v_RentalID 		int,
     IN 	v_ReturnDate 	date)
     begin
     declare message_text varchar(150);
     declare RentalIDchk int default null;
     declare datechk date default null;
     declare Rdate date default null;
     set message_text=' ';
     
     select		 RentalDate
     into 		 datechk
     from		 rental
     where		 RentalID=v_RentalID;
     
     select		 RentalID
     into		 RentalIDchk
     from		 rental 
     where		 RentalID=v_RentalID;
     
     select		 ReturnDate
     into		 Rdate 
     from		 Rental 
     where		 RentalID=v_RentalID;
     
     if (RentalIDchk is null) then
		signal sqlstate '45000'
		set message_text='invalid RentalID';
     end if;
     
	if (Rdate is not null) then 
		signal sqlstate '45000'
		set message_text='book already returned';
	end if;
     
	if datechk is not null and v_Returndate < datechk then
		signal sqlstate '45000'
		set message_text='RETURNDATE CANNOT BE BEFORE RENTDATE';
     
	elseif v_Returndate > curdate() THEN
		signal sqlstate '45000'
		SET message_text='RETURNDATE CANNOT BE BEFORE CURRENT_DATE';
     
	else
		update Rental
		set Returndate = v_Returndate
		where RentalID = v_RentalID;
		set message_text= 'book returned';
		select message_text;
	end if;
	
   
    
   end;
   //
   delimiter ;
   
   
 
    
    /*creating trigger so that quantity of book increases by 1 after each return ie after each sucessful update on return table increase the quantity
    of books by +1*/
   delimiter //
   create trigger Book_Increment_counter
   after update on  Rental
   for each row
   begin
   if old.ReturnDate is null and new.ReturnDate is not null then
   update books
   set Copies_Available= Copies_Available + 1
   where bookID = new.bookID;
   end if ;
   end ;
   //
   delimiter ;

 /*returning books using stored procedure*/
call ReturnBook('1','2025-03-14');
call ReturnBook('2','2025-03-14');
call ReturnBook('3','2025-03-15');
call ReturnBook('4','2025-03-13');
call ReturnBook('5','2025-03-11');
call ReturnBook('6','2025-03-7');
call ReturnBook('7','2025-03-14');
call ReturnBook('8','2025-03-7');
call ReturnBook('9','2025-03-5');
call ReturnBook('10','2025-03-2');
  
  /*veryfying data*/
    select * from Rental;
    
    
/*overdue books... calculate the books which are overdue from their returndate and also calculate their penalty*/

select
		RentalID,
        RentalDate,
        ReturnDate,
	case
        when datediff(coalesce(ReturnDate,curdate()),date_add(RentalDate, interval 7 day))  <0
		then 0
        else datediff(coalesce(ReturnDate,curdate()),date_add(RentalDate, interval 7 day))
       end as delay,
	case 
		when(datediff(coalesce(ReturnDate,curdate()),date_add(RentalDate, interval 7 day)) ) >0
        then (datediff(coalesce(ReturnDate,curdate()),date_add(RentalDate, interval 7 day)) )*5
        else 0
        end as Penalty
      
from Rental;
 
 /* show the  books which are not borrowed */
 
select
			b.BookID,
			b.Title
from		books b
left join   rental r
on			b.BookID=r.Bookid
where 		r.BookID is null;



/*showing each members rental history*/
select 
			m.MemberID,
			m.Name,
			b.BookID,
			b.Title,
			r.RentalDate,
			r.Returndate
from 		members m
left join 	rental r
on 			m.MemberID = r.MemberID
left join 	books b
on			 b.BookID = r. Bookid;
   

   



 