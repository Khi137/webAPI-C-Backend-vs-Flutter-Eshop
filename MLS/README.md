## Table of contents
* [Repository Contents](#repo-contente)
* [Technologies](#technologies)
* [Architecture](#architecture)
* [Features in Tech Stack](#architecture)
* [Setup](#setup)

## What this repo contains
This system is architectured to be loosley coupled with a seperation of concerns.
The repo contains 2 seperate projects, and some files namely:
* Angular 12 project (Front End)
* Web API Core 5 (Backend)
* Typescript object file that is referenced to generate dummy DB data in the DB on the fly.
	
## Technologies
Project is created with:
* Web API Core 5
* Angular 11
* C#
* Font Awesome
* JWT Web Tokens
* AutoMapper
* SQL Server
* EF Core 6
* Postman
* Resharper
* VS Code and Visual Studio
* Swashbuckle for API documentation
* Payment with Paypal
* Swashbuckle for API documentation
* Microsoft Azure

## Setup
To run this project, install it locally using npm:

```
$ cd into the app folder for the Angular client.
$ ng serve
$ cd into API solution and open terminal. Run the API on a static port and automatically rebuild about each save.
NOTICE
$ Before run the API solution, you must change the connection string in the appsettings.json file to your local or Azure SQL DB and run the API.
$ Open the terminal, change default app to DAL and Add-Migration MigrationName, then Update-Database.
$ Data will be generated for you using the Data Seeding feature.



Thanks for reading. Kindly reach out of you have any questions for me.
 I would be glad to help.
 
 Kind Regards,
 Kieran Gajjar
 Passionate Software Developer
