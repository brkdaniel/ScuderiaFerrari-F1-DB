# 🏎️ Scuderia Ferrari F1 Manager - Database & GUI Application

Acest repo conține un sistem de gestiune a unei echipe de Formula 1, construit în jurul unei baze de date relaționale Oracle SQL, cu interfețe grafice dezvoltate în Java (Swing) și C# (.NET/WPF).

## 🗄️ Arhitectura Bazei de Date (Oracle SQL)
Baza de date este nucleul proiectului și a fost proiectată pentru a respecta integritatea datelor și logica de business din motorsport.
* **Structură Complexă:** Conține 15 tabele organizate în entități independente, dependente și asociative.
* **Integritate Referențială:** Utilizarea extensivă a cheilor primare, cheilor străine și a clauzelor `ON DELETE CASCADE`.
* **Constrângeri:** Validări la nivel de tabel (ex: `CHECK` pentru ratinguri, `NOT NULL` pentru date critice).
* **Interogări Avansate:** Implementare de View-uri complexe și vizualizări compuse.

Fișierul SQL complet, inclusiv popularea cu date (seed data), poate fi găsit în scriptul `proiectbdF1.sql` atașat.

---

## 🖥️ Interfețele Grafice (Client Applications)

Pentru a demonstra flexibilitatea și înțelegerea conceptelor OOP, am abordat interfața grafică în două etape:

### Faza 1: Java Swing (Versiunea Stabilă / Funcțională)
Aplicația principală a fost dezvoltată și testată cu succes folosind Java și framework-ul Swing. 
* Realizează conexiunea nativă prin JDBC la baza de date Oracle.
* Permite operațiuni complete de tip CRUD (Create, Read, Update, Delete).
* *Documentația completă a acestei etape este disponibilă în repozitoriu.*

### Faza 2: C# .NET 10 WPF (Migrare în curs / Learning Project)
Pentru a-mi consolida cunoștințele în ecosistemul Microsoft, am început portarea aplicației către o arhitectură modernă .NET.
* **Tehnologii:** C#, .NET 10, Windows Presentation Foundation (WPF), ADO.NET (`Oracle.ManagedDataAccess.Core`).
* **Stadiu curent:** Interfața grafică (XAML) și arhitectura claselor sunt finalizate.
* **Notă tehnică:** În prezent, componenta de C# investighează o excepție de tip timeout (`ORA-50000`) specifică driverului Oracle Managed Data Access la rularea pe mediul local. Pentru demonstrarea capabilităților de UI (DataGrid, Data Binding, Event Handling), aplicația WPF rulează momentan folosind date simulate (Mock Data).

