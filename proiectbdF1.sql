DROP VIEW PIESE_MONOPOST_COMPUS;
DROP VIEW RAPORT_SPONSORI_COMPLEX;
DROP TABLE Rezultate CASCADE CONSTRAINTS PURGE;
DROP TABLE Oferte CASCADE CONSTRAINTS PURGE;
DROP TABLE Contracte CASCADE CONSTRAINTS PURGE;
DROP TABLE Piloti CASCADE CONSTRAINTS PURGE;
DROP TABLE Manageri CASCADE CONSTRAINTS PURGE;
DROP TABLE Mecanici CASCADE CONSTRAINTS PURGE;
DROP TABLE Piese CASCADE CONSTRAINTS PURGE;
DROP TABLE Curse CASCADE CONSTRAINTS PURGE;
DROP TABLE Monoposturi CASCADE CONSTRAINTS PURGE;
DROP TABLE Angajati CASCADE CONSTRAINTS PURGE;
DROP TABLE Sponsori CASCADE CONSTRAINTS PURGE;
DROP TABLE Furnizori CASCADE CONSTRAINTS PURGE;
DROP TABLE Circuite CASCADE CONSTRAINTS PURGE;

COMMIT;


-- TABELE INDEPENDENTE

CREATE TABLE Angajati ( 
    ID_Angajat           INTEGER NOT NULL, 
    Tip_Angajat          VARCHAR2(50) NOT NULL,
    Nume                 VARCHAR2(50) NOT NULL, 
    Prenume              VARCHAR2(50) NOT NULL, 
    Salariu              INTEGER NOT NULL, 
    Data_Angajarii       DATE NOT NULL, 
    Data_Incheiere_Contract DATE, 
    Ani_Experienta       INTEGER,
    CONSTRAINT Angajati_PK PRIMARY KEY (ID_Angajat)
);

CREATE TABLE Circuite ( 
    ID_Circuit           INTEGER NOT NULL, 
    Lungime_KM           FLOAT NOT NULL, 
    Record_Tur           FLOAT NOT NULL, 
    Locatie              VARCHAR2(50) NOT NULL,
    CONSTRAINT Circuite_PK PRIMARY KEY (ID_Circuit)
);

CREATE TABLE Sponsori ( 
    ID_Sponsor           INTEGER NOT NULL, 
    Nume_Sponsor         VARCHAR2(50) NOT NULL, 
    Domeniu_Sponsor      VARCHAR2(50),
    Tara_Origine         VARCHAR2(50),
    Tip_Parteneriat      VARCHAR2(50),
    Email_Contact        VARCHAR2(100),     
    Cod_Fiscal           VARCHAR2(50),      
    
    CONSTRAINT Sponsori_PK PRIMARY KEY (ID_Sponsor)
);

CREATE TABLE Furnizori ( 
    ID_Furnizor          INTEGER NOT NULL, 
    Nume_Furnizor        VARCHAR2(50) NOT NULL, 
    Domeniu_Furnizor     VARCHAR2(50) NOT NULL,
    Tara_Sediu           VARCHAR2(50),
    Rating_Calitate      INTEGER,
    Telefon_Urgenta      VARCHAR2(20),
    Email_Comenzi        VARCHAR2(100),     
    Cod_Fiscal           VARCHAR2(50),      
    
    CONSTRAINT Furnizori_PK PRIMARY KEY (ID_Furnizor),
    CONSTRAINT Check_Rating CHECK (Rating_Calitate BETWEEN 1 AND 10)
);

CREATE TABLE Monoposturi ( 
    ID_Monopost          INTEGER NOT NULL, 
    Nume_Model           VARCHAR2(50) NOT NULL, 
    ID_Sasiu             VARCHAR2(50) NOT NULL, 
    Motorizare           VARCHAR2(50) NOT NULL, 
    CP                   INTEGER NOT NULL, 
    Data_Fabricatiei     DATE NOT NULL, 
    Stare                VARCHAR2(20) NOT NULL, 
    Masa_KG              INTEGER NOT NULL,
    CONSTRAINT Monoposturi_PK PRIMARY KEY (ID_Monopost)
);

-- TABELE DEPENDENTE 

CREATE TABLE Manageri ( 
    ID_Manager           INTEGER NOT NULL, 
    Nivel_Acces          INTEGER NOT NULL, 
    Functie              VARCHAR2(50) NOT NULL, 
    Buget_Gestionat      INTEGER,
    CONSTRAINT Manageri_PK PRIMARY KEY (ID_Manager),
    CONSTRAINT Manageri_Angajati_FK FOREIGN KEY (ID_Manager) 
        REFERENCES Angajati(ID_Angajat) ON DELETE CASCADE
);

CREATE TABLE Mecanici ( 
    ID_Mecanic           INTEGER NOT NULL, 
    Specializare         VARCHAR2(50) NOT NULL, 
    Rol_PitStop          VARCHAR2(50), 
    ID_Monopost          INTEGER,
    CONSTRAINT Mecanici_PK PRIMARY KEY (ID_Mecanic),
    CONSTRAINT Mecanici_Angajati_FK FOREIGN KEY (ID_Mecanic) 
        REFERENCES Angajati(ID_Angajat) ON DELETE CASCADE,
    CONSTRAINT Mecanici_Monoposturi_FK FOREIGN KEY (ID_Monopost) 
        REFERENCES Monoposturi(ID_Monopost)
);

CREATE TABLE Piloti ( 
    ID_Pilot             INTEGER NOT NULL, 
    Statut               VARCHAR2(50) NOT NULL, 
    Licenta              VARCHAR2(50) NOT NULL, 
    Inaltime_CM          INTEGER NOT NULL, 
    Masa_KG              INTEGER NOT NULL, 
    ID_Monopost          INTEGER,
    CONSTRAINT Piloti_PK PRIMARY KEY (ID_Pilot),
    CONSTRAINT Piloti_Angajati_FK FOREIGN KEY (ID_Pilot) 
        REFERENCES Angajati(ID_Angajat) ON DELETE CASCADE,
    CONSTRAINT Piloti_Monoposturi_FK FOREIGN KEY (ID_Monopost) 
        REFERENCES Monoposturi(ID_Monopost)
);

CREATE TABLE Piese ( 
    ID_Piesa             INTEGER NOT NULL, 
    Nume_Piesa           VARCHAR2(50) NOT NULL, 
    Tip_Piesa            VARCHAR2(50) NOT NULL, 
    Valoare_Piesa        INTEGER NOT NULL, 
    Nivel_Uzura_Piesa    INTEGER NOT NULL, 
    ID_Monopost          INTEGER,
    CONSTRAINT Piese_PK PRIMARY KEY (ID_Piesa),
    CONSTRAINT Piese_Monoposturi_FK FOREIGN KEY (ID_Monopost) 
        REFERENCES Monoposturi(ID_Monopost)
);

CREATE TABLE Curse ( 
    ID_Cursa             INTEGER NOT NULL, 
    Data                 DATE NOT NULL, 
    Nr_Tururi            INTEGER NOT NULL, 
    ID_Circuit           INTEGER NOT NULL,
    CONSTRAINT Curse_PK PRIMARY KEY (ID_Cursa),
    CONSTRAINT Curse_Circuite_FK FOREIGN KEY (ID_Circuit) 
        REFERENCES Circuite(ID_Circuit)
);

-- TABELE ASOCIATIVE 

CREATE TABLE Contracte ( 
    ID_Contract          INTEGER NOT NULL,
    ID_Sponsor           INTEGER NOT NULL, 
    ID_Manager           INTEGER NOT NULL, 
    Valoare_Contract     INTEGER, 
    Status_Contract      VARCHAR2(50) NOT NULL, 
    Clauza_Performanta   VARCHAR2(50), 
    Data_Expirare        DATE NOT NULL,
    Data_Semnare         DATE,
    Durata_Luni          INTEGER,
    CONSTRAINT Contracte_PK PRIMARY KEY (ID_Contract),
    CONSTRAINT Contracte_Sponsor_FK FOREIGN KEY (ID_Sponsor) REFERENCES Sponsori(ID_Sponsor) ON DELETE CASCADE,
    CONSTRAINT Contracte_Manager_FK FOREIGN KEY (ID_Manager) REFERENCES Manageri(ID_Manager) ON DELETE CASCADE
);

CREATE TABLE Oferte ( 
    ID_Oferta            INTEGER NOT NULL,
    ID_Furnizor          INTEGER NOT NULL, 
    ID_Piesa             INTEGER NOT NULL, 
    Pret                 NUMBER(10, 2), 
    Termen_Livrare_Zile  INTEGER, 
    Data_Oferta          DATE,
    Data_Expirare        DATE,
    CONSTRAINT Oferte_PK PRIMARY KEY (ID_Oferta),
    CONSTRAINT Oferte_Furnizor_FK FOREIGN KEY (ID_Furnizor) REFERENCES Furnizori(ID_Furnizor) ON DELETE CASCADE,
    CONSTRAINT Oferte_Piesa_FK FOREIGN KEY (ID_Piesa) REFERENCES Piese(ID_Piesa) ON DELETE CASCADE
);

CREATE TABLE Rezultate ( 
    ID_Rezultat          INTEGER NOT NULL,
    ID_Pilot             INTEGER NOT NULL, 
    ID_Cursa             INTEGER NOT NULL, 
    Sezon                INTEGER NOT NULL, 
    Loc_Grid             INTEGER NOT NULL, 
    Tur_Record           NUMBER(5,3) NOT NULL, 
    Tur_Calificare       NUMBER(5,3) NOT NULL,
    Puncte_Obtinute      INTEGER,
    CONSTRAINT Rezultate_PK PRIMARY KEY (ID_Rezultat),
    CONSTRAINT Rezultate_Piloti_FK FOREIGN KEY (ID_Pilot) REFERENCES Piloti(ID_Pilot) ON DELETE CASCADE,
    CONSTRAINT Rezultate_Cursa_FK FOREIGN KEY (ID_Cursa) REFERENCES Curse(ID_Cursa) ON DELETE CASCADE
);

COMMIT;
                        -- MONOPOSTURI --
INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2021, 'Ferrari SF21', '673-chassis', 'Ferrari 065/6', 970, TO_DATE('2021-03-10', 'YYYY-MM-DD'), 'Muzeu', 752);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (1975, 'Ferrari 312T', '022-chassis', 'Ferrari Flat-12', 500, TO_DATE('1975-01-15', 'YYYY-MM-DD'), 'Legenda', 575);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2019, 'Ferrari SF90', '670-chassis', 'Ferrari 064', 1000, TO_DATE('2019-02-15', 'YYYY-MM-DD'), 'Retras', 743);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2018, 'Ferrari SF71H', '669-chassis', 'Ferrari 062 EVO', 980, TO_DATE('2018-02-22', 'YYYY-MM-DD'), 'Muzeu', 733);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2004, 'Ferrari F2004', '234-chassis', 'Ferrari 053 V10', 920, TO_DATE('2004-01-26', 'YYYY-MM-DD'), 'Legenda', 605);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2007, 'Ferrari F2007', '262-chassis', 'Ferrari 056 V8', 780, TO_DATE('2007-01-14', 'YYYY-MM-DD'), 'Legenda', 605);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2020, 'Ferrari SF1000', '671-chassis', 'Ferrari 065 V6', 950, TO_DATE('2020-02-11', 'YYYY-MM-DD'), 'Retras', 850);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2022, 'Ferrari F1-75', '674-chassis', 'Ferrari 066/7 V6', 1035, TO_DATE('2022-02-17', 'YYYY-MM-DD'), 'Muzeu', 798);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2024, 'Ferrari SF-24', '676-chassis', 'Ferrari 066/12 V6', 1050, TO_DATE('2024-02-13', 'YYYY-MM-DD'), 'Muzeu', 798);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2025, 'Ferrari SF-25', '677-chassis', 'Ferrari 066/13 V6', 1060, TO_DATE('2025-02-10', 'YYYY-MM-DD'), 'Muzeu', 790);

INSERT INTO Monoposturi (ID_Monopost, Nume_Model, ID_Sasiu, Motorizare, CP, Data_Fabricatiei, Stare, Masa_KG) 
VALUES (2026, 'Ferrari SF-26', '678-concept', 'Ferrari 067 1.6L V6', 1100, TO_DATE('2025-12-11', 'YYYY-MM-DD'), 'Concept', 798);

COMMIT;

-- CIRCUITE

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (201, 5.793, 1.21, 'Monza, Italia');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (202, 4.909, 1.15, 'Imola, Italia');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (203, 3.337, 1.12, 'Monte Carlo, Monaco');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (204, 7.004, 1.46, 'Stavelot, Belgia');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (205, 5.891, 1.27, 'Silverstone, UK');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (206, 5.807, 1.30, 'Suzuka, Japonia');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (207, 4.309, 1.10, 'Sao Paulo, Brazilia');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (208, 4.361, 1.13, 'Montreal, Canada');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (209, 6.201, 1.35, 'Las Vegas, SUA');

INSERT INTO Circuite (ID_Circuit, Lungime_KM, Record_Tur, Locatie) 
VALUES (210, 5.063, 1.35, 'Marina Bay, Singapore');

COMMIT;

                        -- CURSE --
INSERT INTO Curse VALUES (1, TO_DATE('2024-03-02', 'YYYY-MM-DD'), 57, 201);
INSERT INTO Curse VALUES (2, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 53, 201);
INSERT INTO Curse VALUES (3, TO_DATE('2022-07-03', 'YYYY-MM-DD'), 52, 205);
INSERT INTO Curse VALUES (4, TO_DATE('2023-09-17', 'YYYY-MM-DD'), 62, 210);
INSERT INTO Curse VALUES (5, TO_DATE('2024-05-26', 'YYYY-MM-DD'), 78, 203);
INSERT INTO Curse VALUES (6, TO_DATE('2000-10-08', 'YYYY-MM-DD'), 53, 206);
INSERT INTO Curse VALUES (7, TO_DATE('2004-08-29', 'YYYY-MM-DD'), 44, 204);
INSERT INTO Curse VALUES (8, TO_DATE('2007-10-21', 'YYYY-MM-DD'), 71, 207);
INSERT INTO Curse VALUES (9, TO_DATE('2019-09-08', 'YYYY-MM-DD'), 53, 201);
INSERT INTO Curse VALUES (10, TO_DATE('2023-11-18', 'YYYY-MM-DD'), 50, 209);

COMMIT;

                                -- **ANGAJATI** --
                                -- MANAGERI --
INSERT INTO Angajati VALUES (100, 'MANAGER', 'Ferrari', 'Enzo', 1, TO_DATE('1929-11-16', 'YYYY-MM-DD'), NULL, 30);
INSERT INTO Manageri VALUES (100, 10, 'Fondator', 999999999);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (101, 'MANAGER', 'Vasseur', 'Frederic', 8000000, TO_DATE('2023-01-09', 'YYYY-MM-DD'), 25);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (101, 1, 'Team Principal', 135000000);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (101, 'MANAGER', 'Luigi', 'Frederic', 8000000, TO_DATE('2021-01-09', 'YYYY-MM-DD'), 15);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (102, 2, 'CTO', 2000000);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (110, 'MANAGER', 'Todt', 'Jean', 25000000, TO_DATE('1993-07-01', 'YYYY-MM-DD'), 40);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (110, 1, 'General Manager', 400000000); 


INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (111, 'MANAGER', 'Brawn', 'Ross', 15000000, TO_DATE('1997-01-01', 'YYYY-MM-DD'), 35);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (111, 2, 'Technical Director', 250000000);


INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (112, 'MANAGER', 'Ferrari', 'Piero', 5000000, TO_DATE('1970-01-01', 'YYYY-MM-DD'), 50);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (112, 1, 'Vice Chairman', 999999999);


INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (113, 'MANAGER', 'Binotto', 'Mattia', 8000000, TO_DATE('1995-01-01', 'YYYY-MM-DD'), 28);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (113, 1, 'Team Principal', 140000000);


INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (114, 'MANAGER', 'Arrivabene', 'Maurizio', 9000000, TO_DATE('2014-11-23', 'YYYY-MM-DD'), 20);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (114, 1, 'Team Principal', 350000000);


INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (115, 'MANAGER', 'Domenicali', 'Stefano', 6000000, TO_DATE('1991-01-01', 'YYYY-MM-DD'), 30);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (115, 1, 'Team Principal', 300000000);


INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (116, 'MANAGER', 'Wolff', 'Torger', 28000000, TO_DATE('2013-01-01', 'YYYY-MM-DD'), 25);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (116, 1, 'CEO si Team Principal', 145000000);


INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (117, 'MANAGER', 'Stella', 'Andrea', 7000000, TO_DATE('2000-01-01', 'YYYY-MM-DD'), 24);
INSERT INTO Manageri (ID_Manager, Nivel_Acces, Functie, Buget_Gestionat) 
VALUES (117, 1, 'Team Principal', 140000000);

COMMIT;

                                -- MECANICI --

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (601, 'MECANIC', 'Rossi', 'Marco', 85000, TO_DATE('2018-03-15', 'YYYY-MM-DD'), 6);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (601, 'Trenul de Rulare', 'Gun Man Stanga Fata', 2025);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (602, 'MECANIC', 'Bianchi', 'Luigi', 78000, TO_DATE('2020-01-10', 'YYYY-MM-DD'), 4);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (602, 'Fibra de Carbon', 'Ajustare Eleron Fata', 2025);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (603, 'MECANIC', 'Weber', 'Hans', 120000, TO_DATE('2015-06-20', 'YYYY-MM-DD'), 9);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (603, 'Unitate de Putere', NULL, 2025); 

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (604, 'MECANIC', 'Sato', 'Kenji', 95000, TO_DATE('2022-02-01', 'YYYY-MM-DD'), 3);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (604, 'Sisteme High-Voltage', 'Verificare Impamantare', 2025); 

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (605, 'MECANIC', 'Popescu', 'Andrei', 60000, TO_DATE('2023-05-15', 'YYYY-MM-DD'), 1);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (605, 'Mecanica Generala', 'Jack Man Spate', 2025);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (606, 'MECANIC', 'Esposito', 'Giovanni', 150000, TO_DATE('2000-01-01', 'YYYY-MM-DD'), 24);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (606, 'Sasiu si Restaurare', NULL, 2004); 

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (607, 'MECANIC', 'Dubois', 'Pierre', 92000, TO_DATE('2019-09-01', 'YYYY-MM-DD'), 5);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (607, 'Transmisie', NULL, 2026);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (608, 'MECANIC', 'Moretti', 'Luca', 88000, TO_DATE('2016-04-12', 'YYYY-MM-DD'), 8);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (608, 'Siguranta Pitlane', 'Lollipop Man', 2024);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (609, 'MECANIC', 'Silva', 'Carlos', 70000, TO_DATE('2021-07-20', 'YYYY-MM-DD'), 3);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (609, 'Pneuri', 'Wheel Off Dreapta Spate', 2024);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (610, 'MECANIC', 'Davies', 'Emma', 110000, TO_DATE('2022-01-15', 'YYYY-MM-DD'), 4);
INSERT INTO Mecanici (ID_Mecanic, Specializare, Rol_PitStop, ID_Monopost) 
VALUES (610, 'Telemetrie si Senzori', NULL, 2026); 


                                    -- PILOTI --
                                    
INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (16, 'PILOT', 'Leclerc', 'Charles', 34000000, TO_DATE('2019-01-01', 'YYYY-MM-DD'), 7);
INSERT INTO Piloti (ID_Pilot, Statut, Licenta, Inaltime_CM, Masa_KG, ID_Monopost) 
VALUES (16, 'Titular', 'FIA-SUPER-16', 180, 69, 2024);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (55, 'PILOT', 'Sainz', 'Carlos', 12000000, TO_DATE('2021-01-01', 'YYYY-MM-DD'), 10);
INSERT INTO Piloti (ID_Pilot, Statut, Licenta, Inaltime_CM, Masa_KG, ID_Monopost) 
VALUES (55, 'Titular', 'FIA-SUPER-55', 178, 70, 2024);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (44, 'PILOT', 'Hamilton', 'Lewis', 80000000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), 18);
INSERT INTO Piloti (ID_Pilot, Statut, Licenta, Inaltime_CM, Masa_KG, ID_Monopost) 
VALUES (44, 'Viitor Titular', 'FIA-SUPER-44', 174, 73, 2025);                                    

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (19, 'PILOT', 'Massa', 'Felipe', 12000000, TO_DATE('2006-01-01', 'YYYY-MM-DD'), 15);
INSERT INTO Piloti (ID_Pilot, Statut, Licenta, Inaltime_CM, Masa_KG, ID_Monopost) 
VALUES (19, 'Fost Pilot', 'BRA-FM-19', 166, 59, 2007);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (11, 'PILOT', 'Barrichello', 'Rubens', 10000000, TO_DATE('2000-01-01', 'YYYY-MM-DD'), 19);
INSERT INTO Piloti (ID_Pilot, Statut, Licenta, Inaltime_CM, Masa_KG, ID_Monopost) 
VALUES (11, 'Fost Pilot', 'BRA-RB-11', 172, 70, 2004);

INSERT INTO Angajati (ID_Angajat, Tip_Angajat, Nume, Prenume, Salariu, Data_Angajarii, Ani_Experienta) 
VALUES (38, 'PILOT', 'Bearman', 'Oliver', 500000, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 1);
INSERT INTO Piloti (ID_Pilot, Statut, Licenta, Inaltime_CM, Masa_KG, ID_Monopost) 
VALUES (38, 'Rezerva', 'GBR-OB-38', 184, 72);

INSERT INTO Angajati VALUES (7, 'PILOT', 'Schumacher', 'Michael', 30000000, TO_DATE('1996-01-01', 'YYYY-MM-DD'), NULL, 5);
INSERT INTO Piloti VALUES (7, 'Legenda', 'DEU-MSC-1', 174, 75, 2004);

INSERT INTO Angajati VALUES (9, 'PILOT', 'Raikkonen', 'Kimi', 51000000, TO_DATE('2007-01-01', 'YYYY-MM-DD'), NULL, 6);
INSERT INTO Piloti VALUES (9, 'Legenda', 'FIN-KR-7', 175, 70, 2007);

INSERT INTO Angajati VALUES (5, 'PILOT', 'Vettel', 'Sebastian', 50000000, TO_DATE('2015-01-01', 'YYYY-MM-DD'), NULL, 8);
INSERT INTO Piloti VALUES (5, 'Fost', 'DEU-SV-5', 175, 62, 2018);

INSERT INTO Angajati VALUES (12, 'PILOT', 'Lauda', 'Niki', 200000, TO_DATE('1974-01-01', 'YYYY-MM-DD'), NULL, 3);
INSERT INTO Piloti VALUES (12, 'Legenda', 'AUT-NL-12', 171, 65, 1975);

COMMIT;

-- REZULTATE --
INSERT INTO Rezultate VALUES (1, 16, 1, 2024, 2, 1.310, 1.291, 12);
INSERT INTO Rezultate VALUES (2, 55, 1, 2024, 4, 1.325, 1.305, 15);
INSERT INTO Rezultate VALUES (3, 16, 2, 2024, 4, 1.215, 1.198, 25);
INSERT INTO Rezultate VALUES (4, 55, 2, 2024, 5, 1.220, 1.201, 12);
INSERT INTO Rezultate VALUES (5, 16, 5, 2024, 1, 1.105, 1.099, 25);
INSERT INTO Rezultate VALUES (6, 55, 5, 2024, 3, 1.112, 1.108, 15);
INSERT INTO Rezultate VALUES (7, 16, 10, 2024, 1, 1.341, 1.329, 18);
INSERT INTO Rezultate VALUES (8, 55, 10, 2024, 12, 1.355, 1.340, 8);
INSERT INTO Rezultate VALUES (9, 16, 1, 2023, 3, 1.330, 1.310, 0);
INSERT INTO Rezultate VALUES (10, 55, 1, 2023, 4, 1.335, 1.315, 12);
INSERT INTO Rezultate VALUES (11, 55, 4, 2023, 1, 1.365, 1.352, 25);
INSERT INTO Rezultate VALUES (12, 16, 4, 2023, 3, 1.370, 1.360, 12);
INSERT INTO Rezultate VALUES (13, 7, 6, 2000, 1, 1.355, 1.345, 10);
INSERT INTO Rezultate VALUES (14, 11, 6, 2000, 2, 1.360, 1.350, 6);
INSERT INTO Rezultate VALUES (15, 7, 7, 2004, 2, 1.442, 1.435, 8);
INSERT INTO Rezultate VALUES (16, 11, 7, 2004, 6, 1.450, 1.440, 3);
INSERT INTO Rezultate VALUES (17, 9, 8, 2007, 3, 1.125, 1.119, 10);
INSERT INTO Rezultate VALUES (18, 19, 8, 2007, 1, 1.121, 1.115, 8);
INSERT INTO Rezultate VALUES (19, 55, 3, 2022, 1, 1.285, 1.279, 25);
INSERT INTO Rezultate VALUES (20, 16, 3, 2022, 3, 1.290, 1.285, 12);

COMMIT;

-- SPONSORI
INSERT INTO Sponsori VALUES (1, 'Shell', 'Combustibil', 'Olanda', 'Innovation Partner', 'partnerships@shell.com', 'NL001234567B01');
INSERT INTO Sponsori VALUES (2, 'Santander', 'Bancar', 'Spania', 'Premium Partner', 'sponsorship@santander.es', 'ES-A12345678');
INSERT INTO Sponsori VALUES (3, 'Ray-Ban', 'Ochelari/Fashion', 'Italia', 'Official Partner', 'marketing@ray-ban.it', 'IT00987654321');
INSERT INTO Sponsori VALUES (4, 'Puma', 'Imbracaminte', 'Germania', 'Team Partner', 'scuderia@puma.de', 'DE123456789');
INSERT INTO Sponsori VALUES (5, 'HP', 'Tehnologie', 'USA', 'Title Partner', 'f1-sponsorship@hp.com', 'US-987654321');
INSERT INTO Sponsori VALUES (6, 'AWS', 'Cloud Computing', 'USA', 'Technical Partner', 'aws-racing@amazon.com', 'US-555666777');
INSERT INTO Sponsori VALUES (7, 'Richard Mille', 'Ceasuri', 'Elvetia', 'Official Partner', 'contact@richardmille.ch', 'CHE-101.202.303');
INSERT INTO Sponsori VALUES (8, 'Ceva Logistics', 'Logistica', 'Franta', 'Logistic Partner', 'ops.ferrari@cevalogistics.com', 'FR8877665544');
INSERT INTO Sponsori VALUES (9, 'Peroni', 'Bauturi', 'Italia', 'Official Partner', 'corporate@peroni.it', 'IT1122334455');
INSERT INTO Sponsori VALUES (10, 'Bang Olufsen', 'Audio', 'Danemarca', 'Team Partner', 'f1@bang-olufsen.dk', 'DK99887766');


COMMIT;


    -- FURNIZORI 
    
INSERT INTO Furnizori VALUES (1, 'Brembo', 'Sistem Franare', 'Italia', 10, '+39-035-6052', 'orders@brembo.it', 'IT0044332211');
INSERT INTO Furnizori VALUES (2, 'Magneti Marelli', 'Electronica', 'Italia', 9, '+39-02-972', 'sales@marelli.com', 'IT9988776655');
INSERT INTO Furnizori VALUES (3, 'SKF', 'Rulmenti', 'Suedia', 10, '+46-31-337', 'f1.support@skf.se', 'SE556007349501');
INSERT INTO Furnizori VALUES (4, 'NGK', 'Bujii/Aprindere', 'Japonia', 9, '+81-52-872', 'racing@ngkntk.jp', 'JP1010101010');
INSERT INTO Furnizori VALUES (5, 'Mahle', 'Componente Motor', 'Germania', 8, '+49-711-501', 'motorsport@mahle.de', 'DE147813695');
INSERT INTO Furnizori VALUES (6, 'Toray', 'Fibra Carbon', 'Japonia', 10, '+81-3-3245', 'materials@toray.jp', 'JP9090909090');
INSERT INTO Furnizori VALUES (7, 'Sabelt', 'Siguranta/Centuri', 'Italia', 10, '+39-011-123', 'safety@sabelt.com', 'IT5544332211');
INSERT INTO Furnizori VALUES (8, 'Siemens', 'Software', 'Germania', 9, '+49-89-636', 'plm.support@siemens.de', 'DE963852741');
INSERT INTO Furnizori VALUES (9, 'Pirelli', 'Pneuri', 'Italia', 10, '+39-02-6442', 'f1.tyres@pirelli.com', 'IT1231231234');
INSERT INTO Furnizori VALUES (10, 'OMR', 'Sasiu/Metal', 'Italia', 8, '+39-030-111', 'chassis@omr.it', 'IT7778889990');

COMMIT;


--PIESE --
INSERT INTO Piese VALUES (1, 'Aripa Fata', 'Aerodinamica', 150000, 10, 2024);
INSERT INTO Piese VALUES (2, 'Motor V6 Turbo', 'Propulsie', 4500000, 5, 2024);
INSERT INTO Piese VALUES (3, 'Cutie Viteze', 'Transmisie', 600000, 15, 2024);
INSERT INTO Piese VALUES (4, 'Volan Digital', 'Electronica', 50000, 2, 2025);
INSERT INTO Piese VALUES (5, 'Sasiu Carbon', 'Structura', 1200000, 0, 2025);
INSERT INTO Piese VALUES (6, 'Suspensie Fata', 'Mecanica', 125000, 20, 2024);
INSERT INTO Piese VALUES (7, 'Sistem ERS', 'Hybrid', 850000, 8, 2025);
INSERT INTO Piese VALUES (8, 'Podea Efect Sol', 'Aerodinamica', 350000, 30, 2024);
INSERT INTO Piese VALUES (9, 'Radiator Racire', 'Sistem Racire', 45000, 12, 2004);
INSERT INTO Piese VALUES (10, 'Discuri Frana', 'Franare', 80000, 45, 2004);

COMMIT;

-- OFERTE --

INSERT INTO Oferte VALUES (1, 1, 10, 80000, 7, TO_DATE('2024-01-10', 'YYYY-MM-DD'), TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (2, 10, 10, 75000, 14, TO_DATE('2024-01-12', 'YYYY-MM-DD'), TO_DATE('2024-02-12', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (3, 2, 4, 50000, 30, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (4, 8, 4, 55000, 25, TO_DATE('2024-02-05', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (5, 6, 1, 150000, 45, TO_DATE('2023-11-20', 'YYYY-MM-DD'), TO_DATE('2023-12-20', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (6, 6, 5, 1200000, 90, TO_DATE('2023-12-01', 'YYYY-MM-DD'), TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (7, 6, 8, 350000, 40, TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (8, 3, 3, 5000, 5, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (9, 3, 6, 4500, 5, TO_DATE('2024-03-02', 'YYYY-MM-DD'), TO_DATE('2024-06-02', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (10, 4, 2, 2000, 3, TO_DATE('2024-01-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (11, 5, 2, 15000, 10, TO_DATE('2024-01-22', 'YYYY-MM-DD'), TO_DATE('2024-02-22', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (12, 2, 7, 850000, 60, TO_DATE('2023-10-10', 'YYYY-MM-DD'), TO_DATE('2023-11-10', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (13, 10, 6, 125000, 20, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (14, 1, 6, 30000, 10, TO_DATE('2024-02-18', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (15, 9, 9, 45000, 7, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_DATE('2024-05-10', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (16, 5, 9, 42000, 12, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_DATE('2024-04-12', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (17, 7, 5, 5000, 14, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2025-04-01', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (18, 8, 7, 200000, 15, TO_DATE('2024-01-05', 'YYYY-MM-DD'), TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (19, 3, 2, 8000, 5, TO_DATE('2024-01-08', 'YYYY-MM-DD'), TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO Oferte VALUES (20, 10, 3, 50000, 25, TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'));

COMMIT;


                            -- CONTRACTE --

INSERT INTO Contracte VALUES (1, 1, 116, 50000000, 'Activ', 'Titlu Mondial', TO_DATE('2025-12-31', 'YYYY-MM-DD'), TO_DATE('2023-01-15', 'YYYY-MM-DD'), 24);
INSERT INTO Contracte VALUES (2, 5, 116, 25000000, 'Activ', 'Top 3 Constructori', TO_DATE('2027-05-10', 'YYYY-MM-DD'), TO_DATE('2023-05-10', 'YYYY-MM-DD'), 48);
INSERT INTO Contracte VALUES (3, 7, 112, 12000000, 'Activ', NULL, TO_DATE('2026-01-20', 'YYYY-MM-DD'), TO_DATE('2024-01-20', 'YYYY-MM-DD'), 24);
INSERT INTO Contracte VALUES (4, 1, 100, 55000000, 'Semnat', 'Titlu', TO_DATE('2027-01-15', 'YYYY-MM-DD'), TO_DATE('2025-01-15', 'YYYY-MM-DD'), 24);
INSERT INTO Contracte VALUES (5, 6, 111, 4000000, 'Expirat', NULL, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2023-06-01', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (6, 6, 111, 3800000, 'Expirat', NULL, TO_DATE('2023-06-15', 'YYYY-MM-DD'), TO_DATE('2022-06-15', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (7, 2, 101, 35000000, 'Activ', NULL, TO_DATE('2024-12-31', 'YYYY-MM-DD'), TO_DATE('2023-02-20', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (8, 3, 101, 15000000, 'Activ', 'Podiumuri', TO_DATE('2026-12-31', 'YYYY-MM-DD'), TO_DATE('2024-01-10', 'YYYY-MM-DD'), 36);
INSERT INTO Contracte VALUES (9, 4, 110, 8000000, 'In Negociere', NULL, TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (10, 8, 113, 5000000, 'Expirat', NULL, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2023-03-15', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (11, 9, 114, 45000000, 'Activ', 'Vizibilitate', TO_DATE('2027-02-01', 'YYYY-MM-DD'), TO_DATE('2024-02-01', 'YYYY-MM-DD'), 36);
INSERT INTO Contracte VALUES (12, 2, 115, 32000000, 'Expirat', NULL, TO_DATE('2023-02-10', 'YYYY-MM-DD'), TO_DATE('2022-02-10', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (13, 10, 117, 3000000, 'Activ', NULL, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2023-08-01', 'YYYY-MM-DD'), 6);
INSERT INTO Contracte VALUES (14, 3, 113, 14000000, 'Expirat', NULL, TO_DATE('2024-01-05', 'YYYY-MM-DD'), TO_DATE('2022-01-05', 'YYYY-MM-DD'), 24);
INSERT INTO Contracte VALUES (15, 4, 110, 7500000, 'Expirat', NULL, TO_DATE('2024-01-20', 'YYYY-MM-DD'), TO_DATE('2023-01-20', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (16, 5, 116, 2000000, 'Expirat', NULL, TO_DATE('2023-05-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 5);
INSERT INTO Contracte VALUES (17, 7, 114, 11000000, 'Expirat', NULL, TO_DATE('2024-01-25', 'YYYY-MM-DD'), TO_DATE('2022-01-25', 'YYYY-MM-DD'), 24);
INSERT INTO Contracte VALUES (18, 1, 101, 48000000, 'Expirat', NULL, TO_DATE('2023-01-10', 'YYYY-MM-DD'), TO_DATE('2021-01-10', 'YYYY-MM-DD'), 24);
INSERT INTO Contracte VALUES (19, 8, 115, 4500000, 'Expirat', NULL, TO_DATE('2023-03-10', 'YYYY-MM-DD'), TO_DATE('2022-03-10', 'YYYY-MM-DD'), 12);
INSERT INTO Contracte VALUES (20, 10, 117, 2800000, 'Prelungit', NULL, TO_DATE('2025-01-05', 'YYYY-MM-DD'), TO_DATE('2024-01-05', 'YYYY-MM-DD'), 12);

COMMIT;

--VIEWS --

CREATE OR REPLACE VIEW Piese_Monopost_Compus AS
SELECT 
    P.ID_Piesa,
    P.Nume_Piesa,
    P.Valoare_Piesa,
    P.Nivel_Uzura_Piesa,
    M.Nume_Model AS Model_Monopost  
FROM Piese P
JOIN Monoposturi M ON P.ID_Monopost = M.ID_Monopost;

CREATE OR REPLACE VIEW Raport_Sponsori_Complex AS
SELECT 
    S.Nume_Sponsor,
    S.Tip_Parteneriat,        
    S.Tara_Origine,           
    S.Email_Contact,          
    COUNT(C.ID_Contract) AS Numar_Contracte,
    SUM(C.Valoare_Contract) AS Total_Investit_EUR,
    ROUND(AVG(C.Valoare_Contract), 2) AS Media_Contractelor
FROM Sponsori S
JOIN Contracte C ON S.ID_Sponsor = C.ID_Sponsor
GROUP BY 
    S.Nume_Sponsor, 
    S.Tip_Parteneriat, 
    S.Tara_Origine,
    S.Email_Contact;

COMMIT;