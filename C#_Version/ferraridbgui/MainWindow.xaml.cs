using System;
using System.Data;
using System.Windows;
using System.Windows.Controls;
using Oracle.ManagedDataAccess.Client;

namespace ScuderiaFerrariManager
{
    public partial class MainWindow : Window
    {
        private string connectionString = "User Id=system;Password=123456;Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=BRKVICTUS)(PORT=1521))(CONNECT_DATA=(SID=xe)));Pooling=False;";
        private OracleDataAdapter dataAdapter;
        private DataTable currentDataTable;

        public MainWindow()
        {
            InitializeComponent();
        }

        // Listare, Sortare, Update, Delete Cascade
        private void CmbTables_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (CmbTables.SelectedItem is ComboBoxItem selectedItem)
            {
                string tableName = selectedItem.Content.ToString();
                LoadTableData(tableName);
            }
        }

        private void LoadTableData(string tableName)
        {
            // Date mock temporare pentru portofoliul de GitHub
            DataTable mockTable = new DataTable();

            if (tableName == "Sponsori")
            {
                mockTable.Columns.Add("ID_Sponsor", typeof(int));
                mockTable.Columns.Add("Nume_Sponsor", typeof(string));
                mockTable.Columns.Add("Domeniu", typeof(string));

                mockTable.Rows.Add(1, "Shell", "Combustibil");
                mockTable.Rows.Add(2, "Santander", "Bancar");
                mockTable.Rows.Add(3, "Puma", "Imbracaminte");
            }
            else
            {
                mockTable.Columns.Add("Info", typeof(string));
                mockTable.Rows.Add("Date simulate pentru tabelul " + tableName);
            }

            MainDataGrid.ItemsSource = mockTable.DefaultView;
        }

        private void BtnSave_Click(object sender, RoutedEventArgs e)
        {
            //  Editare/Inserare
            try
            {
                if (dataAdapter != null && currentDataTable != null)
                {
                    dataAdapter.Update(currentDataTable);
                    MessageBox.Show("Modificările au fost salvate cu succes în baza de date!", "Succes");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Eroare la salvare: " + ex.Message);
            }
        }

        private void BtnDelete_Click(object sender, RoutedEventArgs e)
        {
            // Stergere - ON DELETE CASCADE
            if (MainDataGrid.SelectedItem is DataRowView rowView)
            {
                MessageBoxResult result = MessageBox.Show("Ești sigur că vrei să ștergi? (Atenție la Delete Cascade)", "Confirmare", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    rowView.Row.Delete(); 
                    BtnSave_Click(null, null); 
                }
            }
        }

        //Selectare
        private void BtnCerintaC_Click(object sender, RoutedEventArgs e)
        {
            string query = @"
                SELECT A.Nume, A.Prenume, M.Nume_Model, R.Puncte_Obtinute
                FROM Angajati A
                JOIN Piloti P ON A.ID_Angajat = P.ID_Pilot
                JOIN Monoposturi M ON P.ID_Monopost = M.ID_Monopost
                JOIN Rezultate R ON P.ID_Pilot = R.ID_Pilot
                WHERE P.Masa_KG < 75 AND R.Puncte_Obtinute > 10";

            ExecuteReportQuery(query);
        }

        // Grupare folosind having
        private void BtnCerintaD_Click(object sender, RoutedEventArgs e)
        {
            // Valoarea totală a contractelor aduse de un manager, doar pt cei cu peste 10 milioane
            string query = @"
                SELECT A.Nume AS Nume_Manager, SUM(C.Valoare_Contract) AS Total_Valoare_Contracte
                FROM Angajati A
                JOIN Manageri M ON A.ID_Angajat = M.ID_Manager
                JOIN Contracte C ON M.ID_Manager = C.ID_Manager
                GROUP BY A.Nume
                HAVING SUM(C.Valoare_Contract) > 10000000";

            ExecuteReportQuery(query);
        }

        //VIEWS
        private void BtnViewLMD_Click(object sender, RoutedEventArgs e)
        {
            ExecuteReportQuery("SELECT * FROM Piese_Monopost_Compus");
        }

        private void BtnViewComplex_Click(object sender, RoutedEventArgs e)
        {
            ExecuteReportQuery("SELECT * FROM Raport_Sponsori_Complex");
        }

        private void ExecuteReportQuery(string query)
        {
            try
            {
                using (OracleConnection conn = new OracleConnection(connectionString))
                {
                    OracleDataAdapter adapter = new OracleDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (ReportsDataGrid.IsVisible)
                        ReportsDataGrid.ItemsSource = dt.DefaultView;
                    else
                        ViewsDataGrid.ItemsSource = dt.DefaultView;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Eroare la execuția cererii: " + ex.Message);
            }
        }
    }
}