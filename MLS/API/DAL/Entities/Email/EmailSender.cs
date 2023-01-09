using System;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace RepositoryServices.StaticMethods
{
    public static class EmailSender
    {
        public static async Task SendEmailAsync(string email, string subject, string htmlMessage)
        {
            string fromMail = "trantuananh16102k1@gmail.com";
            string fromPassword = "whglumlvwrwdypzs";

            MailMessage message = new MailMessage();
            message.From = new MailAddress(fromMail, "MidLandsShop");

            message.Subject = subject;
            message.To.Add(new MailAddress(email));
            message.Body =  htmlMessage ;
            SmtpClient client = new SmtpClient();
            client.Host = "smtp.gmail.com";
            client.Port = 587;
            client.EnableSsl = true;
            client.UseDefaultCredentials = false;
            var credentials = new System.Net.NetworkCredential(fromMail , fromPassword);
            client.Credentials = credentials;
            client.Send(message);
        }
    }
}
