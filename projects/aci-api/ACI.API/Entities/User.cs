using Microsoft.AspNetCore.Identity;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;

namespace ACI.API.Entities
{
    public class User : IdentityUser
    {
        [MaxLength(100)]
        public string Name { get; set; } = default!;
        public DateOnly CurrentSemester { get; set; }
        public ICollection<Enrolment> Enrolments { get; set; } = new Collection<Enrolment>();
    }
}
