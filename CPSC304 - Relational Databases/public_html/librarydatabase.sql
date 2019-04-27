
drop table book;
drop table movie;
drop table cashPayment;
drop table cardPayment;
drop table lateFee; 
drop table reservation;
drop table renewal;
drop table return; 
drop table loan;
drop table accountRecord;
drop table material; 
drop table librarian; 
drop table patron;

commit;


CREATE TABLE patron ( 
  lid int,
  name varchar(255),
  email varchar(255) UNIQUE,
  address varchar(255),
  PRIMARY KEY (lid));

grant select on patron to public;

CREATE TABLE librarian (
  employeeID int PRIMARY KEY,
  name varchar(255));

grant select on librarian to public;

CREATE TABLE material (
  callNum varchar(6) PRIMARY KEY,
  genre varchar(20),
  title varchar(255),
  condition varchar(3),
  availability varchar(1),
  cost int,
  employeeID int,
  type varchar(20),
  foreign key (employeeID) references librarian ON DELETE SET NULL);

grant select on material to public;

CREATE TABLE book (
  callNum varchar(255) PRIMARY KEY,
  isbn int,
  author varchar(255),
  publisher varchar(255),
  edition int,
  foreign key (callNum) references material ON DELETE CASCADE);

grant select on book to public;

CREATE TABLE movie (
  callNum varchar(255) PRIMARY KEY,
  director varchar(255),
  releaseDate varchar(255),
  foreign key (callNum) references material ON DELETE CASCADE);

grant select on movie to public;

CREATE TABLE accountRecord (
  rid int PRIMARY KEY,
  lid int not null,
  dated int,                      --changed from 'date' to 'dated' due to 'date' being a data type
  -- lateFeeAmount int,
  -- returnDate int,
  -- daysOverdue int,
  -- resHeldUntil int,
  callNum varchar(255) not null,
  employeeID int,
  UNIQUE (rid, lid),
  UNIQUE (rid, callNum),
  foreign key (lid) references patron ON DELETE CASCADE,
  foreign key (callNum) references material ON DELETE SET NULL,
  foreign key (employeeID) references librarian ON DELETE SET NULL);

grant select on accountRecord to public;

CREATE TABLE loan (
  rid int PRIMARY KEY,
  daysOverdue int,
  returnDate varchar(255),
  feeID int,
  foreign key (rid) references accountRecord ON DELETE CASCADE,
  foreign key (feeID) references accountRecord(rid) ON DELETE SET NULL);

grant select on loan to public;
--remember to update daysoverdue and return date when renewing
CREATE TABLE renewal (
  rid int PRIMARY KEY,
  foreign key (rid) references accountRecord ON DELETE CASCADE);

grant select on renewal to public;

CREATE TABLE reservation (
  rid int PRIMARY KEY,
  heldUntil int,
  loanRID int UNIQUE,
  foreign key (rid) references accountRecord ON DELETE CASCADE,
  foreign key (loanRID) references accountRecord(rid) ON DELETE CASCADE);

grant select on reservation to public;
--have to update daysOverdue
CREATE TABLE return (
  rid int PRIMARY KEY,
  loanRID int NOT NULL,
  foreign key (rid) references accountRecord ON DELETE CASCADE,
  foreign key (loanRID) references accountRecord ON DELETE CASCADE, 
  UNIQUE(loanRID));

grant select on return to public;

CREATE TABLE lateFee (
  rid int PRIMARY KEY,
  amount int,
  paymentRID int,
  foreign key (rid) references accountRecord ON DELETE CASCADE,
  foreign key (paymentRID) references accountRecord ON DELETE CASCADE,
  UNIQUE(paymentRID));

grant select on lateFee to public;

CREATE TABLE cashPayment (
  rid int primary key,
  amount int,
  foreign key (rid) references accountRecord ON DELETE CASCADE);

grant select on cashPayment to public;

CREATE TABLE cardPayment (
  rid int PRIMARY KEY,
  amount int,
  cardNum varchar(255),
  csv varchar(255),
  expDate varchar(255),
  type varchar(255),
  foreign key (rid) references accountRecord ON DELETE CASCADE);

grant select on cardPayment to public;

commit;

INSERT INTO patron VALUES (51000,'Cassandra Davis','nibh.sit@vitae.ca','Ap #751-8626 Luctus, Ave');
INSERT INTO patron VALUES (10000,'Arsenio Hayes','scelerisque.neque@ametdapibusid.org','Ap #539-5600 Hendrerit Av.');
INSERT INTO patron VALUES (15000,'Declan Juarez','Ut@etmalesuadafames.net','1054 Nisl. St.');
INSERT INTO patron VALUES (20000,'Claire Morris','claire.m@coolemail.co.uk','182-9470 A, Av.');
INSERT INTO patron VALUES (25000,'Dumas Morris','malesuada.vel@semperNam.co.uk','182-9470 A, Av.');
INSERT INTO patron VALUES (30000,'Jackson Kennedy','interdum.feugiat.Sed@ullamcorper.ca','Ap #722-9629 Sed Rd.');
INSERT INTO patron VALUES (35000,'Wang Rodriguez','at.lacus@tinciduntorciquis.net','P.O. Box 425, 9340 Sed Ave');
INSERT INTO patron VALUES (40000,'Theodore Noble','Aliquam.fringilla@egestasFuscealiquet.org','P.O. Box 131, 9465 Nec Road');
INSERT INTO patron VALUES (45000,'Gisela Sutton','Etiam.imperdiet.dictum@malesuadaIntegerid.ca','Ap #294-5082 Amet Rd.');
INSERT INTO patron VALUES (50000,'Rhiannon Kramer','elit.dictum@scelerisquedui.com','261-8506 Magna St.');
INSERT INTO patron VALUES (55000,'Aquila Sanchez','felis.ullamcorper.viverra@in.net','373-9773 Integer Street');
INSERT INTO patron VALUES (60000,'Jackson Kennedy','pellentesque.a@sedconsequatauctor.com','Ap #674-6650 Natoque Av.');
INSERT INTO patron VALUES (65000,'Chelsea Hunt','dictum.sapien.Aenean@eueratsemper.org','449-3064 Sit Ave');
INSERT INTO patron VALUES (70000,'Aurelia Hines','metus.In@cursus.edu','P.O. Box 280, 152 Nunc Rd.');
INSERT INTO patron VALUES (75000,'Quamar Gonzales','euismod.ac.fermentum@NullaaliquetProin.com','Ap #770-9967 Nunc, Avenue');
INSERT INTO patron VALUES (80000,'Ava Whitney','at.lacus.Quisque@malesuada.co.uk','Ap #567-9777 Luctus Rd.');
INSERT INTO patron VALUES (85000,'Madaline Aguilar','nascetur.ridiculus@Phasellusfermentum.net','606-649 Nulla St.');
INSERT INTO patron VALUES (90000,'Melyssa Watts','lobortis.ultrices@senectusetnetus.net','620-4604 Ac Ave');
INSERT INTO patron VALUES (95000,'Lila Skinner','ipsum.primis@commodohendreritDonec.net','Ap #801-5411 Mauris Rd.');
INSERT INTO patron VALUES (11000,'Winter Reynolds', 'In@aliquam.net','Ap #937-227 Velit Street');

INSERT INTO librarian VALUES (5100,'Winter Reynolds');
INSERT INTO librarian VALUES (1000,'Morgan Hurley');
INSERT INTO librarian VALUES (1500,'India Atkins');
INSERT INTO librarian VALUES (2000,'Tobias Roy');
INSERT INTO librarian VALUES (2500,'Kirk Stephens');
INSERT INTO librarian VALUES (3000,'Castor Mitchell');
INSERT INTO librarian VALUES (3500,'Norman Mckenzie');
INSERT INTO librarian VALUES (4000,'Cedric Cummings');
INSERT INTO librarian VALUES (4500,'Linda Ortega');
INSERT INTO librarian VALUES (5000,'Lacey Sykes');
INSERT INTO librarian VALUES (5500,'Melanie Rowland');
INSERT INTO librarian VALUES (6000,'Walter Mccray');
INSERT INTO librarian VALUES (6500,'Carter Mcintyre');
INSERT INTO librarian VALUES (7000,'Sloane Villarreal');

INSERT INTO material VALUES ('bi0002','biography','Biography 2','g','N',2,7000,'movie');
INSERT INTO material VALUES ('bi0004','biography','Biography 4', 'b','Y',12, 7000, 'movie');
INSERT INTO material VALUES ('fa0002','fantasy','Fantasy 2','g','Y',17,5100,'movie');
INSERT INTO material VALUES ('fa0004','fantasy', 'Fantasy 4','b','N',5,1500,'movie');
INSERT INTO material VALUES ('fa0006','fantasy','The Hobbit','g','Y',25,2500,'movie');
INSERT INTO material VALUES ('th0002','thriller','Thriller 2','g','Y',13,5100,'movie');
INSERT INTO material VALUES ('th0004','thriller','Thriller 4','b','Y',2,2500,'movie');
INSERT INTO material VALUES ('th0006','thriller','Shutter Island','g','Y',30,4500,'movie');
INSERT INTO material VALUES ('th0008','thriller','Memento', 'g', 'N', 19, 4500, 'movie');
INSERT INTO material VALUES ('th0010','thriller','Batman Begins', 'b', 'Y', 3, 1500, 'movie');
INSERT INTO material VALUES ('th0012','thriller','The Dark Knight', 'g', 'N', 14, 5500, 'movie');
INSERT INTO material VALUES ('th0014','thriller','The Dark Knight Rises', 'b', 'Y', 5, 3000, 'movie');
INSERT INTO material VALUES ('my0002','mystery','Mystery 2','g','N',  13, 3000,'movie');
INSERT INTO material VALUES ('my0004','mystery','Mystery 4','b','N',1,3500,'movie');
INSERT INTO material VALUES ('my0006','mystery','Murder on the Orient Express','b','N',10,3500,'movie');
INSERT INTO material VALUES ('my0008','mystery','Murder on the Orient Express','g','N',10,1500,'movie');
INSERT INTO material VALUES ('my0010','mystery','Murder on the Orient Express','g','Y',20,5000,'movie');
INSERT INTO material VALUES ('my0011','mystery','Mystery 4','g','N',7,2000,'movie');
INSERT INTO material VALUES ('au0002','autobiography', 'Autobiography 2', 'g', 'Y', 6, 4000, 'movie');
INSERT INTO material VALUES ('au0004','autobiography', 'Autobiography 4', 'b', 'Y', 14, 4500, 'movie');
INSERT INTO material VALUES ('bi0001','biography','Biography 1','g','Y',4,5100,'book');
INSERT INTO material VALUES ('bi0003','biography','Biography 3', 'b','N',8,5100,'book');
INSERT INTO material VALUES ('fa0001','fantasy','Fantasy 1','g','N',7,1000, 'book');
INSERT INTO material VALUES ('fa0003','fantasy','Fantasy 3','b','Y',13,1000,'book');
INSERT INTO material VALUES ('fa0005','fantasy','The Hobbit','b','Y',25,6500,'book');
INSERT INTO material VALUES ('fa0007','fantasy','The Hobbit','g','N',25,2500,'book');
INSERT INTO material VALUES ('fa0009','fantasy','The Hobbit','g','Y',25,1000,'book');
INSERT INTO material VALUES ('fa0011','fantasy','Leviathan','g','Y',26,6500,'book');
INSERT INTO material VALUES ('fa0013','fantasy', 'The Amulet of Samarkand', 'g', 'N', 14, 5500, 'book');
INSERT INTO material VALUES ('fa0015','fantasy', 'The Golems Eye', 'b', 'Y', 16, 5500, 'book');
INSERT INTO material VALUES ('fa0017','fantasy', 'Ptolemys Gate', 'g', 'Y', 11, 5500, 'book');
INSERT INTO material VALUES ('fa0019','fantasy', 'Solomans Ring', 'b', 'N', 16, 5500, 'book');
INSERT INTO material VALUES ('th0001','thriller','Thriller 1','g','N',19,2500,'book');
INSERT INTO material VALUES ('th0003','thriller','Thriller 3','b','N',7,2500,'book');
INSERT INTO material VALUES ('my0001','mystery','Mystery 1','g','Y',12, 3500,'book');
INSERT INTO material VALUES ('my0003','mystery','Mystery 3','b','Y',17, 4000,'book');
INSERT INTO material VALUES ('my0005','mystery','Shutter Island','g','Y',15, 3000,'book');
INSERT INTO material VALUES ('au0001','autobiography','Autobiography 1','g','N',2,4500,'book');
INSERT INTO material VALUES ('au0003','autobiography','Autobiography 3','b','N',12,7000,'book');
INSERT INTO material VALUES ('ph0001','philosophy','Leviathan','g','Y',35,6000,'book');

INSERT INTO book VALUES ('bi0001',1000000000000,'Wing N. Molina','Urna PC', 4);
INSERT INTO book VALUES ('bi0003',1037105739562,'Athena L. Branch','Diam Sed Publishing',1);
INSERT INTO book VALUES ('th0001',1012368579854,'Quinn E. Ingram', 'Vestibulum Incorporated',1);
INSERT INTO book VALUES ('th0003',1358688815766,'Hilda Douglas','Rutrum Magna Institute',1);
INSERT INTO book VALUES ('my0001',1024737159708,'Rama Mercer','Luctus Ut Foundation Press',2);
INSERT INTO book VALUES ('my0003',1321583076204,'Sloane S. Hubbard','Nullam Vitae Foundation',1);
INSERT INTO book VALUES ('my0005',8922583476244,'Devon Yu','Harper and Row',1);
INSERT INTO book VALUES ('fa0001',1296845916496,'Derek J. Perry','Harper and Row',3);
INSERT INTO book VALUES ('fa0003',1309214496350,'Meghan O. Floyd','Mi Institute',1);
INSERT INTO book VALUES ('fa0005',2224489405546, 'J.R.R. Tolkin','Pharetra LLC',3);
INSERT INTO book VALUES ('fa0007',2224489405546, 'J.R.R. Tolkin','Pharetra LLC',3);
INSERT INTO book VALUES ('fa0009',2224489405546, 'J.R.R. Tolkin','Pharetra LLC',3);
INSERT INTO book VALUES ('fa0011',2199752245838, 'Scott Westerfeld','Schoolastic',2);
INSERT INTO book VALUES ('fa0013',2224489405547,'Jonathan Stroud','Farquarl Publishing',5);
INSERT INTO book VALUES ('fa0015',2224489405548,'Jonathan Stroud','Farquarl Publishing',3);
INSERT INTO book VALUES ('fa0017',2224489405549,'Jonathan Stroud','Farquarl Publishing',2);
INSERT INTO book VALUES ('fa0019',2224489405550,'Jonathan Stroud','Farquarl Publishing',3);
INSERT INTO book VALUES ('au0001',1185528697810,'Neville G. Puckett','Orci Ltd',4);
INSERT INTO book VALUES ('au0003',1210265857518,'Jana Banks','Harper and Row',2);
INSERT INTO book VALUES ('ph0001',9094489437543,'Thomas Hobbes','Hackett Publishing',5);

INSERT INTO movie VALUES ('fa0002','Hayley S. Manning','06/05/13');
INSERT INTO movie VALUES ('fa0004', 'Celeste N. Cooley', '07/01/19');
INSERT INTO movie VALUES ('fa0006', 'Director Guy', '14/07/13');
INSERT INTO movie VALUES ('th0002','Celeste N. Cooley','07/01/19');
INSERT INTO movie VALUES ('th0004','Naomi X. Haney','10/11/06');
INSERT INTO movie VALUES ('th0006','Martin Scorsese','10/03/19');
INSERT INTO movie VALUES ('th0008', 'Christopher Nolan', '09/09/00');
INSERT INTO movie VALUES ('th0010', 'Christopher Nolan', '06/15/05');
INSERT INTO movie VALUES ('th0012', 'Christopher Nolan', '18/07/08');
INSERT INTO movie VALUES ('th0014', 'Christopher Nolan', '20/07/12');
INSERT INTO movie VALUES ('bi0002','Igor Edwards','07/12/24');
INSERT INTO movie VALUES ('bi0004','Geoffrey Q. Skinner','09/04/29');
INSERT INTO movie VALUES ('my0002','Ethan Wilkinson','07/04/16');
INSERT INTO movie VALUES ('my0004','Miranda Strickland','13/07/25');
INSERT INTO movie VALUES ('my0006','Lars Fry','93/10/04');
INSERT INTO movie VALUES ('my0008','Lars Fry','93/10/04');
INSERT INTO movie VALUES ('my0010','Kenneth Branagh','17/09/14');
INSERT INTO movie VALUES ('my0011','Hayley S. Manning','97/11/29');
INSERT INTO movie VALUES ('au0002','Jamalia F. Booth','03/11/14');
INSERT INTO movie VALUES ('au0004','Lars Fry','03/01/28'); 

INSERT INTO accountRecord VALUES (8170,80000,20091219,'my0005',2500);
INSERT INTO accountRecord VALUES (1001,51000,20100101,'th0001',5500);
INSERT INTO accountRecord VALUES (1002,51000,20100101,'fa0001',5500);
INSERT INTO accountRecord VALUES (1003,30000,20100101,'au0002',1500);
INSERT INTO accountRecord VALUES (1004,10000,20100102,'au0003',2500);
INSERT INTO accountRecord VALUES (1005,90000,20100102,'my0008',7000);
INSERT INTO accountRecord VALUES (1006,25000,20100102,'fa0015',4500);
INSERT INTO accountRecord VALUES (1007,10000,20101002,'ph0001',2500);
INSERT INTO accountRecord VALUES (1008,65000,20100102,'th0014',1500);
INSERT INTO accountRecord VALUES (1009,65000,20100102,'fa0011',5100);
INSERT INTO accountRecord VALUES (1010,25000,20100102,'fa0015',7000);
INSERT INTO accountRecord VALUES (1011,90000,20100103,'my0008',3000);
INSERT INTO accountRecord VALUES (1012,20000,20100103,'fa0015',4500);
INSERT INTO accountRecord VALUES (1013,45000,20100103,'fa0017',3500);
INSERT INTO accountRecord VALUES (1014,80000,20100104,'my0005',5500);
INSERT INTO accountRecord VALUES (1015,65000,20100107,'th0014',5000);
INSERT INTO accountRecord VALUES (1016,65000,20100107,'fa0011',4000);
INSERT INTO accountRecord VALUES (1017,45000,20100107,'fa0017',4000);
INSERT INTO accountRecord VALUES (1018,80000,20100110,'my0005',5100);
INSERT INTO accountRecord VALUES (1019,80000,20100110,'my0005',5100);
INSERT INTO accountRecord VALUES (1020,65000,20100114,'fa0011',2000);
INSERT INTO accountRecord VALUES (1021,51000,20100121,'th0001',6500);
INSERT INTO accountRecord VALUES (1022,51000,20100121,'fa0001',6500);
INSERT INTO accountRecord VALUES (1023,40000,20100120,'my0005',3000);
INSERT INTO accountRecord VALUES (1024,45000,20100122,'fa0017',2000);
INSERT INTO accountRecord VALUES (1025,45000,20100122,'fa0017',2000);
INSERT INTO accountRecord VALUES (1026,95000,20100122,'au0003',1500);
INSERT INTO accountRecord VALUES (1027,51000,20101122,'fa0001',3500);
INSERT INTO accountRecord VALUES (1028,51000,20100122,'th0001',3500);
INSERT INTO accountRecord VALUES (1029,20000,20100122,'th0004',2000);
INSERT INTO accountRecord VALUES (1030,45000,20100122,'fa0017',1500);
INSERT INTO accountRecord VALUES (1031,51000,20101122,'fa0001',3500);
INSERT INTO accountRecord VALUES (1032,51000,20100122,'th0001',3500);
INSERT INTO accountRecord VALUES (1033,30000,20100122,'my0002',6500);
INSERT INTO accountRecord VALUES (1034,10000,20100123,'ph0001',3500);
INSERT INTO accountRecord VALUES (1035,10000,20100127,'ph0001',6000);
INSERT INTO accountRecord VALUES (1036,10000,20100127,'ph0001',4500);
INSERT INTO accountRecord VALUES (1037,20000,20100129,'th0004',5500);
INSERT INTO accountRecord VALUES (1038,95000,20100129,'au0003',2000);
INSERT INTO accountRecord VALUES (1039,85000,20100102,'th0001',7000);
INSERT INTO accountRecord VALUES (1040,30000,20100203,'my0002',1500);
INSERT INTO accountRecord VALUES (1042,70000,20100203,'fa0019',4000);
INSERT INTO accountRecord VALUES (1046,65000,20100204,'th0014',7000);
INSERT INTO accountRecord VALUES (1050,20000,20100208,'th0004',1000);
INSERT INTO accountRecord VALUES (1059,15000,20100210,'ph0001',4500);
INSERT INTO accountRecord VALUES (1060,35000,20100210,'bi0001',1500);
INSERT INTO accountRecord VALUES (1061,15000,20100211,'ph0001',5000);
INSERT INTO accountRecord VALUES (1062,15000,20100211,'my0005',7000);
INSERT INTO accountRecord VALUES (1063,85000,20100212,'my0004',6000);
INSERT INTO accountRecord VALUES (1064,85000,20100212,'my0004',6000);
INSERT INTO accountRecord VALUES (1065,95000,20100212,'au0003',3000);
INSERT INTO accountRecord VALUES (1066,30000,20100212,'my0002',4500);
INSERT INTO accountRecord VALUES (1067,30000,20100212,'my0002',4500);
INSERT INTO accountRecord VALUES (1068,50000,20100220,'my0001',5000);
INSERT INTO accountRecord VALUES (1069,11000,20100302,'my0003',5000);
INSERT INTO accountRecord VALUES (1070,11000,20100305,'my0003',1000);
INSERT INTO accountRecord VALUES (1071,70000,20100305,'fa0019',1500);
INSERT INTO accountRecord VALUES (1072,35000,20100305,'bi0001',2500);
INSERT INTO accountRecord VALUES (1073,15000,20100305,'my0005',1500);
INSERT INTO accountRecord VALUES (1074,11000,20100405,'my0003',5100);
INSERT INTO accountRecord VALUES (1080,55000,20100630,'fa0003',5100);
INSERT INTO accountRecord VALUES (1081,55000,20100613,'fa0005',5100);
INSERT INTO accountRecord VALUES (1083,55000,20100630,'fa0005',4500);
INSERT INTO accountRecord VALUES (1085,60000,20100630,'fa0007',4500);
INSERT INTO accountRecord VALUES (1086,60000,20100720,'fa0007',5100);
INSERT INTO accountRecord VALUES (1087,60000,20100720,'fa0007',5100);
INSERT INTO accountRecord VALUES (1088,70000,20100715,'th0012',1000);
INSERT INTO accountRecord VALUES (1089,70000,20100730,'th0012',1000);
INSERT INTO accountRecord VALUES (1090,70000,20100731,'th0012',1000);
INSERT INTO accountRecord VALUES (1091,75000,20100801,'th0012',1000);
INSERT INTO accountRecord VALUES (1092,75000,20100810,'th0012',1000);
INSERT INTO accountRecord VALUES (1093,75000,20100815,'th0012',4500);
INSERT INTO accountRecord VALUES (1094,55000,20100801,'fa0009',1000);
INSERT INTO accountRecord VALUES (1095,55000,20100810,'fa0009',1000);
INSERT INTO accountRecord VALUES (1096,55000,20100810,'fa0009',1000);
INSERT INTO accountRecord VALUES (1097,55000,20100810,'fa0009',1000);
INSERT INTO accountRecord VALUES (1098,10000,20100802,'au0001',2000);
INSERT INTO accountRecord VALUES (1099,10000,20100810,'au0001',1500);
INSERT INTO accountRecord VALUES (1100,10000,20100810,'au0001',1500);
INSERT INTO accountRecord VALUES (1101,10000,20100810,'au0001',1500);
INSERT INTO accountRecord VALUES (1102,30000,20100815,'fa0013',1500);
INSERT INTO accountRecord VALUES (1103,30000,20100830,'fa0013',1500);
INSERT INTO accountRecord VALUES (1104,30000,20100830,'fa0013',1500);
INSERT INTO accountRecord VALUES (1105,30000,20100830,'fa0013',1500);
INSERT INTO accountRecord VALUES (1106,30000,20100805,'fa0019',1000);
INSERT INTO accountRecord VALUES (1107,30000,20100815,'fa0019',1500);
INSERT INTO accountRecord VALUES (1108,30000,20100819,'fa0019',1500);
INSERT INTO accountRecord VALUES (1109,55000,20100723,'fa0004',5000);
INSERT INTO accountRecord VALUES (1110,55000,20100805,'fa0004',5000);
INSERT INTO accountRecord VALUES (1111,55000,20100808,'fa0004',5000);
INSERT INTO accountRecord VALUES (1112,55000,20100808,'fa0004',5000);
INSERT INTO accountRecord VALUES (1113,10000,20100727,'fa0006',5100);
INSERT INTO accountRecord VALUES (1114,10000,20100809,'fa0006',6500);
INSERT INTO accountRecord VALUES (1115,10000,20100812,'fa0006',6500);
INSERT INTO accountRecord VALUES (1116,10000,20100812,'fa0006',6500);
INSERT INTO accountRecord VALUES (1117,30000,20100731,'th0002',2000);
INSERT INTO accountRecord VALUES (1118,30000,20100813,'th0002',2500);
INSERT INTO accountRecord VALUES (1119,30000,20100813,'th0002',2500);
INSERT INTO accountRecord VALUES (1120,30000,20100813,'th0002',2500);
INSERT INTO accountRecord VALUES (1121,10000,20100804,'th0006',4000);
INSERT INTO accountRecord VALUES (1122,10000,20100817,'th0006',4000);
INSERT INTO accountRecord VALUES (1123,10000,20100818,'th0006',5500);
INSERT INTO accountRecord VALUES (1124,10000,20100818,'th0006',5500);
INSERT INTO accountRecord VALUES (1125,51000,20100809,'my0004',3500);
INSERT INTO accountRecord VALUES (1126,51000,20100821,'my0004',4500);
INSERT INTO accountRecord VALUES (1127,51000,20100821,'my0004',4500);
INSERT INTO accountRecord VALUES (1128,51000,20100821,'my0004',4500);
INSERT INTO accountRecord VALUES (1129,55000,20100813,'au0004',2500);
INSERT INTO accountRecord VALUES (1130,55000,20100826,'au0004',2500);
INSERT INTO accountRecord VALUES (1131,55000,20100828,'au0004',2500);
INSERT INTO accountRecord VALUES (1132,55000,20100828,'au0004',2500);
INSERT INTO accountRecord VALUES (1150,51000,20120101,'bi0003',1000);
INSERT INTO accountRecord VALUES (1151,51000,20120103,'bi0003',2500);
INSERT INTO accountRecord VALUES (1152,10000,20120104,'bi0003',3500);
INSERT INTO accountRecord VALUES (1153,10000,20120106,'bi0003',5000);
INSERT INTO accountRecord VALUES (1154,15000,20120107,'bi0003',4500);
INSERT INTO accountRecord VALUES (1155,15000,20120109,'bi0003',5000);
INSERT INTO accountRecord VALUES (1156,20000,20120110,'bi0003',1000);
INSERT INTO accountRecord VALUES (1157,20000,20120112,'bi0003',6000);
INSERT INTO accountRecord VALUES (1158,25000,20120113,'bi0003',7000);
INSERT INTO accountRecord VALUES (1159,25000,20120115,'bi0003',1000);
INSERT INTO accountRecord VALUES (1160,30000,20120116,'bi0003',7000);
INSERT INTO accountRecord VALUES (1161,30000,20120118,'bi0003',2000);
INSERT INTO accountRecord VALUES (1162,35000,20120119,'bi0003',1500);
INSERT INTO accountRecord VALUES (1163,35000,20120121,'bi0003',7000);
INSERT INTO accountRecord VALUES (1164,40000,20120122,'bi0003',3500);
INSERT INTO accountRecord VALUES (1165,40000,20120124,'bi0003',3000);
INSERT INTO accountRecord VALUES (1166,45000,20120125,'bi0003',1500);
INSERT INTO accountRecord VALUES (1167,45000,20120127,'bi0003',6500);
INSERT INTO accountRecord VALUES (1168,50000,20120128,'bi0003',6000);
INSERT INTO accountRecord VALUES (1169,50000,20120130,'bi0003',7000);
INSERT INTO accountRecord VALUES (1170,55000,20120131,'bi0003',5500);
INSERT INTO accountRecord VALUES (1171,55000,20120202,'bi0003',3500);
INSERT INTO accountRecord VALUES (1172,60000,20120203,'bi0003',1000);
INSERT INTO accountRecord VALUES (1173,60000,20120205,'bi0003',1000);
INSERT INTO accountRecord VALUES (1174,65000,20120206,'bi0003',4000);
INSERT INTO accountRecord VALUES (1175,65000,20120208,'bi0003',2000);
INSERT INTO accountRecord VALUES (1176,70000,20120209,'bi0003',3500);
INSERT INTO accountRecord VALUES (1177,70000,20120211,'bi0003',2500);
INSERT INTO accountRecord VALUES (1178,75000,20120212,'bi0003',1500);
INSERT INTO accountRecord VALUES (1179,75000,20120214,'bi0003',1000);
INSERT INTO accountRecord VALUES (1180,80000,20120215,'bi0003',5500);
INSERT INTO accountRecord VALUES (1181,80000,20120217,'bi0003',6000);
INSERT INTO accountRecord VALUES (1182,85000,20120218,'bi0003',6500);
INSERT INTO accountRecord VALUES (1183,85000,20120220,'bi0003',5000);
INSERT INTO accountRecord VALUES (1184,90000,20120221,'bi0003',4500);
INSERT INTO accountRecord VALUES (1185,90000,20120223,'bi0003',4000);
INSERT INTO accountRecord VALUES (1186,95000,20120224,'bi0003',1000);
INSERT INTO accountRecord VALUES (1187,95000,20120226,'bi0003',2500);
INSERT INTO accountRecord VALUES (1188,11000,20120227,'bi0003',2000);
INSERT INTO accountRecord VALUES (1189,11000,20120310,'bi0003',1500);


INSERT INTO loan VALUES (8170,7,'20100103',1014);
INSERT INTO loan VALUES (1001,2,'20100120',1021);
INSERT INTO loan VALUES (1002,2,'20100120',1022);
INSERT INTO loan VALUES (1003,0,'20100212',NULL);
INSERT INTO loan VALUES (1005,10,'20100122',NULL);
INSERT INTO loan VALUES (1006,0,'20100122',NULL);
INSERT INTO loan VALUES (1007,5,'20100122',1034);
INSERT INTO loan VALUES (1015,0,'20100204',NULL);
INSERT INTO loan VALUES (1016,0,'20100114',NULL);
INSERT INTO loan VALUES (1017,1,'20100121',1024);
INSERT INTO loan VALUES (1033,9,'20100203',1040);
INSERT INTO loan VALUES (1037,0,'20100210',NULL);
INSERT INTO loan VALUES (1038,0,'20100215',NULL);
INSERT INTO loan VALUES (1039,0,'20100217',NULL);
INSERT INTO loan VALUES (1042,0,'20100307',NULL);
INSERT INTO loan VALUES (1059,0,'20100217',NULL);
INSERT INTO loan VALUES (1060,0,'20100310',NULL);
INSERT INTO loan VALUES (1062,1,'20100228',1073);
INSERT INTO loan VALUES (1063,0,'20100203',NULL);
INSERT INTO loan VALUES (1066,0,'20100215',NULL);
INSERT INTO loan VALUES (1067,0,'20100220',NULL);
INSERT INTO loan VALUES (1069,7,'20100304',1070);
INSERT INTO loan VALUES (1081,8,'20100620',1083);
INSERT INTO loan VALUES (1085,3,'20100704',1086);
INSERT INTO loan VALUES (1088,4,'20100720',1089);
INSERT INTO loan VALUES (1091,5,'20100809',1092);
INSERT INTO loan VALUES (1094,2,'20100810',1095);
INSERT INTO loan VALUES (1098,2,'20100810',1099);
INSERT INTO loan VALUES (1102,5,'20100820',1103);
INSERT INTO loan VALUES (1106,5,'20100810',1107);
INSERT INTO loan VALUES (1109,6,'20100801',1110);
INSERT INTO loan VALUES (1113,7,'20100804',1114);
INSERT INTO loan VALUES (1117,7,'20100808',1118);
INSERT INTO loan VALUES (1121,8,'20100812',1122);
INSERT INTO loan VALUES (1125,6,'20100816',1126);
INSERT INTO loan VALUES (1129,9,'20100820',1130);
INSERT INTO loan VALUES (1150,0,'20120115',NULL);
INSERT INTO loan VALUES (1152,0,'20120118',NULL);
INSERT INTO loan VALUES (1154,0,'20120121',NULL);
INSERT INTO loan VALUES (1156,0,'20120124',NULL);
INSERT INTO loan VALUES (1158,0,'20120127',NULL);
INSERT INTO loan VALUES (1160,0,'20120130',NULL);
INSERT INTO loan VALUES (1162,0,'20120203',NULL);
INSERT INTO loan VALUES (1164,0,'20120206',NULL);
INSERT INTO loan VALUES (1166,0,'20120209',NULL);
INSERT INTO loan VALUES (1168,0,'20120212',NULL);
INSERT INTO loan VALUES (1170,0,'20120215',NULL);
INSERT INTO loan VALUES (1172,0,'20120218',NULL);
INSERT INTO loan VALUES (1174,0,'20120221',NULL);
INSERT INTO loan VALUES (1176,0,'20120224',NULL);
INSERT INTO loan VALUES (1178,0,'20120227',NULL);
INSERT INTO loan VALUES (1180,0,'20120303',NULL);
INSERT INTO loan VALUES (1182,0,'20120306',NULL);
INSERT INTO loan VALUES (1184,0,'20120309',NULL);
INSERT INTO loan VALUES (1186,0,'20120312',NULL);
INSERT INTO loan VALUES (1188,0,'20120315',NULL);



INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1004,'20100109',NULL);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1008,'20100109',1015);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1009,'20100109',1016);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1013,'20100110',1017);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1023,'20100127',NULL);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1029,'20100129',1037);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1012,'20100110',NULL);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1026,'20100129',1038);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1068,'20100202',NULL);
INSERT INTO reservation (rid,heldUntil,loanRID) VALUES (1080,'20100615',NULL);

INSERT INTO renewal (rid) VALUES (1015);
INSERT INTO renewal (rid) VALUES (1017);
INSERT INTO renewal (rid) VALUES (1003);
INSERT INTO renewal (rid) VALUES (1037);
INSERT INTO renewal (rid) VALUES (1039);
INSERT INTO renewal (rid) VALUES (1042);
INSERT INTO renewal (rid) VALUES (1060);
INSERT INTO renewal (rid) VALUES (1066);
INSERT INTO renewal (rid) VALUES (1067);
INSERT INTO renewal (rid) VALUES (1081);

INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1014,5,1018);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1021,2,1028);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1022,6,1027);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1024,1,1025);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1034,4,1035);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1040,5,1066);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1073,1,NULL);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1070,5,1074);  
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1083,6,NULL);  
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1086,4,1087);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1089,3,1090);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1092,7,1093);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1095,3,1096);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1099,10,1100);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1103,4,1104);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1107,10,1108);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1110,4,1111);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1114,5,1115);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1118,6,1119);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1122,7,1123);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1126,8,1127);
INSERT INTO lateFee (rid,amount,paymentRID) VALUES (1130,9,1131);


INSERT INTO cashPayment (rid,amount) VALUES (1027,2);
INSERT INTO cashPayment (rid,amount) VALUES (1028,6);
INSERT INTO cashPayment (rid,amount) VALUES (1018,5);
INSERT INTO cashPayment (rid,amount) VALUES (1025,1);
INSERT INTO cashPayment (rid,amount) VALUES (1087,4);
INSERT INTO cashPayment (rid,amount) VALUES (1090,3);
INSERT INTO cashPayment (rid,amount) VALUES (1093,5);
INSERT INTO cashPayment (rid,amount) VALUES (1096,3);
INSERT INTO cashPayment (rid,amount) VALUES (1100,10);
INSERT INTO cashPayment (rid,amount) VALUES (1104,4);

INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1066, 5,'4024007154392','451','07/26','MasterCard');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1035,4,'4556317117627','907','12/27','Visa');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1074,5,'4556000214435','325','05/22','Visa');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1108,10,'4356003214445','332','05/20','Visa');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1111,4,'4324007158374','242','03/20','MasterCard');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1115,5,'4294003211873','132','04/24','Visa');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1119,6,'4395039411295','329','01/22','Visa');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1123,7,'4456043451203','937','06/22','MasterCard');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1127,8,'4345203243949','493','11/21','Visa');
INSERT INTO cardPayment (rid,amount,cardNum,csv,expDate,type) VALUES (1131,9,'4694703242837','903','12/20','Visa');


INSERT INTO return VALUES (1010,1006);
INSERT INTO return VALUES (1011,1005);
INSERT INTO return VALUES (1019,8170);
INSERT INTO return VALUES (1020,1016);
INSERT INTO return VALUES (1030,1017);
INSERT INTO return VALUES (1031,1002);
INSERT INTO return VALUES (1032,1001);
INSERT INTO return VALUES (1036,1007);
INSERT INTO return VALUES (1046,1015);
INSERT INTO return VALUES (1050,1037);
INSERT INTO return VALUES (1061,1059);
INSERT INTO return VALUES (1064,1063);
INSERT INTO return VALUES (1065,1038);
INSERT INTO return VALUES (1067,1033);
INSERT INTO return VALUES (1072,1060);
INSERT INTO return VALUES (1071,1042);
INSERT INTO return VALUES (1097,1094);
INSERT INTO return VALUES (1101,1098);
INSERT INTO return VALUES (1105,1102);
INSERT INTO return VALUES (1112,1109);
INSERT INTO return VALUES (1116,1113);
INSERT INTO return VALUES (1120,1117);
INSERT INTO return VALUES (1124,1121);
INSERT INTO return VALUES (1128,1125);
INSERT INTO return VALUES (1132,1129);
INSERT INTO return VALUES (1151,1150);
INSERT INTO return VALUES (1153,1152);
INSERT INTO return VALUES (1155,1154);
INSERT INTO return VALUES (1157,1156);
INSERT INTO return VALUES (1159,1158);
INSERT INTO return VALUES (1161,1160);
INSERT INTO return VALUES (1163,1162);
INSERT INTO return VALUES (1165,1164);
INSERT INTO return VALUES (1167,1166);
INSERT INTO return VALUES (1169,1168);
INSERT INTO return VALUES (1171,1170);
INSERT INTO return VALUES (1173,1172);
INSERT INTO return VALUES (1175,1174);
INSERT INTO return VALUES (1177,1176);
INSERT INTO return VALUES (1179,1178);
INSERT INTO return VALUES (1181,1180);
INSERT INTO return VALUES (1183,1182);
INSERT INTO return VALUES (1185,1184);
INSERT INTO return VALUES (1187,1186);
INSERT INTO return VALUES (1189,1188);




commit work;