using ACI.API.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace ACI.API.Data
{
    public class ACIContext : IdentityDbContext
    {
        public ACIContext(DbContextOptions options) : base(options)
        {
        }

        public DbSet<Major> Majors { get; set; }
    }
}
