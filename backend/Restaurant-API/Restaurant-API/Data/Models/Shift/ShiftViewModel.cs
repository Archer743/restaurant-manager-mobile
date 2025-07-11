using Restaurant_API.Data.Models.Table;

namespace Restaurant_API.Data.Models.Shift
{
    public class ShiftViewModel
    {
        public List<TableAvailabilityModel> Tables { get; set; } = [];
    }
}
