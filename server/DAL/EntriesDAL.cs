using Microsoft.Data.SqlClient;
using RideTrack_FP_OAD.BL;
using System.Data;


namespace RideTrack_FP_OAD.DAL
{
    public class EntriesDAL:DBServices
    {
        private SqlDataReader reader;
        private SqlConnection connection;
        private SqlCommand command;

        public List <Entries> GetAllEntries()
        {
            try {
                connection = Connect("DefaultConnection");
            }
            catch(Exception ex) {
                throw ex;
            }
            command = CreateCommandWithStoredProcedure("GetAllEntries", connection, null);
            try
            {
                List <Entries> entries = new List <Entries>();
                reader= command.ExecuteReader(CommandBehavior.CloseConnection);
                while (reader.Read())
                {
                    entries.Add (new Entries {
                        EntryId = Convert.ToInt32(reader["EntryId"].ToString()),
                        RiderId = Convert.ToInt32(reader["RiderId"].ToString()),
                        HorseId = Convert.ToInt32(reader["HorseId"].ToString()),
                        PayerId = Convert.ToInt32(reader["PayerId"].ToString()),
                        ClassId = Convert.ToInt32(reader["ClassId"].ToString()) 
                    });
                }
                return entries;
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (connection != null)
                {
                    connection.Close();
                }
            }
        }
    }
}
