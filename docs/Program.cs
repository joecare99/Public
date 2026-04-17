using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.FileProviders;
using System.Collections.Generic;

// Konfiguriere den Webserver so, dass er das aktuelle Verzeichnis ("." statt "wwwroot") durchsucht:
var builder = WebApplication.CreateBuilder(new WebApplicationOptions
{
    Args = args,
    WebRootPath = "."
});

var app = builder.Build();

// Leitet automatisch den Root-Pfad '/' auf 'index2.html' (oder index.html) um
app.UseDefaultFiles(new DefaultFilesOptions
{
    DefaultFileNames = new List<string> { "index2.html", "index.html" }
});

// Liefert alle HTML, CSS, JS, JPG und JSON Dateien als Webserver an den Browser aus
app.UseStaticFiles();

app.Run();