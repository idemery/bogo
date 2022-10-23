using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace bogo.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly IConfiguration configuration;

        public IndexModel(ILogger<IndexModel> logger, IConfiguration configuration)
        {
            _logger = logger;
            this.configuration = configuration;
        }

        public void OnGet()
        {
            string cs = configuration.GetValue<string>("ConnectionStrings:DefaultConnection");
            ViewData["cs"] = cs;
        }
    }
}