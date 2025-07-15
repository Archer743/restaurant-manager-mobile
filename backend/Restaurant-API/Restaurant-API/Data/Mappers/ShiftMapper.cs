using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Shift;

namespace Restaurant_API.Data.Mappers
{
    public static class ShiftMapper
    {
        public static ShiftViewModel ToView(this Shift shift)
        {
            return new ShiftViewModel
            {
                Name = shift.Name,
                StartTime = shift.StartTime,
                EndTime = shift.EndTime,
                // Tables are set in TableService
            };
        }
    }
}
