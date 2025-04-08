using System.Collections.ObjectModel;

namespace ACI.API.Entities
{
    public class Major
    {
        public int Id { get; set; }
        public string Title { get; set; } = default!;
        public string Degree { get; set; } = default!;

        public ICollection<Subject> Subjects { get; set; } = new Collection<Subject>();
    }
}
