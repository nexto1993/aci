using ACI.API.Entities.Enums;
using System.Collections.ObjectModel;

namespace ACI.API.Entities
{
    public class Subject
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public SubjectType SubjectType { get; set; }
        public int Hours { get; set; }
        public Major Major { get; set; }
        public int MajorId { get; set; }
        public ICollection<Enrolment> Enrolments { get; set; } = new Collection<Enrolment>();
    }
}
