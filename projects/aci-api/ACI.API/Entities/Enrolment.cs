using ACI.API.Entities.Enums;

namespace ACI.API.Entities
{
    public class Enrolment
    {
        public int Id { get; set; }
        public Grade Grade { get; set; }
        public EnrolmentStatus EnrolmentStatus { get; set; }

        public int SubjectId { get; set; }
        public User User { get; set; } = null!;
        public Subject  Subject { get; set; } = null!;

    }
}
