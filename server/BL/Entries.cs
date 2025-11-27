using RideTrack_FP_OAD.DAL;


namespace RideTrack_FP_OAD.BL

{
    public class Entries
    {
       public int EntryId { get; set; }
       public int RiderId { get; set; }
       public int HorseId { get; set; }
       public int PayerId { get; set; }
       public int ClassId { get; set; }

        internal static List<Entries> GetAllEntries()
        {
            EntriesDAL entriesDAL = new EntriesDAL();
            return entriesDAL.GetAllEntries();
        }
    }
}
